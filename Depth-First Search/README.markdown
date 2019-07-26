# 深度优先搜索(DFS，Depth-First Search)

> 这个主题已经有辅导[文章](https://www.raywenderlich.com/157949/swift-algorithm-club-depth-first-search)

深度优先搜索（DFS）是用于遍历或搜索[树](../Tree/)或[图](../Graph/)数据结构的算法。它从源节点开始，并在回溯之前尽可能地沿着每个分支进行探索。

深度优先搜索可以用于有向图和无向图。

## 动画示例

以下是深度优先搜索在图上的工作方式：

![Animated example](Images/AnimatedExample.gif)

假设我们从节点`A`开始搜索。 在深度优先搜索中，我们查看起始节点的第一个邻居并访问它，在这个示例中是节点`B`。然后我们查找节点`B`的第一个邻居并访问它，它是节点`D`。由于`D`没有自己的任何未访问的邻居节点，我们回溯到节点`B`并转到其另外的邻居节点`E`。依此类推，直到我们访问了图中的所有节点。

每当我们访问第一个邻居节点并继续前进，直到无处可去，然后我们回溯到之前访问的节点。 当我们一直回溯到节点`A`时，搜索就完成了。

对于上面的例子，是按照`A`，`B`，`D`，`E`，`H`，`F`，`G`，`C`的顺序访问节点的。

深度优先搜索过程也可以显示为树：

![Traversal tree](Images/TraversalTree.png)

节点的父节点是“发现”该节点的节点。 树的根是您开始深度优先搜索的节点。 每当有一个分支时，那就是我们回溯的地方。

## 代码

深度优先搜索的简单递归实现：

```swift
func depthFirstSearch(_ graph: Graph, source: Node) -> [String] {
  var nodesExplored = [source.label]
  source.visited = true

  for edge in source.neighbors {
    if !edge.neighbor.visited {
      nodesExplored += depthFirstSearch(graph, source: edge.neighbor)
    }
  }
  return nodesExplored
}
```

[广度优先搜索](../Breadth-First%20Search/)首先访问所有直接邻居，而深度优先搜索尝试尽可能地深入树或图。

在 playground 里测试：

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

let nodesExplored = depthFirstSearch(graph, source: nodeA)
print(nodesExplored)
```

打印结果是： `["a", "b", "d", "e", "h", "f", "g", "c"]`

## DFS有什么用？

深度优先搜索可用于解决许多问题，例如：


* 查找稀疏图的连通分量
* 图中节点的[拓扑排序](../Topological%20Sort/)
* 查找图的桥梁（参见：[Bridges](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm)）
* 还有很多其它应用！

*作者：Paulo Tanaka，Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
