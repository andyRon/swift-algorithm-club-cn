# 有界优先队列（Bounded Priority queue）

A bounded priority queue is similar to a regular [priority queue](../Priority%20Queue/), except that there is a fixed upper bound on the number of elements that can be stored. When a new element is added to the queue while the queue is at capacity, the element with the highest priority value is ejected from the queue.
有界优先级队列类似于常规[优先级队列](../Priority%20Queue/)，除了可以存储的元素数量有固定的上限。在队列处于满容量时，将新元素添加到队列时，具有最高优先级值的元素将从队列中弹出。

## Example
## 例子

Suppose we have a bounded-priority-queue with maximum size 5 that has the following values and priorities:
假设我们有一个最大大小为5的有界优先级队列，它具有以下值和优先级：

```
Value:    [ A,   B,   C,    D,    E   ]
Priority: [ 4.6, 3.2, 1.33, 0.25, 0.1 ]
```

Here, we consider the object with the highest priority value to be the most important (so this is a *max-priority* queue). The larger the priority value, the more we care about the object. So `A` is more important than `B`, `B` is more important than `C`, and so on.
在这里，我们认为具有最高优先级值的对象是最重要的（因此这是*max-priority*队列）。 优先级值越大，我们关注的对象就越多。 所以`A`比`B`更重要，`B`比`C`更重要，依此类推。

Now we want to insert the element `F` with priority `0.4` into this bounded priority queue. Because the queue has maximum size 5, this will insert the element `F` but then evict the lowest-priority element (`E`), yielding the updated queue:
现在我们要将优先级为`0.4`的元素`F`插入到这个有界优先级队列中。 因为队列大小最大为5，所以这将插入元素`F`，然后逐出最低优先级元素（`E`），产生更新的队列：

```
Value:    [ A,   B,   C,    F,   D    ]
Priority: [ 4.6, 3.2, 1.33, 0.4, 0.25 ]
```

`F` is inserted between `C` and `D` because of its priority value. It's less important than `C` but more important than `D`.
由于其优先级值，在`C`和`D`之间插入`F`。它不如`C`重要，但比`D`更重要。

Suppose that we wish to insert the element `G` with priority 0.1 into this BPQ. Because `G`'s priority value is less than the minimum-priority element in the queue, upon inserting `G` it will immediately be evicted. In other words, inserting an element into a BPQ with priority less than the minimum-priority element of the BPQ has no effect.
假设我们希望将优先级为0.1的元素`G`插入到此BPQ中。因为`G`的优先级值小于队列中的最小优先级元素，所以在插入`G`时它将立即被驱逐。换句话说，将元素插入优先级小于BPQ的最小优先级元素的BPQ中没有任何效果。

## Implementation
## 实施

While a [heap](../Heap/) may be a really simple implementation for a priority queue, a sorted [linked list](../Linked%20List/) allows for **O(k)** insertion and **O(1)** deletion, where **k** is the bounding number of elements.
虽然[heap](../Heap/)可能是优先级队列的一个非常简单的实现，但排序的[链表](../Linked%20List/)允许 **O(k)** 插入和 **O(1)** 删除，其中 **k** 是元素的边界数。

Here's how you could implement it in Swift:
以下是在Swift中的实现：

```swift
public class BoundedPriorityQueue<T: Comparable> {
  private typealias Node = LinkedListNode<T>

  private(set) public var count = 0
  fileprivate var head: Node?
  private var tail: Node?
  private var maxElements: Int

  public init(maxElements: Int) {
    self.maxElements = maxElements
  }

  public var isEmpty: Bool {
    return count == 0
  }

  public func peek() -> T? {
    return head?.value
  }
```

The `BoundedPriorityQueue` class contains a doubly linked list of `LinkedListNode` objects. Nothing special here yet. The fun stuff happens in the `enqueue()` method:
`BoundedPriorityQueue`类包含`LinkedListNode`对象的双向链表。 这里没什么特别的。 有趣的东西发生在`enqueue()`方法中：

```swift
public func enqueue(_ value: T) {
  if let node = insert(value, after: findInsertionPoint(value)) {
    // If the newly inserted node is the last one in the list, then update
    // the tail pointer.
    if node.next == nil {
      tail = node
    }

    // If the queue is full, then remove an element from the back.
    count += 1
    if count > maxElements {
      removeLeastImportantElement()
    }
  }
}

private func insert(_ value: T, after: Node?) -> Node? {
  if let previous = after {

    // If the queue is full and we have to insert at the end of the list,
    // then there's no reason to insert the new value.
    if count == maxElements && previous.next == nil {
      print("Queue is full and priority of new object is too small")
      return nil
    }

    // Put the new node in between previous and previous.next (if exists).
    let node = Node(value: value)
    node.next = previous.next
    previous.next?.previous = node
    previous.next = node
    node.previous = previous
    return node

  } else if let first = head {
    // Have to insert at the head, so shift the existing head up once place.
    head = Node(value: value)
    head!.next = first
    first.previous = head
    return head

  } else {
    // This is the very first item in the queue.
    head = Node(value: value)
    return head
  }
}

/* Find the node after which to insert the new value. If this returns nil,
   the new value should be inserted at the head of the list. */
private func findInsertionPoint(_ value: T) -> Node? {
  var node = head
  var prev: Node? = nil

  while let current = node where value < current.value {
    prev = node
    node = current.next
  }
  return prev
}

private func removeLeastImportantElement() {
  if let last = tail {
    tail = last.previous
    tail?.next = nil
    count -= 1
  }

  // Note: Instead of using a tail pointer, we could just scan from the new
  // node until the end. Then nodes also don't need a previous pointer. But
  // this is much slower on large lists.
}
```

We first check if the queue already has the maximum number of elements. If so, and the new priority value is less than the `tail` element's priority value, then there is no room for this new element and we return without inserting it.
我们首先检查队列是否已经具有最大元素数。 如果是这样，并且新的优先级值小于`tail`元素的优先级值，那么这个新元素没有空间，我们返回时不插入它。

If the new value is acceptable, then we search through the list to find the proper insertion location and update the `next` and `previous` pointers.
如果新值是可接受的，那么我们搜索列表以找到正确的插入位置并更新`next`和`previous`指针。

Lastly, if the queue has now reached the maximum number of elements, then we `dequeue()` the one with the largest priority value.
最后，如果队列现在已达到最大元素数，那么我们`dequeue()`具有最大优先级值。

By keeping the most important element at the front of the list, it makes dequeueing very easy:
通过将最重要的元素保留在列表的前面，它使得出列非常容易：

```swift
public func dequeue() -> T? {
  if let first = head {
    count -= 1
    if count == 0 {
      head = nil
      tail = nil
    } else {
      head = first.next
      head!.previous = nil
    }
    return first.value
  } else {
    return nil
  }
}
```

This simply removes the `head` element from the list and returns it.
这只是从列表中删除`head`元素并返回它。



*作者：John Gill, Matthijs Hollemans*
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
