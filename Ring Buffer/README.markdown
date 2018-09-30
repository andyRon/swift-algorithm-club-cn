# Ring Buffer
# 环形缓冲区

Also known as a circular buffer.
也称为循环缓冲区。

The problem with a [queue based on an array](../Queue/) is that adding new items to the back of the queue is fast, **O(1)**, but removing items from the front of the queue is slow, **O(n)**. Removing is slow because it requires the remaining array elements to be shifted in memory.
[基于数组的队列](../Queue/)的问题是在队列后面添加新项目很快，**O(1)**，但是从队列前面删除项目很慢，**O(n)**。 删除速度很慢，因为它需要在内存中移动剩余的数组元素。

A more efficient way to implement a queue is to use a ring buffer or circular buffer. This is an array that conceptually wraps around back to the beginning, so you never have to remove any items. All operations are **O(1)**.
实现队列的更有效方法是使用环形缓冲区或循环缓冲区。 这是一个概念性地回绕到开头的数组，因此您永远不必删除任何项目。 所有操作都是**O(1)**。

Here is how it works in principle. We have an array of a fixed size, say 5 items:
原则上它是如何工作的。 我们有一个固定大小的数组，比如5项：

	[    ,    ,    ,    ,     ]
	 r
	 w

Initially, the array is empty and the read (`r`) and write (`w`) pointers are at the beginning.
最初，数组为空，读（`r`）和写（`w`）指针位于开头。

Let's add some data to this array. We'll write, or "enqueue", the number `123`:
让我们为这个数组添加一些数据。 我们将编写或“排队”数字`123`：

	[ 123,    ,    ,    ,     ]
	  r
	  ---> w

Each time we add data, the write pointer moves one step forward. Let's add a few more elements:
每次添加数据时，写指针都向前移动一步。 让我们添加一些元素：

	[ 123, 456, 789, 666,     ]
	  r    
	       -------------> w

There is now one open spot left in the array, but rather than enqueuing another item the app decides to read some data. That's possible because the write pointer is ahead of the read pointer, meaning data is available for reading. The read pointer advances as we read the available data:
现在数组中还有一个开放点，但是应用程序决定读取一些数据，而不是将另一个项目排入队列。 这是可能的，因为写指针位于读指针之前，这意味着数据可用于读取。 读取指针随着读取可用数据而前进：

	[ 123, 456, 789, 666,     ]
	  ---> r              w

Let's read two more items:
让我们再读两项：

	[ 123, 456, 789, 666,     ]
	       --------> r    w

Now the app decides it's time to write again and enqueues two more data items, `333` and `555`:
现在应用程序决定再次写入并再排队两个数据项`333`和`555`：

	[ 123, 456, 789, 666, 333 ]
	                 r    ---> w

Whoops, the write pointer has reached the end of the array, so there is no more room for object `555`. What now? Well, this is why it's a circular buffer: we wrap the write pointer back to the beginning and write the remaining data:
哎呀，写指针已到达数组的末尾，因此对象`555`没有更多的空间。 现在怎么办？ 好吧，这就是为什么它是循环缓冲区：我们将写指针包装回到开头并写入剩余数据：

	[ 555, 456, 789, 666, 333 ]
	  ---> w         r        

We can now read the remaining three items, `666`, `333`, and `555`.
我们现在可以阅读剩余的三个项目，`666`，`333`和`555`。

	[ 555, 456, 789, 666, 333 ]
	       w         --------> r        

Of course, as the read pointer reaches the end of the buffer it also wraps around:
当然，当读指针到达缓冲区的末尾时，它也会回绕：

	[ 555, 456, 789, 666, 333 ]
	       w            
	  ---> r

And now the buffer is empty again because the read pointer has caught up with the write pointer.
现在缓冲区再次为空，因为读指针已经赶上了写指针。

Here is a very basic implementation in Swift:
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

The `RingBuffer` object has an array for the actual storage of the data, and `readIndex` and `writeIndex` variables for the "pointers" into the array. The `write()` function puts the new element into the array at the `writeIndex`, and the `read()` function returns the element at the `readIndex`.
`RingBuffer`对象有一个数组用于实际存储数据，`readIndex`和`writeIndex`变量用于指向数组的“指针”。 `write()`函数将新元素放入`writeIndex`中的数组中，`read()`函数返回`readIndex`中的元素。

But hold up, you say, how does this wrapping around work? There are several ways to accomplish this and I chose a slightly controversial one. In this implementation, the `writeIndex` and `readIndex` always increment and never actually wrap around. Instead, we do the following to find the actual index into the array:
但是，你说，坚持下去，这是怎么回事？ 有几种方法可以实现这一点，我选择了一个稍微有争议的方法。 在这个实现中，`writeIndex`和`readIndex`总是递增，永远不会实际回绕。 相反，我们执行以下操作来查找数组的实际索引：

```swift
array[writeIndex % array.count]
```

and:

```swift
array[readIndex % array.count]
```

In other words, we take the modulo (or the remainder) of the read index and write index divided by the size of the underlying array.
换句话说，我们采用读取索引的模数（或余数），并将写入索引除以底层数组的大小。

The reason this is a bit controversial is that `writeIndex` and `readIndex` always increment, so in theory these values could become too large to fit into an integer and the app will crash. However, a quick back-of-the-napkin calculation should take away those fears.
这有点争议的原因是`writeIndex`和`readIndex`总是递增，所以理论上这些值可能变得太大而不适合整数，应用程序将崩溃。 然而，快速的卫生巾计算应该可以消除这些担忧。

Both `writeIndex` and `readIndex` are 64-bit integers. If we assume that they are incremented 1000 times per second, which is a lot, then doing this continuously for one year requires `ceil(log_2(365 * 24 * 60 * 60 * 1000)) = 35` bits. That leaves 28 bits to spare, so that should give you about 2^28 years before running into problems. That's a long time. :-)
`writeIndex`和`readIndex`都是64位整数。 如果我们假设它们每秒递增1000次，这是很多，那么连续一年这样做需要`ceil（log_2（365 * 24 * 60 * 60 * 1000））= 35`位。 这留下了28位，因此在遇到问题之前应该给你大约2 ^ 28年。 那是很长一段时间。:-)

To play with this ring buffer, copy the code to a playground and do the following to mimic the example above:
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

You've seen that a ring buffer can make a more optimal queue but it also has a disadvantage: the wrapping makes it tricky to resize the queue. But if a fixed-size queue is suitable for your purposes, then you're golden.
您已经看到环形缓冲区可以创建更优的队列，但它也有一个缺点：包装使得调整队列大小变得棘手。 但如果一个固定大小的队列适合你的目的，那么你就是金色的。

A ring buffer is also very useful for when a producer of data writes into the array at a different rate than the consumer of the data reads it. This happens often with file or network I/O. Ring buffers are also the preferred way of communicating between high priority threads (such as an audio rendering callback) and other, slower, parts of the system.
当数据生产者以不同于数据使用者读取数据的速率写入数组时，环形缓冲区也非常有用。这通常发生在文件或网络I/O上。环形缓冲区也是高优先级线程（例如音频渲染回调）与系统其他较慢部分之间通信的首选方式。

The implementation given here is not thread-safe. It only serves as an example of how a ring buffer works. That said, it should be fairly straightforward to make it thread-safe for a single reader and single writer by using `OSAtomicIncrement64()` to change the read and write pointers.
这里给出的实现不是线程安全的。 它仅作为环形缓冲区如何工作的示例。 也就是说，通过使用`OSAtomicIncrement64()`来改变读写指针，使单个读写器和单个编写器的线程安全应该是相当简单的。

A cool trick to make a really fast ring buffer is to use the operating system's virtual memory system to map the same buffer onto different memory pages. Crazy stuff but worth looking into if you need to use a ring buffer in a high performance environment.
制作一个非常快的环形缓冲区的一个很酷的技巧是使用操作系统的虚拟内存系统将相同的缓冲区映射到不同的内存页面。 疯狂的东西，但值得研究是否需要在高性能环境中使用环形缓冲区。

*Written for Swift Algorithm Club by Matthijs Hollemans*

*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*
