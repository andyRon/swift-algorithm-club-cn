# Priority Queue
# 优先队列

A priority queue is a [queue](../Queue/) where the most important element is always at the front.
优先队列是一种[队列](../Queue/)，其中最重要的元素始终位于前面。

The queue can be a *max-priority* queue (largest element first) or a *min-priority* queue (smallest element first).
优先队列可以分为：*max-priority*队列（最大元素优先）或*min-priority*队列（最小元素优先）。

## Why use a priority queue?
## 为什么要使用优先队列？

Priority queues are useful for algorithms that need to process a (large) number of items and where you repeatedly need to identify which one is now the biggest or smallest -- or however you define "most important".
优先队列对于需要处理（大量）项目的算法以及您反复需要识别哪个项目现在最大或最小 —— 或者您定义“最重要”的算法非常有用。

Examples of algorithms that can benefit from a priority queue:
可以从优先队列中受益的算法示例：

- Event-driven simulations. Each event is given a timestamp and you want events to be performed in order of their timestamps. The priority queue makes it easy to find the next event that needs to be simulated.
- Dijkstra's algorithm for graph searching uses a priority queue to calculate the minimum cost.
- [Huffman coding](../Huffman%20Coding/) for data compression. This algorithm builds up a compression tree. It repeatedly needs to find the two nodes with the smallest frequencies that do not have a parent node yet.
- A* pathfinding for artificial intelligence.
- Lots of other places!

- 事件驱动的模拟。 每个事件都有一个时间戳，您希望按照时间戳的顺序执行事件。 优先队列可以轻松找到需要模拟的下一个事件。
- Dijkstra的图搜索算法使用优先队列来计算最低成本。
- [霍夫曼编码](../Huffman%20Coding/) 用于数据压缩。 该算法构建压缩树。 它反复需要找到具有最小频率且尚未具有父节点的两个节点。
- 用于人工智能的A*寻路。
- 很多其他地方！

With a regular queue or plain old array you'd need to scan the entire sequence over and over to find the next largest item. A priority queue is optimized for this sort of thing.
使用常规队列或普通旧数组，您需要反复扫描整个序列以查找下一个最大的项目。 优先队列针对此类事物进行了优化。

## What can you do with a priority queue?
## 你可以用优先队列做什么？

Common operations on a priority queue:
优先队列的常见操作：

- **Enqueue**: inserts a new element into the queue.
- **Dequeue**: removes and returns the queue's most important element.
- **Find Minimum** or **Find Maximum**: returns the most important element but does not remove it.
- **Change Priority**: for when your algorithm decides that an element has become more important while it's already in the queue.

- **入队**：在队列中插入一个新元素。
- **出队**：删除并返回队列中最重要的元素。
- **查找最小值**或**查找最大值**：返回最重要的元素但不删除它。
- **更改优先级**：当您的算法决定元素已经在队列中时变得更重要时。

## How to implement a priority queue
## 如何实现优先队列

There are different ways to implement priority queues:
有不同的方法来实现优先队列：

- As a [sorted array](../Ordered%20Array/). The most important item is at the end of the array. Downside: inserting new items is slow because they must be inserted in sorted order.
- As a balanced [binary search tree](../Binary%20Search%20Tree/). This is great for making a double-ended priority queue because it implements both "find minimum" and "find maximum" efficiently.
- As a [heap](../Heap/). The heap is a natural data structure for a priority queue. In fact, the two terms are often used as synonyms. A heap is more efficient than a sorted array because a heap only has to be partially sorted. All heap operations are **O(log n)**.

- 作为[有序数组](../Ordered%20Array/)。 最重要的项目位于数组的末尾。 缺点：插入新项目很慢，因为它们必须按排序顺序插入。
- 作为平衡的[二叉搜索树](../Binary%20Search%20Tree/)。 这对于制作双端优先队列非常有用，因为它可以有效地实现“查找最小值”和“查找最大值”。
- 作为[堆](../Heap/)。 堆是优先队列的自然数据结构。 实际上，这两个术语通常用作同义词。 堆比排序数组更有效，因为堆只需要部分排序。 所有堆操作都是**O(log n)**。

Here's a Swift priority queue based on a heap:
这是基于堆的Swift优先队列：

```swift
public struct PriorityQueue<T> {
  fileprivate var heap: Heap<T>

  public init(sort: (T, T) -> Bool) {
    heap = Heap(sort: sort)
  }

  public var isEmpty: Bool {
    return heap.isEmpty
  }

  public var count: Int {
    return heap.count
  }

  public func peek() -> T? {
    return heap.peek()
  }

  public mutating func enqueue(element: T) {
    heap.insert(element)
  }

  public mutating func dequeue() -> T? {
    return heap.remove()
  }

  public mutating func changePriority(index i: Int, value: T) {
    return heap.replace(index: i, value: value)
  }
}
```

As you can see, there's nothing much to it. Making a priority queue is easy if you have a [heap](../Heap/) because a heap *is* pretty much a priority queue.
正如你所看到的，没有什么可以做的。 如果你有[堆](../Heap/)，那么建立优先队列很容易，因为堆几乎是一个优先队列。

## 扩展阅读

[优先队列的维基百科](https://en.wikipedia.org/wiki/Priority_queue)


*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
