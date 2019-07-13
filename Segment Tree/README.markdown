# 线段树（Segment Tree）

> 有关懒惰传播的示例，请参阅此[文章](./LazyPropagation)。

我很高兴向您介绍线段树（Segment Tree）。 它实际上是我最喜欢的数据结构之一，因为它非常灵活且实现简单。

假设你有一个某种类型的数组**a**和一些关联函数**f**。 例如，函数可以是求和，乘法，最小，最大，[最大公约数](../GCD/)等。

你的任务是：


- 回答由**l**和**r**给出的间隔的查询，即执行 `f(a[l], a[l+1], ..., a[r-1], a[r])`
- 支持替换某个索引的一个项目`a[index] = newItem`

例如，如果我们有一个数字数组：

```swift
var a = [ 20, 3, -1, 101, 14, 29, 5, 61, 99 ]
```

我们想查询这个数组3到7区间，并执行函数"sum"。 这意味着我们执行以下操作：

	101 + 14 + 29 + 5 + 61 = 210

因为`101`在数组的索引3处，而`61`在索引7处。所以我们将`101`和`61`之间的所有数字传递给sum函数，这将它们全部加起来。 如果我们使用了“min”函数，结果将为`5`，因为这是3到7之间的最小数字。

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

在最坏的情况下，该算法的运行时间为**O(n)**，即当**l = 0, r =n-1**（其中**n**是数组的元素数量）。 如果我们有**m**次查询，我们得到**O(m\*n)**复杂度。

如果我们有一个包含100,000个项的数组(**n = 10^5**并且我们必须执行100个查询 (**m = 100**)，那么我们的算法将执行 **10^7**单位工作。 哎哟，这听起来不太好。 让我们来看看我们如何改进它。

线段树允许我们应答查询并用 **O(log n)**时间替换。 这不是魔术吗？✨

线段树的主要思想很简单：我们预先计算数组中的一些段，然后我们可以使用它们而不重复计算。

## 线段树的结构

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

每个节点都有以下数据：

- `leftBound`和`rightBound` 描述了一个间隔
- `leftChild`和`rightChild` 是指向子节点的指针
- `value`是函数 `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])` 的结果。

如果我们的数组是`[1, 2, 3, 4]`，函数 `f = a + b` ，则线段树看起来像这样：

![structure](Images/Structure.png)

每个节点的`leftBound`和`rightBound`标记为红色。

## 构建线段树

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

请注意，这是一个递归方法。 你给它一个数组，如`[1, 2, 3, 4]`，它构建整个树，从根节点到所有子节点。

1. 如果`leftBound`和`rightBound`相等，则递归终止。这样的`SegmentTree`实例表示叶节点。对于输入数组`[1,2,3,4]`，这个过程将创建四个这样的叶节点：`1`，`2`，`3`和`4`。我们只用数组中的数字填充`value`属性。

2. 但是，如果`rightBound`仍然大于`leftBound`，我们创建两个子节点。我们将当前段划分为两个相等的段（至少，如果长度是偶数;如果它是奇数，则一个段将略大）。

3. 递归地为这两个段构建子节点。 左子节点覆盖区间**[leftBound, middle]**，右子节点覆盖**[middle + 1, rightBound]**。

4. 在构造了我们的子节点之后，我们可以计算自己的值，因为**f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**。 这是数学！

构建这个树的操作是**O(n)**。

## 获得查询结果

我们经历了所有这些麻烦，因此我们可以有效地查询树。

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

同样，这是一种递归方法。 它检查四种不同的可能性。

1) 首先，我们检查查询段是否等于当前节点负责的段。 如果是，我们只返回此节点的值。

![equalSegments](Images/EqualSegments.png)

2) 查询段是否完全位于右子节点中？ 如果是这样，则递归地对右子节点执行查询。

![rightSegment](Images/RightSegment.png)

3) 查询段是否完全位于左子节点内？ 如果是这样，则递归地对左子节点执行查询。

![leftSegment](Images/LeftSegment.png)

4) 如果不是上述任何一个，则意味着我们的查询部分存在于两个子节点中，因此我们将查询结果组合在两个子节点上。

![mixedSegment](Images/MixedSegment.png)

在playground 测试：

```swift
let array = [1, 2, 3, 4]

let sumSegmentTree = SegmentTree(array: array, function: +)

sumSegmentTree.query(withLeftBound: 0, rightBound: 3)  // 1 + 2 + 3 + 4 = 10
sumSegmentTree.query(withLeftBound: 1, rightBound: 2)  // 2 + 3 = 5
sumSegmentTree.query(withLeftBound: 0, rightBound: 0)  // just 1
sumSegmentTree.query(withLeftBound: 3, rightBound: 3)  // just 4
```

查询树需要**O(log n)**时间。

## 更换选项

线段树中节点的值取决于它下面的节点。 因此，如果我们想要更改叶节点的值，我们也需要更新其所有父节点。

代码:

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

像往常一样，这适用于递归。 如果节点是叶子，我们只需更改其值。 如果节点不是叶子，那么我们递归调用 `replaceItem(at: )` 来更新它的子节点。 之后，我们重新计算节点自己的值，以便它再次更新。

更换项目需要**O(log n)**时间。

有关如何使用线段树的更多示例，请参阅 playground。

## 扩展阅读

[懒惰传播](./LazyPropagation)的执行和说明。

[线段树在PEGWiki的百科](http://wcipeg.com/wiki/Segment_tree)


*作者：[Artur Antonov](https://github.com/goingreen)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  