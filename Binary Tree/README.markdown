# 二叉树（Binary Tree）

二叉树是一种[树](../Tree/)，其中每个节点具有0,1或2个子节点。 这是一个二叉树：

![一个二叉树](Images/BinaryTree.png)

子节点通常称为 *左* 子节点 和 *右* 子节点。 如果节点没有任何子节点，则称为 *叶子*节点。 *根* 是树顶部的节点（程序员习惯树颠倒了😀）。

节点通常会有一个返回其父节点的连接，但这不是绝对必要的。

二叉树通常用作[二叉搜索树](../Binary%20Search%20Tree/)。 在这种情况下，节点必须按特定顺序排列（左侧是较小的值，右侧是较大的值）。 但这不是所有二叉树的要求。

例如，这是一个二叉树，表示一系列算术运算，`(5 * (a - 10)) + (-4 * (3 / b))`：

![一个二叉树](Images/Operations.png)

## 代码

以下是在Swift中实现通用二叉树的方法：

```swift
public indirect enum BinaryTree<T> {
  case node(BinaryTree<T>, T, BinaryTree<T>)
  case empty
}
```

如何使用它的一个例子，让我们构建上面算术运算树：

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

您需要反向构建树，从叶子节点开始，一直到顶部。

添加`description`属性以便打印树，这会很有用的：

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

如果你 `print(tree)` 你应该看到这样的东西：

	value: +, left = [value: *, left = [value: 5, left = [], right = []], right = [value: -, left = [value: a, left = [], right = []], right = [value: 10, left = [], right = []]]], right = [value: *, left = [value: -, left = [], right = [value: 4, left = [], right = []]], right = [value: /, left = [value: 3, left = [], right = []], right = [value: b, left = [], right = []]]]

通过一点想象力，您可以看到树形结构。 ;-)如果你缩进它会清晰的看到：

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

另一个有用的属性是计算树中的节点数：

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

对于示例的树，`tree.count`应该是12。

您经常需要对树进行的操作遍历它们，即以某种顺序查看所有节点。 遍历二叉树有三种方法：

1. *In-order*（或*深度优先*）： 首先查看节点的左子节点，然后查看节点本身，最后查看其右子节点。
2. *Pre-order*： 首先查看节点，然后查看其左右子节点。
3. *Post-order*： 首先查看左右子节点最后处理节点本身。

> **译注：**这三种遍历方式分别称为：前序（Pre-order），中序（In-order），后序（Post-order）

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

这些函数会被递归调用，在使用树结构时很常见。

例如，如果您按 *Post-order* 遍历算术运算树，您将按以下顺序查看值：

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

叶子节点首先出现。 根节点最后出现。

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

*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*
