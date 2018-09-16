# Binary Search Tree (BST)
# 二分搜索树(BST)

> This topic has been tutorialized [here](https://www.raywenderlich.com/139821/swift-algorithm-club-swift-binary-search-tree-data-structure)
> 本编主题的教程 [here](https://www.raywenderlich.com/139821/swift-algorithm-club-swift-binary-search-tree-data-structure)


A binary search tree is a special kind of [binary tree](../Binary%20Tree/) (a tree in which each node has at most two children) that performs insertions and deletions such that the tree is always sorted.
二叉搜索树是一种特殊的[二叉树](../Binary％20Tree/)（每个节点最多有两个子节点的树），它执行插入和删除，以便始终对树进行排序。

For more information about a tree, [read this first](../Tree/).
有关树的更多信息，[请先阅读](../Tree/)。

## "Always sorted" property
## “始终排序”属性

Here is an example of a valid binary search tree:
下面是一个有效二叉搜索树的示例：

![二叉搜索树](Images/Tree1.png)

Notice how each left child is smaller than its parent node, and each right child is greater than its parent node. This is the key feature of a binary search tree.
注意每个左子节点小于其父节点，并且每个右子节点大于其父节点。 这是二叉搜索树的关键特性。

For example, `2` is smaller than `7`, so it goes on the left; `5` is greater than `2`, so it goes on the right.
例如，`2`小于'7`，所以它在左边; `5`大于'2`，所以它在右边。

## Inserting new nodes
## 插入新节点

When performing an insertion, we first compare the new value to the root node. If the new value is smaller, we take the *left* branch; if greater, we take the *right* branch. We work our way down the tree this way until we find an empty spot where we can insert the new value.
执行插入时，我们首先将新值与根节点进行比较。 如果新值较小，我们采用*left*分支; 如果更大，我们采取*right*分支。我们沿着这条路向下走，直到找到一个我们可以插入新值的空位。

Suppose we want to insert the new value `9`:
假设我们要插入新值`9`：

- We start at the root of the tree (the node with the value `7`) and compare it to the new value `9`.
- `9 > 7`, so we go down the right branch and repeat the same procedure but this time on node `10`.
- Because `9 < 10`, we go down the left branch.
- We now arrived at a point where there are no more values to compare with. A new node for `9` is inserted at that location.
- 我们从树的根（值为`7`的节点）开始，并将其与新值`9`进行比较。
- `9> 7`，所以我们走右边的分支并重复相同的过程，但这次是在节点`10`上。
- 因为`9 <10`，我们走左边的分支。
- 我们现在到了一个没有更多值可供比较的地方。 在该位置插入`9`的新节点。

Here is the tree after inserting the new value `9`:
插入新值`9`后：

![After adding 9](Images/Tree2.png)

There is only one possible place where the new element can be inserted in the tree. Finding this place is usually quick. It takes **O(h)** time, where **h** is the height of the tree.
只有一个可能的位置可以在树中插入新元素。 找到这个地方通常很快。 它需要 **O(h)** 时间，其中 **h** 是树的高度。

> **Note:** The *height* of a node is the number of steps it takes to go from that node to its lowest leaf. The height of the entire tree is the distance from the root to the lowest leaf. Many of the operations on a binary search tree are expressed in terms of the tree's height.
> **注意：** 节点的 *height* 是从该节点到最低叶子所需的步骤数。 整棵树的高度是从根到最低叶子的距离。 二叉搜索树上的许多操作都以树的高度表示。

By following this simple rule -- smaller values on the left, larger values on the right -- we keep the tree sorted, so whenever we query it, we can check if a value is in the tree.
通过遵循这个简单的规则 -- 左侧较小的值，右侧较大的值 -- 我们保持树的排序，每当我们查询它时，可以检查值是否在树中。

## Searching the tree
## 搜索树

To find a value in the tree, we perform the same steps as with insertion:
要在树中查找值，我们执行与插入相同的步骤：

- If the value is less than the current node, then take the left branch.
- If the value is greater than the current node, take the right branch.
- If the value is equal to the current node, we've found it!
- 如果该值小于当前节点，则采用左分支。
- 如果该值大于当前节点，请选择右分支。
- 如果该值等于当前节点，我们就找到了它！

Like most tree operations, this is performed recursively until either we find what we are looking for or run out of nodes to look at.
像大多数树操作一样，这是递归执行的，直到我们找到我们正在查找的内容或用完要查看的所有节点。

Here is an example for searching the value `5`:
以下是搜索值“5”的示例：

![搜索树](Images/Searching.png)

Searching is fast using the structure of the tree. It runs in **O(h)** time. If you have a well-balanced tree with a million nodes, it only takes about 20 steps to find anything in this tree. (The idea is very similar to [binary search](../Binary%20Search) in an array.)
使用树的结构搜索很快。 它在 **O(h)** 时间内运行。 如果你有一个具有一百万个节点的均衡树，那么在这棵树中只需要大约20步就可以找到任何东西。（这个想法与数组中的[二分搜索](../Binary％20Search/)非常相似）

## Traversing the tree
## 遍历树

Sometimes you need to look at all nodes rather than only one.
有时您需要查看所有节点而不是仅查看一个节点。

There are three ways to traverse a binary tree:
遍历二叉树有三种方法：

1. *In-order* (or *depth-first*): first look at the left child of a node then at the node itself and finally at its right child.
2. *Pre-order*: first look at a node then its left and right children.
3. *Post-order*: first look at the left and right children and process the node itself last.
1. *有序*（或 *深度优先*）：首先查看节点的左子节点，然后查看节点本身，最后查看其右子节点。
2. *预订*：首先查看一个节点，然后查看其左右子节点。
3. *后订单*：首先查看左右子节点并最后处理节点本身。

Traversing the tree also happens recursively.
遍历树也是递归发生的。

If you traverse a binary search tree in-order, it looks at all the nodes as if they were sorted from low to high. For the example tree, it would print `1, 2, 5, 7, 9, 10`:
如果按顺序遍历二叉搜索树，它会查看所有节点，就好像它们从低到高排序一样。 对于示例树，它将打印`1,2,5,7,9,10`：

![遍历树](Images/Traversing.png)

## Deleting nodes
## 删除节点

Removing nodes is easy. After removing a node, we replace the node with either its biggest child on the left or its smallest child on the right. That way the tree is still sorted after the removal. In the following example, 10 is removed and replaced with either 9 (Figure 2) or 11 (Figure 3).
删除节点很容易。删除节点后，我们将节点替换为左侧最大的子节点或右侧的最小子节点。这样，树在删除节点后仍然排序。在以下示例中，将删除10并替换为9（Figure 2）或11（Figure 3）。

![删除有两个孩子的节点](Images/DeleteTwoChildren.png)

Note the replacement needs to happen when the node has at least one child. If it has no child, you just disconnect it from its parent:
请注意，当节点至少有一个子节点时，需要进行替换。 如果它没有子节点，您只需将其与其父节点断开连接：

![Deleting a leaf node](Images/DeleteLeaf.png)


## The code (solution 1)
## 代码（解决方案1）

So much for the theory. Let's see how we can implement a binary search tree in Swift. There are different approaches you can take. First, I will show you how to make a class-based version, but we will also look at how to make one using enums.
这个理论太多了。让我们看看如何在Swift中实现二叉搜索树。您可以采取不同的方法。首先，我将向您展示如何制作基于类的版本，但我们还将介绍如何使用枚举制作版本。

Here is an example for a `BinarySearchTree` class:
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

  public var isRoot: Bool {
    return parent == nil
  }

  public var isLeaf: Bool {
    return left == nil && right == nil
  }

  public var isLeftChild: Bool {
    return parent?.left === self
  }

  public var isRightChild: Bool {
    return parent?.right === self
  }

  public var hasLeftChild: Bool {
    return left != nil
  }

  public var hasRightChild: Bool {
    return right != nil
  }

  public var hasAnyChild: Bool {
    return hasLeftChild || hasRightChild
  }

  public var hasBothChildren: Bool {
    return hasLeftChild && hasRightChild
  }

  public var count: Int {
    return (left?.count ?? 0) + 1 + (right?.count ?? 0)
  }
}
```

This class describes just a single node not the entire tree. It is a generic type, so the node can store any kind of data. It also has references to its `left` and `right` child nodes and a `parent` node.
此类仅描述单个节点而不是整个树。 它是泛型类型，因此节点可以存储任何类型的数据。 它还引用了它的`left`和`right`子节点以及一个`parent`节点。

Here is how you can use it:
以下是如何使用它：

```swift
let tree = BinarySearchTree<Int>(value: 7)
```

The `count` property determines how many nodes are in the subtree described by this node. This does not just count the node's immediate children but also their children and their children's children, and so on. If this particular object is the root node, then it counts how many nodes are in the entire tree. Initially, `count = 0`.
`count`属性确定此节点描述的子树中有多少个节点。这不仅仅计算节点的直接子节点，还计算他们的子节点和子节点的子节点，等等。如果此特定对象是根节点，则它计算整个树中有多少个节点。 最初，`count = 0`。

> **Note:** Because `left`, `right`, and `parent` are optional, we can make good use of Swift's optional chaining (`?`) and nil-coalescing operators (`??`). You could also write this sort of thing with `if let`, but that is less concise.
> **注意：** 因为`left`，`right`和`parent`是可选的，我们可以很好地利用Swift的可选值链（`？`）和 空合运算符（`??`）。 你也可以用`if let`写这种东西，但那不简洁。

### Inserting nodes
### 插入节点

A tree node by itself is useless, so here is how you would add new nodes to the tree:
树节点本身是无用的，所以这里是如何向树添加新节点：

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

Like so many other tree operations, insertion is easiest to implement with recursion. We compare the new value to the values of the existing nodes and decide whether to add it to the left branch or the right branch.
像许多其他树操作一样，插入最容易实现递归。 我们将新值与现有节点的值进行比较，并决定是将其添加到左侧分支还是右侧分支。

If there is no more left or right child to look at, we create a `BinarySearchTree` object for the new node and connect it to the tree by setting its `parent` property.
如果没有更多的左或右子进行查看，我们为新节点创建一个`BinarySearchTree`对象，并通过设置其`parent`属性将其连接到树。

> **Note:** Because the whole point of a binary search tree is to have smaller nodes on the left and larger ones on the right, you should always insert elements at the root to make sure this remains a valid binary tree!
> **注意：** 因为二分搜索树的整个点是左边有较小的节点而右边有较大的节点，所以你应该总是在根处插入元素，以确保它仍然是一个有效的二叉树！

To build the complete tree from the example you can do:
要从示例构建完整的树，您可以执行以下操作：

```swift
let tree = BinarySearchTree<Int>(value: 7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)
```

> **Note:** For reasons that will become clear later, you should insert the numbers in a random order. If you insert them in a sorted order, the tree will not have the right shape.
> **注意：** 由于后来会变得明确的原因，您应该以随机顺序插入数字。 如果按排序顺序插入它们，则树的形状将不正确。

For convenience, let's add an init method that calls `insert()` for all the elements in an array:
为方便起见，让我们添加一个init方法，为数组中的所有元素调用`insert（）`：

```swift
  public convenience init(array: [T]) {
    precondition(array.count > 0)
    self.init(value: array.first!)
    for v in array.dropFirst() {
      insert(value: v)
    }
  }
```

Now you can simply do this:
现在可以简单的使用：

```swift
let tree = BinarySearchTree<Int>(array: [7, 2, 5, 10, 9, 1])
```

The first value in the array becomes the root of the tree.
数组中的第一个值成为树的根。

### Debug output
### 调试输出

When working with complicated data structures, it is useful to have human-readable debug output.
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

When you do a `print(tree)`, you should get something like this:
当你执行`print（tree）`时，你应该得到这样的东西：

	((1) <- 2 -> (5)) <- 7 -> ((9) <- 10)

The root node is in the middle. With some imagination, you should see that this indeed corresponds to the following tree:
根节点位于中间。 发挥一些想象力，您应该看到这确实对应于下面的树：

![The tree](Images/Tree2.png)

You may be wondering what happens when you insert duplicate items? We always insert those in the right branch. Try it out!
您可能想知道插入重复项时会发生什么？我们总是将它们插入正确的分支中。 试试看！

### Searching
### 搜索

What do we do now that we have some values in our tree? Search for them, of course! To find items quickly is the main purpose of a binary search tree. :-)
我们现在做什么，我们树上有一些价值？ 当然，搜索它们吧！ 快速查找项目是二叉搜索树的主要目的。:-)

Here is the implementation of `search()`:
这是`search（）`的实现：

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

I hope the logic is clear: this starts at the current node (usually the root) and compares the values. If the search value is less than the node's value, we continue searching in the left branch; if the search value is greater, we dive into the right branch.
我希望逻辑清楚：这从当前节点（通常是根节点）开始并比较这些值。 如果搜索值小于节点的值，我们继续在左侧分支中搜索;如果搜索值更大，我们会跳到正确的分支。

If there are no more nodes to look at -- when `left` or `right` is nil -- then we return `nil` to indicate the search value is not in the tree.
如果没有更多的节点要看 - 当`left`或`right`为nil时 - 那么我们返回`nil`表示搜索值不在树中。

> **Note:** In Swift, that is conveniently done with optional chaining; when you write `left?.search(value)` it automatically returns nil if `left` is nil. There is no need to explicitly check for this with an `if` statement.
> **注意：** 在Swift中，可以通过可选链方便地完成; 当你写`left？.search（value）`时，如果`left`为nil，它会自动返回nil。 没有必要使用`if`语句显式检查。

Searching is a recursive process, but you can also implement it with a simple loop instead:
搜索是一个递归过程，但您也可以使用简单的循环来实现它：

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

Verify that you understand these two implementations are equivalent. Personally, I prefer to use iterative code over recursive code, but your opinion may differ. ;-)
验证您是否理解这两个实现是等效的。 就个人而言，我更喜欢使用迭代代码而不是递归代码，但您的意见可能会有所不同。;-)

Here is how to test searching:
以下是如何测试搜索：

```swift
tree.search(5)
tree.search(2)
tree.search(7)
tree.search(6)   // nil
```

The first three lines return the corresponding `BinaryTreeNode` object. The last line returns `nil` because there is no node with value `6`.
前三行返回相应的`BinaryTreeNode`对象。 最后一行返回`nil`，因为没有值为`6`的节点。

> **Note:** If there are duplicate items in the tree, `search()` returns the "highest" node. That makes sense, because we start searching from the root downwards.
> **注意：** 如果树中有重复项，`search（）`返回“最高”节点。 这是有道理的，因为我们开始从根向下搜索。

### Traversal
### 遍历

Remember there are 3 different ways to look at all nodes in the tree? Here they are:
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

They all work the same but in different orders. Notice that all the work is done recursively. The Swift's optional chaining makes it clear that the calls to `traverseInOrder()` etc are ignored when there is no left or right child.
它们都以不同的顺序工作。 请注意，所有工作都是递归完成的。 Swift的可选链清楚地表明，当没有左或右子时，忽略对`traverseInOrder（）`等的调用。

To print out all the values of the tree sorted from low to high you can write:
要打印出从低到高排序的树的所有值，您可以编写：

```swift
tree.traverseInOrder { value in print(value) }
```

This prints the following:
打印结果：

	1
	2
	5
	7
	9
	10

You can also add things like `map()` and `filter()` to the tree. For example, here is an implementation of map:
你还可以在树中添加`map（）`和`filter（）`灯方法。 例如，这是map的实现：

```swift

  public func map(formula: (T) -> T) -> [T] {
    var a = [T]()
    if let left = left { a += left.map(formula: formula) }
    a.append(formula(value))
    if let right = right { a += right.map(formula: formula) }
    return a
  }
```

This calls the `formula` closure on each node in the tree and collects the results in an array. `map()` works by traversing the tree in-order.
这将在树中的每个节点上调用`formula`闭包，并在数组中收集结果。 `map（）`通过按顺序遍历树来工作。

An extremely simple example of how to use `map()`:
一个非常简单的如何使用`map（）`的例子：

```swift
  public func toArray() -> [T] {
    return map { $0 }
  }
```

This turns the contents of the tree back into a sorted array. Try it out in the playground:
这会将树的内容重新转换为已排序的数组。 在playground上试一试：

```swift
tree.toArray()   // [1, 2, 5, 7, 9, 10]
```

As an exercise, see if you can implement filter and reduce.
作为练习，看看是否可以实现过滤和减少。

### Deleting nodes
### 删除节点

We can make the code more readable by defining some helper functions.
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

Making changes to the tree involves changing a bunch of `parent` and `left` and `right` pointers. This function helps with this implementation. It takes the parent of the current node -- that is `self` -- and connects it to another node which will be one of the children of `self`.
对树进行更改涉及更改`parent`和`left`和`right`指针。 此功能有助于实现此功能。 它接受当前节点的父节点 - 即`self` - 并将其连接到另一个节点，该节点将是`self`的子节点之一。

We also need a function that returns the minimum and maximum of a node:
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

The rest of the code is self-explanatory:
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

### Depth and height
### 深度和高度

Recall that the height of a node is the distance to its lowest leaf. We can calculate that with the following function:
回想一下节点的高度是到最低叶子的距离。 我们可以用以下函数来计算：

```swift
  public func height() -> Int {
    if isLeaf {
      return 0
    } else {
      return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
  }
```

We look at the heights of the left and right branches and take the highest one. Again, this is a recursive procedure. Since this looks at all children of this node, performance is **O(n)**.
我们看一下左右分支的高度并取最高分。 同样，这是一个递归过程。 由于这会查看此节点的所有子节点，因此性能为 **O(n)**。

> **Note:** Swift's null-coalescing operator is used as shorthand to deal with `left` or `right` pointers that are nil. You could write this with `if let`, but this is more concise.
> **注意：** Swift的空合运算符用作处理nil的`left`或`right`指针的简写。 你可以用`if let`来写这个，但这更简洁。

Try it out:
试试看：

```swift
tree.height()  // 2
```

You can also calculate the *depth* of a node, which is the distance to the root. Here is the code:
您还可以计算节点的 *深度*，即到根的距离。 这是代码：

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

It steps upwards through the tree, following the `parent` pointers until we reach the root node (whose `parent` is nil). This takes **O(h)** time. Here is an example:
它沿着 `parent` 指针向上逐步穿过树，直到我们到达根节点（其`parent`为nil）。 这需要 **O(h)** 时间。 这是一个例子：

```swift
if let node9 = tree.search(9) {
  node9.depth()   // returns 2
}
```

### Predecessor and successor
### 前身和继任者

The binary search tree is always "sorted" but that does not mean that consecutive numbers are actually next to each other in the tree.
二叉搜索树总是“排序”但这并不意味着连续的数字实际上在树中彼此相邻。

![Example](Images/Tree2.png)

Note that you cannot find the number that comes before `7` by just looking at its left child node. The left child is `2`, not `5`. Likewise for the number that comes after `7`.
请注意，通过查看其左子节点，您无法找到`7`之前的数字。 左边的子节点是`2`，而不是`5`。 同样地，在`7`之后出现的数字。

The `predecessor()` function returns the node whose value precedes the current value in sorted order:
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

It is easy if we have a left subtree. In that case, the immediate predecessor is the maximum value in that subtree. You can verify in the above picture that `5` is indeed the maximum value in `7`'s left branch.
如果我们有一个左子树很容易。 在这种情况下，前一个前一个是该子树中的最大值。 您可以在上面的图片中验证`5`确实是`7`左分支中的最大值。

If there is no left subtree, then we have to look at our parent nodes until we find a smaller value. If we want to know what the predecessor is of node `9`, we keep going up until we find the first parent with a smaller value, which is `7`.
如果没有左子树，那么我们必须查看父节点，直到找到一个较小的值。如果我们想知道节点`9`的前身是什么，我们一直向上，直到找到第一个具有较小值的父节点，即`7`。

The code for `successor()` works the same way but mirrored:
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

Both these methods run in **O(h)** time.
这两种方法都在 **O(h)** 时间内运行。

> **Note:** There is a variation called a ["threaded" binary tree](../Threaded%20Binary%20Tree) where "unused" left and right pointers are repurposed to make direct links between predecessor and successor nodes. Very clever!
> **注意：** 有一种称为[“线程”二叉树](../ Threaded％20Binary％20Tree)的变体，其中“未使用的”左右指针被重新用于在前任和后继节点之间建立直接链接。 非常聪明！

### Is the search tree valid?
### 搜索树有效吗？

If you were intent on sabotage you could turn the binary search tree into an invalid tree by calling `insert()` on a node that is not the root. Here is an example:
如果您打算进行破坏，可以通过在非根节点上调用`insert（）`将二分搜索树变为无效树。 这是一个例子：

```swift
if let node1 = tree.search(1) {
  node1.insert(100)
}
```

The value of the root node is `7`, so a node with value `100`must be in the tree's right branch. However, you are not inserting at the root but at a leaf node in the tree's left branch. So the new `100` node is in the wrong place in the tree!
根节点的值为`7`，因此值为`100`的节点必须位于树的右侧分支中。 但是，您不是插入根，而是插入树左侧分支中的叶节点。 所以新的`100`节点在树中的错误位置！

As a result, doing `tree.search(100)` gives nil.
结果，做`tree.search（100）`给出nil。

You can check whether a tree is a valid binary search tree with the following method:
您可以使用以下方法检查树是否是有效的二叉搜索树：

```swift
  public func isBST(minValue minValue: T, maxValue: T) -> Bool {
    if value < minValue || value > maxValue { return false }
    let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
    let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
    return leftBST && rightBST
  }
```

This verifies the left branch contains values that are less than the current node's value, and that the right branch only contains values that are larger.
这将验证左侧分支包含的值是否小于当前节点的值，右侧分支仅包含更大的值。

Call it as follows:
称其如下：

```swift
if let node1 = tree.search(1) {
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
  node1.insert(100)                                 // EVIL!!!
  tree.search(100)                                  // nil
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}
```

## The code (solution 2)
## 代码（解决方案2）

We have implemented the binary tree node as a class, but you can also use an enum.
我们已将二叉树节点实现为类，但您也可以使用枚举。

The difference is reference semantics versus value semantics. Making a change to the class-based tree will update that same instance in memory, but the enum-based tree is immutable -- any insertions or deletions will give you an entirely new copy of the tree. Which one is best, totally depends on what you want to use it for.
区别在于引用语义与值语义。 对基于类的树进行更改将更新内存中的相同实例，但基于枚举的树是不可变的 - 任何插入或删除都将为您提供树的全新副本。哪一个最好，完全取决于你想用它做什么。


Here is how you can make a binary search tree using an enum:
以下是使用枚举创建二叉搜索树的方法：

```swift
public enum BinarySearchTree<T: Comparable> {
  case Empty
  case Leaf(T)
  indirect case Node(BinarySearchTree, T, BinarySearchTree)
}
```

The enum has three cases:

- `Empty` to mark the end of a branch (the class-based version used `nil` references for this).
- `Leaf` for a leaf node that has no children.
- `Node` for a node that has one or two children. This is marked `indirect` so that it can hold `BinarySearchTree` values. Without `indirect` you can't make recursive enums.

枚举有三种情况：

- `Empty`标记分支的结尾（基于类的版本使用`nil`引用）。
- 没有子节点的叶节点的`Leaf`。
- 具有一个或两个子节点的节点的`Node`。 这标记为`indirect`，因此它可以保存`BinarySearchTree`值。 如果没有`indirect`，你就无法生成递归枚举。

> **Note:** The nodes in this binary tree do not have a reference to their parent node. It is not a major impediment, but it will make certain operations more cumbersome to implement.
> **注意：**此二叉树中的节点没有对其父节点的引用。 这不是一个主要障碍，但它会使某些操作实施起来更加麻烦。

This implementation is recursive, and each case of the enum will be treated differently. For example, this is how you can calculate the number of nodes in the tree and the height of the tree:
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

Inserting new nodes looks like this:
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

Try it out in a playground:
在playground尝试：

```swift
var tree = BinarySearchTree.Leaf(7)
tree = tree.insert(2)
tree = tree.insert(5)
tree = tree.insert(10)
tree = tree.insert(9)
tree = tree.insert(1)
```

Notice that for each insertion, you get back a new tree object, so you need to assign the result back to the `tree` variable.
请注意，对于每次插入，都会返回一个新的树对象，因此需要将结果分配回`tree`变量。

Here is the all-important search function:
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

Most of these functions have the same structure.
大多数这些功能具有相同的结构。

Try it out in a playground:
在playground尝试：

```swift
tree.search(10)
tree.search(1)
tree.search(11)   // nil
```

To print the tree for debug purposes, you can use this method:
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

When you do `print(tree)`, it will look like this:
当你执行`print(tree)`时，它看起来像这样：

	((1 <- 2 -> 5) <- 7 -> (9 <- 10 -> .))

The root node is in the middle, and a dot means there is no child at that position.
根节点位于中间，点表示该位置没有子节点。

## When the tree becomes unbalanced...
## 当树变得不平衡时......

A binary search tree is *balanced* when its left and right subtrees contain the same number of nodes. In that case, the height of the tree is *log(n)*, where *n* is the number of nodes. That is the ideal situation.
当二进制搜索树的左右子树包含相同数量的节点时，它是*平衡的*。 在这种情况下，树的高度为* log(n)*，其中 *n* 是节点数。 这是理想的情况。

If one branch is significantly longer than the other, searching becomes very slow. We end up checking more values than we need. In the worst case, the height of the tree can become *n*. Such a tree acts like a [linked list](../Linked%20List/) than a binary search tree, with performance degrading to **O(n)**. Not good!
如果一个分支明显长于另一个分支，则搜索变得非常慢。 我们最终检查的价值超出了我们的需要。 在最坏的情况下，树的高度可以变为 *n*。 这样的树就像 [linked list](../Linked％20List/) 而不是二叉搜索树，性能降低到 **O(n)**。 不好！

One way to make the binary search tree balanced is to insert the nodes in a totally random order. On average that should balance out the tree well, but it not guaranteed, nor is it always practical.
使二进制搜索树平衡的一种方法是以完全随机的顺序插入节点。 平均而言，应该很好地平衡树木，但不保证，也不总是实用。

The other solution is to use a *self-balancing* binary tree. This type of data structure adjusts the tree to keep it balanced after you insert or delete nodes. To see examples, check [AVL tree](../AVL%20Tree) and [red-black tree](../Red-Black%20Tree).
另一种解决方案是使用 *自平衡* 二叉树。 插入或删除节点后，此类型的数据结构会调整树以使其保持平衡。 要查看示例，请检查[AVL树](../AVL％20Tree)和[红黑树](../Red-Black％20Tree)。

## See also
## 扩展阅读

[Binary Search Tree on Wikipedia](https://en.wikipedia.org/wiki/Binary_search_tree)
[二叉树搜索的维基百科](https://en.wikipedia.org/wiki/Binary_search_tree)

*Written for the Swift Algorithm Club by [Nicolas Ameghino](http://www.github.com/nameghino) and Matthijs Hollemans*
*作者：[Nicolas Ameghino](http://www.github.com/nameghino) 和 Matthijs Hollemans*  
*译者：[Andy Ron](https://github.com/andyRon)*