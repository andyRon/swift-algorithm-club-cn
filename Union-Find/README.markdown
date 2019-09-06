# 并查集(Union-Find)

并查集是一种数据结构，可以跟踪一组元素，它们分布在几个不相交（非重叠）子集合中。 它也被称为不相交集数据结构。

这是什么意思呢？ 例如，并查集数据结构可以跟踪以下集合：

	[ a, b, f, k ]
	[ e ]
	[ g, d, c ]
	[ i, j ]

这些集合**是不相交的**，因为它们没有共同的成员。

并查集支持三个基本操作：

1. **Find(A)**：确定元素**A**所在的子集。例如，`find(d)`将返回子集  `[ g, d, c ]`。

2. **Union(A, B)**：将包含 **A** 和 **B** 的两个子集合并为一个子集。 例如，`union(d, j)` 表示将 `[g, d, c]` 和 `[i, j]` 组合成更大的集合 `[g, d, c, i, j]`。

3. **AddSet(A)**：添加仅包含元素**A**的新子集合 。 例如，`addSet(h)`会添加一个新的集合`[ h ]`。

该数据结构的最常见应用是跟踪无向[图](../Graph/)的[连通分量](https://baike.baidu.com/item/连通分量/290350?fr=aladdin)。 它还用于实现[Kruskal算法](https://zh.wikipedia.org/wiki/克鲁斯克尔演算法)的有效版本，以查找图的最小生成树。

## 实施

并查集可以通过多种方式实现，但我们将看一个高效且易于理解的实现：Weighted Quick Union。
> __PS：并查集 的多个实现已包含在playground .__

```swift
public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()
}
```

我们的并查集数据结构实际上是一个森林，其中每个子集由[树](../Tree/)表示。

基于我们的目的，我们只需要跟踪每个树节点的父节点，而不是子节点。 为此，我们使用数组`parent`，那么`parent[i]`是节点`i`的父节点索引。

示例：如果`parent`看起来像这样，

	parent [ 1, 1, 1, 0, 2, 0, 6, 6, 6 ]
	     i   0  1  2  3  4  5  6  7  8

然后树结构看起来像：

	      1              6
	    /   \           / \
	  0       2        7   8
	 / \     /
	3   5   4

这片森林中有两棵树，每棵树对应一组元素。 （注意：由于ASCII的限制，树在这里显示为二叉树，但情况不一定如此。）

我们为每个子集提供唯一的编号以识别它。 该数字是该子集树的根节点的索引。 在示例中，节点`1`是第一棵树的根节点，`6`是第二棵树的根节点。

所以在这个例子中我们有两个子集，第一个带有标签`1`，第二个带有标签`6`。 **Find**操作实际上返回了set的标签，而不是其内容。

请注意，根节点的`parent[]`指向自身。 所以`parent[1] = 1` 和 `parent [6] = 6`。 这就是我们如何判断那些是根节点的方法。

## 添加集合

让我们看一下这些基本操作的实现，从开始添加新集。

```swift
public mutating func addSetWith(_ element: T) {
  index[element] = parent.count  // 1
  parent.append(parent.count)    // 2
  size.append(1)                 // 3
}
```

添加新元素时，实际上会添加一个仅包含该元素的新子集。

1. 我们在`index`字典中保存新元素的索引。 这让我们可以在以后快速查找元素。

2. 然后我们将该索引添加到`parent`数组中，为该集合构建一个新树。这里，`parent[i]`指向自身，因为表示新集合的树只包含一个节点，当然这是该树的根节点。

3. `size[i]`是树的节点数，其根位于索引`i`。 对于新集合，这是1，因为它只包含一个元素。 我们将在Union操作中使用`size`数组。

## 查找

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

因为我们正在处理树结构，所以这边使用的是递归方法。

回想一下，每个集合由树表示，并且根节点的索引用作标识集合的数字。 我们将找到我们要搜索的元素所属的树的根节点，并返回其索引。

1. 首先，我们检查给定索引是否代表根节点（即“父”指向节点本身的节点）。 如果是这样，我们就完成了。

2. 否则，我们以递归方式在当前节点的父节点上调用此方法。然后我们做了一个**非常重要的事情**：我们用根节点的索引覆盖当前节点的父节点，实际上将节点直接重新连接到树的根节点。下次我们调用此方法时，它将执行得更快，因为树的根路径现在要短得多。 如果没有这种优化，这种方法的复杂性就是**O(n)**，但现在结合尺寸优化（在Union部分中说明）它几乎是**O(1)**。

3. 我们返回根节点的索引作为结果。

这是我说明的意思。 现在树看起来像这样：

![BeforeFind](Images/BeforeFind.png)

我们调用`setOf(4)`。 要找到根节点，我们必须首先转到节点`2`然后转到节点`7`。 （元素的索引标记为红色。）

在调用`setOf(4)`期间，树被重组为如下所示：

![AfterFind](Images/AfterFind.png)

现在如果我们需要再次调用`setOf(4)`，我们就不再需要通过节点`2`再到根节点了。 因此，当您使用Union-Find数据结构时，它会优化自身。 太酷了！

还有一个辅助方法来检查两个元素是否在同一个集合中：

```swift
public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
  if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
    return firstSet == secondSet
  } else {
    return false
  }
}
```

这会调用`setOf()`，也会优化树。

## Union (Weighted)

最后的操作是 **Union**，它将两集合并为一组更大的集合。

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

下面是它的工作原理：

1. 我们找到每个元素所属的集合。请记住，这给了我们两个整数：`parent`数组中根节点的索引。

2. 检查这些集合是否相等，如果相等，合并就没有意义。

3. 这是大小优化的来源（加权）。我们希望保持树尽可能浅，所以我们总是将较小的树附加到较大树的根部。为了确定哪个是较小的树，我们按照它们的大小比较树。

4. 这里我们将较小的树附加到较大树的根部。

5. 更新较大树的大小，因为它只添加了一堆节点。

插图可能有助于更好地理解这一点。 假设我们有这两个集合，每个都有自己的树：

![BeforeUnion](Images/BeforeUnion.png)

现在我们调用 `unionSetsContaining(4, and:3)`。 较小的树与较大的树相连：

![AfterUnion](Images/AfterUnion.png)

请注意，因为我们在方法的开头调用`setOf()`，所以在该过程中也对树进行了优化 - 节点`3`现在直接挂在根之上。

具有优化的Union只需要几乎 **O(1)** 时间。

## 路径压缩

```swift
private mutating func setByIndex(_ index: Int) -> Int {
    if index != parent[index] {
        // Updating parent index while looking up the index of parent.
        parent[index] = setByIndex(parent[index])
    }
    return parent[index]
}
```
路径压缩有助于保持树非常平坦，因此查找操作可能只需要__O(1)__ 。

## 复杂度总结

##### 处理N个对象

| Data Structure | Union | Find |
|---|---|---|
|Quick Find|N|1|
|Quick Union|Tree height|Tree height|
|Weighted Quick Union|lgN|lgN|
|Weighted Quick Union + Path Compression| very close, but not O(1)| very close, but not O(1) |

##### 在N个对象上处理M的union命令

| Algorithm | Worst-case time|
|---|---|
|Quick Find| M N |
|Quick Union| M N |
|Weighted Quick Union| N + M lgN |
|Weighted Quick Union + Path Compression| (M + N) lgN |

## 扩展阅读

有关如何使用此便捷数据结构的更多示例，请参阅 playground。

[并查集的维基百科](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)


*作者：[Artur Antonov](https://github.com/goingreen) ，[Yi Ding](https://github.com/antonio081014)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

