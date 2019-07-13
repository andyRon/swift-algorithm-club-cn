# 环形缓冲区（Ring Buffer）

也称为循环缓冲区。

[基于数组的队列](../Queue/)的问题是在队列后面添加新项目很快，**O(1)**，但是从队列前面删除项目很慢，**O(n)**。删除速度很慢，因为它需要在内存中移动剩余的数组元素。

实现队列的更有效方法是使用环形缓冲区或循环缓冲区。 这是一个概念性地回绕到开头的数组，因此您永远不必删除任何项目。 所有操作都是**O(1)**。

原则上它是如何工作的。 我们有一个固定大小的数组，比如5项：

	[    ,    ,    ,    ,     ]
	 r
	 w

最初，数组为空，读（`r`）和写（`w`）指针位于开头。

让我们为这个数组添加一些数据。 我们将写入或叫“入队”，数字`123`：

	[ 123,    ,    ,    ,     ]
	  r
	  ---> w

每次添加数据时，写指针都向前移动一步。 让我们添加更多元素：

	[ 123, 456, 789, 666,     ]
	  r    
	       -------------> w

现在数组中还有一个空点，但是应用程序决定读取一些数据，而不是将另一个项送入队列。这是可能的，因为写指针位于读指针之前，这意味着数据可用于读取。 读取指针随着读取可用数据而前进：

	[ 123, 456, 789, 666,     ]
	  ---> r              w

让我们再读两项：

	[ 123, 456, 789, 666,     ]
	       --------> r    w

现在应用程序决定再次写入并再入队两个数据项`333`和`555`：

	[ 123, 456, 789, 666, 333 ]
	                 r    ---> w

哎呀，写指针已到达数组的末尾，因此对象`555`没有更多的空间。现在怎么办？好吧，这就是为什么它是循环缓冲区：我们将写指针包装回到开头并写入剩余数据：

	[ 555, 456, 789, 666, 333 ]
	  ---> w         r        

我们现在可以阅读剩余的三个项目，`666`，`333`和`555`。

	[ 555, 456, 789, 666, 333 ]
	       w         --------> r        

当然，当读指针到达缓冲区的末尾时，它也会回绕：

	[ 555, 456, 789, 666, 333 ]
	       w            
	  ---> r

现在缓冲区再次为空，因为读指针已经赶上了写指针。

这是Swift中一个非常基本的实现：

```swift
public struct RingBuffer<T> {
  fileprivate var array: [T?]
  fileprivate var readIndex = 0
  fileprivate var writeIndex = 0

  public init(count: Int) {
    array = [T?](repeating: nil, count: count)
  }

  public mutating func write(_ element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }

  public mutating func read() -> T? {
    if !isEmpty {
      let element = array[readIndex % array.count]
      readIndex += 1
      return element
    } else {
      return nil
    }
  }

  fileprivate var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }

  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }

  fileprivate var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }

  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}
```

`RingBuffer`对象有一个数组用于实际存储数据，`readIndex`和`writeIndex`变量用于指向数组的“指针”。 `write()`函数将新元素放入`writeIndex`中的数组中，`read()`函数返回`readIndex`中的元素。

但是，你说，如何继续工作下去？ 有几种方法可以实现这一点，我选择了一个稍微有争议的方法。 在这个实现中，`writeIndex`和`readIndex`总是递增，永远不会实际回绕。 相反，我们执行以下操作来查找数组的实际索引：

```swift
array[writeIndex % array.count]
```

and:

```swift
array[readIndex % array.count]
```

换句话说，我们分别获取读取索引和写入索引除以底层数组的大小的模数（或余数）。

这有点争议的原因是`writeIndex`和`readIndex`总是递增，所以理论上这些值可能变得太大而不适合整数，应用程序将崩溃。然而，快速的卫生巾计算应该可以消除这些担忧。

`writeIndex`和`readIndex`都是64位整数。 如果我们假设它们每秒递增1000次，这是很多，那么连续一年这样做需要`ceil（log_2（365 * 24 * 60 * 60 * 1000））= 35`位。 这留下了28位，因此在遇到问题之前应该给你大约2 ^ 28年。 那是很长一段时间。:-)

要使用此环形缓冲区，请将代码复制到playground并执行以下操作以模仿上面的示例：

```swift
var buffer = RingBuffer<Int>(count: 5)

buffer.write(123)
buffer.write(456)
buffer.write(789)
buffer.write(666)

buffer.read()   // 123
buffer.read()   // 456
buffer.read()   // 789

buffer.write(333)
buffer.write(555)

buffer.read()   // 666
buffer.read()   // 333
buffer.read()   // 555
buffer.read()   // nil
```

您已经看到环形缓冲区可以创建更优的队列，但它也有一个缺点：包装使得调整队列大小变得棘手。但如果一个固定大小的队列适合你的目的，那么你就牛掰了。

当数据生产者以不同于数据使用者读取数据的速率写入数组时，环形缓冲区也非常有用。这通常发生在文件或网络I/O上。环形缓冲区也是高优先级线程（例如音频渲染回调）与系统其他较慢部分之间通信的首选方式。

这里给出的实现不是线程安全的。它仅作为环形缓冲区如何工作的示例。也就是说，通过使用`OSAtomicIncrement64()`来改变读写指针，使单个读写器和单个编写器的线程安全应该是相当简单的。

制作一个非常快的环形缓冲区的一个很酷的技巧是使用操作系统的虚拟内存系统将相同的缓冲区映射到不同的内存页面。疯狂的东西，但值得研究是否需要在高性能环境中使用环形缓冲区。


*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
