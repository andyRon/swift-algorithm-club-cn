# 八叉树（OcTree）

An octree is a [tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Tree) in which each internal (not leaf) node has eight children. Often used for collision detection in games for example.
八叉树是[树](../Tree)，其中每个内部（非叶节点）节点有八个子节点。 例如，通常用于游戏中的碰撞检测。

### Problem
### 问题

Consider the following problem: your need to store a number of objects in 3D space (each at a certain location with `X`, `Y` and `Z` coordinates) and then you need to answer which objects lie in a certain 3D region. A naive solution would be to store the points inside an array and then iterate over the points and check each one individually. This solution runs in O(n) though.

考虑以下问题：您需要在3D空间中存储多个对象（每个对象在某个位置使用`X`，`Y`和`Z`坐标表示）然后您需要回答哪些对象位于某个3D区域。 一个天真的解决方案是将点存储在一个数组中，然后迭代这些点并分别检查每个点。 该解决方案花费O(n)。

### A Better Approach
### 更好的方法

Octrees are most commonly used to partition a three-dimensional space by recursively subdividing it into 8 regions. Let's see how we can use an Octree to store some values.
八叉树最常用于通过递归地将其细分为8个区域来划分三维空间。 让我们看看我们如何使用八叉树来存储一些值。

Each node in the tree represents a box-like region. Leaf nodes store a single point in that region with an array of objects assigned to that point.
树中的每个节点代表一个类似盒子的区域。 叶节点在该区域中存储单个点，并为该点分配一组对象。

Once an object within the same region (but at a different point) is added the leaf node turns into an internal node and 8 child nodes (leaves) are added to it. All points previously contained in the node are passed to its corresponding children and stored. Thus only leaves contain actual points and values.
一旦添加了同一区域内（但在不同点）的对象，叶节点就会变成一个内部节点，并向它添加8个子节点（叶节点）。 先前包含在节点中的所有点都将传递给其对应的子节点并进行存储。 因此，只有叶子包含实际的点和值。

To find the points that lie in a given region we can now traverse the tree from top to bottom and collect the suitable points from nodes.
为了找到位于给定区域中的点，我们现在可以从上到下遍历树并从节点收集合适的点。

Both adding a point and searching can still take up to O(n) in the worst case, since the tree isn't balanced in any way. However, on average it runs significantly faster (something comparable to O(log n)).
在最坏的情况下，添加点和搜索仍然可以占用O(n)，因为树不以任何方式平衡。 但是，平均而言，它的运行速度明显更快（与O(log n)相当）。

### 扩展阅读

[八叉树的维基百科](https://en.wikipedia.org/wiki/Octree)  
苹果公司的八叉树实现[GKOctree](https://developer.apple.com/documentation/gameplaykit/gkoctree)


*作者：Jaap Wijnen*  
*灵感来自于Timur Galimov和苹果公司的八叉树实现*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

