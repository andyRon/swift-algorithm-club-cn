# 伸展树/分裂树（Splay Tree）

Splay tree is a data structure, structurally identitical to a balanced binary search tree. Every operation performed on a Splay Tree causes a readjustment in order to provide fast access to recently operated values. On every access, the tree is rearranged and the node accessed is moved to the root of the tree using a set of specific rotations, which together are referred to as **Splaying**.
伸展树是一种数据结构，在结构上与平衡二叉搜索树相同。 在伸展树上执行的每个操作都会导致重新调整，以便快速访问最近运行的值。 在每次访问时，树被重新排列，并且使用一组特定的旋转将访问的节点移动到树的根，这些旋转一起被称为**Splaying**。


## Rotations
## 旋转

There are 3 types of rotations that can form an **Splaying**:
有3种类型的旋转可以形成**Splaying**：

- ZigZig
- ZigZag
- Zig

### Zig-Zig

Given a node *a* if *a* is not the root, and *a* has a child *b*, and both *a* and *b* are left children or right children, a **Zig-Zig** is performed.
给定节点*a*，如果*a*不是根节点，*a*具有子节点*b*，并且*a*和*b*都是左子节点或右子节点，则按 **Zig-Zig** 执行。

### Case both nodes right children
### 案例两个节点都是右节点

![ZigZigCase1](Images/zigzig1.png)

### Case both nodes left children
### 案例两个节点都是左节点


![ZigZigCase2](Images/zigzig2.png)

**IMPORTANT** is to note that a *ZigZig* performs first the rotation of the middle node with its parent (call it the grandparent) and later the rotation of the remaining node (grandchild). Doing that helps to keep the trees balanced even if it was first created by inserted a sequence of increasing values (see below worst case scenario followed by an explanation about why ZigZig rotates first to the grandparent).
**重要**的是要注意 *ZigZig* 首先执行中间节点与其父节点的旋转（称之为祖父节点），然后执行剩余节点（孙子节点）的旋转。 这样做有助于保持树平衡，即使它是通过插入一系列递增值来首次创建的（参见下面的最坏情况场景，然后解释为什么ZigZig首先旋转到祖父母）。

### Zig-Zag

Given a node *a* if *a* is not the root, and *a* has a child *b*, and *b* is the left child of *a* being the right child (or the opposite), a **Zig-Zag** is performed.
给定节点*a*，如果*a*不是根节点，并且*a*具有子节点*b*，并且*b*是*a*的左子节点，*a*本身是右子节点（相反的节点），则执行 **Zig-Zag**。

### Case right - left
### 案例 右-左

![ZigZagCase1](Images/zigzag1.png)

> **译注：** 上图中9是*a*，7是*b*

### Case left - right
### 案例 左-右

![ZigZagCase2](Images/zigzag2.png)

**IMPORTANT** A *ZigZag* performs first the rotation of the grandchild node and later the same node with its new parent again. 
**重要**的是*ZigZag*首先执行孙子节点的旋转，然后再次执行与其新父节点相同的节点。

### Zig

A **Zig** is performed when the node *a* to be rotated has the root as parent.
当要旋转的节点*a*父节点是根节点时，执行**Zig**。

![ZigCase](Images/zig.png)


## 伸展

Splaying consists in making so many rotations as needed until the node affected by the operation is at the top and becomes the root of the tree.
伸展 包括根据需要进行如此多的旋转，直到受操作影响的节点位于顶部并成为树的根节点。

```
while (node.parent != nil) {
    operation(forNode: node).apply(onNode: node)
}
```

Where operation returns the required rotation to be applied. 
操作返回要应用的所需旋转。

```
public static func operation<T>(forNode node: Node<T>) -> SplayOperation {
    
    if let parent = node.parent, let _ = parent.parent {
        if (node.isLeftChild && parent.isRightChild) || (node.isRightChild && parent.isLeftChild) {
            return .zigZag
        }
        return .zigZig
    }
    return .zig
}
```

During the applying phase, the algorithms determines which nodes are involved depending on the rotation to be applied and proceeding to re-arrange the node with its parent.
在应用阶段，算法根据要应用的旋转确定涉及哪些节点，并继续用其父节点重新排列节点。

```
public func apply<T>(onNode node: Node<T>) {
    switch self {
    case .zigZag:
        assert(node.parent != nil && node.parent!.parent != nil, "Should be at least 2 nodes up in the tree")
        rotate(child: node, parent: node.parent!)
        rotate(child: node, parent: node.parent!)

    case .zigZig:
        assert(node.parent != nil && node.parent!.parent != nil, "Should be at least 2 nodes up in the tree")
        rotate(child: node.parent!, parent: node.parent!.parent!)
        rotate(child: node, parent: node.parent!)
    
    case .zig:
        assert(node.parent != nil && node.parent!.parent == nil, "There should be a parent which is the root")
        rotate(child: node, parent: node.parent!)
    }
}
```


## Operations on an Splay Tree
## 伸展树上的操作

### Insertion 
### 插入

To insert a value:

- Insert it as in a binary search tree
- Splay the value to the root

要插入值：

- 将其插入二叉搜索树中
- 将值显示到根目录

### Deletion 
### 删除

To delete a value: 

- Delete it as in a binary search tree 
- Splay the parent of the removed node to the root 

删除值：

- 在二叉搜索树中删除
- 将已删除节点的父节点放到根节点

### Search 
### 搜索

To search a value: 

- Search for it as in a binary search tree 
- Splay the node containing the value to the root 
- If not found splay the node that would had been the parent of the searched value 

要搜索值：

- 在二叉搜索树中搜索它
- 将包含值的节点放到根目录
- 如果未找到，则展开将成为搜索值的父节点的节点

### Minimum and maximum 
### 最小和最大

- Search the tree for the required value 
- Splay the node to the root 

- 在树中搜索所需的值
- 将节点放到根节点

## Examples 
## 例子

### Example 1
### 例子 1

Lets suppose a *find(20)* operation was performed and now the values **20** needs to be splayed to the root. 
The sequence of steps will be the following: 
让我们假设执行*find(20)*操作，现在需要将值**20**显示到根节点。
步骤顺序如下：


1. Since we are in a *ZigZig* case, we need to rotate **9** to **4**
1. 当我们使用*ZigZig*时，我们需要旋转**9**到**4**。

![ZiggEx1](Images/examplezigzig1.png)

2. We got the following tree after the first rotation: 
2. 第一次旋转后，我们得到下面树：

![ZiggEx2](Images/examplezigzig2.png)

3. And finally the **20** is rotated to the **9**
3. 最后把**20**旋转到**9**

![ZiggEx3](Images/examplezigzig3.png)


### Example 2
### 例子 2

Now suppose a *insert(7)* operation was performed and we're in a *ZigZag* case.
现在假设执行了*insert(7)*操作，我们处于*ZigZag*情况。


1. First **7** is rotated to **9**
1. 首先**7**旋转到**9**

![ZigggEx21](Images/example1-1.png)

2. And the result tree is: 
2. 结果为：

![ZigggEx22](Images/example1-2.png)

3. Finally **7** is rotated to **4**
3. 最后**7**旋转到**4**

![ZigggEx23](Images/example1-3.png)


## Advantages 
## 优点

Splay trees provide an efficient way to quickly access elements that are frequently requested. This characteristic makes then a good choice to implement, for example, caches or garbage collection algorithms, or in any other problem involving frequent access to a certain numbers of elements from a data set.
伸展树提供了一种快速访问经常请求的元素的有效方法。这个特性让下面实现有了一个很好的选择，例如高速缓存或垃圾收集算法，或涉及从数据集频繁访问特定数量的元素的任何其他问题。

## Disadvantages
## 缺点

Splay tree are not perfectly balanced always, so in case of accessing all the elements in the tree in an increasing order, the height of the tree becomes *n*.
伸展树总是不完美平衡，因此在以递增顺序访问树中的所有元素的情况下，树的高度变为*n*。

## 时间复杂度

| Case          | Performance   |
| ------------- |:-------------:|
| 平均           | O(log n)      |
| 最差           | n             |

With *n* being the number of items in the tree.
*n*是树中的项数。

# An example of the Worst Case Performance 
# 最糟糕案例表现的一个例子

Suppose the a sequence of consecutive values are inserted in an Splay Tree. 
Let's take for example [1,2,3,4,5,6,7,8].
假设在伸展树中插入了一系列连续值。我们以[1,2,3,4,5,6,7,8]为例。

The tree construction will be like following: 
树的结构如下：


1. Insert the number **1**

2. Insert **2** 

1. 插入数字 **1**
2. 插入 **2**


![WorstCase1](Images/worst-case-1.png)


3. Splay **2** to the root 
3. 伸展 **2** 到根节点


![WorstCase2](Images/worst-case-2.png)


4. Insert **3** 
4. 插入 **3**


![WorstCase3](Images/worst-case-3.png)

5. Splay **3** to the root 
5. 伸展 **3** 到根节点


![WorstCase4](Images/worst-case-4.png)


6. Insert **4** 
6. 插入 **4**


![WorstCase5](Images/worst-case-5.png)


7. After inserting the rest of the values the tree will look like this: 
7. 插入其余值后，树将如下所示：


![WorstCase6](Images/worst-case-6.png)



If we keep insert number following the same sequence, that tree becomes inbalanced and have a height of **n** with **n** being the numbers of values inserted. 
After getting this tree, a *find(1)* operation for example will take **O(n)**
如果我们按照相同的顺序保持插入编号，则该树变得不平衡并且高度为**n**，**n**是插入的值的数量。
获取此树后，*find(1)*操作将采用**O(n)**

## ZigZig rotation order: first grandparent
## ZigZig旋转顺序：首先祖父节点

But thanks to the properties of the **Splay Tree** and the *ZigZig* rotations after the *find(1)* operation the tree becomes balanced again. This only happens if we respect the order of the *ZigZig* rotation, and the rotation to the grandparent happens first. 
但是由于**伸展树** 的属性和*find(1)*操作后的*ZigZig*旋转，树再次变得平衡。只有当我们考虑*ZigZig*旋转的顺序，并且首先发生对祖父节点的旋转时，才会发生这种情况。

The sequence of *ZigZigs* rotations will look like follows: 
*ZigZigs* 旋转的顺序如下所示：

1. Rotate **2** to **3**

![ZigZig1](Images/example-zigzig-1.png)

2. Rotate **1** to **2** 

![ZigZig2](Images/example-zigzig-2.png)

3. Rotate **4** to **5**

![ZigZig3](Images/example-zigzig-3.png)

4. Rotate **1** to **4** 

![ZigZig4](Images/example-zigzig-4.png)

5. Finally after splaying **1** to the root the tree will look like this: 
5. 最后将**1**伸展到根节点之后，树将如下所示：

![ZigZig5](Images/example-zigzig-5.png)


Based on the example above, we can see why it's important to rotate first to the grandparent. We got a tree of height = 6, from an initial tree of height = 8. If the tree would had been taller, we would have achieved almost half of the initial height after the splaying operation.
基于上面的例子，我们可以看出为什么首先旋转祖父节点是很重要的。 我们从一棵 height = 8 的初始树得到一棵 height = 6 的树。如果树高了，我们通过伸展操作后，可以几乎得到初始高度一半的树。

## ZigZig wrong rotation order 
## ZigZig错误的旋转顺序

If the rotations would had been taking first the parent and not the grandparent we would have finished with the following, yet unbalanced tree, just inverting the side of the elements.
如果旋转首先是父节点而不是祖父节点，我们将完成以下不平衡的树，只是反转原树元素。

![ZigZigWrong](Images/zigzig-wrongrotated.png)


## 扩展阅读

[伸展树的维基百科](https://en.wikipedia.org/wiki/Splay_tree)

加州大学伯克利分校的伸展树课程[CS 61B Lecture 34](https://www.youtube.com/watch?v=8Zs1lj_bUV0)



*作者：Martina Rodeker*   
*翻译：[Andy Ron](https://github.com/andyRon)* 
*校对：[Andy Ron](https://github.com/andyRon)* 


