# 线段树（Segment Tree）

> For an example on lazy propagation, see this [article](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Segment%20Tree/LazyPropagation).
> 有关懒惰传播的示例，请参阅此[文章](./LazyPropagation)。

I'm pleased to present to you Segment Tree. It's actually one of my favorite data structures because it's very flexible and simple in realization.
我很高兴向您介绍线段树（Segment Tree）。 它实际上是我最喜欢的数据结构之一，因为它非常灵活且实现简单。

Let's suppose that you have an array **a** of some type and some associative function **f**. For example, the function can be sum, multiplication, min, max, [gcd](../GCD/), and so on.
假设你有一个某种类型的数组**a**和一些关联函数**f**。 例如，函数可以是求和，乘法，最小，最大，[最大公约数](../GCD/)等。

Your task is to:
你的任务是：

- answer a query for an interval given by **l** and **r**, i.e. perform `f(a[l], a[l+1], ..., a[r-1], a[r])`
- support replacing an item at some index `a[index] = newItem`

- 回答由**l**和**r**给出的间隔的查询，即执行 `f(a[l], a[l+1], ..., a[r-1], a[r])`
- 支持替换某个索引的一个项目`a[index] = newItem`

For example, if we have an array of numbers:
例如，如果我们有一个数字数组：

```swift
var a = [ 20, 3, -1, 101, 14, 29, 5, 61, 99 ]
```

We want to query this array on the interval from 3 to 7 for the function "sum". That means we do the following:
我们想查询这个数组3到7区间，并执行函数"sum"。 这意味着我们执行以下操作：

	101 + 14 + 29 + 5 + 61 = 210

because `101` is at index 3 in the array and `61` is at index 7. So we pass all the numbers between `101` and `61` to the sum function, which adds them all up. If we had used the "min" function, the result would have been `5` because that's the smallest number in the interval from 3 to 7.
因为`101`在数组的索引3处，而`61`在索引7处。所以我们将`101`和`61`之间的所有数字传递给sum函数，这将它们全部加起来。 如果我们使用了“min”函数，结果将为`5`，因为这是3到7之间的最小数字。

Here's naive approach if our array's type is `Int` and **f** is just the sum of two integers:
如果我们的数组的类型是`Int`并且**f**只是两个整数的求和，这是原始的方法：

```swift
func query(array: [Int], l: Int, r: Int) -> Int {
  var sum = 0
  for i in l...r {
    sum += array[i]
  }
  return sum
}
```

The running time of this algorithm is **O(n)** in the worst case, that is when **l = 0, r = n-1** (where **n** is the number of elements in the array). And if we have **m** queries to answer we get **O(m\*n)** complexity.
在最坏的情况下，该算法的运行时间为**O(n)**，即当**l = 0, r =n-1**（其中**n**是数组的元素数量）。 如果我们有**m**次查询，我们得到**O(m\*n)**复杂度。

If we have an array with 100,000 items (**n = 10^5**) and we have to do 100 queries (**m = 100**), then our algorithm will do **10^7** units of work. Ouch, that doesn't sound very good. Let's look at how we can improve it.
如果我们有一个包含100,000个项的数组(**n = 10^5**并且我们必须执行100个查询 (**m = 100**)，那么我们的算法将执行 **10^7**单位工作。 哎哟，这听起来不太好。 让我们来看看我们如何改进它。

Segment trees allow us to answer queries and replace items with **O(log n)** time. Isn't it magic? :sparkles:
线段树允许我们应答查询并用 **O(log n)**时间替换。 这不是魔术吗？✨

The main idea of segment trees is simple: we precalculate some segments in our array and then we can use those without repeating calculations.  
线段树的主要思想很简单：我们预先计算数组中的一些段，然后我们可以使用它们而不重复计算。

## Structure of segment tree
## 线段树的结构

A segment tree is just a [binary tree](../Binary%20Tree/) where each node is an instance of the `SegmentTree` class:
线段树只是一个[二叉树](../Binary%20Tree/)，其中每个节点都是`SegmentTree`类的一个实例：

```swift
public class SegmentTree<T> {
  private var value: T
  private var function: (T, T) -> T
  private var leftBound: Int
  private var rightBound: Int
  private var leftChild: SegmentTree<T>?
  private var rightChild: SegmentTree<T>?
}
```

Each node has the following data:
每个节点都有以下数据：

- `leftBound` and `rightBound` describe an interval
- `leftChild` and `rightChild` are pointers to child nodes
- `value` is the result of applying the function `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])`

- `leftBound`和`rightBound` 描述了一个间隔
- `leftChild`和`rightChild` 是指向子节点的指针
- `value`是函数 `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])` 的结果。

If our array is `[1, 2, 3, 4]` and the function `f = a + b`, the segment tree looks like this:
如果我们的数组是`[1, 2, 3, 4]`，函数 `f = a + b` ，则线段树看起来像这样：

![structure](Images/Structure.png)

The `leftBound` and `rightBound` of each node are marked in red.
每个节点的`leftBound`和`rightBound`标记为红色。

## Building a segment tree
## 构建线段树

Here's how we create a node of the segment tree:
以下是我们如何创建线段树的节点：

```swift
public init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.function = function

    if leftBound == rightBound {                    // 1
      value = array[leftBound]
    } else {
      let middle = (leftBound + rightBound) / 2     // 2

      // 3
      leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
      rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)

      value = function(leftChild!.value, rightChild!.value)  // 4
    }
  }
```

Notice that this is a recursive method. You give it an array such as `[1, 2, 3, 4]` and it builds up the entire tree, from the root node to all the child nodes.
请注意，这是一个递归方法。 你给它一个数组，如`[1, 2, 3, 4]`，它构建整个树，从根节点到所有子节点。

1. The recursion terminates if `leftBound` and `rightBound` are equal. Such a `SegmentTree` instance represents a leaf node. For the input array `[1, 2, 3, 4]`, this process will create four such leaf nodes: `1`, `2`, `3`, and `4`. We just fill in the `value` property with the number from the array.

2. However, if `rightBound` is still greater than `leftBound`, we create two child nodes. We divide the current segment into two equal segments (at least, if the length is even; if it's odd, one segment will be slightly larger).

3. Recursively build child nodes for those two segments. The left child node covers the interval **[leftBound, middle]** and the right child node covers **[middle+1, rightBound]**.

4. After having constructed our child nodes, we can calculate our own value because **f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**. It's math!

1. 如果`leftBound`和`rightBound`相等，则递归终止。这样的`SegmentTree`实例表示叶节点。对于输入数组`[1,2,3,4]`，这个过程将创建四个这样的叶节点：`1`，`2`，`3`和`4`。我们只用数组中的数字填充`value`属性。

2. 但是，如果`rightBound`仍然大于`leftBound`，我们创建两个子节点。我们将当前段划分为两个相等的段（至少，如果长度是偶数;如果它是奇数，则一个段将略大）。

3. 递归地为这两个段构建子节点。 左子节点覆盖区间**[leftBound, middle]**，右子节点覆盖**[middle + 1, rightBound]**。

4. 在构造了我们的子节点之后，我们可以计算自己的值，因为**f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**。 这是数学！

Building the tree is an **O(n)** operation.
构建这个树的操作是**O(n)**。

## Getting answer to query
## 获得查询结果

We go through all this trouble so we can efficiently query the tree.
我们经历了所有这些麻烦，因此我们可以有效地查询树。

Here's the code:
代码：

```swift
  public func query(withLeftBound: leftBound: Int, rightBound: Int) -> T {
    // 1
    if self.leftBound == leftBound && self.rightBound == rightBound {
      return self.value
    }

    guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
    guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }

    // 2
    if leftChild.rightBound < leftBound {
      return rightChild.query(withLeftBound: leftBound, rightBound: rightBound)

    // 3
    } else if rightChild.leftBound > rightBound {
      return leftChild.query(withLeftBound: leftBound, rightBound: rightBound)

    // 4
    } else {
      let leftResult = leftChild.query(withLeftBound: leftBound, rightBound: leftChild.rightBound)
      let rightResult = rightChild.query(withLeftBound: rightChild.leftBound, rightBound: rightBound)
      return function(leftResult, rightResult)
    }
  }
```

Again, this is a recursive method. It checks four different possibilities.
同样，这是一种递归方法。 它检查四种不同的可能性。

1) First, we check if the query segment is equal to the segment for which our current node is responsible. If it is we just return this node's value.
1) 首先，我们检查查询段是否等于当前节点负责的段。 如果是，我们只返回此节点的值。

![equalSegments](Images/EqualSegments.png)

2) Does the query segment fully lie within the right child? If so, recursively perform the query on the right child.
2) 查询段是否完全位于右子节点中？ 如果是这样，则递归地对右子节点执行查询。

![rightSegment](Images/RightSegment.png)

3) Does the query segment fully lie within the left child? If so, recursively perform the query on the left child.
3) 查询段是否完全位于左子节点内？ 如果是这样，则递归地对左子节点执行查询。

![leftSegment](Images/LeftSegment.png)

4) If none of the above, it means our query partially lies in both children so we combine the results of queries on both children.
4) 如果不是上述任何一个，则意味着我们的查询部分存在于两个子节点中，因此我们将查询结果组合在两个子节点上。

![mixedSegment](Images/MixedSegment.png)

This is how you can test it out in a playground:
在playground 测试：

```swift
let array = [1, 2, 3, 4]

let sumSegmentTree = SegmentTree(array: array, function: +)

sumSegmentTree.query(withLeftBound: 0, rightBound: 3)  // 1 + 2 + 3 + 4 = 10
sumSegmentTree.query(withLeftBound: 1, rightBound: 2)  // 2 + 3 = 5
sumSegmentTree.query(withLeftBound: 0, rightBound: 0)  // just 1
sumSegmentTree.query(withLeftBound: 3, rightBound: 3)  // just 4
```

Querying the tree takes **O(log n)** time.
查询树需要**O(log n)**时间。

## Replacing items
## 更换选项

The value of a node in the segment tree depends on the nodes below it. So if we want to change a value of a leaf node, we need to update all its parent nodes too.  
线段树中节点的值取决于它下面的节点。 因此，如果我们想要更改叶节点的值，我们也需要更新其所有父节点。

Here is the code:

```swift
  public func replaceItem(at index: Int, withItem item: T) {
    if leftBound == rightBound {
      value = item
    } else if let leftChild = leftChild, rightChild = rightChild {
      if leftChild.rightBound >= index {
        leftChild.replaceItem(at: index, withItem: item)
      } else {
        rightChild.replaceItem(at: index, withItem: item)
      }
      value = function(leftChild.value, rightChild.value)
    }
  }
```

As usual, this works with recursion. If the node is a leaf, we just change its value. If the node is not a leaf, then we recursively call `replaceItem(at: )` to update its children. After that, we recalculate the node's own value so that it is up-to-date again.
像往常一样，这适用于递归。 如果节点是叶子，我们只需更改其值。 如果节点不是叶子，那么我们递归调用 `replaceItem(at: )` 来更新它的子节点。 之后，我们重新计算节点自己的值，以便它再次更新。

Replacing an item takes **O(log n)** time.
更换项目需要**O(log n)**时间。

See the playground for more examples of how to use the segment tree.
有关如何使用线段树的更多示例，请参阅 playground。

## See also
## 扩展阅读

[懒惰传播](./LazyPropagation)的执行和说明。

[线段树在PEGWiki的百科](http://wcipeg.com/wiki/Segment_tree)


*作者：[Artur Antonov](https://github.com/goingreen)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  