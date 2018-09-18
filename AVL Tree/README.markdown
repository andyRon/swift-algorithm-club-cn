# AVL Tree
# AVL树

An AVL tree is a self-balancing form of a [binary search tree](../Binary%20Search%20Tree/), in which the height of subtrees differ at most by only 1.
AVL树是[二叉搜索树](../Binary％20Search％20Tree/)的自平衡形式，其中子树的高度最多只相差1。

A binary tree is *balanced* when its left and right subtrees contain roughly the same number of nodes. That is what makes searching the tree really fast. But if a binary search tree is unbalanced, searching can become really slow.
当二进制树的左右子树包含大致相同数量的节点时，它是*平衡的*。 这就是使树搜索速度非常快的原因。 但是如果二元搜索树不平衡，搜索会变得非常慢。

This is an example of an unbalanced tree:
这是一个不平衡树的例子：

![Unbalanced tree](Images/Unbalanced.png)

All the children are in the left branch and none are in the right. This is essentially the same as a [linked list](../Linked%20List/). As a result, searching takes **O(n)** time instead of the much faster **O(log n)** that you'd expect from a binary search tree.
所有的子节点都在左侧分支，没有一个在右侧。 这与[链表](../Linked％20List/)基本相同。 因此，搜索需要 **O(n)** 时间，而不是您期望从二叉搜索树获得的更快的 **O(log n)** 。

A balanced version of that tree would look like this:
该树的平衡版本如下所示：

![Balanced tree](Images/Balanced.png)

One way to make the binary search tree balanced is to insert the nodes in a totally random order. But that doesn't guarantee success, nor is it always practical.
使二进制搜索树平衡的一种方法是以完全随机的顺序插入节点。 但这并不能保证成功，也不总是切实可行。

The other solution is to use a *self-balancing* binary tree. This type of data structure adjusts the tree to keep it balanced after you insert or delete nodes. The height of such a tree is guaranteed to be *log(n)* where *n* is the number nodes. On a balanced tree all insert, remove, and search operations take only **O(log n)** time. That means fast. ;-)
另一种解决方案是使用*自平衡*二叉树。 插入或删除节点后，此类型的数据结构会调整树以使其保持平衡。 这种树的高度保证为 *log(n)*，其中 *n* 是节点的数量。 在平衡树上，所有插入，移除和搜索操作仅需 **O(logn)** 时间。 这意味着快速。;-)

## Introducing the AVL tree
## 介绍AVL树

An AVL tree fixes any imbalances by "rotating" the tree to the left or right.
AVL树通过向左或向右“旋转”树来修复任何不平衡。

A node in an AVL tree is considered balanced if its subtrees differ in "height" by at most 1. The tree itself is balanced if all its nodes are balanced.
如果AVL树中的节点在“高度”上的差异最大为1，则认为它是平衡的。如果树的所有节点都是平衡的，则树本身是平衡的。

The *height* of a node is how many steps it takes to get to that node's lowest leaf. For example, in the following tree it takes three steps to go from A to E, so the height of A is 3. The height of B is 2, the height of C is 1, and the height of the others is 0 because they are leaf nodes.
节点的*height*是获取该节点最低叶子所需的步数。 例如，在下面的树中，从A到E需要三个步骤，因此A的高度为3.B的高度为2，C的高度为1，其他的高度为0，因为它们 是叶节点。

![Node height](Images/Height.png)

As mentioned, in an AVL tree a node is balanced if its left and right subtree have the same height. It doesn't have to be the exact same height, but the difference may not be greater than 1. These are all examples of balanced trees:
如上所述，在AVL树中，如果节点的左右子树具有相同的高度，则节点是平衡的。 它不必是完全相同的高度，但差异可能不会大于1.这些都是平衡树的例子：

![Balanced trees](Images/BalanceOK.png)

But the following are trees that are unbalanced, because the height of the left subtree is too large compared to the right subtree:
但是以下是不平衡的树，因为左子树的高度与右子树相比太大了：

![Unbalanced trees](Images/BalanceNotOK.png)

The difference between the heights of the left and right subtrees is called the *balance factor*. It is calculated as follows:
左右子树的高度之间的差异称为*平衡因子*。 计算方法如下：

	balance factor = abs(height(left subtree) - height(right subtree))

If after an insertion or deletion the balance factor becomes greater than 1, then we need to re-balance this part of the AVL tree. And that is done with rotations.
如果在插入或删除后平衡因子变得大于1，那么我们需要重新平衡AVL树的这一部分。 这是通过轮换完成的。

## Rotations
## 轮换

Each tree node keeps track of its current balance factor in a variable. After inserting a new node, we need to update the balance factor of its parent node. If that balance factor becomes greater than 1, we "rotate" part of that tree to restore the balance.
每个树节点在变量中跟踪其当前平衡因子。 插入新节点后，我们需要更新其父节点的平衡因子。 如果该平衡因子大于1，我们“旋转”该树的一部分以恢复平衡。

![Rotation0](Images/RotationStep0.jpg)

For the rotation we're using the terminology:
* *Root* - the parent node of the subtrees that will be rotated;
* *Pivot* - the node that will become parent (basically will be on the *Root*'s position) after rotation;
* *RotationSubtree* - subtree of the *Pivot* upon the side of rotation
* *OppositeSubtree* - subtree of the *Pivot* opposite the side of rotation

对于轮换，我们使用术语：
* *Root* - 将要旋转的子树的父节点;
* *Pivot* - 旋转后将成为父节点（基本上位于* Root *位置）的节点;
* *RotationSubtree* - 旋转侧的*Pivot*的子树
* *OppositeSubtree* - 与旋转侧相对的*Pivot*的子树

Let take an example of balancing the unbalanced tree using *Right* (clockwise direction) rotation:
让我们举一个使用*Right*（顺时针方向）旋转来平衡不平衡树的示例：

![Rotation1](Images/RotationStep1.jpg) ![Rotation2](Images/RotationStep2.jpg) ![Rotation3](Images/RotationStep3.jpg)

The steps of rotation could be described by following:  

1. Assign the *RotationSubtree* as a new *OppositeSubtree* for the *Root*;
2. Assign the *Root* as a new *RotationSubtree* for the *Pivot*;
3. Check the final result

轮换步骤可以通过以下方式描述：

1.将*RotationSubtree*指定为*Root*的新*OppositeSubtree*;
2.将*Root*指定为*Pivot*的新*RotationSubtree*;
3.检查最终结果


In pseudocode the algorithm above could be written as follows:
在伪代码中，上面的算法可以写成如下：
```
Root.OS = Pivot.RS
Pivot.RS = Root
Root = Pivot
```

This is a constant time operation - __O(1)__ Insertion never needs more than 2 rotations. Removal might require up to __log(n)__ rotations.
这是一个恒定时间操作 - __O（1）__ 插入永远不需要超过2次旋转。 删除可能需要最多 __log（n）__ 轮换。


## The code
## 代码

Most of the code in [AVLTree.swift](AVLTree.swift) is just regular [binary search tree](../Binary%20Search%20Tree/) stuff. You'll find this in any implementation of a binary search tree. For example, searching the tree is exactly the same. The only things that an AVL tree does slightly differently are inserting and deleting the nodes.
[AVLTree.swift](AVLTree.swift)中的大多数代码只是常规[二叉搜索树](../Binary％20Search％20Tree/)的东西。 您可以在二叉搜索树的任何实现中找到它。 例如，搜索树是完全相同的。 AVL树唯一不同的是插入和删除节点。

> **Note:** If you're a bit fuzzy on the regular operations of a binary search tree, I suggest you [catch up on those first](../Binary%20Search%20Tree/). It will make the rest of the AVL tree easier to understand.
> **注意：** 如果你对二进制搜索树的常规操作有点模糊，我建议你[先赶上那些](../Binary％20Search％20Tree/)。 它将使AVL树的其余部分更容易理解。

The interesting bits are in the `balance()` method which is called after inserting or deleting a node.
有趣的位在`balance()`方法中，在插入或删除节点后调用。

## See also
## 扩展阅读

[AVL tree on Wikipedia](https://en.wikipedia.org/wiki/AVL_tree)

AVL tree was the first self-balancing binary tree. These days, the [red-black tree](../Red-Black%20Tree/) seems to be more popular.
AVL树是第一个自平衡二叉树。 这些天，[红黑树](../Red-Black％20Tree/)似乎更受欢迎。

*Written for Swift Algorithm Club by Mike Taghavi and Matthijs Hollemans*

*作者：Mike Taghavi， Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
