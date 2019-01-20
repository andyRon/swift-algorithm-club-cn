

# 拓扑排序(Topological Sort)

Topological sort is an algorithm that orders a directed graph such that for each directed edge *u→v*, vertex *u* comes before vertex *v*.
拓扑排序是一种对有向图进行排序的算法，使得对于每个有向边*u→v*，顶点*u*在顶点*v*之前。

In other words, a topological sort places the vertices of a [directed acyclic graph](../Graph/) on a line so that all directed edges go from left to right. 
换句话说，拓扑排序将[有向无环图](../Graph/)的顶点放在一条直线上，以便所有有向边从左到右。

Consider the graph in the following example:
请考虑以下示例中的图表：

![Example](Images/Graph.png)

This graph has two possible topological sorts:
该图有两种可能的拓扑排序：

![Example](Images/TopologicalSort.png)

The topological orderings are **S, V, W, T, X** and **S, W, V, T, X**. Notice how the arrows all go from left to right.
拓扑排序是 **S, V, W, T, X** 和 **S, W, V, T, X**。 注意箭头是如何从左到右的。

The following is not a valid topological sort for this graph, since **X** and **T** cannot happen before **V**:
以下不是该图的有效拓扑排序，因为**X**和**T**不能在**V**之前发生：

![Example](Images/InvalidSort.png)

## Where is this used?
## 在哪里使用？

Let's consider that you want to learn all the algorithms and data structures from the Swift Algorithm Club. This might seem daunting at first but we can use topological sort to get things organized.
让我们考虑一下你想要学习Swift算法俱乐部的所有算法和数据结构。 这可能看起来令人生畏，但我们可以使用拓扑排序来使事情井井有条。

Since you're learning about topological sort, let's take this topic as an example. What else do you need to learn first before you can fully understand topological sort? Well, topological sort uses [depth-first search](../Depth-First%20Search/) as well as a [stack](../Stack/). But before you can learn about the depth-first search algorithm, you need to know what a [graph](../Graph/) is, and it helps to know what a [tree](../Tree/) is. In turn, graphs and trees use the idea of linking objects together, so you may need to read up on that first. And so on...
由于您正在学习拓扑排序，我们以此主题为例。 在完全理解拓扑排序之前，您还需要先学习什么？ 拓扑排序使用[深度优先搜索](../Depth-First％20Search/)以及[stack](../ Stack/)。 但在你了解深度优先搜索算法之前，你需要知道[graph](../Graph/)是什么，它有助于知道[tree](../Tree/)是什么。 反过来，图形和树使用将对象链接在一起的想法，因此您可能需要首先阅读。 等等...

If we were to represent these objectives in the form of a graph it would look as follows:
如果我们以图表的形式表示这些目标，它将如下所示：

![Example](Images/Algorithms.png)

If we consider each algorithm to be a vertex in the graph you can clearly see the dependencies between them. To learn something you might have to know something else first. This is exactly what topological sort is used for -- it will sort things out so that you know what to do first.
如果我们将每个算法视为图中的顶点，您可以清楚地看到它们之间的依赖关系。 要学习一些东西，你可能必须先了解别的东西。 这正是拓扑排序的用途 - 它将对事情进行排序，以便您首先知道要做什么。

## How does it work?
## 它是如何工作的？

**Step 1: Find all vertices that have in-degree of 0**
**步骤1：查找度数为0的所有顶点**

The *in-degree* of a vertex is the number of edges pointing at that vertex. Vertices with no incoming edges have an in-degree of 0. These vertices are the starting points for the topological sort.
顶点的*in-degree*是指向该顶点的边数。 没有入边的顶点的入度为0.这些顶点是拓扑排序的起点。

In the context of the previous example, these starting vertices represent algorithms and data structures that don't have any prerequisites; you don't need to learn anything else first, hence the sort starts with them.
在前一个示例的上下文中，这些起始顶点表示没有任何先决条件的算法和数据结构; 你不需要先学习任何其他东西，因此排序从它们开始。

**Step 2: Traverse the graph with depth-first search**
**第2步：使用深度优先搜索遍历图表**

Depth-first search is an algorithm that starts traversing the graph from a certain vertex and explores as far as possible along each branch before backtracking. To find out more about depth-first search, please take a look at the [detailed explanation](../Depth-First%20Search/).
深度优先搜索是一种算法，它开始从某个顶点遍历图形，并在回溯之前尽可能沿每个分支进行探索。 要了解有关深度优先搜索的更多信息，请查看[详细说明](../Depth-First％20Search/)。

We perform a depth-first search on each vertex with in-degree 0. This tells us which vertices are connected to each of these starting vertices.
我们对每个具有in-degree 0的顶点执行深度优先搜索。这告诉我们哪些顶点连接到这些起始顶点中的每一个。

**Step 3: Remember all visited vertices**
**第3步：记住所有访问过的顶点**

As we perform the depth-first search, we maintain a list of all the vertices that have been visited. This is to avoid visiting the same vertex twice.
当我们执行深度优先搜索时，我们维护已访问的所有顶点的列表。 这是为了避免两次访问相同的顶点。

**Step 4: Put it all together**
**第4步：全部放在一起**

The last step of the sort is to combine the results of the different depth-first searches and put the vertices in a sorted list.
排序的最后一步是组合不同深度优先搜索的结果，并将顶点放在排序列表中。

## Example
## 例子

Consider the following graph:
请考虑以下图表：

![Graph Example](Images/Example.png)

**Step 1:** The vertices with 0 in-degree are: **3, 7, 5**. These are our starting vertices.
**步骤1：** 0度的顶点是：**3, 7, 5**。 这些是我们的起点。

**Step 2:** Perform depth-first search for each starting vertex, without remembering vertices that have already been visited:
**步骤2：**对每个起始顶点执行深度优先搜索，而不记住已经访问过的顶点：

```
Vertex 3: 3, 10, 8, 9
Vertex 7: 7, 11, 2, 8, 9
Vertex 5: 5, 11, 2, 9, 10
```

**Step 3:** Filter out the vertices already visited in each previous search:
**步骤3：**过滤掉之前每次搜索中已访问过的顶点：

```
Vertex 3: 3, 10, 8, 9
Vertex 7: 7, 11, 2
Vertex 5: 5
```

**Step 4:** Combine the results of these three depth-first searches. The final sorted order is **5, 7, 11, 2, 3, 10, 8, 9**. (Important: we need to add the results of each subsequent search to the *front* of the sorted list.)
**步骤4：**结合这三个深度优先搜索的结果。 最终排序顺序为**5,7,11,2,3,10,8,9**。 （重要：我们需要将每个后续搜索的结果添加到排序列表的*front*。）

The result of the topological sort looks like this:
拓扑排序的结果如下所示：

![Result of the sort](Images/GraphResult.png)

> **Note:** This is not the only possible topological sort for this graph. For example, other valid solutions are **3, 7, 5, 10, 8, 11, 9, 2** and **3, 7, 5, 8, 11, 2, 9, 10**. Any order where all the arrows are going from left to right will do. 
> **注意：**这不是此图的唯一可能的拓扑排序。 例如，其他有效的解决方案是**3,7,5,10,8,11,9,2**和**3,7,5,8,11,2,9,10**。 所有箭头从左到右的任何顺序都可以。

## The code
## 代码

Here is how you could implement topological sort in Swift (see also [TopologicalSort1.swift](TopologicalSort1.swift)):
以下是在Swift中实现拓扑排序的方法（另请参见[TopologicalSort1.swift](TopologicalSort1.swift)）：

```swift
extension Graph {
  public func topologicalSort() -> [Node] {
    // 1
    let startNodes = calculateInDegreeOfNodes().filter({ _, indegree in
      return indegree == 0
    }).map({ node, indegree in
      return node
    })
    
    // 2
    var visited = [Node : Bool]()
    for (node, _) in adjacencyLists {
      visited[node] = false
    }
    
    // 3
    var result = [Node]()
    for startNode in startNodes {
      result = depthFirstSearch(startNode, visited: &visited) + result
    }

    // 4    
    return result
  }
}
```

Some remarks:

1. Find the in-degree of each vertex and put all the vertices with in-degree 0 in the `startNodes` array. In this graph implementation, vertices are called "nodes". Both terms are used interchangeably by people who write graph code.

2. The `visited` array keeps track of whether we've already seen a vertex during the depth-first search. Initially, we set all elements to `false`.

3. For each of the vertices in the `startNodes` array, perform a depth-first search. This returns an array of sorted `Node` objects. We prepend that array to our own `result` array.

4. The `result` array contains all the vertices in topologically sorted order.

> **Note:** For a slightly different implementation of topological sort using depth-first search, see [TopologicalSort3.swift](TopologicalSort3.swift). This uses a stack and does not require you to find all vertices with in-degree 0 first.

一些讨论：

1. 找到每个顶点的入度，并将所有顶点都置于“startNodes”数组中。 在此图实现中，顶点称为“节点”。 这两个术语可供编写图形代码的人互换使用。

2. “visited”数组跟踪我们是否在深度优先搜索期间已经看到过顶点。 最初，我们将所有元素设置为“false”。

3. 对于`startNodes`数组中的每个顶点，执行深度优先搜索。 这将返回一个排序的`Node`对象数组。 我们将该数组添加到我们自己的`result`数组中。

4. `result`数组包含拓扑排序顺序的所有顶点。

> **注意：**对于使用深度优先搜索的拓扑排序略有不同的实现，请参阅[TopologicalSort3.swift]（TopologicalSort3.swift）。 这使用堆栈，并且不需要您首先找到具有in-degree 0的所有顶点。



## Kahn's algorithm

Even though depth-first search is the typical way to perform a topological sort, there is another algorithm that also does the job. 
尽管深度优先搜索是执行拓扑排序的典型方法，但还有另一种算法也能完成这项工作。

1. Find out what the in-degree is of every vertex.
2. Put all the vertices that have no predecessors in a new array called `leaders`. These vertices have in-degree 0 and therefore do not depend on any other vertices.
3. Go through this list of leaders and remove them one-by-one from the graph. We don't actually modify the graph, we just decrement the in-degree of the vertices they point to. That has the same effect.
4. Look at the (former) immediate neighbor vertices of each leader. If any of them now have an in-degree of 0, then they no longer have any predecessors themselves. We'll add those vertices to the `leaders` array too.
5. This repeats until there are no more vertices left to look at. At this point, the `leaders` array contains all the vertices in sorted order.

1. 找出每个顶点的度数是多少。
2. 将所有没有前驱的顶点放在一个名为`leaders`的新数组中。 这些顶点具有in-degree 0，因此不依赖于任何其他顶点。
3. 浏览此领导者列表并从图表中逐个删除它们。 我们实际上并没有修改图形，我们只是递减它们指向的顶点的入度。 这具有相同的效果。
4. 查看每个领导者的（前）直接邻居顶点。 如果它们中的任何一个现在具有0度的度数，则它们本身不再具有任何前辈。 我们也将这些顶点添加到`leaders`数组中。
5. 这种情况一直重复，直到没有更多的顶点可供查看。 此时，`leaders`数组按排序顺序包含所有顶点。

This is an **O(n + m)** algorithm where **n** is the number of vertices and **m** is the number of edges. You can see the implementation in [TopologicalSort2.swift](TopologicalSort2.swift).
这是一个**O(n + m)**算法，其中**n**是顶点数，**m**是边数。 您可以在[TopologicalSort2.swift]（TopologicalSort2.swift）中看到实现。

Source: I first read about this alternative algorithm in the Algorithm Alley column in Dr. Dobb's Magazine from May 1993.
资料来源：我从1993年5月开始在Dr. Dobb杂志的Algorithm Alley专栏中首次阅读这种替代算法。

*Written for Swift Algorithm Club by Ali Hafizji and Matthijs Hollemans*



*作者：Ali Hafizji， Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*