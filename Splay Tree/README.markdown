# 伸展树/分裂树（Splay Tree）

伸展树是一种数据结构，在结构上与平衡二叉搜索树相同。 在伸展树上执行的每个操作都会导致重新调整，以便快速访问最近运行的值。 在每次访问时，树被重新排列，并且使用一组特定的旋转将访问的节点移动到树的根，这些旋转一起被称为**Splaying**。


## 旋转

有3种类型的旋转可以形成**Splaying**：

- ZigZig
- ZigZag
- Zig

### Zig-Zig

给定节点*a*，如果*a*不是根节点，*a*具有子节点*b*，并且*a*和*b*都是左子节点或右子节点，则按 **Zig-Zig** 执行。

### 案例两个节点都是右节点

![ZigZigCase1](Images/zigzig1.png)

### 案例两个节点都是左节点


![ZigZigCase2](Images/zigzig2.png)

**重要**的是要注意 *ZigZig* 首先执行中间节点与其父节点的旋转（称之为祖父节点），然后执行剩余节点（孙子节点）的旋转。 这样做有助于保持树平衡，即使它是通过插入一系列递增值来首次创建的（参见下面的最坏情况场景，然后解释为什么ZigZig首先旋转到祖父母）。

### Zig-Zag

给定节点*a*，如果*a*不是根节点，并且*a*具有子节点*b*，并且*b*是*a*的左子节点，*a*本身是右子节点（相反的节点），则执行 **Zig-Zag**。

### 案例 右-左

![ZigZagCase1](Images/zigzag1.png)

> **译注：** 上图中9是*a*，7是*b*

### 案例 左-右

![ZigZagCase2](Images/zigzag2.png)

**重要**的是*ZigZag*首先执行孙子节点的旋转，然后再次执行与其新父节点相同的节点。

### Zig

当要旋转的节点*a*父节点是根节点时，执行**Zig**。

![ZigCase](Images/zig.png)


## 伸展

伸展 包括根据需要进行如此多的旋转，直到受操作影响的节点位于顶部并成为树的根节点。

```
while (node.parent != nil) {
    operation(forNode: node).apply(onNode: node)
}
```

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


## 伸展树上的操作

### 插入


要插入值：

- 将其插入二叉搜索树中
- 将值显示到根目录

### 删除



删除值：

- 在二叉搜索树中删除
- 将已删除节点的父节点放到根节点

### 搜索



要搜索值：

- 在二叉搜索树中搜索它
- 将包含值的节点放到根目录
- 如果未找到，则展开将成为搜索值的父节点的节点

### 最小和最大



- 在树中搜索所需的值
- 将节点放到根节点

## 例子

### 例子 1

The sequence of steps will be the following: 
让我们假设执行*find(20)*操作，现在需要将值**20**显示到根节点。
步骤顺序如下：


1. 当我们使用*ZigZig*时，我们需要旋转**9**到**4**。

![ZiggEx1](Images/examplezigzig1.png)

2. 第一次旋转后，我们得到下面树：

![ZiggEx2](Images/examplezigzig2.png)

3. 最后把**20**旋转到**9**

![ZiggEx3](Images/examplezigzig3.png)


### 例子 2

现在假设执行了*insert(7)*操作，我们处于*ZigZag*情况。


1. 首先**7**旋转到**9**

![ZigggEx21](Images/example1-1.png)

2. 结果为：

![ZigggEx22](Images/example1-2.png)

3. 最后**7**旋转到**4**

![ZigggEx23](Images/example1-3.png)


## 优点

伸展树提供了一种快速访问经常请求的元素的有效方法。这个特性让下面实现有了一个很好的选择，例如高速缓存或垃圾收集算法，或涉及从数据集频繁访问特定数量的元素的任何其他问题。

## 缺点

伸展树总是不完美平衡，因此在以递增顺序访问树中的所有元素的情况下，树的高度变为*n*。

## 时间复杂度

| Case          | Performance   |
| ------------- |:-------------:|
| 平均           | O(log n)      |
| 最差           | n             |

*n*是树中的项数。

# 最糟糕案例表现的一个例子

假设在伸展树中插入了一系列连续值。我们以[1,2,3,4,5,6,7,8]为例。

树的结构如下：


1. 插入数字 **1**
2. 插入 **2**


![WorstCase1](Images/worst-case-1.png)


3. 伸展 **2** 到根节点


![WorstCase2](Images/worst-case-2.png)


4. 插入 **3**


![WorstCase3](Images/worst-case-3.png)

5. 伸展 **3** 到根节点


![WorstCase4](Images/worst-case-4.png)


6. 插入 **4**


![WorstCase5](Images/worst-case-5.png)


7. 插入其余值后，树将如下所示：


![WorstCase6](Images/worst-case-6.png)



如果我们按照相同的顺序保持插入编号，则该树变得不平衡并且高度为**n**，**n**是插入的值的数量。
获取此树后，*find(1)*操作将采用**O(n)**

## ZigZig旋转顺序：首先祖父节点

但是由于**伸展树** 的属性和*find(1)*操作后的*ZigZig*旋转，树再次变得平衡。只有当我们考虑*ZigZig*旋转的顺序，并且首先发生对祖父节点的旋转时，才会发生这种情况。

*ZigZigs* 旋转的顺序如下所示：

1. Rotate **2** to **3**

![ZigZig1](Images/example-zigzig-1.png)

2. Rotate **1** to **2** 

![ZigZig2](Images/example-zigzig-2.png)

3. Rotate **4** to **5**

![ZigZig3](Images/example-zigzig-3.png)

4. Rotate **1** to **4** 

![ZigZig4](Images/example-zigzig-4.png)

5. 最后将**1**伸展到根节点之后，树将如下所示：

![ZigZig5](Images/example-zigzig-5.png)


基于上面的例子，我们可以看出为什么首先旋转祖父节点是很重要的。 我们从一棵 height = 8 的初始树得到一棵 height = 6 的树。如果树高了，我们通过伸展操作后，可以几乎得到初始高度一半的树。

## ZigZig错误的旋转顺序

如果旋转首先是父节点而不是祖父节点，我们将完成以下不平衡的树，只是反转原树元素。

![ZigZigWrong](Images/zigzig-wrongrotated.png)


## 扩展阅读

[伸展树的维基百科](https://en.wikipedia.org/wiki/Splay_tree)

加州大学伯克利分校的伸展树课程[CS 61B Lecture 34](https://www.youtube.com/watch?v=8Zs1lj_bUV0)



*作者：Martina Rodeker*   
*翻译：[Andy Ron](https://github.com/andyRon)* 
*校对：[Andy Ron](https://github.com/andyRon)* 


