# 最短路径算法（Shortest Path(Unweighted Graph)）

目标：找到图中从一个节点到另一个节点的最短路径。

假设我们以下图为例：

![Example graph](Images/Graph.png)

我们可能想知道从节点`A`到节点`F`的最短路径是什么。

如果[图是未加权的](../Graph/)，那么找到最短路径很容易：我们可以使用广度优先搜索算法。 对于加权图，我们可以使用Dijkstra算法。

## 未加权图：广度优先搜索

[广度优先搜索](../Breadth-First%20Search/)是遍历树或图数据结构的方法。 它从源节点开始，在移动到下一级邻居之前首先探索直接邻居节点。 方便的副作用是，它会自动计算源节点与树或图中其他每个节点之间的最短路径。

广度优先搜索的结果可以用树表示：

![The BFS tree](../Breadth-First%20Search/Images/TraversalTree.png)

树的根节点是广度优先搜索开始的节点。 为了找到从节点`A`到任何其他节点的距离，我们只计算树中边的数目。 所以我们发现`A`和`F`之间的最短路径是2.树不仅告诉你路径有多长，而且还告诉你如何实际从`A`到`F`（或者任何一个其他节点）。

让我们将广度优先搜索付诸实践，并计算从`A`到所有其他节点的最短路径。 我们从源节点`A`开始，并将其添加到队列中，距离为`0`。

```swift
queue.enqueue(element: A)
A.distance = 0
```

队列现在是`[A]`。 我们将`A`出列并将其两个直接邻居节点`B`和`C`入列，并设置距离`1`。

```swift
queue.dequeue()   // A
queue.enqueue(element: B)
B.distance = A.distance + 1   // result: 1
queue.enqueue(element: C)
C.distance = A.distance + 1   // result: 1
```

队列现在是`[B, C]`。 将`B`出列，并将`B`的邻居节点`D`和`E`入列，距离为`2`。

```swift
queue.dequeue()   // B
queue.enqueue(element: D)
D.distance = B.distance + 1   // result: 2
queue.enqueue(element: E)
E.distance = B.distance + 1   // result: 2
```

队列现在是`[C, D, E]`。 将`C`出列并将`C`的邻居节点`F`和`G`入队，距离为`2`。

```swift
queue.dequeue()   // C
queue.enqueue(element: F)
F.distance = C.distance + 1   // result: 2
queue.enqueue(element: G)
G.distance = C.distance + 1   // result: 2
```

这么一直持续到队列为空，同时我们访问了所有节点。 每次我们发现一个新节点时，它会获得其父节点的`distance`加1.正如您所看到的，这正是[广度优先搜索](../Breadth-First%20Search/)算法的作用， 除此之外，我们现在还知道距离寻找的路径。

这是代码：

```swift
func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
  let shortestPathGraph = graph.duplicate()

  var queue = Queue<Node>()
  let sourceInShortestPathsGraph = shortestPathGraph.findNodeWithLabel(label: source.label)
  queue.enqueue(element: sourceInShortestPathsGraph)
  sourceInShortestPathsGraph.distance = 0

  while let current = queue.dequeue() {
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.hasDistance {
        queue.enqueue(element: neighborNode)
        neighborNode.distance = current.distance! + 1
      }
    }
  }

  return shortestPathGraph
}
```

在playground中进行测试：

```swift
let shortestPathGraph = breadthFirstSearchShortestPath(graph: graph, source: nodeA)
print(shortestPathGraph.nodes)
```

输出结果：

	Node(label: a, distance: 0), Node(label: b, distance: 1), Node(label: c, distance: 1),
	Node(label: d, distance: 2), Node(label: e, distance: 2), Node(label: f, distance: 2),
	Node(label: g, distance: 2), Node(label: h, distance: 3)

> **注意：**这个版本的`breadthFirstSearchShortestPath()`实际上并不生成树，它只计算距离。 有关如何通过去除边缘将图转换为树，请参见[最小生成树](../Minimum%20Spanning%20Tree%20(Unweighted)/)。


*作者：[Chris Pilcher](https://github.com/chris-pilcher)，Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
