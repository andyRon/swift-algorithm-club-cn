# 线索二叉树（Threaded Binary Tree）

A threaded binary tree is a special kind of [binary tree](../Binary%20Tree/) (a
tree in which each node has at most two children) that maintains a few extra
variables to allow cheap and fast **in-order traversal** of the tree.  We will
explore the general structure of threaded binary trees, as well as
[the Swift implementation](ThreadedBinaryTree.swift) of a fully functioning
threaded binary tree.

线索二叉树是一种特殊的[二叉树](../Binary%20Tree/)(每个节点最多有两个子节点的树)，其中保留了一些额外的节点变量允许廉价和快速地**按中序遍历**树。 我们会探索线索二叉树的一般结构，以及[Swift实现](ThreadedBinaryTree.swift)功能齐全线程二叉树。

If you don't know what a tree is or what it is for, then
[read this first](../Tree/).

如果您不知道树是什么或它是什么，那么[先读这个](../Tree/)。


## In-order traversal
## 中序遍历

The main motivation behind using a threaded binary tree over a simpler and
smaller standard binary tree is to increase the speed of an in-order traversal
of the tree.  An in-order traversal of a binary tree visits the nodes in the
order in which they are stored, which matches the underlying ordering of a
[binary search tree](../Binary%20Search%20Tree/).  This means most threaded binary
trees are also binary search trees.  The idea is to visit all the left children
of a node first, then visit the node itself, and then visit the right children
last.

使用线索二叉树而不是更简单、更小的标准二叉树的主要动机是为了提高中序遍历的速度。 二叉树的中序遍历访问了节点中的存储顺序，与[二叉搜索树](../Binary%20Search%20Tree/)基本顺序相匹配。这意味着大多数线程二叉树也是二叉搜索树。这个想法是首先访问所有左子节，然后访问节点本身，最后访问右子节点。

An in-order traversal of any binary tree generally goes as follows (using Swift
syntax):
任何二叉树的中序遍历通常如下（使用Swift语法）：

```swift
func traverse(n: Node?) {
  if (n == nil) { return
  } else {
    traverse(n.left)
    visit(n)
    traverse(n.right)
  }
}
```
Where `n` is a a node in the tree (or `nil`), each node stores its children as
`left` and `right`, and "visiting" a node can mean performing any desired
action on it.  We would call this function by passing to it the root of the
tree we wish to traverse.

其中`n`是树中的节点（或`nil`），每个节点将其子节点存储为`left`和`right`，以及“访问”一个节点可以意味着对这个节点任意操作。 我们通过传递给它树的根节点，来调用这个函数遍历树。

While simple and understandable, this algorithm uses stack space proportional
to the height of the tree due to its recursive nature.  If the tree has **n**
nodes, this usage can range anywhere from **O(log n)** for a fairly balanced
tree, to **O(n)** to a very unbalanced tree.

虽然简单易懂，但该算法使用堆栈空间比例由于其递归性质而达到树的高度。 如果树有**n**节点，这个用法的范围可以从**O(log n)**到相当平衡的范围树，**O(n)**到非常不平衡的树。

A threaded binary tree fixes this problem.
线索二叉树修复了这个问题。

> For more information about in-order traversals [see here](../Binary%20Tree/).
> 有关中序遍历的更多信息[请参阅此处](../Binary%20Tree/)。


## Predecessors and successors
## 前驱和后继

An in-order traversal of a tree yields a linear ordering of the nodes.  Thus
each node has both a **predecessor** and a **successor** (except for the first
and last nodes, which only have a successor or a predecessor respectively).  In
a threaded binary tree, each left child that would normally be `nil` instead
stores the node's predecessor (if it exists), and each right child that would
normally be `nil` instead stores the node's successor (if it exists).  This is
what separates threaded binary trees from standard binary trees.

树的中序遍历产生节点的线性排序。从而每个节点都有**前驱**和**后继**（第一个和最后的节点除外，它们分别只有后继或前驱）。在一个线索二叉树中，每个左子节点通常都是`nil`存储节点的前驱（如果存在），以及每个右子节点通常是`nil`替代存储节点的后继（如果存在）。这让线索二叉树与标准二叉树区分开。

There are two types of threaded binary trees:  **single threaded** and **double
threaded**:
- A single threaded tree keeps track of **either** the in-order predecessor
  **or** successor (left **or** right).
- A double threaded tree keeps track of **both** the in-order predecessor
  **and** successor (left **and** right).

有两种类型的线索二叉树：**单线索**和**双线索**：
- 单线索树**不是**追踪中序前驱，**就是**追踪后继（左**或**右）。
- 双线索树**既**追踪中序前驱，**又**追踪后继（左**和**右）。 

Using a single or double threaded tree depends on what we want to accomplish.
If we only need to traverse the tree in one direction (either forward or
backward), then we use a single threaded tree.  If we want to traverse in both
directions, then we use a double threaded tree.

使用单线索或双线索树取决于我们想要完成的任务。如果我们只需要在一个方向上遍历树（向前或向后），那么我们使用单线程树。 如果我们想要在前后都要遍历，然后我们使用双线索树。

It is important to note that each node stores either its predecessor or its
left child, and either its successor or its right child.  The nodes do not
need to keep track of both.  For example, in a double threaded tree, if a node
has a right child but no left child, it will track its predecessor in place of
its left child.

重要的是要注意每个节点存储其前驱或其前左子节点，和后继或其有子节点。节点没有需要跟踪两者。例如，在双线索树中，如果是节点有一个左子节点，而没有右子节点，它将追踪其前驱替代它的左子节点。

Here is an example valid "full" threaded binary tree:
这是一个有效的“完整”线索二叉树示例：

![Full](Images/Full.png)

While the following threaded binary tree is not "full," it is still valid.  The
structure of the tree does not matter as long as it follows the definition of a
binary search tree:

虽然以下线索二叉树不是“完整”，但它仍然有效。该树的结构无关紧要，只要它遵循二叉搜索树的定义：

![Partial](Images/Partial.png)

The solid lines denote the links between parents and children, while the dotted
lines denote the "threads."  It is important to note how the children and
thread edges interact with each other.  Every node besides the root has one
entering edge (from its parent), and two leaving edges: one to the left and one
to the right.  The left leaving edge goes to the node's left child if it
exists, and to its in-order predecessor if it does not.  The right leaving edge
goes to the node's right child if it exists, and to its in-order successor if
it does not.  The exceptions are the left-most node and the right-most node,
which do not have a predecessor or successor, respectively.

实线表示父节点和自己诶单之间的联系，而虚线表示表示“线索”。重要的是要注意子节点和子节点线索边缘相互作用。除根节点之外的每个节点都有一个进入边缘（从其父节点）和两个离开边缘：一个在左边，一个在右边。左边缘到达节点的左子节点，如果不存在，则存在于其中序的前驱中。正确的离开边缘如果它存在，则转到节点的右子节点，如果存在则转到它的有序后继节点它不是。 最左边的节点和最右边的节点是例外，它们分别没有前驱或后继。


## Representation
## 表示

Before we go into detail about the methods of a threaded binary tree, we should
first explain how the tree itself is represented.  The core of this data
structure is the `ThreadedBinaryTree<T: Comparable>` class.  Each instance of
this class represents a node with six member variables:  `value`, `parent`,
`left`, `right`, `leftThread`, and `rightThread`.  Of all of these, only
`value` is required.  The other five are Swift *optionals* (they may be `nil`).
- `value: T` is the value of this node (e.g. 1, 2, A, B, etc.)
- `parent: ThreadedBinaryTree?` is the parent of this node
- `left: ThreadedBinaryTree?` is the left child of this node
- `right: ThreadedBinaryTree?` is the right child of this node
- `leftThread: ThreadedBinaryTree?` is the in-order predecessor of this node
- `rightThread: ThreadedBinaryTree?` is the in-order successor of this node

在我们详细介绍线索二叉树的方法之前，我们应该这样做首先解释树本身是如何表示的。 这个数据的核心结构是`ThreadedBinaryTree <T：Comparable>`类。 这个类的每个实例有节点的六个成员变量：`value`，`parent`，`left`，`right`，`leftThread`和`rightThread`。 其中仅`value`是必需的。 其他五个是Swift *optionals*（它们可能是`nil`）。
- `value: T`是该节点的值（例如1,2，A，B等）
- `parent: ThreadedBinaryTree?` 是这个节点的父节点
- `left: ThreadedBinaryTree?` 是这个节点的左子节点
- `right: ThreadedBinaryTree?` 是这个节点的右子节点
- `leftThread: ThreadedBinaryTree?` 是这个节点的中序前驱
- `rightThread: ThreadedBinaryTree?` 是这个节点的中序前驱

As we are storing both `leftThread` and `rightThread`, this is a double
threaded tree. Now we are ready to go over some of the member functions in our
`ThreadedBinaryTree` class.

因为我们存储了`leftThread`和`rightThread`，所以这是双线索树。 现在我们准备好了解一下我们的一些成员函数`ThreadedBinaryTree`类。

## Traversal algorithm
## 遍历算法

Let's start with the main reason we're using a threaded binary tree.  It is now
very easy to find the in-order predecessor and the in-order successor of any
node in the tree.  If the node has no `left`/`right` child, we can simply
return the node's `leftThread`/`rightThread`.  Otherwise, it is trivial to move
down the tree and find the correct node.

让我们从使用线索二叉树的主要原因开始。就是现在很容易在树种找到中序前驱和任何节点中序后继。如果节点没有`left`/`right`子节点，我们可以简单地说返回节点的`leftThread`/`rightThread`。 否则，向下移动树和寻找正确节点是微不足道的。

```swift
  func predecessor() -> ThreadedBinaryTree<T>? {
    if let left = left {
      return left.maximum()
    } else {
      return leftThread
    }
  }

  func successor() -> ThreadedBinaryTree<T>? {
    if let right = right {
      return right.minimum()
    } else {
      return rightThread
    }
  }
```
> Note: `maximum()` and `minimum()` are methods of `ThreadedBinaryTree` which
return the largest/smallest node in a given sub-tree.  See
[the implementation](ThreadedBinaryTree.swift) for more detail.

> 注意：`maximum()`和`minimum()`是`ThreadedBinaryTree`的方法，返回给定子树中的最大/最小节点。 到[实现](ThreadedBinaryTree.swift)了解更多细节。

Because these are `ThreadedBinaryTree` methods, we can call
`node.predecessor()` or `node.successor()` to obtain the predecessor or
successor of any `node`, provided that `node` is a `ThreadedBinaryTree` object.

因为这些是`ThreadedBinaryTree`的方法，我们可以调用`node.predecessor()`或`node.successor()`来获取任何`node`的前驱和后继，只要`node`是`ThreadedBinaryTree`对象。

Because predecessors and/or successors are tracked, an in-order traversal of a
threaded binary tree is much more efficient than the recursive algorithm
outlined above.  We use these predecessor/successor attributes to great effect
in this new algorithm for both forward and backward traversals:

因为前驱和/或后继被追踪，所以如上概述，中序遍历线索二叉树比递归算法更有效概述如上。 在这个用向前和向后遍历的新算法中，我们使用这些前驱/后继的属性产生了很大的效果：

```swift
    public func traverseInOrderForward(_ visit: (T) -> Void) {
        var n: ThreadedBinaryTree
        n = minimum()
        while true {
            visit(n.value)
            if let successor = n.successor() {
                n = successor
            } else {
                break
            }
        }
    }

    public func traverseInOrderBackward(_ visit: (T) -> Void) {
        var n: ThreadedBinaryTree
        n = maximum()
        while true {
            visit(n.value)
            if let predecessor = n.predecessor() {
                n = predecessor
            } else {
                break
            }
        }
    }
```
Again, this a method of `ThreadedBinaryTree`, so we'd call it via
`node.traverseInorderForward(visitFunction)`.  Note that we are able to specify
a function that executes on each node as they are visited.  This function can
be anything you want, as long as it accepts `T` (the type of the values of the
nodes of the tree) and has no return value.

再一次，这是一个`ThreadedBinaryTree`的方法，所以我们通过它来调用它`node.traverseInorderForward(visitFunction)`。 请注意，我们可以指定在访问每个节点时执行的函数。 这个功能可以是你想要的任何东西，只要它接受`T`（树节点值的类型）并且没有返回值。

Let's walk through a forward traversal of a tree by hand to get a better idea
of how a computer would do it.  For example, take this simple threaded tree:

让我们手动通过树的向前遍历来获得更好的想法，看看计算机将如何做到这一点。 例如，采用这个简单的线索树：

![Base](Images/Base.png)

We start at the root of the tree, **9**.  Note that we don't `visit(9)` yet.
From there we want to go to the `minimum()` node in the tree, which is **2** in
this case.  We then `visit(2)` and see that it has a `rightThread`, and thus
we immediately know what its `successor()` is.  We follow the thread to **5**,
which does not have any leaving threads.  Therefore, after we `visit(5)`, we go
to the `minimum()` node in its `right` subtree, which is **7**.  We then
`visit(7)` and see that it has a `rightThread`, which we follow to get back to
**9**.  *Now* we `visit(9)`, and after noticing that it has no `rightThread`,
we go to the `minimum()` node in its `right` subtree, which is **12**.  This
node has a `rightThread` that leads to `nil`, which signals that we have
completed the traversal!  We visited the nodes in order **2, 5, 7, 9, 12**,
which intuitively makes sense, as that is their natural increasing order.

我们从树的根节点开始，**9**。 请注意，我们还没有`visit(9)`。我们想要进入树中的`minimum()`节点，在这个案例即**2**
。然后我们`visit(2)`并看到它有一个`rightThread`，因此我们立即知道它的`successor()`是什么。 我们按照线索**5**，没有任何离开的线程。 因此，在我们`visit(5)`之后，我们去了到`right`子树中的`minimum()`节点，即 **7**。 然后我们`visit(7)`并看到它有一个`rightThread`，我们按照它来回到**9**。 *现在*我们`visit(9)`，并注意到它没有`rightThread`，我们转到`right`子树中的`minimum()`节点，即** 12**。 这个节点有一个`rightThread`，它会导致`nil`，它表示我们有完成了遍历！ 我们按顺序访问节点 **2,5,7,9,12**，直觉上有意义，因为这是他们自然增长的顺序。

A backward traversal would be very similar, but you would replace `right`,
`rightThread`, `minimum()`, and `successor()` with `left`, `leftThread`,
`maximum()`, and `predecessor()`.

向后遍历将非常相似，但你会替换`right`，`rightThread`，`minimum()`和`successor()`with`left`，`leftThread`，`maximum()`和`predecessor()`。


## Insertion and deletion
## 插入和删除

The quick in-order traversal that a threaded binary trees gives us comes at a
small cost.  Inserting/deleting nodes becomes more complicated, as we have to
continuously manage the `leftThread` and `rightThread` variables.  Rather than
walking through some boring code, it is best to explain this with an example
(although you can read through [the implementation](ThreadedBinaryTree.swift)
if you want to know the finer details).  Please note that this requires
knowledge of binary search trees, so make sure you have
[read this first](../Binary%20Search%20Tree/).

线程二叉树给我们的快速有序遍历来自于成本很低。 正如我们必须的那样，插入/删除节点变得更加复杂不断管理`leftThread`和`rightThread`变量。 而不是通过一些无聊的代码，最好用一个例子解释一下（虽然你可以阅读[实现](ThreadedBinaryTree.swift)如果你想知道更精细的细节）。 请注意，这需要二进制搜索树的知识，所以请确保你有[首先阅读](../Binary%20Search%20Tree/)。

> Note: we do allow duplicate nodes in this implementation of a threaded binary
> tree.  We break ties by defaulting insertion to the right.

> 注意：我们在这个线程二进制实现中允许重复节点
> 树。 我们通过默认插入右边来打破关系。

Let's start with the same tree that we used for the above traversal example:
让我们从我们用于上述遍历示例的相同树开始：

![Base](Images/Base.png)

Suppose we insert **10** into this tree.  The resulting graph would look like
this, with the changes highlighted in red:

假设我们在这棵树中插入**10**。 结果图看起来像这个，更改以红色突出显示：

![Insert1](Images/Insert1.png)

If you've done your homework and are familiar with binary search trees, the
placement of this node should not surprise you.  What's new is how we maintain
the threads between nodes.  So we know that we want to insert **10** as
**12**'s `left` child.  The first thing we do is set **12**'s `left` child to
**10**, and set **10**'s `parent` to **12**.  Because **10** is being inserted
on the `left`, and **10** has no children of its own, we can safely set
**10**'s `rightThread` to its `parent` **12**.  What about **10**'s
`leftThread`?  Because we know that **10** < **12**, and **10** is the only
`left` child of **12**, we can safely set **10**'s `leftThread` to **12**'s
(now outdated) `leftThread`.  Finally we set **12**'s `leftThread = nil`, as it
now has a `left` child.

如果你已完成家庭作业并熟悉二元搜索树，那么放置此节点不应该让您感到惊讶。 新的方法是我们如何维护节点之间的线程。 所以我们知道我们要插入**10**作为**12**的`left`孩子。 我们要做的第一件事是将**12**的`left`孩子设置为** 10 **，并将** 10 **的“父母”设置为**12**。 因为正在插入** 10 **在`left`，**10**没有自己的孩子，我们可以安全地设置**10**的`rightThread`到它的`parent` **12**。 怎么样**10**`leftThread`？ 因为我们知道**10** < **12**，而 **10**是唯一的`left`孩子的 **12**，我们可以安全地将 **10**的`leftThread`设置为 **12**（现在已经过时了）`leftThread`。 最后我们将**12**的`leftThread = nil`设置为现在有一个`left`的孩子。

Let's now insert another node, **4**, into the tree:
现在让我们在树中插入另一个节点**4**：

![Insert2](Images/Insert2.png)

While we are inserting **4** as a `right` child, it follows the exact same
process as above, but mirrored (swap `left` and `right`).  For the sake of
completeness, we'll insert one final node, **15**:
虽然我们将**4**作为“正确”的孩子插入，但它遵循完全相同的原则如上所述，但是镜像（交换`left`和`right`）。 为了完整性，我们将插入一个最终节点，**15**：

![Insert3](Images/Insert3.png)

Now that we have a fairly crowded tree, let's try removing some nodes.
Compared to insertion, deletion is a little more complicated.  Let's start with
something simple, like removing **7**, which has no children:

现在我们有一个相当拥挤的树，让我们尝试删除一些节点。与插入相比，删除更复杂一些。 让我们开始吧简单的东西，比如删除没有孩子的**7**：

![Remove1](Images/Remove1.png)

Before we can just throw **7** away, we have to perform some clean-up.  In this
case, because **7** is a `right` child and has no children itself, we can
simply set the `rightThread` of **7**'s `parent`(**5**) to **7**'s (now
outdated) `rightThread`. Then we can just set **7**'s `parent`, `left`,
`right`, `leftThread`, and `rightThread` to `nil`, effectively removing it from
the tree. We also set the parent's `rightChild` to `nil`, which completes the deletion of this right child.

在我们离开**7**之前，我们必须进行一些清理工作。 在这因为**7**是一个“正确”的孩子而且本身没有孩子，我们可以只需将**7**的 `parent`（**5**）的`rightThread`设置为**7**（现在过时的）`rightThread`。 然后我们可以设置**7**的`parent`，`left`，`right`，`leftThread`和`rightThread`到`nil`，有效地将其删除那个树。 我们还将父的`rightChild`设置为`nil`，这样就完成了删除这个正确的孩子。 

Let's try something a little harder.  Say we remove **5** from the tree:
让我们尝试一点点努力。 假设我们从树中删除**5**：

![Remove2](Images/Remove2.png)

This is a little trickier, as **5** has some children that we have to deal
with.  The core idea is to replace **5** with its first child, **2**.  To
accomplish this, we of course set **2**'s `parent` to **9** and set **9**'s
`left` child to **2**.  Note that **4**'s `rightThread` used to be **5**, but
we are removing **5**, so it needs to change.  It is now important to
understand two important properties of threaded binary trees:

这有点棘手，因为**5**有一些孩子，我们必须处理用。 核心思想是用第一个孩子 **2** 取代 **5**。 至实现这一点，我们当然将** 2 **的“父母”设置为**9**并设置 **9** `left`孩子到 **2**。 请注意，**4**的`rightThread`曾经是 **5**，但是我们正在删除**5**，所以它需要改变。 现在重要的是了解线程二叉树的两个重要属性：

1. For the rightmost node **m** in the `left` subtree of any node **n**,
**m**'s `rightThread` is **n**.
2. For the leftmost node **m** in the `right` subtree of any node **n**,
**m**'s `leftThread` is **n**.

1.对于任何节点**n**的`left`子树中最右边的节点**m**，**m**的`rightThread`是**n**。
2.对于任何节点**n**的`right`子树中最左边的节点**m**，**m**的`leftThread`是 **n**。

Note how these properties held true before the removal of **5**, as **4** was
the rightmost node in **5**'s `left` subtree.  In order to maintain this
property, we must set **4**'s `rightThread` to **9**, as **4** is now the
rightmost node in **9**'s `left` subtree.  To completely remove **5**, all we
now have to do is set **5**'s `parent`, `left`, `right`, `leftThread`, and
`rightThread` to `nil`.

注意在移除**5**之前这些属性是如何保持为真的，因为**4**是**5**的`left`子树中最右边的节点。 为了维持这一点属性，我们必须将**4**的`rightThread`设置为**9**，因为**4**现在是**9**的`left`子树中最右边的节点。 要彻底删除**5**，我们所有人现在要做的就是设置**5**的`parent`，`left`，`right`，`leftThread`，以及`rightThread`到`nil`。

How about we do something crazy?  What would happen if we tried to remove
**9**, the root node?  This is the resulting tree:

我们做些疯狂的事情怎么样？ 如果我们试图删除会发生什么**9**，根节点？ 这是结果树：

![Remove3](Images/Remove3.png)

Whenever we want to remove a node that has two children, we take a slightly
different approach than the above examples.  The basic idea is to replace the
node that we want to remove with the leftmost node in its `right`  subtree,
which we call the replacement node.

每当我们想要删除一个有两个孩子的节点时，我们会稍微采取一些措施
与上述例子不同的方法。 基本的想法是取代
我们想要在其“right”子树中用最左边的节点删除的节点，
我们称之为替换节点。

> Note: we could also replace the node with the rightmost node in its `left`
> subtree.  Choosing left or right is mostly an arbitrary decision.

>注意：我们也可以用“left”中最右边的节点替换节点
>子树。 选择左或右主要是一个随意的决定。

Once we find the replacement node, **10** in this case, we remove it from the
tree using the algorithms outlined above.  This ensures that the edges in the
`right` subtree remain correct.  From there it is easy to replace **9** with
**10**, as we just have to update the edges leaving **10**.  Now all we have to
do is fiddle with the threads in order to maintain the two properties outlined
above.  In this case, **12**'s `leftThread` is now **10**. Node **9** is no
longer needed, so we can finish the removal process by setting all of its
variables to `nil`.

一旦我们找到替换节点，在这种情况下 **10**，我们将其从中移除树使用上面概述的算法。 这确保了边缘`right`子树保持正确。 从那里很容易更换**9**和**10**，因为我们只需要更新边缘，留下**10**。 现在我们所有的一切为了保持概述的两个属性，do完成了线程以上。 在这种情况下，**12**的`leftThread`现在是 **10**。 节点 **9**是没有的需要更长时间，所以我们可以通过设置所有它来完成删除过程变量为`nil`。

In order to illustrate how to remove a node that has only a `right` child,
we'll remove one final node, **12** from the tree:

为了说明如何删除只有`right`子节点的节点，我们将从树中删除一个最终节点**12**：

![Remove4](Images/Remove4.png)

The process to remove **12** is identical to the process we used to remove
**5**, but mirrored.  **5** had a `left` child, while **12** has a `right`
child, but the core algorithm is the same.

删除**12**的过程与我们过去删除的过程相同**5**，但镜像。 **5**有一个`left`孩子，而**12**有`right`孩子，但核心算法是一样的。

And that's it!  This was just a quick overview of how insertion and deletion
work in threaded binary trees, but if you understood these examples, you should
be able to insert or remove any node from any tree you want.  More detail can
of course be found in
[the implementation](ThreadedBinaryTree.swift).

就是这样！ 这只是对插入和删除方式的快速概述在线程二叉树中工作，但如果您理解这些示例，则应该能够从您想要的任何树插入或删除任何节点。 更多细节可以
当然可以找到[实现](ThreadedBinaryTree.swift)。


## Miscellaneous methods
## 杂项方法

There are many other smaller operations that a threaded binary tree can do,
such as `searching()` for a node in the tree, finding the `depth()` or
`height()` of a node, etc.  You can check
[the implementation](ThreadedBinaryTree.swift) for the full technical details.
Many of these methods are inherent to binary search trees as well, so you can
find [further documentation here](../Binary%20Search%20Tree/).

线程二叉树可以执行许多其他较小的操作，例如`search()`表示树中的节点，找到`depth()`或`height()`你可以检查[实现](ThreadedBinaryTree.swift) 获取完整的技术细节。其中许多方法也是二叉搜索树所固有的，所以你可以找到[此处的进一步文档](../Binary%20Search%20Tree/)。

## See also
## 扩展阅读

[线索二叉树的维基百科](https://en.wikipedia.org/wiki/Threaded_binary_tree)

*Written for the Swift Algorithm Club by
[Jayson Tung](https://github.com/JFTung)*
*Migrated to Swift 3 by Jaap Wijnen*

*Images made using www.draw.io*

*作者：[Jayson Tung](https://github.com/JFTung)，Jaap Wijnen*   
*图片来自   www.draw.io *
*翻译：[Andy Ron](https://github.com/andyRon)*
