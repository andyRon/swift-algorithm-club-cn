# Depth-First Search
# 深度优先搜索(DFS)

> This topic has been tutorialized [here](https://www.raywenderlich.com/157949/swift-algorithm-club-depth-first-search)
> 这个主题已经有辅导[文章](https://www.raywenderlich.com/157949/swift-algorithm-club-depth-first-search)

Depth-first search (DFS) is an algorithm for traversing or searching [tree](../Tree/) or [graph](../Graph/) data structures. It starts at a source node and explores as far as possible along each branch before backtracking.
深度优先搜索（DFS）是用于遍历或搜索[树](../Tree/)或[图](../Graph/)数据结构的算法。 它从源节点开始，并在回溯之前尽可能地沿着每个分支进行探索。

Depth-first search can be used on both directed and undirected graphs.
深度优先搜索可以用于有向图和无向图。

## Animated example
## 动画示例

Here's how depth-first search works on a graph:
以下是深度优先搜索在图上的工作方式：

![Animated example](Images/AnimatedExample.gif)

Let's say we start the search from node `A`. In depth-first search we look at the starting node's first neighbor and visit that. In the example that is node `B`. Then we look at node `B`'s first neighbor and visit it. This is node `D`. Since `D` doesn't have any unvisited neighbors of its own, we backtrack to node `B` and go to its other neighbor `E`. And so on, until we've visited all the nodes in the graph.
假设我们从节点`A`开始搜索。 在深度优先搜索中，我们查看起始节点的第一个邻居并访问它。 在节点`B`的示例中。 然后我们看一下节点`B`的第一个邻居并访问它。 这是节点`D`。 由于`D`没有自己的任何未访问的邻居，我们回溯到节点`B`并转到其他邻居`E`。 依此类推，直到我们访问了图表中的所有节点。

Each time we visit the first neighbor and keep going until there's nowhere left to go, and then we backtrack to a point where there are again nodes to visit. When we've backtracked all the way to node `A`, the search is complete.
每当我们访问第一个邻居并继续前进，直到无处可去，然后我们回溯到再次访问节点的点。 当我们一直回溯到节点`A`时，搜索就完成了。

For the example, the nodes were visited in the order `A`, `B`, `D`, `E`, `H`, `F`, `G`, `C`.
例如，按照`A`，`B`，`D`，`E`，`H`，`F`，`G`，`C`的顺序访问节点。

The depth-first search process can also be visualized as a tree:
深度优先搜索过程也可以显示为树：

![Traversal tree](Images/TraversalTree.png)

The parent of a node is the one that "discovered" that node. The root of the tree is the node you started the depth-first search from. Whenever there's a branch, that's where we backtracked.
节点的父节点是“发现”该节点的节点。 树的根是您开始深度优先搜索的节点。 每当有一个分支时，那就是我们回溯的地方。

## The code
## 代码

Simple recursive implementation of depth-first search:
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

Where a [breadth-first search](../Breadth-First%20Search/) visits all immediate neighbors first, a depth-first search tries to go as deep down the tree or graph as it can.
在[广度优先搜索](../Breadth-First%20Search/)首先访问所有直接邻居的情况下，深度优先搜索尝试尽可能地深入树或图形。

Put this code in a playground and test it like so:
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

This will output: `["a", "b", "d", "e", "h", "f", "g", "c"]`
打印结果是： `["a", "b", "d", "e", "h", "f", "g", "c"]`

## What is DFS good for?
## DFS有什么用？

Depth-first search can be used to solve many problems, for example:
深度优先搜索可用于解决许多问题，例如：

* Finding connected components of a sparse graph
* [Topological sorting](../Topological%20Sort/) of nodes in a graph
* Finding bridges of a graph (see: [Bridges](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm))
* And lots of others!

* 查找稀疏图的连通分量
* 图中节点的[拓扑排序](../Topological%20Sort/)
* 查找图形的桥梁（参见：[Bridges](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm)）
* 还有很多其它应用！

*Written for Swift Algorithm Club by Paulo Tanaka and Matthijs Hollemans*
*作者：Paulo Tanaka，Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*
