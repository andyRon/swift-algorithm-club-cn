# Binary Tree
# 二叉树

A binary tree is a [tree](../Tree/) where each node has 0, 1, or 2 children. This is a binary tree:
二叉树是一种[树](../Tree/)，其中每个节点具有0,1或2个子节点。 这是一棵二叉树：

![A binary tree](Images/BinaryTree.png)

The child nodes are usually called the *left* child and the *right* child. If a node doesn't have any children, it's called a *leaf* node. The *root* is the node at the very top of the tree (programmers like their trees upside down).
子节点通常称为 *left* 子节点 和 *right* 子节点。 如果节点没有任何子节点，则称为 *leaf*节点。 *root* 是树顶部的节点（程序员喜欢它们的树倒置）。

Often nodes will have a link back to their parent but this is not strictly necessary.
节点通常会有一个返回其父节点的连接，但这不是绝对必要的。

Binary trees are often used as [binary search trees](../Binary%20Search%20Tree/). In that case, the nodes must be in a specific order (smaller values on the left, larger values on the right). But this is not a requirement for all binary trees.
二叉树通常用作[二叉搜索树](../Binary％20Search％20Tree/)。 在这种情况下，节点必须按特定顺序排列（左侧较小的值，右侧较大的值）。 但这不是所有二叉树的要求。

For example, here is a binary tree that represents a sequence of arithmetical operations, `(5 * (a - 10)) + (-4 * (3 / b))`:
例如，这是一个二叉树，表示一系列算术运算，`(5 * (a - 10)) + (-4 * (3 / b))`：

![A binary tree](Images/Operations.png)

## The code
## 代码

Here's how you could implement a general-purpose binary tree in Swift:
以下是在Swift中实现通用二叉树的方法：

```swift
public indirect enum BinaryTree<T> {
  case node(BinaryTree<T>, T, BinaryTree<T>)
  case empty
}
```

As an example of how to use this, let's build that tree of arithmetic operations:
作为如何使用它的一个例子，让我们构建算术运算树：

```swift
// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.node(timesLeft, "+", timesRight)
```

You need to build up the tree in reverse, starting with the leaf nodes and working your way up to the top.
您需要反向构建树，从叶节点开始，一直到顶部。

It will be useful to add a `description` method so you can print the tree:
添加`description`方法以便打印树是很有用的：

```swift
extension BinaryTree: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .node(left, value, right):
      return "value: \(value), left = [\(left.description)], right = [\(right.description)]"
    case .empty:
      return ""
    }
  }
}
```

If you `print(tree)` you should see something like this:
如果你 `print(tree)` 你应该看到这样的东西：

	value: +, left = [value: *, left = [value: 5, left = [], right = []], right = [value: -, left = [value: a, left = [], right = []], right = [value: 10, left = [], right = []]]], right = [value: *, left = [value: -, left = [], right = [value: 4, left = [], right = []]], right = [value: /, left = [value: 3, left = [], right = []], right = [value: b, left = [], right = []]]]

With a bit of imagination, you can see the tree structure. ;-) It helps if you indent it:
通过一点想象力，您可以看到树形结构。 ;-)如果你缩进它会有所帮助：

	value: +, 
		left = [value: *, 
			left = [value: 5, left = [], right = []], 
			right = [value: -, 
				left = [value: a, left = [], right = []], 
				right = [value: 10, left = [], right = []]]], 
		right = [value: *, 
			left = [value: -, 
				left = [], 
				right = [value: 4, left = [], right = []]], 
			right = [value: /, 
				left = [value: 3, left = [], right = []], 
				right = [value: b, left = [], right = []]]]

Another useful method is counting the number of nodes in the tree:
另一个有用的方法是计算树中的节点数：

```swift
  public var count: Int {
    switch self {
    case let .node(left, _, right):
      return left.count + 1 + right.count
    case .empty:
      return 0
    }
  }
```

On the tree from the example, `tree.count` should be 12.
在示例的树上，`tree.count`应该是12。

Something you often need to do with trees is traverse them, i.e. look at all the nodes in some order. There are three ways to traverse a binary tree:
您经常需要对树进行的操作遍历它们，即以某种顺序查看所有节点。 遍历二叉树有三种方法：

1. *In-order* (or *depth-first*): first look at the left child of a node, then at the node itself, and finally at its right child.
2. *Pre-order*: first look at a node, then at its left and right children. 
3. *Post-order*: first look at the left and right children and process the node itself last.

1. *有序*（或*深度优先*）：首先查看节点的左子节点，然后查看节点本身，最后查看其右子节点。
2. *预订*：首先查看节点，然后查看其左右儿童。
3. *后订单*：首先查看左右子节点并最后处理节点本身。

Here is how you'd implement that:
以下是您实现的方法：

```swift
  public func traverseInOrder(process: (T) -> Void) {
    if case let .node(left, value, right) = self {
      left.traverseInOrder(process: process)
      process(value)
      right.traverseInOrder(process: process)
    }
  }
  
  public func traversePreOrder(process: (T) -> Void) {
    if case let .node(left, value, right) = self {
      process(value)
      left.traversePreOrder(process: process)
      right.traversePreOrder(process: process)
    }
  }
  
  public func traversePostOrder(process: (T) -> Void) {
    if case let .node(left, value, right) = self {
      left.traversePostOrder(process: process)
      right.traversePostOrder(process: process)
      process(value)
    }
  }
```

As is common when working with tree structures, these functions call themselves recursively.
在使用树结构时很常见，这些函数会递归调用它们。

For example, if you traverse the tree of arithmetic operations in post-order, you'll see the values in this order:
例如，如果您按顺序遍历算术运算树，您将按以下顺序查看值：

	5
	a
	10
	-
	*
	4
	-
	3
	b
	/
	*
	+

The leaves appear first. The root node appears last.
树叶首先出现。 根节点最后出现。

You can use a stack machine to evaluate these expressions, something like the following pseudocode:
您可以使用堆栈计算机来评估这些表达式，类似于以下伪代码：

```swift
tree.traversePostOrder { s in 
  switch s {
  case this is a numeric literal, such as 5:
    push it onto the stack
  case this is a variable name, such as a:
    look up the value of a and push it onto the stack
  case this is an operator, such as *:
    pop the two top-most items off the stack, multiply them,
    and push the result back onto the stack
  }
  the result is in the top-most item on the stack
}
```

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*
*译者：[Andy Ron](https://github.com/andyRon)*
