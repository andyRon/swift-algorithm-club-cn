# 双端队列(Deque)

出于某种原因，双端队列也被称为“deck”。

常规[队列](../Queue/)元素在后面添加（入队），从前面删除（出队）。 除了这些，双端队列还可以在后面出队，从前面入队，并且两端都可查看。

Swift中双端队列的一个非常基本的实现：

```swift
public struct Deque<T> {
  private var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func enqueueFront(_ element: T) {
    array.insert(element, atIndex: 0)
  }

  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }

  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }

  public func peekFront() -> T? {
    return array.first
  }

  public func peekBack() -> T? {
    return array.last
  }
}
```

这个实现的内部使用数组。 入队和出列只是在数组的前面或后面，添加或删除元素。

在 playground 中使用：

```swift
var deque = Deque<Int>()
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)

deque.dequeue()       // 1
deque.dequeueBack()   // 4

deque.enqueueFront(5)
deque.dequeue()       // 5
```

`Deque`的这种实现很简单但效率不高。几个操作是 **O(n)**，特别是`enqueueFront()`和`dequeue()`。这个实现只是为了说明双端队列的作用原理。

## 更高效的版本

`dequeue()`和`enqueueFront()`的时间复杂度是**O(n)**，原因是它们在数组的前面（开始）工作。如果删除数组前面的元素，那么所有剩余的元素都需要在内存中移位。

假设双端队列的数组包含以下元素：

	[ 1, 2, 3, 4 ]

然后`dequeue()`将从数组中删除`1`，元素`2`，`3`和`4`将向前移动一个位置：

	[ 2, 3, 4 ]

这是一个**O(n)**操作，因为所有数组元素都需要在内存中移动一个位置。

同样，在数组的前面插入一个元素也是昂贵的，因为它要求所有其他元素必须向后移动一个位置。 因此`enqueueFront(5)`会将数组更改为：

	[ 5, 2, 3, 4 ]

首先，将元素`2`，`3`和`4`在内存中向后移动一个位置，然后将新元素`5`插入到曾经是`2`的位置。

为什么`enqueue()`和`dequeueBack()`没有这样的问题？  
好吧，这些操作是在数组末尾操作的。在Swift中数组默认都是可调整大小的，它的实现方式是，在数组后面预留一定量的可用空间。

我们的初始数组`[1, 2, 3, 4]`实际上在内存中看起来像这样：

	[ 1, 2, 3, 4, x, x, x ]

其中`x`表示数组中尚未使用的空间。 调用`enqueue(6)`只是将新元素复制到下一个未使用的空间：

	[ 1, 2, 3, 4, 6, x, x ]

`dequeueBack()`函数使用`array.removeLast()`删除元素。这不会缩小数组的内存，只会将`array.count`减1。这里没有涉及昂贵的内存拷贝。因此在数组末尾的操作很快，复杂度是**O(1)**。

数组可能会用尽末尾预留的未使用空间。 在这种情况下，Swift将分配一个新的更大的数组，并复制所有数据。这是一个**O(n)**操作，但因为它只是偶尔发生一次，所以在数组末尾添加新元素的平均值仍然是**O(1)**。

当然，我们可以在数组的*开头*使用相同的技巧。 这将使我们的双端队列在 *开头* 的操作也高效。 我们的数组将如下所示：

	[ x, x, x, 1, 2, 3, 4, x, x, x ]

现在在数组的开头还有一大块可用空间，这样，在数组前面添加或删除元素的操作也是**O(1)**。

这是`Deque`的新版本：

```swift
public struct Deque<T> {
  private var array: [T?]
  private var head: Int
  private var capacity: Int
  private let originalCapacity:Int

  public init(_ capacity: Int = 10) {
    self.capacity = max(capacity, 1)
    originalCapacity = self.capacity
    array = [T?](repeating: nil, count: capacity)
    head = capacity
  }

  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func enqueueFront(_ element: T) {
    // this is explained below
  }

  public mutating func dequeue() -> T? {
    // this is explained below
  }

  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }

  public func peekFront() -> T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }

  public func peekBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.last!
    }
  }  
}
```

这看起来与之前的代码基本相同 —— `enqueue()` 和 `dequeueBack()` 没有改变 —— 但也有一些重要的区别。 数组现在存储类型为`T？`的对象而不是`T`，因为我们数组元素可能会被标记为空。

`init`方法分配一个包含一定数量的`nil`值的新数组。 在数组开头处添加了空白空间，默认情况下，会创建10个空白空间。

`head`是数组中最前面对象的索引。 由于队列当前是空的，`head`指向数组末尾后面的索引。

	[ x, x, x, x, x, x, x, x, x, x ]
	                                 |
	                                 head

为了将对象放在前面，我们将`head`向左移动一个位置，然后将新对象复制到索引`head`处。 例如，`enqueueFront(5)`结果：

	[ x, x, x, x, x, x, x, x, x, 5 ]
	                             |
	                             head

`enqueueFront(7)`的结果:

	[ x, x, x, x, x, x, x, x, 7, 5 ]
	                          |
	                          head

等等......`head`继续向左移动并始终指向队列中的第一个元素。`enqueueFront()`现在的操作是**O(1)**，因为它只涉及将元素复制到数组中，这是一个恒定时间操作。

代码：

```swift
  public mutating func enqueueFront(element: T) {
    head -= 1
    array[head] = element
  }
```

向队列后面添加元素方式没有改变（与之前的代码完全相同）。 例如，`enqueue(1)`结果：

	[ x, x, x, x, x, x, x, x, 7, 5, 1, x, x, x, x, x, x, x, x, x ]
	                          |
	                          head

<!--
Notice how the array has resized itself. There was no room to add the `1`, so Swift decided to make the array larger and add a number of empty spots to the end. If you enqueue another object, it gets added to the next empty spot in the back. For example, `enqueue(2)`:
注意数组如何调整自身大小。 空白空间添加`1`，因此Swift决定将数组放大并在末尾添加一些空白点。 
-->

如果您将另一个对象入队，它将被添加到后面的下一个空白空间。 例如，`enqueue(2)`：

	[ x, x, x, x, x, x, x, x, 7, 5, 1, 2, x, x, x, x, x, x, x, x ]
	                          |
	                          head

> **注意：** 当你`print(deque.array)`时，你不会在数组后面看到那些空白空间。 这是因为Swift会将它们隐藏起来。 只显示数组前面的空白空间。

`dequeue()`方法与`enqueueFront()`是相反操作，它读取`head`处的元素，将设置为`nil`，然后将`head`移动到右边的一个位置：

```swift
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    return element
  }
```

有一个很小的问题......如果在前面添加了很多对象，会在某些时候用尽前面的空白空间。 当这发生在数组的后面时，Swift会自动调整它的大小。 但是在数组的前面我们必须自己处理这种情况，在`enqueueFront()`中有一些额外的逻辑：

```swift
  public mutating func enqueueFront(element: T) {
    if head == 0 {
      capacity *= 2
      let emptySpace = [T?](repeating: nil, count: capacity)
      array.insert(contentsOf: emptySpace, at: 0)
      head = capacity
    }

    head -= 1
    array[head] = element
  }
```

如果`head`等于0，则前面没有剩余空间。 当发生这种情况时，我们在数组中添加了一大堆新的`nil`元素。 这是一个**O(n)**操作，但由于这个操作不是在每次`enqueueFront()`调用时都会发生，所以每次对`enqueueFront()`单独调用的时间复杂度，仍然可以认为是**O(1)**。

> **注意：** 每次发生这种情况时，我们会将容量乘以2，因此如果您的队列会越来越大，调整大小的次数也就越少。 这也是Swift数组在后面自动执行的操作方式。

我们必须为`dequeue()`做类似的事情。 如果你大部分时间将很多元素从前面入队，并且大多数时候也从前面出队，那么你最终可能会得到一个如下所示的数组：

	[ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
	                                                              |
	                                                              head

当你调用`enqueueFront()`时，只会使用前面的空白空间。 但是如果在前面入队的操作很少发生，那么就会有很多闲置的空白空间。 所以让我们在`dequeue()`中添加一些代码来清理它：

```swift
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    if capacity >= originalCapacity && head >= capacity*2 {
      let amountToRemove = capacity + capacity/2
      array.removeFirst(amountToRemove)
      head -= amountToRemove
      capacity /= 2
    }
    return element
  }
```

回想一下`capacity`是队列前面的空白空间的原始数量。 如果`head`向右移动的次数超过了容量的两倍(译注：`head >= capacity*2`)，那么就该修剪掉这些空白空间了。 我们将它降低到约25%。

> **注意：** 通过将`capacity`与`originalCapacity`进行比较，双端队列将至少保持其原始容量。

例如：

	[ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
	                                |                             |
	                                capacity                      head

修剪后：

	[ x, x, x, x, x, 1, 2, 3 ]
	                 |
	                 head
	                 capacity

通过这种方式，我们可以在前面的快速入队、出队与保持合理的内存空间之间取得平衡。

> **注意：** 我们不对非常小的数组执行修剪，仅保存几个字节的内存是没有必要的。

## 扩展阅读

其它可以实现双端队列的方法：[双向链表](../Linked%20List/)，[环形缓冲区](../Ring%20Buffer/)，或方法相反的两个[栈](../Stack/)。

[双端队列功能齐全的Swift实现](https://github.com/lorentey/Deque)



*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
