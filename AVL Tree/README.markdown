# AVL树(AVL Tree)

AVL树是[二叉搜索树](../Binary%20Search%20Tree/)的自平衡形式，其中子树的高度最多只相差1。

当二叉树的左右子树包含大致相同数量的节点时，称树是 *平衡的*。 这就是使树搜索速度非常快的原因。 但是如果二元搜索树不平衡，搜索会变得非常慢。

这是一个不平衡树的例子：

![Unbalanced tree](Images/Unbalanced.png)


所有的子节点都在左侧分支，没有一个在右侧分支。 这与[链表](../Linked%20List/)基本相同。 因此，搜索需要 **O(n)** 时间，而不是您期望从二叉搜索树获得的更快的 **O(log n)** 。

该树的平衡版本如下所示：

![Balanced tree](Images/Balanced.png)

使二进制搜索树平衡的一种方法是以完全随机的顺序插入节点。 但这并不能保证成功，也不总是切实可行。

另一种解决方案是使用*自平衡*二叉树。 插入或删除节点后，此类型的数据结构会调整树以使其保持平衡。 这种树的高度保证为 *log(n)*，其中 *n* 是节点的数量。 在平衡树上，所有插入，移除和搜索操作仅需 **O(logn)** 时间。 这意味着快速。;-)



## 介绍AVL树

AVL树通过向左或向右“旋转”树来修复任何不平衡。

如果AVL树中的节点在“高度”上的差异最大为1，则认为它是平衡的。如果树的所有节点都是平衡的，则树本身是平衡的。

节点的*height*是获取该节点最低叶子所需的步数。 例如，在下面的树中，从A到E需要三个步，因此A的高度为3。B的高度为2，C的高度为1，其他的高度为0，因为它们是叶节点。

![Node height](Images/Height.png)



如上所述，在AVL树中，如果节点的左右子树具有相同的高度，则节点是平衡的。 当然不必是完全相同的高度，但差异不能大于1。这些都是平衡树的例子：

![Balanced trees](Images/BalanceOK.png)

以下是不平衡的树，因为左子树的高度与右子树相比太大了：

![Unbalanced trees](Images/BalanceNotOK.png)

左右子树的高度之间的差异称为*平衡因子(balance factor)*。 计算方法如下：

	balance factor = abs(height(left subtree) - height(right subtree))

如果在插入或删除后平衡因子变得大于1，那么我们需要重新平衡AVL树的这一部分。 这是通过旋转完成的。

> **译注：** `abs`是绝对值的意思。



## 旋转

每个树节点在变量中跟踪其当前平衡因子。 插入新节点后，我们需要更新其父节点的平衡因子。 如果该平衡因子大于1，我们“旋转”该树的一部分以恢复平衡。

![Rotation0](Images/RotationStep0.jpg)



对于旋转，我们使用术语：
* *Root* - 将要旋转的子树的父节点;
* *Pivot* - 旋转后将成为父节点（基本上位于* Root *位置）的节点;
* *RotationSubtree* - 旋转侧的*Pivot*的子树
* *OppositeSubtree* - 与旋转侧相对的*Pivot*的子树



让我们举一个使用*右*（顺时针方向）旋转来平衡不平衡树的示例：

![Rotation1](Images/RotationStep1.jpg) ![Rotation2](Images/RotationStep2.jpg) ![Rotation3](Images/RotationStep3.jpg)



旋转步骤可以通过以下方式描述：

1. 将*RotationSubtree*指定为*Root*的新*OppositeSubtree*;
2. 将*Root*指定为*Pivot*的新*RotationSubtree*;
3. 检查最终结果

用伪代码，上面的算法可以写成如下：

```
Root.OS = Pivot.RS
Pivot.RS = Root
Root = Pivot
```


这是一个恒定时间操作 - __O(1)__ 插入永远不需要超过2次旋转。 删除可能需要最多 __log(n)__ 轮换。



## 代码


[AVLTree.swift](AVLTree.swift)中的大多数代码只是常规[二叉搜索树](../Binary%20Search%20Tree/)的东西。 您可以在二叉搜索树找到大部分实现。 例如，搜索树是完全相同的。 AVL树唯一不同的是插入和删除节点。

> **注意：** 如果你对二叉搜索树的常规操作有点模糊，我建议你[看这边](../Binary%20Search%20Tree/)。 这会使AVL树更容易理解。

有趣的位在`balance()`方法中，在插入或删除节点后调用。



## 扩展阅读

[AVL树的维基百科](https://en.wikipedia.org/wiki/AVL_tree)

AVL树是第一个自平衡二叉树。 最近，[红黑树](../Red-Black%20Tree/)似乎更受欢迎。



*作者：Mike Taghavi， Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  