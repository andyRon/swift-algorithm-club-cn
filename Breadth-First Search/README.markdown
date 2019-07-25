# 广度优先搜索(BFS，Breadth-First Search)

> 这个话题已经有个辅导[文章](https://www.raywenderlich.com/155801/swift-algorithm-club-swift-breadth-first-search)


广度优先搜索（BFS，Breadth-First Search）是用于遍历、搜索[树](../Tree/)或[图](../Graph/)数据结构的算法。它从源节点开始，在移动到下一级邻居之前首先探索直接邻居节点。

广度优先搜索可以用于有向图和无向图。

## 动画示例

以下是广度优先搜索在图上的工作原理：

![广度优先搜索的动画示例](Images/AnimatedExample.gif)

当我们访问节点时，将其着色为黑色。 还将其邻居节点放入[队列](../Queue/)。 在动画中，入队但尚未访问的节点以灰色显示。

让我们按照动画示例进行操作。 我们从源节点`A`开始，并将其添加到队列中。 在动画中，这显示为节点`A`变为灰色。

```swift
queue.enqueue(A)
```

队列现在是`[A]`。 我们的想法是，只要队列中有节点，我们就会访问位于队列前端的节点，如果尚未访问它们，则将其相邻的邻居节点入队。

要开始遍历图，我们将第一个节点从队列中推出`A`，并将其着色为黑色。 然后我们将它的两个邻居节点`B`和`C`入队。 它们的颜色变成灰色。

```swift
queue.dequeue()   // A
queue.enqueue(B)
queue.enqueue(C)
```

队列现在是`[B, C]`。 我们将`B`出列，并将`B`的邻居节点`D`和`E`排入队列。

```swift
queue.dequeue()   // B
queue.enqueue(D)
queue.enqueue(E)
```

队列现在是`[C, D, E]`。 将`C`出列，并将`C`的邻居节点`F`和`G`入队。

```swift
queue.dequeue()   // C
queue.enqueue(F)
queue.enqueue(G)
```

队列现在是`[D, E, F, G]`。 出列`D`，它没有邻居节点。

```swift
queue.dequeue()   // D
```

队列现在是`[E, F, G]`。 将`E`出列并将其单个邻居节点`H`排队。 注意`B`也是`E`的邻居，但我们已经访问了`B`，所以我们不再将它添加到队列中。

```swift
queue.dequeue()   // E
queue.enqueue(H)
```

队列现在是`[F, G, H]`。 出队`F`，它没有未访问的邻居节点。

```swift
queue.dequeue()   // F
```

队列现在是`[G, H]`。 出列`G`，它没有未访问的邻居节点。

```swift
queue.dequeue()   // G
```

队列现在是`[H]`。 出列`H`，它没有未访问的邻居节点。

```swift
queue.dequeue()   // H
```

队列现在为空，这意味着已经探索了所有节点。 探索节点的顺序是`A`，`B`，`C`，`D`，`E`，`F`，`G`，`H`。

我们可以将其显示为树：

![The BFS tree](Images/TraversalTree.png)

节点的父节点是"发现"该节点的节点。 树的根是广度优先搜索开始的节点。

对于未加权的图，此树定义从起始节点到树中每个其他节点的最短路径。 广度优先搜索是在图中找到两个节点之间的最短路径的一种方法。

## 代码

使用队列简单实现广度优先搜索：

```swift
func breadthFirstSearch(_ graph: Graph, source: Node) -> [String] {
  var queue = Queue<Node>()
  queue.enqueue(source)

  var nodesExplored = [source.label]
  source.visited = true

  while let node = queue.dequeue() {
    for edge in node.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.visited {
        queue.enqueue(neighborNode)
        neighborNode.visited = true
        nodesExplored.append(neighborNode.label)
      }
    }
  }

  return nodesExplored
}
```

虽然队列中有节点，但我们访问第一个节点，然后将其尚未被访问的直接邻居节点入队。

将此代码放在 playground中， 并进行如下测试：

```swift
let graph = Graph()

let nodeA = graph.addNode("a")
let nodeB = graph.addNode("b")
let nodeC = graph.addNode("c")
let nodeD = graph.addNode("d")
let nodeE = graph.addNode("e")
let nodeF = graph.addNode("f")
let nodeG = graph.addNode("g")
let nodeH = graph.addNode("h")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeD)
graph.addEdge(nodeB, neighbor: nodeE)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeG)
graph.addEdge(nodeE, neighbor: nodeH)
graph.addEdge(nodeE, neighbor: nodeF)
graph.addEdge(nodeF, neighbor: nodeG)

let nodesExplored = breadthFirstSearch(graph, source: nodeA)
print(nodesExplored)
```

结果输出： `["a", "b", "c", "d", "e", "f", "g", "h"]`

## BFS有什么用？

广度优先搜索可用于解决许多问题。 例如：

* 计算源节点和其他每个节点之间的[最短路径](../Shortest%20Path%20(Unweighted)/)（仅适用于未加权的图形）。
* 在未加权的图表上计算[最小生成树](../Minimum%20Spanning%20Tree%20(Unweighted)/)。



*作者：[Chris Pilcher](https://github.com/chris-pilcher)， Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
