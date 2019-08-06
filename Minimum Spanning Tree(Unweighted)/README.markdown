# 最小生成树（未加权图）（Minimum Spanning Tree (Unweighted Graph)）

最小生成树描述了包含访问图中每个节点所需的最小数目边的路径。

看下图：

![Graph](Images/Graph.png)

如果我们从节点`a`开始并想要访问每个其他节点，那么最有效的路径是什么？ 我们可以使用最小生成树算法来计算它。

这是图的最小生成树。 它由粗体边表示：

![Minimum spanning tree](Images/MinimumSpanningTree.png)

绘制为更一般形式的树，它看起来像这样：

![An actual tree](Images/Tree.png)

要计算未加权图上的最小生成树，我们可以使用[广度优先搜索](../Breadth-First%20Search/) 算法。广度优先搜索从源节点开始，并在移动到下一级邻居之前首先通过探索直接邻居节点来遍历图。如果我们通过选择性地删除边来调整此算法，那么它可以将图转换为最小生成树。

让我们逐步完成这个例子。 我们从源节点`a`开始，将其添加到队列中并将其标记为已访问。

```swift
queue.enqueue(a)
a.visited = true
```

队列现在是`[a]`。 与广度优先搜索一样，我们将队列前面的节点`a`出队，并将其直接邻居节点`b`和`h`入队。 将它们标记为访问过。

```swift
queue.dequeue()   // a
queue.enqueue(b)
b.visited = true
queue.enqueue(h)
h.visited = true
```

队列现在是`[b, h]`。 将`b`出队并将邻居节点`c`入队。 将其标记为已访问。 将`b`到`h`边移除，因为已经访问过`h`。

```swift
queue.dequeue()   // b
queue.enqueue(c)
c.visited = true
b.removeEdgeTo(h)
```

队列现在是`[h, c]`。 将`h`出队并将邻居节点`g`和`i`入队，并将它们标记为已访问。

```swift
queue.dequeue()   // h
queue.enqueue(g)
g.visited = true
queue.enqueue(i)
i.visited = true
```

队列现在是`[c, g, i]`。 将`c`出队并将邻居节点`d`和`f`入队，并将它们标记为已访问。 删除`c`和`i`之间的边，因为已经访问了`i`。

```swift
queue.dequeue()   // c
queue.enqueue(d)
d.visited = true
queue.enqueue(f)
f.visited = true
c.removeEdgeTo(i)
```

队列现在是`[g, i, d, f]`。 出队`g`。 它的所有邻居都已经被发现了，所以没有什么可以入队的。 删除`g`到`f`的边，以及`g`到`i`的边，因为已经发现了`f`和`i`。

```swift
queue.dequeue()   // g
g.removeEdgeTo(f)
g.removeEdgeTo(i)
```

队列现在是`[i, d, f]`。 出队`i`。 这个节点没有别的办法。

```swift
queue.dequeue()   // i
```

队列现在是`[d, f]`。 将`d`出队并将邻居节点`e`入队。 将其标记为已访问。 删除`d`到`f`的边，因为已经访问了`f`。

```swift
queue.dequeue()   // d
queue.enqueue(e)
e.visited = true
d.removeEdgeTo(f)
```

队列现在是`[f, e]`。 出列`f`。 删除`f`和`e`之间的边，因为已经访问过`e`。

```swift
queue.dequeue()   // f
f.removeEdgeTo(e)
```

队列现在是`[e]`。 出队`e`。

```swift
queue.dequeue()   // e
```

队列为空，这意味着已计算出最小生成树。

代码如下：

```swift
func breadthFirstSearchMinimumSpanningTree(graph: Graph, source: Node) -> Graph {
  let minimumSpanningTree = graph.duplicate()

  var queue = Queue<Node>()
  let sourceInMinimumSpanningTree = minimumSpanningTree.findNodeWithLabel(source.label)
  queue.enqueue(sourceInMinimumSpanningTree)
  sourceInMinimumSpanningTree.visited = true

  while let current = queue.dequeue() {
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.visited {
        neighborNode.visited = true
        queue.enqueue(neighborNode)
      } else {
        current.remove(edge)
      }
    }
  }

  return minimumSpanningTree
}
```

此函数返回一个新的`Graph`对象，该对象仅描述最小生成树。 在图中，这将是仅包含粗体边的图。

将此代码放在playground上，进行测试：

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
let nodeI = graph.addNode("i")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeH)
graph.addEdge(nodeB, neighbor: nodeA)
graph.addEdge(nodeB, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeH)
graph.addEdge(nodeC, neighbor: nodeB)
graph.addEdge(nodeC, neighbor: nodeD)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeI)
graph.addEdge(nodeD, neighbor: nodeC)
graph.addEdge(nodeD, neighbor: nodeE)
graph.addEdge(nodeD, neighbor: nodeF)
graph.addEdge(nodeE, neighbor: nodeD)
graph.addEdge(nodeE, neighbor: nodeF)
graph.addEdge(nodeF, neighbor: nodeC)
graph.addEdge(nodeF, neighbor: nodeD)
graph.addEdge(nodeF, neighbor: nodeE)
graph.addEdge(nodeF, neighbor: nodeG)
graph.addEdge(nodeG, neighbor: nodeF)
graph.addEdge(nodeG, neighbor: nodeH)
graph.addEdge(nodeG, neighbor: nodeI)
graph.addEdge(nodeH, neighbor: nodeA)
graph.addEdge(nodeH, neighbor: nodeB)
graph.addEdge(nodeH, neighbor: nodeG)
graph.addEdge(nodeH, neighbor: nodeI)
graph.addEdge(nodeI, neighbor: nodeC)
graph.addEdge(nodeI, neighbor: nodeG)
graph.addEdge(nodeI, neighbor: nodeH)

let minimumSpanningTree = breadthFirstSearchMinimumSpanningTree(graph, source: nodeA)

print(minimumSpanningTree) // [node: a edges: ["b", "h"]]
                           // [node: b edges: ["c"]]
                           // [node: c edges: ["d", "f"]]
                           // [node: d edges: ["e"]]
                           // [node: h edges: ["g", "i"]]
```

> **注意：** 在未加权的图上，任何生成树始终是最小生成树。 这意味着您还可以使用[深度优先搜索](../Depth-First%20Search)来查找最小生成树。


*作者：[Chris Pilcher](https://github.com/chris-pilcher)， Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
