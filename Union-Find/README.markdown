# Union-Find
# 并查集

Union-Find is a data structure that can keep track of a set of elements partitioned into a number of disjoint (non-overlapping) subsets. It is also known as disjoint-set data structure.
并查集是一种数据结构，可以跟踪分成多个不相交（非重叠）子集的一组元素。 它也被称为不相交集数据结构。

What do we mean by this? For example, the Union-Find data structure could be keeping track of the following sets:
这是什么意思呢？ 例如，并查集数据结构可以跟踪以下集合：

	[ a, b, f, k ]
	[ e ]
	[ g, d, c ]
	[ i, j ]

These sets are **disjoint** because they have no members in common.
这些集合**是不相交的**，因为它们没有共同的成员。

Union-Find supports three basic operations:
并查集支持上个基本操作：

1. **Find(A)**: Determine which subset an element **A** is in. For example, `find(d)` would return the subset `[ g, d, c ]`.

2. **Union(A, B)**: Join two subsets that contain **A** and **B** into a single subset. For example, `union(d, j)` would combine `[ g, d, c ]` and `[ i, j ]` into the larger set `[ g, d, c, i, j ]`.

3. **AddSet(A)**: Add a new subset containing just that element **A**. For example, `addSet(h)` would add a new set `[ h ]`.

1. **Find(A)**：确定元素**A**所在的子集。例如，`find（d）`将返回子集`[g，d，c]`。

2. **Union(A, B)**：将包含 **A** 和 **B** 的两个子集合并为一个子集。 例如，`union(d, j)` 将 `[g, d, c]` 和 `[i,j]` 组合成更大的集合 `[g, d, c, i,j]`。

3. **AddSet(A)**：添加仅包含该元素的新子集 **A**。 例如，`addSet(h)`会添加一个新的集合`[h]`。

The most common application of this data structure is keeping track of the connected components of an undirected [graph](../Graph/). It is also used for implementing an efficient version of Kruskal's algorithm to find the minimum spanning tree of a graph.
该数据结构的最常见应用是跟踪无向[图形](../Graph/)的连通分量。 它还用于实现Kruskal算法的有效版本，以查找图的最小生成树。

## Implementation
## 实施

Union-Find can be implemented in many ways but we'll look at an efficient and easy to understand implementation: Weighted Quick Union.
> __PS: Multiple implementations of Union-Find has been included in playground.__
并查集可以通过多种方式实现，但我们将看一个高效且易于理解的实现：Weighted Quick Union。
> __PS：并查集 的多个实现已包含在playground .__

```swift
public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()
}
```

Our Union-Find data structure is actually a forest where each subset is represented by a [tree](../Tree/).
我们的并查集数据结构实际上是一个森林，其中每个子集由[tree](../Tree/)表示。

For our purposes we only need to keep track of the parent of each tree node, not the node's children. To do this we use the array `parent` so that `parent[i]` is the index of node `i`'s parent.
出于我们的目的，我们只需要跟踪每个树节点的父节点，而不是节点的子节点。 为此，我们使用数组`parent`，以便`parent[i]`是节点`i`的父节点的索引。

Example: If `parent` looks like this,
示例：如果`parent`看起来像这样，

	parent [ 1, 1, 1, 0, 2, 0, 6, 6, 6 ]
	     i   0  1  2  3  4  5  6  7  8

then the tree structure looks like:
然后树结构看起来像：

	      1              6
	    /   \           / \
	  0       2        7   8
	 / \     /
	3   5   4

There are two trees in this forest, each of which corresponds to one set of elements. (Note: due to the limitations of ASCII art the trees are shown here as binary trees but that is not necessarily the case.)
这片森林中有两棵树，每棵树对应一组元素。 （注意：由于ASCII艺术的限制，树在这里显示为二叉树，但情况不一定如此。）

We give each subset a unique number to identify it. That number is the index of  the root node of that subset's tree. In the example, node `1` is the root of the first tree and `6` is the root of the second tree.
我们为每个子集提供唯一的编号以识别它。 该数字是该子集树的根节点的索引。 在示例中，节点`1`是第一棵树的根，`6`是第二棵树的根。

So in this example we have two subsets, the first with the label `1` and the second with the label `6`. The **Find** operation actually returns the set's label, not its contents.
所以在这个例子中我们有两个子集，第一个带有标签`1`，第二个带有标签`6`。 **Find**操作实际上返回了set的标签，而不是其内容。

Note that the `parent[]` of a root node points to itself. So `parent[1] = 1` and `parent[6] = 6`. That's how we can tell something is a root node.
请注意，根节点的`parent []`指向自身。 所以`parent[1] = 1` 和 `parent [6] = 6`。 这就是我们如何判断一些根节点的方法。

## Add set

Let's look at the implementation of these basic operations, starting with adding a new set.
让我们看一下这些基本操作的实现，从开始添加新集。

```swift
public mutating func addSetWith(_ element: T) {
  index[element] = parent.count  // 1
  parent.append(parent.count)    // 2
  size.append(1)                 // 3
}
```

When you add a new element, this actually adds a new subset containing just that element.
添加新元素时，实际上会添加一个仅包含该元素的新子集。

1. We save the index of the new element in the `index` dictionary. That lets us look up the element quickly later on.

2. Then we add that index to the `parent` array to build a new tree for this  set. Here, `parent[i]` is pointing to itself because the tree that represents the new set contains only one node, which of course is the root of that tree.

3. `size[i]` is the count of nodes in the tree whose root is at index `i`. For the new set this is 1 because it only contains the one element. We'll be using the `size` array in the Union operation.

1. 我们在`index`字典中保存新元素的索引。 这让我们可以在以后快速查找元素。

2. 然后我们将该索引添加到`parent`数组中，为该集合构建一个新树。 这里，`parent[i]`指向自身，因为表示新集合的树只包含一个节点，当然这是该树的根。

3. `size[i]`是树的节点数，其根位于索引`i`。 对于新集合，这是1，因为它只包含一个元素。 我们将在Union操作中使用`size`数组。

## Find

Often we want to determine whether we already have a set that contains a given element. That's what the **Find** operation does. In our `UnionFind` data structure it is called `setOf()`:
通常我们想确定我们是否已经有一个包含给定元素的集合。 这就是**Find**操作所做的。 在我们的`UnionFind`数据结构中，它被称为`setOf()`：

```swift
public mutating func setOf(_ element: T) -> Int? {
  if let indexOfElement = index[element] {
    return setByIndex(indexOfElement)
  } else {
    return nil
  }
}
```

This looks up the element's index in the `index` dictionary and then uses a helper method to find the set that this element belongs to:
这会在`index`字典中查找元素的索引，然后使用辅助方法来查找此元素所属的集合：

```swift
private mutating func setByIndex(_ index: Int) -> Int {
  if parent[index] == index {  // 1
    return index
  } else {
    parent[index] = setByIndex(parent[index])  // 2
    return parent[index]       // 3
  }
}
```

Because we're dealing with a tree structure, this is a recursive method.
因为我们正在处理树结构，所以这是一种递归方法。

Recall that each set is represented by a tree and that the index of the root node serves as the number that identifies the set. We're going to find the root node of the tree that the element we're searching for belongs to, and return its index.
回想一下，每个集合由树表示，并且根节点的索引用作标识集合的数字。 我们将找到我们要搜索的元素所属的树的根节点，并返回其索引。

1. First, we check if the given index represents a root node (i.e. a node whose `parent` points back to the node itself). If so, we're done.

2. Otherwise we recursively call this method on the parent of the current node. And then we do a **very important thing**: we overwrite the parent of the current node with the index of root node, in effect reconnecting the node directly to the root of the tree. The next time we call this method, it will execute faster because the path to the root of the tree is now much shorter. Without that optimization, this method's complexity is **O(n)** but now in combination with the size optimization (covered in the Union section) it is almost **O(1)**.

3. We return the index of the root node as the result.
1. 首先，我们检查给定索引是否代表根节点（即“父”指向节点本身的节点）。 如果是这样，我们就完成了。

2. 否则，我们以递归方式在当前节点的父节点上调用此方法。 然后我们做了一个**非常重要的事情**：我们用根节点的索引覆盖当前节点的父节点，实际上将节点直接重新连接到树的根节点。 下次我们调用此方法时，它将执行得更快，因为树的根路径现在要短得多。 如果没有这种优化，这种方法的复杂性就是**O(n)**，但现在结合尺寸优化（在Union部分中说明）它几乎是**O(1)**。

3. 我们返回根节点的索引作为结果。

Here's illustration of what I mean. Let's say the tree looks like this:
这是我说明的意思。 让我们说树看起来像这样：

![BeforeFind](Images/BeforeFind.png)

We call `setOf(4)`. To find the root node we have to first go to node `2` and then to node `7`. (The indices of the elements are marked in red.)
我们称之为`setOf(4)`。 要找到根节点，我们必须首先转到节点`2`然后转到节点`7`。 （元素的索引标记为红色。）

During the call to `setOf(4)`, the tree is reorganized to look like this:
在调用`setOf(4)`期间，树被重组为如下所示：

![AfterFind](Images/AfterFind.png)

Now if we need to call `setOf(4)` again, we no longer have to go through node `2` to get to the root. So as you use the Union-Find data structure, it optimizes itself. Pretty cool!
现在如果我们需要再次调用`setOf(4)`，我们就不再需要通过节点`2`来到根。 因此，当您使用Union-Find数据结构时，它会优化自身。 太酷了！

There is also a helper method to check that two elements are in the same set:
还有一个帮助方法来检查两个元素是否在同一个集合中：

```swift
public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
  if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
    return firstSet == secondSet
  } else {
    return false
  }
}
```

Since this calls `setOf()` it also optimizes the tree.
因为这会调用`setOf()`它也会优化树。

## Union (Weighted)

The final operation is **Union**, which combines two sets into one larger set.
最后的操作是 **Union**，它将两组合并为一组更大的组合。

```swift
    public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
        if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) { // 1
            if firstSet != secondSet {                // 2
                if size[firstSet] < size[secondSet] { // 3
                    parent[firstSet] = secondSet      // 4
                    size[secondSet] += size[firstSet] // 5
                } else {
                    parent[secondSet] = firstSet
                    size[firstSet] += size[secondSet]
                }
            }
        }
    }
```

Here is how it works:
下面是它的工作原理：

1. We find the sets that each element belongs to. Remember that this gives us two integers: the indices of the root nodes in the `parent` array.

2. Check that the sets are not equal because if they are it makes no sense to union them.

3. This is where the size optimization comes in (Weighting). We want to keep the trees as shallow as possible so we always attach the smaller tree to the root of the larger tree. To determine which is the smaller tree we compare trees by their sizes.

4. Here we attach the smaller tree to the root of the larger tree.

5. Update the size of larger tree because it just had a bunch of nodes added to it.

1. 我们找到每个元素所属的集合。 请记住，这给了我们两个整数：`parent`数组中根节点的索引。

2. 检查这些集合是否相等，因为如果它们合并就没有意义。

3. 这是尺寸优化的来源（加权）。 我们希望保持树尽可能浅，所以我们总是将较小的树附加到较大树的根部。 为了确定哪个是较小的树，我们按照它们的大小比较树。

4. 这里我们将较小的树附加到较大树的根部。

5. 更新较大树的大小，因为它只添加了一堆节点。

An illustration may help to better understand this. Let's say we have these two sets, each with its own tree:
插图可能有助于更好地理解这一点。 假设我们有这两组，每组都有自己的树：

![BeforeUnion](Images/BeforeUnion.png)

Now we call `unionSetsContaining(4, and: 3)`. The smaller tree is attached to the larger one:
现在我们调用 `unionSetsContaining(4, and:3)`。 较小的树与较大的树相连：

![AfterUnion](Images/AfterUnion.png)

Note that, because we call `setOf()` at the start of the method, the larger tree was also optimized in the process -- node `3` now hangs directly off the root.
请注意，因为我们在方法的开头调用`setOf()`，所以在该过程中也对优化的树进行了优化 - 节点`3`现在直接挂在根之上。

Union with optimizations also takes almost **O(1)** time.
具有优化的联盟也需要几乎 **O(1)** 时间。

## Path Compression
```swift
private mutating func setByIndex(_ index: Int) -> Int {
    if index != parent[index] {
        // Updating parent index while looking up the index of parent.
        parent[index] = setByIndex(parent[index])
    }
    return parent[index]
}
```
Path Compression helps keep trees very flat, thus find operation could take __ALMOST__ in __O(1)__
路径压缩有助于保持树非常平坦，因此在 __O(1)__ 中查找操作可能需要 __ALMOST__

## Complexity Summary

##### To process N objects
| Data Structure | Union | Find |
|---|---|---|
|Quick Find|N|1|
|Quick Union|Tree height|Tree height|
|Weighted Quick Union|lgN|lgN|
|Weighted Quick Union + Path Compression| very close, but not O(1)| very close, but not O(1) |

##### To process M union commands on N objects
| Algorithm | Worst-case time|
|---|---|
|Quick Find| M N |
|Quick Union| M N |
|Weighted Quick Union| N + M lgN |
|Weighted Quick Union + Path Compression| (M + N) lgN |

## See also
## 扩展阅读

See the playground for more examples of how to use this handy data structure.
有关如何使用此便捷数据结构的更多示例，请参阅 playground。

[Union-Find at Wikipedia](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)
[并查集的维基百科](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)

*Written for Swift Algorithm Club by [Artur Antonov](https://github.com/goingreen)*, *modified by [Yi Ding](https://github.com/antonio081014).*

*作者：Artur Antonov](https://github.com/goingreen) ，[Yi Ding](https://github.com/antonio081014)*  
*翻译：[Andy Ron](https://github.com/andyRon)*
