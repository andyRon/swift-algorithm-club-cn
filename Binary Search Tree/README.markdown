# 二叉搜索树(Binary Search Tree, BST)

> 这个话题已经有个辅助[文章](https://www.raywenderlich.com/139821/swift-algorithm-club-swift-binary-search-tree-data-structure)


二叉搜索树（或者叫做二分搜索树）是一种特殊的[二叉树](../Binary%20Tree/)（每个节点最多有两个子节点），它执行插入和删除，以便始终对树进行排序。

> **译注：** sort，平常都可以理解为从大到小或从小到大的排序，但本文有点不同，可以理解为是按一定规则的整理。因为“排序”在汉语中也不是简单理解为从大到小或从小到大，所以我还是把sort翻译成*排序*，但注意和平常理解的排序有点不同。


有关树的更多信息，[请先阅读](../Tree/)。



## “始终排序”属性

下面是一个有效二叉搜索树的示例：

![二叉搜索树](Images/Tree1.png)


注意每个左子节点小于其父节点，并且每个右子节点大于其父节点。 这是二叉搜索树的关键特性。

例如，`2`小于`7`，因此它在左边; `5`大于`2`，因此它在右边。



## 插入新节点


执行插入时，我们首先将新值与根节点进行比较。 如果新值较小，我们采取 *左* 分支; 如果更大，我们采取 *右* 分支。我们沿着这条路向下走，直到找到一个我们可以插入新值的空位。 

假设我们要插入新值`9`：

- 我们从树的根（值为`7`的节点）开始，并将其与新值`9`进行比较。
- `9 > 7`，因此我们走右边的分支，并重复相同的过程，但这次节点是`10`。
- 因为`9 < 10`，所以我们走左边的分支。
- 我们现在到了一个没有更多值可供比较的地方。 在该位置插入`9`的新节点。

插入新值`9`后树结构：

![After adding 9](Images/Tree2.png)


只有一个可能的位置可以在树中插入新元素。 找到这个地方通常很快。 它需要 **O(h)** 时间，其中 **h** 是树的高度。

> ** 注意：** 节点的 *高度* 是从该节点到最低叶节点所需的步骤数。 整棵树的*高度*是从根到最低叶节点的距离。 二叉搜索树上的许多操作都以树的高度表示。

通过遵循这个简单的规则 —— 左侧较小的值，右侧较大的值 —— 我们保持树的排序，因此无论何时都可以查询某值是否在树种。



## 搜索树

要在树中查找值，我们执行与插入相同的步骤：

- 如果该值小于当前节点，则选择左分支。

- 如果该值大于当前节点，则选择右分支。

- 如果该值等于当前节点，我们就找到了它！


像大多数树操作一样，这是递归执行的，直到找到我们正在查找的内容或查完要查看的所有节点。

以下是搜索值`5`的示例：

![搜索树](Images/Searching.png)


使用树的结构搜索很快。 它在 **O(h)** 时间内运行。 如果你有一个具有一百万个节点的均衡树，那么在这棵树中只需要大约20步就可以找到任何东西。（这个想法与数组中的[二分搜索](../Binary%20Search/)非常相似）

> **注：** `2^0 + 2^1 + 2^2 + ... + 2^19` 大约是百万级别。



## 遍历树

有时您需要查看所有节点而不是仅查看一个节点。

遍历二叉树有三种方法：

1. *中序*（或 *深度优先*，In-order/depth-first）：首先查看节点的左子节点，然后查看节点本身，最后查看其右子节点。
2. *前序*（Pre-order）：首先查看节点本身，然后查看其左右子节点。
3. *后序*（Post-order）：首先查看左右子节点并最后处理节点本身。



遍历树的过程也是递归的。


如果按中序遍历二叉搜索树，它会查看所有节点，就好像它们从低到高排序一样。 对于示例树，将打印`1, 2, 5, 7, 9, 10`：

![遍历树](Images/Traversing.png)

## 删除节点


删除节点很容易。不过删除节点后，需要将节点替换为左侧最大的子节点或右侧的最小子节点。这样，树在删除节点后仍然排序。在以下示例中，将删除10并替换为9（Figure 2）或11（Figure 3）。

![Deleting a node with two children](Images/DeleteTwoChildren.png)


请注意，当节点至少有一个子节点时，需要进行替换。 如果它没有子节点，您只需将其与其父节点断开连接：

![Deleting a leaf node](Images/DeleteLeaf.png)

## 代码（解决方案1）


说了太多理论了。让我们看看如何在Swift中实现二叉搜索树。您可以采取不同的实现方法。首先，我将向您展示如何制作基于类的版本，但我们还将介绍如何使用枚举制作版本。



以下是`BinarySearchTree`类的示例：

```swift
public class BinarySearchTree<T: Comparable> {
    private(set) public var value: T
    private(set) public var parent: BinarySearchTree?
    private(set) public var left: BinarySearchTree?
    private(set) public var right: BinarySearchTree?
    
    public init(value: T) {
        self.value = value
    }
    /// 是否是根节点
    public var isRoot: Bool {
        return parent == nil
    }
    /// 是否是叶节点
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    /// 是否是左子节点
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    /// 是否是右子节点
    public var isRightChild: Bool {
        return parent?.right === self
    }
    /// 是否有左子节点
    public var hasLeftChild: Bool {
        return left != nil
    }
    /// 是否有右子节点
    public var hasRightChild: Bool {
        return right != nil
    }
    /// 是否有子节点
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    /// 是否左右两个子节点都有
    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    /// 当前节点包括子树中的所有节点总数
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
}
```



此类仅描述单个节点而不是整个树。 它是泛型类型，因此节点可以存储任何类型的数据。 它还包含了`left`和`right`子节点以及一个`parent`节点的引用。

以下是如何使用它：

```swift
let tree = BinarySearchTree<Int>(value: 7)
```

`count`属性是此节点描述的子树中有多少个节点（**译注：**本身+此节点的所有子节点）。这不仅仅计算节点的直接子节点，还计算它们的子节点和子节点的子节点，等等。如果此节点是根节点，则`count`表示计算整个树中有多少个节点。

> **注意：** 因为`left`，`right`和`parent`是可选的，我们可以很好地利用Swift的可选值链（`?`）和 空合运算符（`??`）。 你也可以用`if let`，但那不简洁。
>
> **译注：**关于空合运算符，可查看我之前写的一篇文章[Swift中的问号三种用法](http://andyron.com/2017/swift-question)



### 插入节点

只有树节点本身是没有什么用的，所以需要如何向树添加新节点的方法：

```swift
  public func insert(value: T) {
    if value < self.value {
      if let left = left {
        left.insert(value: value)
      } else {
        left = BinarySearchTree(value: value)
        left?.parent = self
      }
    } else {
      if let right = right {
        right.insert(value: value)
      } else {
        right = BinarySearchTree(value: value)
        right?.parent = self
      }
    }
  }
```

像许多其他树操作一样，插入最容易用递归实现。 我们将新值与现有节点的值进行比较，并决定是将其添加到左侧分支还是右侧分支。

如果没有更多的左或右子节点，我们创建一个新节点`BinarySearchTree`对象，并通过设置其`parent`属性将其连接到树。

> **注意：** 因为二叉搜索树的都是左边有较小的节点而右边有较大的节点，所以你应该总是在根节点开始（比较）插入元素，以确保它仍然是一个有效的二叉树！  



构建上面示例中完整的树：

```swift
let tree = BinarySearchTree<Int>(value: 7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)
```

> **Note:** For reasons that will become clear later, you should insert the numbers in a random order. If you insert them in a sorted order, the tree will not have the right shape.
> **注意：** 由于后来会变得明确的原因，您应该以随机顺序插入数字。 如果按排序顺序插入它们，则树的形状将不正确。 （？？由于理解不够深，翻译的不准确，保留原文）



为方便起见，让我们添加一个以数组的方式初始化的方法，这个方法为数组中所有元素调用`insert()`：

```swift
  public convenience init(array: [T]) {
    precondition(array.count > 0)
    self.init(value: array.first!)
    for v in array.dropFirst() {
      insert(value: v)
    }
  }
```

现在可以简单的使用：

```swift
let tree = BinarySearchTree<Int>(array: [7, 2, 5, 10, 9, 1])
```

数组中的第一个值成为树的根节点。

### 调试输出

使用复杂的数据结构时，拥有人类可读的调试输出很有用。

```swift
extension BinarySearchTree: CustomStringConvertible {
  public var description: String {
    var s = ""
    if let left = left {
      s += "(\(left.description)) <- "
    }
    s += "\(value)"
    if let right = right {
      s += " -> (\(right.description))"
    }
    return s
  }
}
```

当你执行`print(tree)`时，你应该得到：

	((1) <- 2 -> (5)) <- 7 -> ((9) <- 10)

根节点位于中间。 发挥一些想象力，您应该看到这确实对应于下面的树：

![The tree](Images/Tree2.png)

您可能想知道插入重复项时会发生什么？我们总是将它们插入正确的分支中。 试试看！

### 搜索

我们现在做什么，让树有一些价值？ 当然，搜索它们吧！ 快速查找项是二叉搜索树的主要目的。:-)

这是`search()`的实现：

```swift
  public func search(value: T) -> BinarySearchTree? {
    if value < self.value {
      return left?.search(value)
    } else if value > self.value {
      return right?.search(value)
    } else {
      return self  // found it!
    }
  }
```

我希望逻辑清楚：这从当前节点（通常是根节点）开始并比较这些值。 如果搜索值小于节点的值，我们继续在左侧分支中搜索;如果搜索值更大，我们会跳到右侧分支中搜索。

如果没有更多的节点要看 —— 当`left`或`right`为nil时 —— 那么我们返回`nil`表示搜索值不在树中。

> **注意：** 在Swift中，可以通过可选链方便地完成; 当你写`left?.search(value)`时，如果`left`为nil，它会自动返回nil。 没有必要使用`if`语句显式检查。

搜索是一个递归过程，但您也可以使用简单的迭代来实现它：

```swift
  public func search(_ value: T) -> BinarySearchTree? {
    var node: BinarySearchTree? = self
    while let n = node {
      if value < n.value {
        node = n.left
      } else if value > n.value {
        node = n.right
      } else {
        return node
      }
    }
    return nil
  }
```

验证您是否理解这两个实现是等效的。 就个人而言，我更喜欢使用迭代代码而不是递归代码，但您的意见可能会有所不同。;-)

测试搜索：

```swift
tree.search(value: 5)
tree.search(value: 2)
tree.search(value: 7)
tree.search(value: 6)   // nil
```

前三行返回相应的`BinaryTreeNode`对象。 最后一行返回`nil`，因为没有值为`6`的节点。

> **注意：** 如果树中有重复项，`search()`返回“最高”节点。 这是有道理的，因为我们开始从根节点向下搜索。



### 遍历

还记得有三种不同的方法可以查看树中的所有节点吗？ 如下：

```swift
  public func traverseInOrder(process: (T) -> Void) {
    left?.traverseInOrder(process: process)
    process(value)
    right?.traverseInOrder(process: process)
  }

  public func traversePreOrder(process: (T) -> Void) {
    process(value)
    left?.traversePreOrder(process: process)
    right?.traversePreOrder(process: process)
  }

  public func traversePostOrder(process: (T) -> Void) {
    left?.traversePostOrder(process: process)
    right?.traversePostOrder(process: process)
    process(value)
  }
```

它们都以不同的顺序工作。 请注意，所有工作都是递归完成的。 Swift的可选链清楚地表明，当没有左或右子节点时，忽略对`traverseInOrder()`等的调用。



要打印出从低到高排序的树的所有值，您可以编写：

```swift
tree.traverseInOrder { value in print(value) }
```

打印结果：

	1
	2
	5
	7
	9
	10

你还可以在树中添加`map()`和`filter()`方法。 例如，这是map的实现：

```swift

  public func map(formula: (T) -> T) -> [T] {
    var a = [T]()
    if let left = left { a += left.map(formula: formula) }
    a.append(formula(value))
    if let right = right { a += right.map(formula: formula) }
    return a
  }
```

这将在树中的每个节点上调用`formula`闭包，并在结果以数组返回。 `map()`通过按中序遍历树来工作。

一个非常简单的如何使用`map()`的例子：

```swift
  public func toArray() -> [T] {
    return map { $0 }
  }
```

这会将树的内容重新转换为已排序的数组。 在playground上试一试：

```swift
tree.toArray()   // [1, 2, 5, 7, 9, 10]
```

作为练习，看看是否可以实现`filter`和`reduce`。

> **译注：**`map`,  `filter`和`reduce`都是高阶函数，关于高阶函数可查看我总结的文章 [Swift中的高阶函数：sorted, map, reduce, forEach, flatMap, filter](http://andyron.com/2018/swift-higher-order-function) 。



### 删除节点

我们可以通过定义一些辅助函数来使代码更具可读性。

```swift
  private func reconnectParentTo(node: BinarySearchTree?) {
    if let parent = parent {
      if isLeftChild {
        parent.left = node
      } else {
        parent.right = node
      }
    }
    node?.parent = parent
  }
```


对树进行更改涉及更改`parent`和`left`和`right`指针。 此功能有助于实现此功能。 它接受当前节点的父节点 - 即`self` - 并将其连接到另一个节点，该节点将是`self`的子节点之一。

我们还需要一个返回节点最小值和最大值的函数：

```swift
  public func minimum() -> BinarySearchTree {
    var node = self
    while let next = node.left {
      node = next
    }
    return node
  }

  public func maximum() -> BinarySearchTree {
    var node = self
    while let next = node.right {
      node = next
    }
    return node
  }

```

其余代码是不言自明的：

```swift
  @discardableResult public func remove() -> BinarySearchTree? {
    let replacement: BinarySearchTree?

    // Replacement for current node can be either biggest one on the left or
    // smallest one on the right, whichever is not nil
    if let right = right {
      replacement = right.minimum()
    } else if let left = left {
      replacement = left.maximum()
    } else {
      replacement = nil
    }

    replacement?.remove()

    // Place the replacement on current node's position
    replacement?.right = right
    replacement?.left = left
    right?.parent = replacement
    left?.parent = replacement
    reconnectParentTo(node:replacement)

    // The current node is no longer part of the tree, so clean it up.
    parent = nil
    left = nil
    right = nil

    return replacement
  }
```

> **译注：** swift正常的方法如果有返回值的话,调用的时候必须有一个接收方,否则的话编译器会报一个警告,如果在方法前加上`@discardableResult` 不处理的时候就不会有警告了。



### 深度和高度

回想一下节点的高度是到最低叶节点的距离。 我们可以用以下函数来计算：

```swift
  public func height() -> Int {
    if isLeaf {
      return 0
    } else {
      return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
  }
```

我们看一下左右分支的高度并取最大值。 同样，这是一个递归过程。 由于这会查看此节点的所有子节点，因此性能为 **O(n)**。

> **注意：** Swift的空合运算符方便处理`left`或`right`指针为`nil`的情况。 你也可以用`if let`，但这更简洁。


试试看：

```swift
tree.height()  // 2
```

您还可以计算节点的 *深度*，即到根节点的距离。 这是代码：

```swift
  public func depth() -> Int {
    var node = self
    var edges = 0
    while let parent = node.parent {
      node = parent
      edges += 1
    }
    return edges
  }
```

它沿着 `parent` 指针向上逐步穿过树，直到我们到达根节点（即`parent`为nil）。 这需要 **O(h)** 时间。 这是一个例子：

```swift
if let node9 = tree.search(9) {
  node9.depth()   // returns 2
}
```

### 前驱节点和后继节点


二叉搜索树总是“排序”，但这并不意味着连续的数字实际上在树中是彼此相邻的。

![Example](Images/Tree2.png)

请注意，通过查看其左子节点，您无法找到`7`之前的数字。 左子节点是`2`，而不是`5`。 同样地，也无法找到`7`之后的数字。

`predecessor()`函数以排序顺序返回其值在当前值之前的节点：

```swift
  public func predecessor() -> BinarySearchTree<T>? {
    if let left = left {
      return left.maximum()
    } else {
      var node = self
      while let parent = node.parent {
        if parent.value < value { return parent }
        node = parent
      }
      return nil
    }
  }
```

如果该节点有左子树很容易。 在这种情况下，该节点的前驱节点是左子树中的最大值。 您可以在上面的图片中验证`5`确实是`7`左分支中的最大值。

如果没有左子树，那么我们必须查看父节点，直到找到一个较小的值。如果我们想知道节点`9`的前驱节点是什么，我们一直向上，直到找到第一个具有较小值的父节点，即`7`。

`successor()`的代码以相同的方式工作：

```swift
  public func successor() -> BinarySearchTree<T>? {
    if let right = right {
      return right.minimum()
    } else {
      var node = self
      while let parent = node.parent {
        if parent.value > value { return parent }
        node = parent
      }
      return nil
    }
  }
```

这两种方法都在 **O(h)** 时间内运行。

> **注意：** 有一种称为[“线索”二叉树](../Threaded%20Binary%20Tree)的二叉搜索树变体，其中“未使用的”左右指针被重新用于在前驱节点和后继节点之间建立直接链接。 非常聪明！



### 搜索树有效吗？

如果您打算进行破坏，可以通过在非根节点上调用`insert()`将二分搜索树变为无效树。 这是一个例子：

```swift
if let node1 = tree.search(1) {
  node1.insert(100)
}
```

根节点的值为`7`，因此值为`100`的节点必须位于树的右侧分支中。 但是，您不是插入根，而是插入树左侧分支中的叶节点。 所以新的`100`节点在树中的错误位置！

结果，`tree.search(100)`给出nil。

您可以使用以下方法检查树是否是有效的二叉搜索树：

```swift
  public func isBST(minValue minValue: T, maxValue: T) -> Bool {
    if value < minValue || value > maxValue { return false }
    let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
    let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
    return leftBST && rightBST
  }
```

这将验证左侧分支包含的值是否小于当前节点的值，右侧分支仅包含更大的值。

使用如下：

```swift
if let node1 = tree.search(1) {
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
  node1.insert(100)                                 // EVIL!!!
  tree.search(100)                                  // nil
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}
```

## 代码（解决方案2）

我们已经使用类实现二叉树节点，但您也可以使用枚举。

鉴于引用类型与值类型的不同。 对基于类的树进行更改将更新内存中的相同实例，但基于枚举的树是不可变的 - 任何插入或删除都将为您提供树的全新副本。哪一个好，完全取决于你想用它做什么。


以下是使用枚举创建二叉搜索树的方法：

```swift
public enum BinarySearchTree<T: Comparable> {
  case Empty
  case Leaf(T)
  indirect case Node(BinarySearchTree, T, BinarySearchTree)
}
```



枚举有三种情况：

- `Empty`标记分支的结尾（基于类的版本使用`nil`引用）。
- 没有子节点的叶节点的`Leaf`。
- 具有一个或两个子节点的节点的`Node`。 这标记为`indirect`，因此它可以保存`BinarySearchTree`值。 如果没有`indirect`，你就无法生成递归枚举。

> **注意：**此二叉树中的节点没有对其父节点的引用。 这不是一个主要障碍，但它会使某些操作实施起来更加麻烦。

这个实现是递归的，枚举的每个情况都将被区别对待。 例如，这是您可以计算树中节点数和树高的方法：

```swift
  public var count: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return left.count + 1 + right.count
    }
  }

  public var height: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return 1 + max(left.height, right.height)
    }
  }
```

插入新节点如下所示：

```swift
  public func insert(newValue: T) -> BinarySearchTree {
    switch self {
    case .Empty:
      return .Leaf(newValue)

    case .Leaf(let value):
      if newValue < value {
        return .Node(.Leaf(newValue), value, .Empty)
      } else {
        return .Node(.Empty, value, .Leaf(newValue))
      }

    case .Node(let left, let value, let right):
      if newValue < value {
        return .Node(left.insert(newValue), value, right)
      } else {
        return .Node(left, value, right.insert(newValue))
      }
    }
  }
```

在playground尝试：

```swift
var tree = BinarySearchTree.Leaf(7)
tree = tree.insert(2)
tree = tree.insert(5)
tree = tree.insert(10)
tree = tree.insert(9)
tree = tree.insert(1)
```

请注意，对于每次插入，都会返回一个新的树对象，因此需要将结果分配回`tree`变量。

这是最重要的搜索功能：

```swift
  public func search(x: T) -> BinarySearchTree? {
    switch self {
    case .Empty:
      return nil
    case .Leaf(let y):
      return (x == y) ? self : nil
    case let .Node(left, y, right):
      if x < y {
        return left.search(x)
      } else if y < x {
        return right.search(x)
      } else {
        return self
      }
    }
  }
```

大多数这些功能具有相同的结构。

在playground尝试：

```swift
tree.search(10)
tree.search(1)
tree.search(11)   // nil
```

要打印树以进行调试，可以使用以下方法：

```swift
extension BinarySearchTree: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .Empty: return "."
    case .Leaf(let value): return "\(value)"
    case .Node(let left, let value, let right):
      return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
    }
  }
}
```

当你执行`print(tree)`时，它看起来像这样：

	((1 <- 2 -> 5) <- 7 -> (9 <- 10 -> .))

根节点位于中间，点表示该位置没有子节点。

## 当树变得不平衡时......

当二叉制搜索树的左右子树包含相同数量的节点时，它是*平衡的*。 在这种情况下，树的高度为 *log(n)*，其中 *n* 是节点数。 这是理想的情况。

如果一个分支明显长于另一个分支，则搜索变得非常慢。 我们最终检查的花费超出了我们的需要。 在最坏的情况下，树的高度可以变为 *n*。 这样的树就像 [链表](../Linked%20List/) 而不是二叉搜索树，性能降低到 **O(n)**。 不好！

使二叉制搜索树平衡的一种方法是以完全随机的顺序插入节点。 平均而言，应该很好地平衡树，但不保证，也不总是实用。

另一种解决方案是使用 *自平衡* 二叉树。 插入或删除节点后，此类型的数据结构会调整树以使其保持平衡。 要查看示例，请查看[AVL树](../AVL%20Tree)和[红黑树](../Red-Black%20Tree)。



## 扩展阅读

[二叉树搜索的维基百科](https://en.wikipedia.org/wiki/Binary_search_tree)



*作者：[Nicolas Ameghino](http://www.github.com/nameghino) 和 Matthijs Hollemans*  
*译者：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

