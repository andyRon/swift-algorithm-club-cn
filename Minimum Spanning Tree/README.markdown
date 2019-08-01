# 最小生成树（加权图）（Minimum Spanning Tree (Weighted Graph)）


> 这个主题有一篇辅导[文章](https://www.raywenderlich.com/169392/swift-algorithm-club-minimum-spanning-tree-with-prims-algorithm)

连接的无向加权图的[最小生成树](https://en.wikipedia.org/wiki/Minimum_spanning_tree)（MST）具有来自原始图的边的子集，其将所有顶点连接在一起，没有任何循环并尽可能减少总边权重。 图中可以有多个MST。

有两种流行的算法来计算图形的MST - [Kruskal算法](https://en.wikipedia.org/wiki/Kruskal's_algorithm)和[Prim算法](https://en.wikipedia.org/wiki/Prim's_algorithm)。 两种算法的总时间复杂度为`O(ElogE)`，其中`E`是原始图的边数。

### Kruskal算法

Sort the edges base on weight. Greedily select the smallest one each time and add into the MST as long as it doesn't form a cycle.
根据权重对边进行排序。每次贪婪地选择最小的一个并且只要它不形成循环就加入MST。  
Kruskal的算法使用[并查集](../Union-Find) 数据结构来检查是否有任何其他边导致循环。逻辑是将所有连接的顶点放在同一个集合中（在并查集的概念中）。如果来自新边的两个顶点不属于同一个集合，那么将该边添加到MST中是安全的。

下图演示了这个步骤：

![Graph](Images/kruskal.png)

准备
```swift
// Initialize the values to be returned and Union Find data structure.
var cost: Int = 0
var tree = Graph<T>()
var unionFind = UnionFind<T>()
for vertex in graph.vertices {

// Initially all vertices are disconnected.
// Each of them belongs to it's individual set.
  unionFind.addSetWith(vertex)
}
```

排序边：
```swift
let sortedEdgeListByWeight = graph.edgeList.sorted(by: { $0.weight < $1.weight })
```

一次取一个边并尝试将其插入MST。
```swift
for edge in sortedEdgeListByWeight {
  let v1 = edge.vertex1
  let v2 = edge.vertex2 
  
  // Same set means the two vertices of this edge were already connected in the MST.
  // Adding this one will cause a cycle.
  if !unionFind.inSameSet(v1, and: v2) {
    // Add the edge into the MST and update the final cost.
    cost += edge.weight
    tree.addEdge(edge)
    
    // Put the two vertices into the same set.
    unionFind.unionSetsContaining(v1, and: v2)
  }
}
```

### Prim算法

Prim算法不会对所有边进行预排序。相反，它使用[优先队列](../Priority%20Queue)来维护正在运行的已排序的下一个可能的顶点。  
从一个顶点开始，循环遍历所有未访问的邻居，并为每个邻居入队一对值 —— 顶点和将当前顶点连接到邻居的边的权重。每次贪婪地选择优先队列的顶部（权重值最小的那个）顶点，如果尚未访问已入队的邻居，则将边添加到最终的MST中。

下图演示了这个步骤：

![Graph](Images/prim.png)

准备
```swift
// Initialize the values to be returned and Priority Queue data structure.
var cost: Int = 0
var tree = Graph<T>()
var visited = Set<T>()

// In addition to the (neighbour vertex, weight) pair, parent is added for the purpose of printing out the MST later.
// parent is basically current vertex. aka. the previous vertex before neigbour vertex gets visited.
var priorityQueue = PriorityQueue<(vertex: T, weight: Int, parent: T?)>(sort: { $0.weight < $1.weight })
```

排序顶点：
```swift
priorityQueue.enqueue((vertex: graph.vertices.first!, weight: 0, parent: nil))
```

```swift
// Take from the top of the priority queue ensures getting the least weight edge.
while let head = priorityQueue.dequeue() {
  let vertex = head.vertex
  if visited.contains(vertex) {
    continue
  }

  // If the vertex hasn't been visited before, its edge (parent-vertex) is selected for MST.
  visited.insert(vertex)
  cost += head.weight
  if let prev = head.parent { // The first vertex doesn't have a parent.
    tree.addEdge(vertex1: prev, vertex2: vertex, weight: head.weight)
  }

  // Add all unvisted neighbours into the priority queue.
  if let neighbours = graph.adjList[vertex] {
    for neighbour in neighbours {
      let nextVertex = neighbour.vertex
      if !visited.contains(nextVertex) {
        priorityQueue.enqueue((vertex: nextVertex, weight: neighbour.weight, parent: vertex))
      }
    }
  }
}
```

*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

