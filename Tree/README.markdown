# 树(Tree)

> 这个话题已经有个辅导[文章](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure)


树表示对象之间的层次关系。 这是一个树的结构：

![A tree](Images/Tree.png)

树由节点组成，这些节点彼此连接。

节点可以连接到他们的子节点，也可以连接到他们的父节点。 子节点是给定节点下的节点; 父节点是上面的节点。 节点始终只有一个父节点，但可以有多个子节点。

![A tree](Images/ParentChildren.png)

没有父节点的节点是 *root* 节点。 没有子节点的节点是 *leaf* 节点。

树中的指针不能形成循环。 这不是树：

![Not a tree](Images/Cycles.png)

这种结构称为[图](../Graph/)。 树实际上是一种非常简单的图形式。 （类似地，[链表](../Linked%20List/)是树的简单版本。想一想！）

本文讨论通用树。 通用树对每个节点可能有多少个子节点，或树中节点的顺序没有任何限制。

这是在Swift中的基本实现：

```swift
public class TreeNode<T> {
  public var value: T

  public weak var parent: TreeNode?
  public var children = [TreeNode<T>]()

  public init(value: T) {
    self.value = value
  }

  public func addChild(_ node: TreeNode<T>) {
    children.append(node)
    node.parent = self
  }
}
```

这描述了树中的单个节点。 它包含泛型类型`T`，对`parent`节点的引用，以及子节点数组。

添加`description`以便打印树：

```swift
extension TreeNode: CustomStringConvertible {
  public var description: String {
    var s = "\(value)"
    if !children.isEmpty {
      s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
    }
    return s
  }
}
```

在 playground 创建树：

```swift
let tree = TreeNode<String>(value: "beverages")

let hotNode = TreeNode<String>(value: "hot")
let coldNode = TreeNode<String>(value: "cold")

let teaNode = TreeNode<String>(value: "tea")
let coffeeNode = TreeNode<String>(value: "coffee")
let chocolateNode = TreeNode<String>(value: "cocoa")

let blackTeaNode = TreeNode<String>(value: "black")
let greenTeaNode = TreeNode<String>(value: "green")
let chaiTeaNode = TreeNode<String>(value: "chai")

let sodaNode = TreeNode<String>(value: "soda")
let milkNode = TreeNode<String>(value: "milk")

let gingerAleNode = TreeNode<String>(value: "ginger ale")
let bitterLemonNode = TreeNode<String>(value: "bitter lemon")

tree.addChild(hotNode)
tree.addChild(coldNode)

hotNode.addChild(teaNode)
hotNode.addChild(coffeeNode)
hotNode.addChild(chocolateNode)

coldNode.addChild(sodaNode)
coldNode.addChild(milkNode)

teaNode.addChild(blackTeaNode)
teaNode.addChild(greenTeaNode)
teaNode.addChild(chaiTeaNode)

sodaNode.addChild(gingerAleNode)
sodaNode.addChild(bitterLemonNode)
```

如果你打印出`tree`的值，你会得到：

	beverages {hot {tea {black, green, chai}, coffee, cocoa}, cold {soda {ginger ale, bitter lemon}, milk}}

这对应于以下结构：

![Example tree](Images/Example.png)

`beverages`节点是根节点，因为它没有父节点。 叶子节点是`黑色`，`绿色`，`柴`，`咖啡`，`可可`，`姜汁`，`苦柠檬`，`牛奶`，因为它们没有任何子节点。

对于任何节点，您可以查看`parent`属性， 并按照自己的方式返回到根：

```swift
teaNode.parent           // this is the "hot" node
teaNode.parent!.parent   // this is the root
```

在谈论树时，我们经常使用以下定义：

- **树的高度**。 这是根节点和最低叶子之间的连接数。 在我们的示例中，树的高度为3，因为从根到底部需要三次跳跃。

- **节点的深度。** 此节点与根节点之间的连接数。 例如，`tea` 的深度为2，因为需要两次跳跃才能到达根部。 （根本身的深度为0.）

构建树的方法有很多种。 例如，有时您根本不需要 `parent` 属性。 或者，您可能只需要为每个节点提供最多两个子节点 - 这样的树称为[二叉树](../Binary％20Tree/)。 一种非常常见的树类型是[二叉搜索树](../Binary％20Search％20Tree/)（或BST），它是二叉树的更严格版本，其中节点以特定方式排序以加速搜索。

我在这里展示的通用树非常适合描述分层数据，但它实际上取决于您的应用程序需要具备哪种额外功能。

下面是一个如何使用`TreeNode`类来确定树是否包含特定值的示例。 首先看一下节点自己的`value`属性，如果没有匹配，那么依次看看这个节点所有的子节点。 当然，这些子节点也是`TreeNode`，所以它们将递归地重复相同的过程：首先看看它们自己的`value`属性，然后看看它们的子节点。 它们的子节点也会再次做同样的事情，等等...递归和树齐头并进。

这是代码：

```swift
extension TreeNode where T: Equatable {
  func search(_ value: T) -> TreeNode? {
    if value == self.value {
      return self
    }
    for child in children {
      if let found = child.search(value) {
        return found
      }
    }
    return nil
  }
}
```

如何使用它的示例：

```swift
tree.search("cocoa")    // returns the "cocoa" node
tree.search("chai")     // returns the "chai" node
tree.search("bubbly")   // nil
```

也可以使用数组来描述树。 数组中的索引表示不同的节点，然后，创建不同节点之间的连接。 例如，如果我们有：

```
0 = beverage    5 = cocoa   9  = green
1 = hot         6 = soda    10 = chai
2 = cold        7 = milk    11 = ginger ale
3 = tea         8 = black   12 = bitter lemon
4 = coffee        			
```
那么我们可以使用以下数组描述树：

	[ -1, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 6, 6 ]

数组中的每个项的值都是指向其父节点的指针。索引3处的项`tea`，其值为1，因为其父项为`hot`。根节点指向`-1`，因为它没有父节点。您只能将这些树从一个节点遍历到根节点，而不是相反。

顺便说一句，有时您会看到使用术语 *forest* 的算法。 显而易见，这是给予单独树对象集合的名称。 有关此示例，请参阅 [union-find](../Union-Find/)。


*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
