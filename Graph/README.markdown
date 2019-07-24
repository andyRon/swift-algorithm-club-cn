# 图(Graph)

> 这个话题已经有个辅导[文章](https://www.raywenderlich.com/152046/swift-algorithm-club-graphs-adjacency-list)

图看上去像下图：

![A graph](Images/Graph.png)

在计算机科学中，图形被定义为一组*点*和与之配对的一组*边*。 点用圆圈表示，边是它们之间的线。 边链接点与点。

> **注意：** 点有时称为“节点”，边称为“链接”。

图可以代表社交网络。 每个人都是一个点，彼此认识的人通过边链接。 下面是一个有点历史不准确的例子：

![Social network](Images/SocialNetwork.png)

图具有各种形状和大小。 当为每个边分配正数或负数，边可以具有*权重*。 考虑一个代表飞机航班的图示例。 城市用点表示，而航班用边表示。 然后，边权重可以描述航班时间或票价。

![Airplane flights](Images/Flights.png)

有了这个假想的航线，从旧金山(San Francisco)飞往莫斯科(Moscow)，经过纽约(New York)这条航线是最便宜的。

边也可以*有向的*。 在上面提到的例子中，边是无向的。 例如，如果阿达（Ada）可以到达查尔斯（Charles），那么查尔斯也可以到达阿达。 另一方面，有向边意味着单向关系。 从点X到点Y的有向边链接X到Y，但Y*不能*到X.

从航班的例子来看，从旧金山到阿拉斯加的朱诺( Juneau, Alaska)的有向的边表明从旧金山到朱诺的航班，但不是从朱诺到旧金山（我想这意味着你正在走回头路）的航班。

![One-way flights](Images/FlightsDirected.png)

以下也是图：

![Tree and linked list](Images/TreeAndList.png)

左边是[树](../Tree/)结构，右边是[链表](../Linked%20List/)。 它们可以被视为形式更简单的图。 它们都有点（节点）和边（链接）。

第一个图（译注：文章的第一个图）包括*循环*，您可以从点开始，沿着路径，然后返回到原始点。 树是没有这种循环的图。

另一种常见类型的图是*有向无环图*(DAG, directed acyclic graph)：

![DAG](Images/DAG.png)

像树一样，这个图没有任何循环（无论你从哪里开始，都没有回到起始点的路径），但是这个图的定向边的形状不一定形成层次结构。

## 为什么使用图？

也许你耸耸肩膀思考，有什么大不了的？ 好吧，事实证明图是一种有用的数据结构。

如果您遇到编程问题，您可以将数据表示为点和边，那么您可以将你的问题绘制为图形并使用众所周知的图算法，例如[广度优先搜索](../Breadth-First%20Search/)或[深度优先搜索](../Depth-First%20Search)找到解决方案。

例如，假设您有一个任务列表，其中某些任务必须先等待其他任务才能开始。 您可以使用非循环有向图对此进行建模：

![Tasks as a graph](Images/Tasks.png)

每个点代表一个任务。 两个点之间的边意味着必须在目标任务开始之前必须完成源任务。 例如，任务C在B和D完成之前无法启动，B和D可以在A完成之前启动。

现在使用图表表示问题，您可以使用深度优先搜索来执行[拓扑排序](../Topological%20Sort/)。 这将使任务处于最佳顺序，以便最大限度地减少等待任务完成所花费的时间。 （这里可能的一个顺序是A，B，D，E，C，F，G，H，I，J，K。）

无论何时遇到困难的编程问题，请问自己，“如何使用图表示此问题？” 图是你所有数据之间特定关系。 诀窍在于如何定义“关系”。

如果您是音乐家，您可能会喜欢这张图：

![Chord map](Images/ChordMap.png)

这些点是C大调的和弦。 边 —— 和弦之间的关系 —— 代表[可能一个和弦跟随另一个和弦](http://mugglinworks.com/chordmaps/genmap.htm)。 这是一个有向图，因此箭头的方向显示了如何从一个和弦转到下一个和弦。 它也是一个权重图，其中边的权重 —— 这里用线条粗细描绘 —— 显示了两个和弦之间的强关系。 正如你所看到的，G7和弦很可能后跟一个C和弦，也可能是一个Am和弦。

您可能在不知道图时，已经使用过图了。 您的数据模型也是图（来自Apple的Core Data文档）：

![Core Data model](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreDataVersioning/Art/recipe_version2.0.jpg)

程序员使用的另一个常见图是状态机(state machine)，其中边描述了状态之间转换的条件。 这是一个模拟我的猫的状态机：

![State machine](Images/StateMachine.png)

图很棒。 Facebook从他们的社交图中赚了大钱。 如果要学习任何数据结构，则必须选择图和大量标准图算法。

## 哦，我的点和边！

理论上，图只是一堆点和边对象，但是如何在代码中描述它？

有两种主要策略：邻接表和邻接矩阵。

**邻接表(Adjacency List)**。在邻接表实现中，每个点存储一个从这个点出发的所有边的列表。例如，如果点A具有到点B，C和D的边，则点A将具有包含3个边的列表。

![Adjacency list](Images/AdjacencyList.png)

邻接表描述了传出边。 A具有到B的边，但是B没有返回到A的边，因此A不出现在B的邻接表中。在两个点之间找到边或权重成本可能很高，因为没有随机访问边。 您必须遍历邻接表，直到找到它为止。

**邻接矩阵(Adjacency Matrix)**。 在邻接矩阵实现中，具有表示顶点的行和列的矩阵存储权重以指示顶点是否连接以及权重。  例如，如果从点A到点B有一个权重为5.6的有向边，那么点A行和B列交叉的值为5.6：

![Adjacency matrix](Images/AdjacencyMatrix.png)

向图添加另一个点是成本很高，因为必须创建一个新的矩阵结构，并有足够的空间来容纳新的行/列，并且必须将现有结构复制到新的矩阵结构中。

那么你应该使用哪一个？ 大多数情况下，邻接表是正确的方法。 以下是两者之间更详细的比较。

设 *V* 是图中点的数量，*E* 是边数。 然后我们有：


| 操作             | 邻接列表        | 邻接矩阵            |
|-----------------|----------------|------------------ |
| 存储空间         |  O(V + E)       | O(V^2)           |
| 添加点           | O(1)           | O(V^2)           |
| Add Edge        | O(1)           | O(1)             |
| 添加边           | O(1)           | O(1)             |
| 检查邻接         | O(V)           | O(1)             |


“检查邻接”意味着我们试图确定给定点是另一个点的直接邻居。 检查邻接表的邻接的时间是 **O(V)**，因为在最坏的情况下，点需要连接到*每个*其他点。

在*稀疏*图的情况下，每个点仅链接到少数其他点，邻接表是存储边的最佳方式。 如果图是*密集*的，其中每个点连接到大多数其他点，则优选矩阵。

以下是邻接表和邻接矩阵的示例实现：

## 代码：边和点

每个点的邻接表由`Edge`对象组成：

```swift
public struct Edge<T>: Equatable where T: Equatable, T: Hashable {

  public let from: Vertex<T>
  public let to: Vertex<T>

  public let weight: Double?

}
```

此结构描述了“from”和“to”点以及权重值。 请注意，`Edge`对象始终是有向的，单向连接（如上图中的箭头所示）。 如果需要无向连接，还需要在相反方向添加`Edge`对象。 每个`Edge`可选地存储权重，因此它们可用于描述权重和无权重图。

`Vertex`看起来像这样：

```swift
public struct Vertex<T>: Equatable where T: Equatable, T: Hashable {

  public var data: T
  public let index: Int

}
```

它存储了一个可以表示任意数据泛型`T`，它是`Hashable`以强制唯一性，还有`Equatable`。 点本身也是`Equatable`。

## 代码：图

> **注意：** 有很多方法可以实现图。 这里给出的代码只是一种可能的实现。 您可能希望根据为您尝试解决的每个问题定制图代码。 例如，您的边可能不需要`weight`属性，或者您可能不需要区分有向边和无向边。

这是简单图的例子：

![Demo](Images/Demo1.png)

我们可以将其表示为邻接矩阵或邻接表。 实现这些概念的类都从`AbstractGraph`继承了一个通用API，因此它们可以以相同的方式创建，在幕后具有不同的优化数据结构。

让我们使用每个表示创建一些有向权重图来存储示例：

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

如前所述，要创建无向边，您需要制作两个有向边。 对于无向图，我们改为使用以下方法：

```swift
  graph.addUndirectedEdge(v1, to: v2, withWeight: 1.0)
  graph.addUndirectedEdge(v2, to: v3, withWeight: 1.0)
  graph.addUndirectedEdge(v3, to: v4, withWeight: 4.5)
  graph.addUndirectedEdge(v4, to: v1, withWeight: 2.8)
  graph.addUndirectedEdge(v2, to: v5, withWeight: 3.2)
```

在任何一种情况下，我们都可以提供`nil`作为`withWeight`参数的值来制作无权重图。

## 代码：邻接表

为了维护邻接表，有一个类将边列表映射到点。 该图只是维护这些对象的数组，并根据需要修改它们。

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

该示例的邻接表如下所示：

```
v1 -> [(v2: 1.0)]
v2 -> [(v3: 1.0), (v5: 3.2)]
v3 -> [(v4: 4.5)]
v4 -> [(v1: 2.8)]
```

一般形式`a -> [(b: w), ...]`，表示从`a`到`b`的边是存在的，权重为`w`（可能有更多`a`出去的边）。

## 代码：邻接矩阵

我们将在二维`[[Double?]]`数组中追踪邻接矩阵。 `nil`表示没有边，而任何其他值表示给定权重的边。 如果`adjacencyMatrix[i][j]`不是`nil`，则从点`i`到点`j`有一条边。

要使用点索引矩阵，我们使用`Vertex`中的`index`属性，该属性是在通过图对象创建点时分配的。 创建新点时，图必须调整矩阵的大小：

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

然后邻接矩阵看起来像这样：

	[[nil, 1.0, nil, nil, nil]    v1
	 [nil, nil, 1.0, nil, 3.2]    v2
	 [nil, nil, nil, 4.5, nil]    v3
	 [2.8, nil, nil, nil, nil]    v4
	 [nil, nil, nil, nil, nil]]   v5
	
	  v1   v2   v3   v4   v5


## 扩展阅读

本文描述了图是什么，以及如何实现基本数据结构。 我们还有关于图实际用途的其他文章，所以也要查看一下！


*作者：Donald Pinckney， Matthijs Hollemans*     
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  