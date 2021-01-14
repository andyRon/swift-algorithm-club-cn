# Weighted graph general concepts
# 加权图一般概念

Every weighted graph should contain:
1. Vertices/Nodes (I will use "vertex" in this readme).

每个加权图应包含：
1. 顶点/节点（我将在本自述文件中使用“顶点”）。

<img src="Images/Vertices.png" height="250" />

2. Edges connecting vertices. Let's add some edges to our graph. For simplicity let's create directed graph for now. Directed means that edge has a direction, i.e. vertex, where it starts and vertex, where it ends. But remember a VERY IMPORTANT thing:
    * All undirected graphs can be viewed as a directed graph.
    * A directed graph is undirected if and only if every edge is paired with an edge going in the opposite direction.

2. 连接顶点的边缘。 让我们在图中添加一些边。 为简单起见，我们现在创建有向图。 定向意味着边缘有一个方向，即顶点，它开始的位置和顶点，它的终点。 但请记住一件非常重要的事情：
     * 所有无向图可以被视为有向图。
     * 当且仅当每个边缘与沿相反方向的边缘配对时，有向图是无向的。

<img src="Images/DirectedGraph.png" height="250" />

3. Weights for every edge.
3. 每个边的权重。

<img src="Images/WeightedDirectedGraph.png" height="250" />

Final result.
Directed weighted graph:

最后结果。
定向加权图：

<img src="Images/WeightedDirectedGraphFinal.png" height="250" />

Undirected weighted graph:

<img src="Images/WeightedUndirectedGraph.png" height="250" />

And once again: An undirected graph it is a directed graph with every edge paired with an edge going in the opposite direction. This statement is clear on the image above.

Great! Now we are familiar with general concepts about graphs.

再一次：一个无向图，它是一个有向图，每条边与一条边相反。 这个陈述在上面的图片中很清楚。

大！ 现在我们熟悉关于图的一般概念。

# The Dijkstra's algorithm

This [algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) was invented in 1956 by Edsger W. Dijkstra.
这个[算法](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)由Edsger W. Dijkstra于1956年发明。

It can be used when you have one source vertex and want to find the shortest paths to ALL other vertices in the graph.

The best example is a road network. If you want to find the shortest path from your house to your job or if you want to find the closest store to your house then it is time for the Dijkstra's algorithm.

当您有一个源顶点并且想要找到图中所有其他顶点的最短路径时，可以使用它。

最好的例子是道路网络。 如果你想找到从你家到你工作的最短路径，或者如果你想找到离你家最近的商店，那么现在是Dijkstra算法的时候了。

The algorithm repeats following cycle until all vertices are marked as visited.
Cycle:
1. From the non-visited vertices the algorithm picks a vertex with the shortest path length from the start (if there are more than one vertex with the same shortest path value then algorithm picks any of them)
2. The algorithm marks picked vertex as visited.
3. The algorithm checks all of its neighbours. If the current vertex path length from the start plus an edge weight to a neighbour less than the neighbour current path length from the start than it assigns new path length from the start to the neighbour.
When all vertices are marked as visited, the algorithm's job is done. Now, you can see the shortest path from the start for every vertex by pressing the one you are interested in.

算法重复以下循环，直到所有顶点都标记为已访问。
周期：
1. 从非访问顶点，算法从开始选择具有最短路径长度的顶点（如果有多个具有相同最短路径值的顶点，则算法选择其中任何一个）
2. 该算法将拾取的顶点标记为已访问。
3. 算法检查所有邻居。 如果从开始加上边缘权重到邻居的当前顶点路径长度小于从开始起的邻居当前路径长度，则从开始到邻居分配新的路径长度。
当所有顶点都标记为已访问时，算法的作业就完成了。 现在，您可以按下您感兴趣的那个，从每个顶点开始看到从最开始的最短路径。

I have created **VisualizedDijkstra.playground** game/tutorial to improve your understanding of the algorithm's flow. Besides, below is step by step algorithm's description.

A short sidenote. The Swift Algorithm Club also contains the A* algorithm, which essentially is a faster version of Dijkstra's algorithm for which the only extra prerequisite is you have to know where the destination is located.

我创建了 **VisualizedDijkstra.playground** 游戏/教程，以提高您对算法流程的理解。 此外，下面是逐步算法的描述。

一个简短的旁注。 Swift算法俱乐部还包含 `A*`算法，它本质上是Dijkstra算法的更快版本，唯一的额外先决条件是您必须知道目的地的位置。

## Example
## 例子

Let's imagine that you want to go to the shop. Your house is A vertex and there are 4 possible stores around your house. How to find the closest one/ones? Luckily, you have a graph that connects your house with all these stores. So, you know what to do :)

让我们想象你想去商店。 你的房子是一个顶点，你家周围有4个可能的商店。 如何找到最近的一个/一个？ 幸运的是，你有一个图表，连接你的房子和所有这些商店。 所以，你知道怎么做:)

### Initialisation
### 初始化

When the algorithm starts to work initial graph looks like this:
当算法开始工作时，初始图形如下所示：

<img src="Images/image1.png" height="250" />

The table below represents graph state:
下表表示图形状态：

|                           |  A  |  B  |  C  |  D  |  E  |
|:------------------------- |:---:|:---:|:---:|:---:|:---:|
| Visited                   |  F  |  F  |  F  |  F  |  F  |
| Path Length From Start    | inf | inf | inf | inf | inf |
| Path Vertices From Start  | [ ] | [ ] | [ ] | [ ] | [ ] |

>inf is equal infinity which basically means that algorithm doesn't know how far away is this vertex from start one.

>F states for False

>T states for True

> inf等于无穷大，这基本上意味着算法不知道这个顶点距离起点有多远。

> F表示False

> T表示True

To initialize our graph we have to set source vertex path length from source vertex to 0 and append itself to path vertices from start.
要初始化我们的图形，我们必须将源顶点路径长度从源顶点设置为0，并将自身附加到从start开始的路径顶点。


|                           |  A  |  B  |  C  |  D  |  E  |
|:------------------------- |:---:|:---:|:---:|:---:|:---:|
| Visited                   |  F  |  F  |  F  |  F  |  F  |
| Path Length From Start    |  0  | inf | inf | inf | inf |
| Path Vertices From Start  | [A] | [ ] | [ ] | [ ] | [ ] |

Great, now our graph is initialised and we can pass it to the Dijkstra's algorithm, let's start!

Let's follow the algorithm's cycle and pick the first vertex which neighbours we want to check.
All our vertices are not visited but there is only one has the smallest path length from start. It is A. This vertex is the first one which neighbors we will check.
First of all, set this vertex as visited.

太好了，现在我们的图表被初始化了，我们可以将它传递给Dijkstra的算法，让我们开始吧！

让我们按照算法的循环，选择我们要检查的邻居的第一个顶点。
我们没有访问所有顶点，但只有一个顶点从开始开始具有最小的路径长度。 它是A.这个顶点是我们将检查的邻居的第一个顶点。
首先，将此顶点设置为已访问。

A.visited = true

<img src="Images/image2.png" height="250" />

After this step graph has this state:
在此步骤图之后具有以下状态：

|                           |  A  |  B  |  C  |  D  |  E  |
|:------------------------- |:---:|:---:|:---:|:---:|:---:|
| Visited                   |  T  |  F  |  F  |  F  |  F  |
| Path Length From Start    |  0  | inf | inf | inf | inf |
| Path Vertices From Start  | [A] | [ ] | [ ] | [ ] | [ ] |

### Step 1

Then we check all of its neighbours.
If checking vertex path length from start + edge weight is smaller than neighbour's path length from start then we set neighbour's path length from start new value and append to its pathVerticesFromStart array new vertex: checkingVertex. Repeat this action for every vertex.

然后我们检查所有邻居。
如果检查顶点路径长度从 start + edge weight开始小于邻居的路径长度那么我们从start new value设置邻居的路径长度并追加到它的pathVerticesFromStart数组new vertex：checkingVertex。 对每个顶点重复此操作。

for clarity:
```swift
if (A.pathLengthFromStart + AB.weight) < B.pathLengthFromStart {
    B.pathLengthFromStart = A.pathLengthFromStart + AB.weight
    B.pathVerticesFromStart = A.pathVerticesFromStart
    B.pathVerticesFromStart.append(B)
}
```
And now our graph looks like this one:

现在我们的图表看起来像这样：

<img src="Images/image3.png" height="250" />

And its state is here:
它的状态在这里：

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     F      |     F      |     F      |     F      |
| Path Length From Start    |     0      |     3      |    inf     |     1      |    inf     |
| Path Vertices From Start  |    [A]     |   [A, B]   |    [ ]     |   [A, D]   |    [ ]     |

### Step 2

From now we repeat all actions again and fill our table with new info!

从现在开始，我们再次重复所有操作，并用新信息填写我们的表格！

<img src="Images/image4.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     F      |     F      |     T      |     F      |
| Path Length From Start    |     0      |     3      |    inf     |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |    [ ]     |   [A, D]   | [A, D, E]  |

### Step 3

<img src="Images/image5.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     F      |     F      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     11     |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |[A, D, E, C]|   [A, D]   | [A, D, E ] |

### Step 4

<img src="Images/image6.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     T      |     F      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     8      |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |   [A, B, C]|   [A, D]   | [A, D, E ] |

### Step 5

<img src="Images/image7.png" height="250" />

|                           |     A      |     B      |     C      |     D      |     E      |
|:------------------------- |:----------:|:----------:|:----------:|:----------:|:----------:|
| Visited                   |     T      |     T      |     T      |     T      |     T      |
| Path Length From Start    |     0      |     3      |     8      |     1      |     2      |
| Path Vertices From Start  |    [A]     |   [A, B]   |   [A, B, C]|   [A, D]   | [A, D, E ] |


## Code implementation
## 代码实现

First of all, let’s create class that will describe any Vertex in the graph.
It is pretty simple

首先，让我们创建一个类来描述图中的任何顶点。
这很简单

```swift
open class Vertex {

    //Every vertex should be unique that's why we set up identifier
    open var identifier: String

    //For Dijkstra every vertex in the graph should be connected with at least one other vertex. But there can be some usecases
    //when you firstly initialize all vertices without neighbours. And then on next iteration you set up their neighbours. So, initially neighbours is an empty array.
    //Array contains tuples (Vertex, Double). Vertex is a neighbour and Double is as edge weight to that neighbour.
    open var neighbours: [(Vertex, Double)] = []

    //As it was mentioned in the algorithm description, default path length from start for all vertices should be as much as possible.
    //It is var because we will update it during the algorithm execution.
    open var pathLengthFromStart = Double.infinity

    //This array contains vertices which we need to go through to reach this vertex from starting one
    //As with path length from start, we will change this array during the algorithm execution.
    open var pathVerticesFromStart: [Vertex] = []

    public init(identifier: String) {
        self.identifier = identifier
    }

    //This function let us use the same array of vertices again and again to calculate paths with different starting vertex.
    //When we will need to set new starting vertex and recalculate paths then we will simply clear graph vertices' cashes.
    open func clearCache() {
        pathLengthFromStart = Double.infinity
        pathVerticesFromStart = []
    }
}
```

As every vertex should be unique it is useful to make them Hashable and according Equatable. We use an identifier for this purposes.

由于每个顶点都应该是唯一的，因此将它们设为Hashable并根据Equatable非常有用。 我们为此目的使用标识符。

```swift
extension Vertex: Hashable {
    open var hashValue: Int {
        return identifier.hashValue
    }
}

extension Vertex: Equatable {
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
```

We've created a base for our algorithm. Now let's create a house :)
Dijkstra's realisation is really straightforward.

我们已经为我们的算法创建了一个基础。 现在让我们创建一个房子:)
Dijkstra的实现非常简单。

```swift
public class Dijkstra {
    //This is a storage for vertices in the graph.
    //Assuming that our vertices are unique we can use Set instead of array. This approach will bring some benefits later.
    private var totalVertices: Set<Vertex>

    public init(vertices: Set<Vertex>) {
        totalVertices = vertices
    }

    //Remember clearCache function in the Vertex class implementation?
    //This is just a wrapper that cleans cache for all stored vertices.
    private func clearCache() {
        totalVertices.forEach { $0.clearCache() }
    }

    public func findShortestPaths(from startVertex: Vertex) {
	//Before we start searching the shortest path from startVertex,
	//we need to clear vertices cache just to be sure that out graph is clean.
	//Remember that every Vertex is a class and classes are passed by reference.
	//So whenever you change vertex outside of this class it will affect this vertex inside totalVertices Set
        clearCache()
	//Now all our vertices have Double.infinity pathLengthFromStart and an empty pathVerticesFromStart array.

	//The next step in the algorithm is to set startVertex pathLengthFromStart and pathVerticesFromStart
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)

	//Here starts the main part. We will use while loop to iterate through all vertices in the graph.
	//For this purpose we define currentVertex variable which we will change in the end of each while cycle.
        var currentVertex: Vertex? = startVertex

        while let vertex = currentVertex {

    	    //Next line of code is an implementation of setting vertex as visited.
    	    //As it has been said, we should check only unvisited vertices in the graph,
	    //So why don't just delete it from the set? This approach let us skip checking for *"if !vertex.visited then"*
            totalVertices.remove(vertex)

	    //filteredNeighbours is an array that contains current vertex neighbours which aren't yet visited
            let filteredNeighbours = vertex.neighbours.filter { totalVertices.contains($0.0) }

	    //Let's iterate through them
            for neighbour in filteredNeighbours {
		//These variable are more representative, than neighbour.0 or neighbour.1
                let neighbourVertex = neighbour.0
                let weight = neighbour.1

		//Here we calculate new weight, that we can offer to neighbour.
                let theoreticNewWeight = vertex.pathLengthFromStart + weight

		//If it is smaller than neighbour's current pathLengthFromStart
		//Then we perform this code
                if theoreticNewWeight < neighbourVertex.pathLengthFromStart {

		    //set new pathLengthFromStart
                    neighbourVertex.pathLengthFromStart = theoreticNewWeight

		    //set new pathVerticesFromStart
                    neighbourVertex.pathVerticesFromStart = vertex.pathVerticesFromStart

		    //append current vertex to neighbour's pathVerticesFromStart
                    neighbourVertex.pathVerticesFromStart.append(neighbourVertex)
                }
            }

	    //If totalVertices is empty, i.e. all vertices are visited
	    //Than break the loop
            if totalVertices.isEmpty {
                currentVertex = nil
                break
            }

	    //If loop is not broken, than pick next vertex for checkin from not visited.
	    //Next vertex pathLengthFromStart should be the smallest one.
            currentVertex = totalVertices.min { $0.pathLengthFromStart < $1.pathLengthFromStart }
        }
    }
}
```

That's all! Now you can check this algorithm in the playground. On the main page there is a code for creating a random graph.

Also there is a **VisualizedDijkstra.playground**. Use it to figure out the algorithm's flow in real (slowed :)) time.

It is up to you how to implement some specific parts of the algorithm, you can use Array instead of Set, add _visited_ property to Vertex or you can create some local totalVertices Array/Set inside _func findShortestPaths(from startVertex: Vertex)_ to keep totalVertices Array/Set unchanged. This is a general explanation with one possible implementation :)

就这样！ 现在您可以在操场上查看此算法。 在主页面上有一个用于创建随机图的代码。

还有一个**VisualizedDijkstra.playground**。 用它来计算实际（slowed :)时间内算法的流量。

由你来决定如何实现算法的某些特定部分，你可以使用Array而不是Set，将 _visited_ 属性添加到Vertex，或者你可以在_func中创建一些局部totalVertices数组/设置 _func findShortestPaths(from startVertex: Vertex)_ 来保持 totalVertices数组/集不变。 这是一个可能的实现的一般解释:)

# About this repository

This repository contains two playgrounds:
* To understand how does this algorithm works, I created **VisualizedDijkstra.playground.** It works in auto and interactive modes. Moreover, there are play/pause/stop buttons.
* If you need only realisation of the algorithm without visualisation then run **Dijkstra.playground.** It contains necessary classes and couple functions to create random graph for algorithm testing.

该存储库包含两个游乐场：
* 为了理解这个算法是如何工作的，我创建了 **VisualizedDijkstra.playground**。 它适用于自动和交互模式。 此外，还有播放/暂停/停止按钮。
* 如果您只需要实现没有可视化的算法，那么运行**Dijkstra.playground**。 它包含必要的类和几个函数来创建用于算法测试的随机图。

# Demo video

Click the link: [YouTube](https://youtu.be/PPESI7et0cQ)

# Credits

WWDC 2017 Scholarship Project (Rejected) created by [Taras Nikulin](https://github.com/crabman448)
