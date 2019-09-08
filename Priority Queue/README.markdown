
# 优先队列(Priority Queue)

优先队列是一种[队列](../Queue/)，其中最重要的元素始终位于前面。

优先队列可以分为：*max-priority*队列（最大元素优先）或*min-priority*队列（最小元素优先）。



## 为什么要使用优先队列？



优先队列对于需要处理（有大量）项目的算法以及反复需要识别哪个项目现在最大或最小 —— 或者是定义“最重要”的算法非常有用。

可以从优先队列中受益的算法示例：

- 事件驱动的模拟。 每个事件都有一个时间戳，您希望按照时间戳的顺序执行事件。 优先队列可以轻松找到需要模拟的下一个事件。
- Dijkstra的图搜索算法使用优先队列来计算最低成本。
- [霍夫曼编码](../Huffman%20Coding/) 用于数据压缩。 该算法构建压缩树。 它反复需要找到具有最小频率且尚未具有父节点的两个节点。
- 用于人工智能的A*寻路。
- 很多其他地方！


使用常规队列或普通旧数组，您需要反复扫描整个序列以查找下一个最大的项目。 优先队列针对此类事物进行了优化。



## 你可以用优先队列做什么？

优先队列的常见操作：

- **入队**：在队列中插入一个新元素。
- **出队**：删除并返回队列中最重要的元素。
- **查找最小值**或**查找最大值**：返回最重要的元素但不删除它。
- **更改优先级**：当您的算法决定元素已经在队列中时变得更重要时。



## 如何实现优先队列

有不同的方法来实现优先队列：

- 作为[有序数组](../Ordered%20Array/)。 最重要的项目位于数组的末尾。 缺点：插入新项目很慢，因为它们必须按排序顺序插入。
- 作为平衡的[二叉搜索树](../Binary%20Search%20Tree/)。 这对于制作双端优先队列非常有用，因为它可以有效地实现“查找最小值”和“查找最大值”。
- 作为[堆](../Heap/)。 堆是优先队列的自然数据结构。 实际上，这两个术语通常用作同义词。 堆比排序数组更有效，因为堆只需要部分排序。 所有堆操作都是**O(log n)**。

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


正如你所看到的，没有什么可以做的。 如果你有[堆](../Heap/)，那么建立优先队列很容易，因为堆几乎是一个优先队列。

## 扩展阅读

[优先队列的维基百科](https://en.wikipedia.org/wiki/Priority_queue)



*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  