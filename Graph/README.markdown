# Graph
# 图

> This topic has been tutorialized [here](https://www.raywenderlich.com/152046/swift-algorithm-club-graphs-adjacency-list)
> 这个话题已经有个辅导[文章](https://www.raywenderlich.com/152046/swift-algorithm-club-graphs-adjacency-list)


A graph looks like the following picture:
图看上像下面的图片：

![A graph](Images/Graph.png)

In computer science, a graph is defined as a set of *vertices* paired with a set of *edges*. The vertices are represented by circles, and the edges are the lines between them. Edges connect a vertex to other vertices.
在计算机科学中，图形被定义为一组*点*与一组*边*配对。 点用圆圈表示，边是它们之间的线。 边将点连接到其他点。

> **Note:** Vertices are sometimes called "nodes", and edges are called "links".
> **注意：** 点有时称为“节点”，边称为“连接”。

A graph can represent a social network. Each person is a vertex, and people who know each other are connected by edges. Here is a somewhat historically inaccurate example:
图可以代表社交网络。 每个人都是一个点，彼此认识的人通过边连接。 这是一个有点历史不准确的例子：

![Social network](Images/SocialNetwork.png)

Graphs have various shapes and sizes. The edges can have a *weight*, where a positive or negative numeric value is assigned to each edge. Consider an example of a graph representing airplane flights. Cities can be vertices, and flights can be edges. Then, an edge weight could describe flight time or the price of a ticket.
图具有各种形状和大小。 当为每个边分配正数或负数，边可以具有*权重*。 考虑一个代表飞机飞行的图示例。 城市可以是点，而航班可以是缘。 然后，边权重可以描述航班时间或票价。

![Airplane flights](Images/Flights.png)

With this hypothetical airline, flying from San Francisco to Moscow is cheapest by going through New York.
有了这个假想的航空公司，从旧金山飞往莫斯科，经过纽约是最便宜的。

Edges can also be *directed*. In examples mentioned above, the edges are undirected. For instance, if Ada knows Charles, then Charles also knows Ada. A directed edge, on the other hand, implies a one-way relationship. A directed edge from vertex X to vertex Y connects X to Y, but *not* Y to X.
边也可以*定向*。 在上面提到的例子中，边是无向的。 例如，如果阿达（Ada）可以到达查尔斯（Charles），那么查尔斯也可以到达阿达。 另一方面，有向边意味着单向关系。 从点X到点Y的有向边连接X到Y，但 *不是* Y到X.

Continuing from the flights example, a directed edge from San Francisco to Juneau in Alaska indicates that there is a flight from San Francisco to Juneau, but not from Juneau to San Francisco (I suppose that means you're walking back).
从航班的例子来看，从旧金山到阿拉斯加的朱诺的有针对性的边表明从旧金山到朱诺的航班，但不是从朱诺到旧金山（我想这意味着你正在向后走）。

![One-way flights](Images/FlightsDirected.png)

The following are also graphs:
以下也是图：

![Tree and linked list](Images/TreeAndList.png)

On the left is a [tree](../Tree/) structure, on the right a [linked list](../Linked%20List/). They can be considered graphs but in a simpler form. They both have vertices (nodes) and edges (links).
左边是[tree](../Tree/)结构，右边是[链表](../Linked％20List/)。 它们可以被视为图形，但形式更简单。 它们都有点（节点）和边（连接）。

The first graph includes *cycles*, where you can start off at a vertex, follow a path, and come back to the original vertex. A tree is a graph without such cycles.
第一个图包括*cycles*，您可以从点开始，沿着路径，然后返回到原始点。 树是没有这种循环的图。

Another common type of graph is the *directed acyclic graph* or DAG:
另一种常见类型的图是*有向无环图*或DAG：

![DAG](Images/DAG.png)

Like a tree, this graph does not have any cycles (no matter where you start, there is no path back to the starting vertex), but this graph has directional edges with the shape that does not necessarily form a hierarchy.
像树一样，这个图没有任何循环（无论你从哪里开始，都没有回到起始点的路径），但是这个图的方向边的形状不一定形成层次结构。

## Why use graphs?
## 为什么使用图？

Maybe you're shrugging your shoulders and thinking, what's the big deal? Well, it turns out that a graph is a useful data structure.
也许你耸耸肩膀思考，有什么大不了的？ 好吧，事实证明图是一种有用的数据结构。

If you have a programming problem where you can represent your data as vertices and edges, then you can draw your problem as a graph and use well-known graph algorithms such as [breadth-first search](../Breadth-First%20Search/) or [depth-first search](../Depth-First%20Search) to find a solution.
如果您遇到编程问题，您可以将数据表示为点和边，那么您可以将图形绘制为图形并使用众所周知的图算法，例如[广度优先搜索](../Breadth-First％20Search/)或[深度优先搜索](../Depth-First％20Search)找到解决方案。

For example, suppose you have a list of tasks where some tasks have to wait on others before they can begin. You can model this using an acyclic directed graph:
例如，假设您有一个任务列表，其中某些任务必须先等待其他任务才能开始。 您可以使用非循环有向图对此进行建模：

![Tasks as a graph](Images/Tasks.png)

Each vertex represents a task. An edge between two vertices means the source task must be completed before the destination task can start. As an example, task C cannot start before B and D are finished, and B nor D can start before A is finished.
每个点代表一个任务。 两个点之间的边意味着必须在目标任务开始之前完成源任务。 例如，任务C在B和D完成之前无法启动，B和D可以在A完成之前启动。

Now that the problem is expressed using a graph, you can use a depth-first search to perform a [topological sort](../Topological%20Sort/). This will put the tasks in an optimal order so that you minimize the time spent waiting for tasks to complete. (One possible order here is A, B, D, E, C, F, G, H, I, J, K.)
现在使用图表表示问题，您可以使用深度优先搜索来执行[拓扑排序](../Topological％20Sort/)。 这将使任务处于最佳顺序，以便最大限度地减少等待任务完成所花费的时间。 （这里可能的一个顺序是A，B，D，E，C，F，G，H，I，J，K。）

Whenever you are faced with a tough programming problem, ask yourself, "how can I express this problem using a graph?" Graphs are all about representing relationships between your data. The trick is in how you define "relationships".
无论何时遇到困难的编程问题，请问自己，“如何使用图表达此问题？” 图都是关于表示数据之间的关系。 诀窍在于如何定义“关系”。

If you are a musician you might appreciate this graph:
如果您是音乐家，您可能会喜欢这张图：

![Chord map](Images/ChordMap.png)

The vertices are chords from the C major scale. The edges -- the relationships between the chords -- represent how [likely one chord is to follow another](http://mugglinworks.com/chordmaps/genmap.htm). This is a directed graph, so the direction of the arrows shows how you can go from one chord to the next. It is also a weighted graph, where the weight of the edges -- portrayed here by line thickness -- shows a strong relationship between two chords. As you can see, a G7-chord is very likely to be followed by a C chord, and much less likely by a Am chord.
点是C大调的和弦。 边 - 和弦之间的关系 - 代表[可能一个和弦跟随另一个和弦](http://mugglinworks.com/chordmaps/genmap.htm)。 这是一个有向图，因此箭头的方向显示了如何从一个和弦转到下一个和弦。 它也是一个加权图，其中边的重量 - 这里用线条粗细描绘 - 显示了两个和弦之间的强关系。 正如你所看到的，G7和弦很可能后跟一个C和弦，并且很可能是一个Am和弦。

You are probably already using graphs without even knowing it. Your data model is also a graph (from Apple's Core Data documentation):
您可能已经在使用图表时甚至不知道它。 您的数据模型也是图表（来自Apple的Core Data文档）：

![Core Data model](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreDataVersioning/Art/recipe_version2.0.jpg)

Another common graph used by programmers is the state machine, where edges depict the conditions for transitioning between states. Here is a state machine that models my cat:
程序员使用的另一个常见图形是状态机，其中边描述了状态之间转换的条件。 这是一个模拟我的猫的状态机：

![State machine](Images/StateMachine.png)

Graphs are awesome. Facebook made a fortune from their social graph. If you are going to learn any data structure, you must choose the graph and the vast collection of standard graph algorithms.
图表很棒。 Facebook从他们的社交图中赚了大钱。 如果要学习任何数据结构，则必须选择图形和大量标准图形算法。

## Vertices and edges, oh my!
## 哦，我的点和边！

In theory, a graph is just a bunch of vertex and edge objects, but how do you describe this in code?
理论上，图形只是一堆点和边对象，但是如何在代码中描述它？

There are two main strategies: adjacency list and adjacency matrix.
有两种主要策略：邻接列表和邻接矩阵。

**Adjacency List.** In an adjacency list implementation, each vertex stores a list of edges that originate from that vertex. For example, if vertex A has an edge to vertices B, C, and D, then vertex A would have a list containing 3 edges.
**邻接列表。**在邻接列表实现中，每个点存储源自该点的边的列表。 例如，如果点A具有到点B，C和D的边，则点A将具有包含3个边的列表。

![Adjacency list](Images/AdjacencyList.png)

The adjacency list describes outgoing edges. A has an edge to B, but B does not have an edge back to A, so A does not appear in B's adjacency list. Finding an edge or weight between two vertices can be expensive because there is no random access to edges. You must traverse the adjacency lists until it is found.
邻接列表描述了传出边。 A具有到B的边，但是B没有返回到A的边，因此A不出现在B的邻接列表中。 在两个点之间找到边或权重可能很昂贵，因为没有随机访问边。 您必须遍历邻接列表，直到找到它为止。

**Adjacency Matrix.** In an adjacency matrix implementation, a matrix with rows and columns representing vertices stores a weight to indicate if vertices are connected and by what weight. For example, if there is a directed edge of weight 5.6 from vertex A to vertex B, then the entry with row for vertex A and column for vertex B would have the value 5.6:
**邻接矩阵。**在邻接矩阵实现中，具有表示点的行和列的矩阵存储权重以指示点是否连接以及权重。 例如，如果从点A到点B有一个权重为5.6的有向边，那么点A的行和点B的列的条目的值为5.6：

![Adjacency matrix](Images/AdjacencyMatrix.png)

Adding another vertex to the graph is expensive, because a new matrix structure must be created with enough space to hold the new row/column, and the existing structure must be copied into the new one.
向图表添加另一个点是很昂贵的，因为必须创建一个新的矩阵结构，并有足够的空间来容纳新的行/列，并且必须将现有结构复制到新的结构/列中。

So which one should you use? Most of the time, the adjacency list is the right approach. What follows is a more detailed comparison between the two.
那么你应该使用哪一个？ 大多数情况下，邻接列表是正确的方法。 以下是两者之间更详细的比较。

Let *V* be the number of vertices in the graph, and *E* the number of edges.  Then we have:
设 *V* 是图中点的数量，*E* 是边数。 然后我们有：

| Operation       | Adjacency List | Adjacency Matrix |
|-----------------|----------------|------------------|
| Storage Space   | O(V + E)       | O(V^2)           |
| Add Vertex      | O(1)           | O(V^2)           |
| Add Edge        | O(1)           | O(1)             |
| Check Adjacency | O(V)           | O(1)             |

| 操作             | 邻接列表        | 邻接矩阵            |
|-----------------|----------------|------------------ |
| 存储空间         | O（V + E）      | O（V ^ 2）|
| 添加点         | O（1）          | O（V ^ 2）|
| 添加边         | O（1）          | O（1）|
| 检查邻接         | O（V）          | O（1）|

"Checking adjacency" means that we try to determine that a given vertex is an immediate neighbor of another vertex. The time to check adjacency for an adjacency list is **O(V)**, because in the worst case a vertex is connected to *every* other vertex.
“检查邻接”意味着我们试图确定给定点是另一个点的直接邻居。 检查邻接列表的邻接的时间是 **O(V)**，因为在最坏的情况下，点连接到*每个*其他点。

In the case of a *sparse* graph, where each vertex is connected to only a handful of other vertices, an adjacency list is the best way to store the edges. If the graph is *dense*, where each vertex is connected to most of the other vertices, then a matrix is preferred.
在*稀疏*图形的情况下，每个点仅连接到少数其他点，邻接列表是存储边的最佳方式。 如果图形是*密集*，其中每个点连接到大多数其他点，则优选矩阵。

Here are sample implementations of both adjacency list and adjacency matrix:
以下是邻接列表和邻接矩阵的示例实现：

## The code: edges and vertices
## 代码：边和点

The adjacency list for each vertex consists of `Edge` objects:
每个点的邻接列表由`Edge`对象组成：

```swift
public struct Edge<T>: Equatable where T: Equatable, T: Hashable {

  public let from: Vertex<T>
  public let to: Vertex<T>

  public let weight: Double?

}
```

This struct describes the "from" and "to" vertices and a weight value. Note that an `Edge` object is always directed, a one-way connection (shown as arrows in the illustrations above). If you want an undirected connection, you also need to add an `Edge` object in the opposite direction. Each `Edge` optionally stores a weight, so they can be used to describe both weighted and unweighted graphs.
此结构描述了“from”和“to”点以及权重值。 请注意，`Edge`对象始终是定向的，单向连接（如上图中的箭头所示）。 如果需要无向连接，还需要在相反方向添加`Edge`对象。 每个`Edge`可选地存储权重，因此它们可用于描述加权和未加权图形。

The `Vertex` looks like this:
`Vertex`看起来像这样：

```swift
public struct Vertex<T>: Equatable where T: Equatable, T: Hashable {

  public var data: T
  public let index: Int

}
```

It stores arbitrary data with a generic type `T`, which is `Hashable` to enforce uniqueness, and also `Equatable`. Vertices themselves are also `Equatable`.
它存储了一个通用类型`T`的任意数据，它是`Hashable`以强制唯一性，还有`Equatable`。 点本身也是`Equatable`。

## The code: graphs
## 代码：图

> **Note:** There are many ways to implement graphs. The code given here is just one possible implementation. You probably want to tailor the graph code to each individual problem you are trying to solve. For instance, your edges may not need a `weight` property, or you may not have the need to distinguish between directed and undirected edges.
> **注意：** 有很多方法可以实现图形。 这里给出的代码只是一种可能的实现。 您可能希望根据您尝试解决的每个问题定制图形代码。 例如，您的边可能不需要“权重”属性，或者您可能不需要区分有向边和无向边。

Here is an example of a simple graph:
这是简单图的例子：

![Demo](Images/Demo1.png)

We can represent it as an adjacency matrix or adjacency list. The classes implementing those concepts both inherit a common API from `AbstractGraph`, so they can be created in an identical fashion, with different optimized data structures behind the scenes.
我们可以将其表示为邻接矩阵或邻接列表。 实现这些概念的类都从`AbstractGraph`继承了一个通用API，因此它们可以以相同的方式创建，在幕后具有不同的优化数据结构。

Let's create some directed, weighted graphs, using each representation, to store the example:
让我们使用每个表示创建一些有向图的加权图来存储示例：

```swift
for graph in [AdjacencyMatrixGraph<Int>(), AdjacencyListGraph<Int>()] {

  let v1 = graph.createVertex(1)
  let v2 = graph.createVertex(2)
  let v3 = graph.createVertex(3)
  let v4 = graph.createVertex(4)
  let v5 = graph.createVertex(5)

  graph.addDirectedEdge(v1, to: v2, withWeight: 1.0)
  graph.addDirectedEdge(v2, to: v3, withWeight: 1.0)
  graph.addDirectedEdge(v3, to: v4, withWeight: 4.5)
  graph.addDirectedEdge(v4, to: v1, withWeight: 2.8)
  graph.addDirectedEdge(v2, to: v5, withWeight: 3.2)

}
```

As mentioned earlier, to create an undirected edge you need to make two directed edges. For undirected graphs, we call the following method instead:
如前所述，要创建无向边，您需要制作两个有向边。 对于无向图，我们改为使用以下方法：

```swift
  graph.addUndirectedEdge(v1, to: v2, withWeight: 1.0)
  graph.addUndirectedEdge(v2, to: v3, withWeight: 1.0)
  graph.addUndirectedEdge(v3, to: v4, withWeight: 4.5)
  graph.addUndirectedEdge(v4, to: v1, withWeight: 2.8)
  graph.addUndirectedEdge(v2, to: v5, withWeight: 3.2)
```

We could provide `nil` as the values for the `withWeight` parameter in either case to make unweighted graphs.
在任何一种情况下，我们都可以提供`nil`作为`withWeight`参数的值来制作未加权的图形。

## The code: adjacency list
## 代码：邻接列表

To maintain the adjacency list, there is a class that maps a list of edges to a vertex. The graph simply maintains an array of such objects and modifies them as necessary.
为了维护邻接列表，有一个类将边列表映射到点。 该图只是维护这些对象的数组，并根据需要修改它们。

```swift
private class EdgeList<T> where T: Equatable, T: Hashable {

  var vertex: Vertex<T>
  var edges: [Edge<T>]? = nil

  init(vertex: Vertex<T>) {
    self.vertex = vertex
  }

  func addEdge(_ edge: Edge<T>) {
    edges?.append(edge)
  }

}
```

They are implemented as a class as opposed to structs, so we can modify them by reference, in place, like when adding an edge to a new vertex, where the source vertex already has an edge list:
它们被实现为一个类而不是结构，所以我们可以通过引用来修改它们，就像将边添加到新点一样，源点已经有一个边列表：

```swift
open override func createVertex(_ data: T) -> Vertex<T> {
  // check if the vertex already exists
  let matchingVertices = vertices.filter() { vertex in
    return vertex.data == data
  }

  if matchingVertices.count > 0 {
    return matchingVertices.last!
  }

  // if the vertex doesn't exist, create a new one
  let vertex = Vertex(data: data, index: adjacencyList.count)
  adjacencyList.append(EdgeList(vertex: vertex))
  return vertex
}
```

The adjacency list for the example looks like this:

```
v1 -> [(v2: 1.0)]
v2 -> [(v3: 1.0), (v5: 3.2)]
v3 -> [(v4: 4.5)]
v4 -> [(v1: 2.8)]
```

where the general form `a -> [(b: w), ...]` means an edge exists from `a` to `b` with weight `w` (with possibly more edges connecting `a` to other vertices as well).
一般形式`a - > [（b：w），...]`表示边从`a`到`b`存在，重量为`w`（可能有更多的边连接`a`到其他点为 好）。

## The code: adjacency matrix
## 代码：邻接矩阵

We will keep track of the adjacency matrix in a two-dimensional `[[Double?]]` array. An entry of `nil` indicates no edge, while any other value indicates an edge of the given weight. If `adjacencyMatrix[i][j]` is not nil, then there is an edge from vertex `i` to vertex `j`.
我们将在二维`[[Double？]]`数组中跟踪邻接矩阵。 `nil`条目表示没有边，而任何其他值表示给定重量的边。 如果`adjacencyMatrix[i][j]`不是`nil`，则从点`i`到点`j`有一条边。

To index into the matrix using vertices, we use the `index` property in `Vertex`, which is assigned when creating the vertex through the graph object. When creating a new vertex, the graph must resize the matrix:
要使用点索引矩阵，我们使用`Vertex`中的`index`属性，该属性是在通过图形对象创建点时分配的。 创建新点时，图形必须调整矩阵的大小：

```swift
open override func createVertex(_ data: T) -> Vertex<T> {
  // check if the vertex already exists
  let matchingVertices = vertices.filter() { vertex in
    return vertex.data == data
  }

  if matchingVertices.count > 0 {
    return matchingVertices.last!
  }

  // if the vertex doesn't exist, create a new one
  let vertex = Vertex(data: data, index: adjacencyMatrix.count)

  // Expand each existing row to the right one column.
  for i in 0 ..< adjacencyMatrix.count {
    adjacencyMatrix[i].append(nil)
  }

  // Add one new row at the bottom.
  let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
  adjacencyMatrix.append(newRow)

  _vertices.append(vertex)

  return vertex
}
```

Then the adjacency matrix looks like this:
然后邻接矩阵看起来像这样：

	[[nil, 1.0, nil, nil, nil]    v1
	 [nil, nil, 1.0, nil, 3.2]    v2
	 [nil, nil, nil, 4.5, nil]    v3
	 [2.8, nil, nil, nil, nil]    v4
	 [nil, nil, nil, nil, nil]]   v5

	  v1   v2   v3   v4   v5


## See also
## 扩展阅读

This article described what a graph is, and how you can implement the basic data structure. We have other articles on practical uses of graphs, so check those out too!
本文描述了图形是什么，以及如何实现基本数据结构。 我们还有关于图实际用途的其他文章，所以也要检查一下！

*Written by Donald Pinckney and Matthijs Hollemans*

*作者：Donald Pinckney， Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
