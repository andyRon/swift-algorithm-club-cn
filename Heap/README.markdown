# 堆(Heap)

> 这个话题已经有个辅导[文章](https://www.raywenderlich.com/160631/swift-algorithm-club-heap-and-priority-queue-data-structure)

A heap is a [binary tree](../Binary%20Tree/) inside an array, so it does not use parent/child pointers. A heap is sorted based on the "heap property" that determines the order of the nodes in the tree.
堆是数组内的[二叉树](../Binary%20Tree/)，因此它不使用父/子指针。 堆基于“堆属性”进行排序，该属性确定树中节点的顺序。

Common uses for heap:
堆的一般用法

- To build [priority queues](../Priority%20Queue/).
- To support [heap sorts](../Heap%20Sort/).
- To compute the minimum (or maximum) element of a collection quickly.
- To impress your non-programmer friends.

- 构建[优先队列](../Priority%20Queue)。
- 支持[堆排序](../Heap%20Sort/)。
- 快速计算集合中最大（或最小）值。
- 给你的非程序员朋友留下深刻影响。

## The heap property
## 堆属性

There are two kinds of heaps: a *max-heap* and a *min-heap* which are different by the order in which they store the tree nodes.
有两种堆：*max-heap* 和 *min-heap*，它们与存储树节点的顺序不同。

In a max-heap, parent nodes have a greater value than each of their children. In a min-heap, every parent node has a smaller value than its child nodes. This is called the "heap property", and it is true for every single node in the tree.
在*max-heap*中，父节点的值大于其子节点。 在*min-heap*中，每个父节点的值都小于其子节点。 这称为“堆属性”，对于树中的每个节点都是如此。

An example:
一个例子：

![A max-heap](Images/Heap1.png)

This is a max-heap because every parent node is greater than its children. `(10)` is greater than `(7)` and `(2)`. `(7)` is greater than `(5)` and `(1)`.
这是一个*max-heap*，因为每个父节点都大于其子节点。 `(10)`大于`(7)`和`(2)`。 `(7)`大于`(5)`和`(1)`。

As a result of this heap property, a max-heap always stores its largest item at the root of the tree. For a min-heap, the root is always the smallest item in the tree. The heap property is useful because heaps are often used as a [priority queue](../Priority%20Queue/) to access the "most important" element quickly.
作为此堆属性的结果，*max-heap*始终将其最大项存储在树的根中。 对于*min-heap*，根始终是树中的最小项。 堆属性很有用，因为堆通常用作[优先级队列](../Priority%20Queue/)来快速访问“最重要的”元素。

> **Note:** The root of the heap has the maximum or minimum element, but the sort order of other elements are not predictable. For example, the maximum element is always at index 0 in a max-heap, but the minimum element isn’t necessarily the last one. -- the only guarantee you have is that it is one of the leaf nodes, but not which one.
> **注意：** 堆的根具有最大或最小元素，但其他元素的排序顺序是不可预测的。例如，最大元素始终位于*max-heap*中的索引0处，但最小元素不一定是最后一个元素。 —— 唯一的保证是它是叶子节点之一，但不是哪一个。

## How does a heap compare to regular trees?
## 堆如何与常规树进行比较？

A heap is not a replacement for a binary search tree, and there are similarities and differnces between them. Here are some main differences:
堆不是二叉搜索树的替代品，它们之间存在相似之处和不同之处。 以下是一些主要差异：


**Order of the nodes.** In a [binary search tree (BST)](../Binary%20Search%20Tree/), the left child must be smaller than its parent, and the right child must be greater. This is not true for a heap. In a max-heap both children must be smaller than the parent, while in a min-heap they both must be greater.
**节点的顺序。**在[二叉搜索树（BST）](../Binary%20Search%20Tree/)中，左子节点必须小于其父节点，右子节点必须更大。 堆不是这样。 在*max-heap*中，两个子节点必须小于父节点，而在*min-heap*中，子节点必须大于父节点。

**Memory.** Traditional trees take up more memory than just the data they store. You need to allocate additional storage for the node objects and pointers to the left/right child nodes. A heap only uses a plain array for storage and uses no pointers.
**内存。**传统的树比它们存储的数据占用更多的内存。 您需要为节点对象和指向左/右子节点的指针分配额外的存储空间。 堆只使用普通数组进行存储，不使用指针。

**Balancing.** A binary search tree must be "balanced" so that most operations have **O(log n)** performance. You can either insert and delete your data in a random order or use something like an [AVL tree](../AVL%20Tree/) or [red-black tree](../Red-Black%20Tree/), but with heaps we don't actually need the entire tree to be sorted. We just want the heap property to be fulfilled, so balancing isn't an issue. Because of the way the heap is structured, heaps can guarantee **O(log n)** performance.
**平衡。** 二叉搜索树（BST）必须“平衡”，以便大多数操作具有**O(log n)**性能。 您可以按随机顺序插入和删除数据，也可以使用[AVL树](../AVL%20Tree/)或[红黑树](../Red-Black%20Tree/)，但 我们实际上并不需要对整个树进行排序。 我们只是希望实现堆属性，因此平衡不是问题。 由于堆的结构方式，堆可以保证 **O(log n)** 的性能。

**Searching.** Whereas searching is fast in a binary tree, it is slow in a heap. Searching isn't a top priority in a heap since the purpose of a heap is to put the largest (or smallest) node at the front and to allow relatively fast inserts and deletes.
**搜索。** 虽然在二叉树中搜索速度很快，但它在堆中速度很慢。 搜索不是堆中的最高优先级，因为堆的目的是将最大（或最小）节点放在前面并允许相对快速的插入和删除。

## The tree inside an array
## 数组中的树

An array may seem like an odd way to implement a tree-like structure, but it is efficient in both time and space.
数组似乎是实现树状结构的奇怪方式，但它在时间和空间上都很有效。

This is how we are going to store the tree from the above example:
这就是我们如何从上面的例子中存储树：

	[ 10, 7, 2, 5, 1 ]

That's all there is to it! We don't need any more storage than just this simple array.
这里的所有都是它的！ 我们不需要比这个简单数组更多的存储空间。

So how do we know which nodes are the parents and which are the children if we are not allowed to use any pointers? Good question! There is a well-defined relationship between the array index of a tree node and the array indices of its parent and children.
那么，如果不允许使用任何指针，我们如何知道哪些节点是父节点，哪些节点是子节点？ 好问题！树节点的数组索引与其父节点和子节点的数组索引之间存在明确定义的关系。

If `i` is the index of a node, then the following formulas give the array indices of its parent and child nodes:
如果`i`是节点的索引，则以下公式给出其父节点和子节点的数组索引：

    parent(i) = floor((i - 1)/2)
    left(i)   = 2i + 1
    right(i)  = 2i + 2

Note that `right(i)` is simply `left(i) + 1`. The left and right nodes are always stored right next to each other.
注意`right(i)`只是`left(i)+ 1`。 左侧和右侧节点始终紧挨着存储。

Let's use these formulas on the example. Fill in the array index and we should get the positions of the parent and child nodes in the array:
我们在这个例子中使用这些公式。 填写数组索引，我们应该得到数组中父节点和子节点的位置：

| Node | Array index (`i`) | Parent index | Left child | Right child |
|------|-------------|--------------|------------|-------------|
| 10 | 0 | -1 | 1 | 2 |
| 7 | 1 | 0 | 3 | 4 |
| 2 | 2 | 0 | 5 | 6 |
| 5 | 3 | 1 | 7 | 8 |
| 1 | 4 | 1 | 9 | 10 |

| 节点 | 数组中的索引 | 父节点索引 | 左子节点索引 | 右子节点索引 |
|------|-------------|--------------|------------|-------------|
| 10 | 0 | -1 | 1 | 2 |
| 7 | 1 | 0 | 3 | 4 |
| 2 | 2 | 0 | 5 | 6 |
| 5 | 3 | 1 | 7 | 8 |
| 1 | 4 | 1 | 9 | 10 |

Verify for yourself that these array indices indeed correspond to the picture of the tree.
验证这些数组索引确实对应于树的图片。

> **Note:** The root node `(10)` does not have a parent because `-1` is not a valid array index. Likewise, nodes `(2)`, `(5)`, and `(1)` do not have children because those indices are greater than the array size, so we always have to make sure the indices we calculate are actually valid before we use them.
> **注意：** 根节点`(10)`没有父节点，因为`-1`不是有效的数组索引。 同样，节点`(2)`，`(5)`和`(1)`没有子节点，因为那些索引大于数组大小，所以用它们之前我们总是要确保我们计算的索引实际上是有效的。

Recall that in a max-heap, the parent's value is always greater than (or equal to) the values of its children. This means the following must be true for all array indices `i`:
回想一下，在*max-heap*中，父节点的值总是大于（或等于）其子节点的值。 这意味着对于所有数组索引`i`必须满足以下条件：

```swift
array[parent(i)] >= array[i]
```

Verify that this heap property holds for the array from the example heap.
验证此堆属性是否适用于示例堆中的数组。

As you can see, these equations allow us to find the parent or child index for any node without the need for pointers. It is complicated than just dereferencing a pointer, but that is the tradeoff: we save memory space but pay with extra computations. Fortunately, the computations are fast and only take **O(1)** time.
如您所见，这些等式允许我们在不需要指针的情况下找到任何节点的父索引或子索引。 它只是解除引用一个指针很复杂，但这是权衡：我们节省了内存空间，但需要额外的计算。 幸运的是，计算速度很快，只需要 **O(1)** 时间。

It is important to understand this relationship between array index and position in the tree. Here is a larger heap which has 15 nodes divided over four levels:
理解树中数组索引和位置之间的这种关系很重要。 这是一个更大的堆，有15个节点分为四个级别：

![Large heap](Images/LargeHeap.png)

The numbers in this picture are not the values of the nodes but the array indices that store the nodes! Here is the array indices correspond to the different levels of the tree:
此图片中的数字不是节点的值，而是存储节点的数组索引！ 这是数组索引对应树的不同级别：

![The heap array](Images/Array.png)

For the formulas to work, parent nodes must appear before child nodes in the array. You can see that in the above picture.
要使公式起作用，父节点必须出现在数组中的子节点之前。 你可以在上面的图片中看到。

Note that this scheme has limitations. You can do the following with a regular binary tree but not with a heap:
请注意，此方案有局限性。 您可以使用常规二叉树执行以下操作，但不能使用堆执行以下操作：

![Impossible with a heap](Images/RegularTree.png)

You can not start a new level unless the current lowest level is completely full, so heaps always have this kind of shape:
除非当前最低级别已满，否则无法启动新级别，因此堆总是具有这种形状：

![The shape of a heap](Images/HeapShape.png)

> **Note:** You *could* emulate a regular binary tree with a heap, but it would be a waste of space, and you would need to mark array indices as being empty.
> **注意：** 您*可以*使用堆模拟常规二叉树，但这会浪费空间，您需要将数组索引标记为空。

Pop quiz! Let's say we have the array:
突击测验！ 假设我们有数组：

	[ 10, 14, 25, 33, 81, 82, 99 ]

Is this a valid heap? The answer is yes! A sorted array from low-to-high is a valid min-heap. We can draw this heap as follows:
这是一个有效的堆吗？ 答案是肯定的！ 从低到高的排序数组是有效的*min-heap*。 我们可以按如下方式绘制这个堆：

![A sorted array is a valid heap](Images/SortedArray.png)

The heap property holds for each node because a parent is always smaller than its children. (Verify for yourself that an array sorted from high-to-low is always a valid max-heap.)
堆属性适用于每个节点，因为父节点始终小于其子节点。 （自己验证从高到低排序的数组始终是有效的*max-heap*。）

> **Note:** But not every min-heap is necessarily a sorted array! It only works one way. To turn a heap back into a sorted array, you need to use [heap sort](../Heap%20Sort/).
> **注意：**但并非每个*min-heap*都必须是一个排序数组！ 它只适用于一种方式。 要将堆重新转换为已排序的数组，需要使用[heap sort](../Heap%20Sort/)。

## More math!
## 更多数学！

In case you are curious, here are a few more formulas that describe certain properties of a heap. You do not need to know these by heart, but they come in handy sometimes. Feel free to skip this section!
如果你很好奇，这里有一些描述堆的某些属性的公式。 你不需要知道这些，但它们有时会派上用场。 随意跳过此部分！

The *height* of a tree is defined as the number of steps it takes to go from the root node to the lowest leaf node, or more formally: the height is the maximum number of edges between the nodes. A heap of height *h* has *h + 1* levels.
树的*height*定义为从根节点到最低叶节点所需的步数，或者更正式：*height*是节点之间的最大边数。 高度*h*的堆具有*h + 1*级别。

This heap has height 3, so it has 4 levels:
这个堆的*height*为3，所以它有4个级别：

![Large heap](Images/LargeHeap.png)

A heap with *n* nodes has height *h = floor(log2(n))*. This is because we always fill up the lowest level completely before we add a new level. The example has 15 nodes, so the height is `floor(log2(15)) = floor(3.91) = 3`.

If the lowest level is completely full, then that level contains *2^h* nodes. The rest of the tree above it contains *2^h - 1* nodes. Fill in the numbers from the example: the lowest level has 8 nodes, which indeed is `2^3 = 8`. The first three levels contain a total of 7 nodes, i.e. `2^3 - 1 = 8 - 1 = 7`.

具有*n*个节点的堆具有高度*h = floor(log2(n))*。 这是因为我们总是在添加新级别之前完全填满最低级别。 该示例有15个节点，因此高度为 `floor(log2(15)) = floor(3.91) = 3`。

如果最低级别已满，则该级别包含 *2^h* 个节点。 它上面的树的其余部分包含 *2^h - 1* 个节点。 填写示例中的数字：最低级别有8个节点，实际上是 `2^3 = 8` 。 前三个级别包含总共7个节点，即`2^3 - 1 = 8 - 1 = 7`。

The total number of nodes *n* in the entire heap is therefore *2^(h+1) - 1*. In the example, `2^4 - 1 = 16 - 1 = 15`.

There are at most *ceil(n/2^(h+1))* nodes of height *h* in an *n*-element heap.

The leaf nodes are always located at array indices *floor(n/2)* to *n-1*. We will make use of this fact to quickly build up the heap from an array. Verify this for the example if you don't believe it. ;-)

Just a few math facts to brighten your day.

因此，整个堆中的节点总数*n* 为 *2^(h+1) - 1*。 在示例中，`2^4 - 1 = 16 - 1 = 15`。

在 *n*-element堆中最多有 *ceil(n/2^(h+1))* 个高度*h*的节点。

叶节点总是位于数组索引 *floor(n/2)* 到 *n-1*。 我们将利用这一事实从数组中快速构建堆。 如果您不相信，请验证此示例。;-)

只是一些数学事实来照亮你的一天。


## What can you do with a heap?
## 你能用堆做什么？

There are two primitive operations necessary to make sure the heap is a valid max-heap or min-heap after you insert or remove an element:

- `shiftUp()`: If the element is greater (max-heap) or smaller (min-heap) than its parent, it needs to be swapped with the parent. This makes it move up the tree.

- `shiftDown()`. If the element is smaller (max-heap) or greater (min-heap) than its children, it needs to move down the tree. This operation is also called "heapify".

Shifting up or down is a recursive procedure that takes **O(log n)** time.

在插入或删除元素之后，有两个必要的基本操作来确保堆是有效的*max-heap*或*min-heap*：

- `shiftUp()`：如果元素比其父元素更大（*max-heap*）或更小（*min-heap*），则需要与父元素交换。 这使它向上移动树。

- `shiftDown()`。 如果元素比子元素小（max-heap）或更大（min-heap），则需要向下移动树。 此操作也称为“heapify”。

向上或向下移动是一个递归过程，需要**O(log n)**时间。

Here are other operations that are built on primitive operations:

- `insert(value)`: Adds the new element to the end of the heap and then uses `shiftUp()` to fix the heap.

- `remove()`: Removes and returns the maximum value (max-heap) or the minimum value (min-heap). To fill up the hole left by removing the element, the very last element is moved to the root position and then `shiftDown()` fixes up the heap. (This is sometimes called "extract min" or "extract max".)

- `removeAtIndex(index)`: Just like `remove()` with the exception that it allows you to remove any item from the heap, not just the root. This calls both `shiftDown()`, in case the new element is out-of-order with its children, and `shiftUp()`, in case the element is out-of-order with its parents.

- `replace(index, value)`: Assigns a smaller (min-heap) or larger (max-heap) value to a node. Because this invalidates the heap property, it uses `shiftUp()` to patch things up. (Also called "decrease key" and "increase key".)

All of the above take time **O(log n)** because shifting up or down is expensive. There are also a few operations that take more time:

- `search(value)`. Heaps are not built for efficient searches, but the `replace()` and `removeAtIndex()` operations require the array index of the node, so you need to find that index. Time: **O(n)**.

- `buildHeap(array)`: Converts an (unsorted) array into a heap by repeatedly calling `insert()`. If you are smart about this, it can be done in **O(n)** time.

- [Heap sort](../Heap%20Sort/). Since the heap is an array, we can use its unique properties to sort the array from low to high. Time: **O(n lg n).**

The heap also has a `peek()` function that returns the maximum (max-heap) or minimum (min-heap) element, without removing it from the heap. Time: **O(1)**.

以下是基于原始操作的其他操作：

- `insert(value)`：将新元素添加到堆的末尾，然后使用`shiftUp()`来修复堆。

- `remove()`：删除并返回最大值(max-heap）或最小值(min-heap）。要通过删除元素填充剩下的洞，最后一个元素移动到根位置，然后`shiftDown()`修复堆。 (有时称为“提取最小值”或“提取最大值”。）

- `removeAtIndex(index)`：就像`remove()`一样，除了它允许你从堆中删除任何项目，而不仅仅是root。如果新元素与其子元素无序，则调用`shiftDown()`;如果元素与其父元素无序，则调用`shiftUp()`。

- `replace(index，value)`：为节点分配一个较小(*min-heap*）或较大(*max-heap*）的值。因为这会使heap属性失效，所以它使用`shiftUp()`来补丁。 (也称为“减少键”和“增加键”。）

以上所有都需要时间**O(log n**因为向上或向下移动是昂贵的。还有一些操作需要更多时间：

- `搜索(值)`。堆不是为高效搜索而构建的，但`replace()`和`removeAtIndex()`操作需要节点的数组索引，因此您需要找到该索引。时间：**O(n)**。

- `buildHeap(array)`：通过重复调用`insert()`将(未排序的）数组转换为堆。如果您对此很聪明，可以在**O(n)**时间内完成。

- [堆排序](../Heap％20Sort/)。由于堆是一个数组，我们可以使用它的唯一属性将数组从低到高排序。时间：**O(n lg n)。**

堆还有一个`peek()`函数，它返回最大(*max-heap*）或最小(*min-heap*）元素，而不从堆中删除它。时间：**O(1)**。

> **Note:** By far the most common things you will do with a heap are inserting new values with `insert()` and removing the maximum or minimum value with `remove()`. Both take **O(log n)** time. The other operations exist to support more advanced usage, such as building a priority queue where the "importance" of items can change after they have been added to the queue.
> **注意：** 到目前为止，您将使用堆执行的最常见操作是使用`insert()`插入新值，并使用`remove()`删除最大值或最小值。 两者都需要**O(log n)**时间。 存在其他操作以支持更高级的使用，例如构建优先级队列，其中项目的“重要性”在添加到队列后可以改变。

## Inserting into the heap
## 插入堆中

Let's go through an example of insertion to see in details how this works. We will insert the value `16` into this heap:
我们来看一个插入示例，详细了解其工作原理。 我们将值`16`插入此堆：

![The heap before insertion](Images/Heap1.png)

The array for this heap is `[ 10, 7, 2, 5, 1 ]`.
这个堆的数组是`[10,7,2,5,1]`。

The first step when inserting a new item is to append it to the end of the array. The array becomes:
插入新项目的第一步是将其附加到数组的末尾。 该数组变为：

	[ 10, 7, 2, 5, 1, 16 ]

This corresponds to the following tree:
这对应于以下树：

![The heap before insertion](Images/Insert1.png)

The `(16)` was added to the first available space on the last row.
`(16)`被添加到最后一行的第一个可用空间。

Unfortunately, the heap property is no longer satisfied because `(2)` is above `(16)`, and we want higher numbers above lower numbers. (This is a max-heap.)
不幸的是，堆属性不再满足，因为`(2)`高于`(16)`，我们希望更高的数字高于低数字。 (这是*max-heap*。)

To restore the heap property, we swap `(16)` and `(2)`.
要恢复堆属性，我们交换`(16)`和`(2)`。

![The heap before insertion](Images/Insert2.png)

We are not done yet because `(10)` is also smaller than `(16)`. We keep swapping our inserted value with its parent, until the parent is larger or we reach the top of the tree. This is called **shift-up** or **sifting** and is done after every insertion. It makes a number that is too large or too small "float up" the tree.
我们还没有完成，因为`(10)`也小于`(16)`。 我们继续将其插入值与其父项交换，直到父项更大或我们到达树的顶部。 这称为**升档**或**筛选**，并在每次插入后完成。 它会使一个太大或太小的数字“浮起”树。

Finally, we get:
最后，我们得到：

![The heap before insertion](Images/Insert3.png)

And now every parent is greater than its children again.

The time required for shifting up is proportional to the height of the tree, so it takes **O(log n)** time. (The time it takes to append the node to the end of the array is only **O(1)**, so that does not slow it down.)

现在每个父母都比他们的孩子更重要了。

上移所需的时间与树的高度成正比，因此需要**O(log n)**时间。 （将节点附加到数组末尾所需的时间仅为**O(1)**，因此不会降低它的速度。）

## Removing the root
## 删除root

Let's remove `(10)` from this tree:
从树种移除`(10)`：

![The heap before removal](Images/Heap1.png)

What happens to the empty spot at the top?
顶部的空白点会发生什么？

![The root is gone](Images/Remove1.png)

When inserting, we put the new value at the end of the array. Here, we do the opposite: we take the last object we have, stick it up on top of the tree, and restore the heap property.
插入时，我们将新值放在数组的末尾。 在这里，我们做相反的事情：我们采用我们拥有的最后一个对象，将其粘贴在树的顶部，然后恢复堆属性。

![The last node goes to the root](Images/Remove2.png)

Let's look at how to **shift-down** `(1)`. To maintain the heap property for this max-heap, we want to the highest number of top. We have two candidates for swapping places with: `(7)` and `(2)`. We choose the highest number between these three nodes to be on top. That is `(7)`, so swapping `(1)` and `(7)` gives us the following tree.
让我们来看看如何**降档**`(1)`。 要维护此*max-heap*的堆属性，我们希望得到最高的top数。 我们有两个交换位置的候选者：`(7)`和`(2)`。 我们选择这三个节点之间的最高数字位于顶部。 那是`(7)`，所以交换`(1)`和`(7)`给我们下面的树。

![The last node goes to the root](Images/Remove3.png)

Keep shifting down until the node does not have any children or it is larger than both its children. For our heap, we only need one more swap to restore the heap property:
继续向下移动，直到节点没有任何孩子，或者它比两个孩子都大。 对于我们的堆，我们只需要一个交换来恢复堆属性：

![The last node goes to the root](Images/Remove4.png)

The time required for shifting all the way down is proportional to the height of the tree which takes **O(log n)** time.
完全向下移动所需的时间与树的高度成正比，这需要**O(log n)**时间。

> **Note:** `shiftUp()` and `shiftDown()` can only fix one out-of-place element at a time. If there are multiple elements in the wrong place, you need to call these functions once for each of those elements.
> **注意：** `shiftUp()`和`shiftDown()`一次只能修复一个异常元素。 如果错误的位置有多个元素，则需要为每个元素调用一次这些函数。

## Removing any node
## 删除任何节点

The vast majority of the time you will be removing the object at the root of the heap because that is what heaps are designed for.
绝大多数情况下，您将删除堆根部的对象，因为这是堆的设计目的。

However, it can be useful to remove an arbitrary element. This is a general version of `remove()` and may involve either `shiftDown()` or `shiftUp()`.
但是，删除任意元素可能很有用。 这是`remove()`的一般版本，可能涉及`shiftDown()`或`shiftUp()`。

Let's take the example tree again and remove `(7)`:
让我们再次采用示例树并删除`(7)`：

![The heap before removal](Images/Heap1.png)

As a reminder, the array is:
提醒一下，数组是：

	[ 10, 7, 2, 5, 1 ]

As you know, removing an element could potentially invalidate the max-heap or min-heap property. To fix this, we swap the node that we are removing with the last element:
如您所知，删除元素可能会使max-heap或min-heap属性失效。 要解决这个问题，我们将要移除的节点与最后一个元素交换：

	[ 10, 1, 2, 5, 7 ]

The last element is the one that we will return; we will call `removeLast()` to remove it from the heap. The `(1)` is now out-of-order because it is smaller than its child, `(5)` but sits higher in the tree. We call `shiftDown()` to repair this.
最后一个元素是我们将返回的元素; 我们将调用`removeLast()`将其从堆中删除。 `(1)`现在是乱序的，因为它小于它的孩子，`(5)`但是在树中更高。 我们调用`shiftDown()`来修复它。

However, shifting down is not the only situation we need to handle. It may also happen that the new element must be shifted up. Consider what happens if you remove `(5)` from the following heap:
但是，向下移动并不是我们需要处理的唯一情况。 也可能发生新元素必须向上移动。 考虑如果从以下堆中删除`(5)`会发生什么：

![We need to shift up](Images/Remove5.png)

Now `(5)` gets swapped with `(8)`. Because `(8)` is larger than its parent, we need to call `shiftUp()`.
现在`(5)`与`(8)`交换。 因为`(8)`比它的父大，我们需要调用`shiftUp()`。

## Creating a heap from an array
## 从数组创建堆

It can be convenient to convert an array into a heap. This just shuffles the array elements around until the heap property is satisfied.
将数组转换为堆可以很方便。 这只是对数组元素进行洗牌，直到满足堆属性。

In code it would look like this:
在代码中它看起来像这样：

```swift
  private mutating func buildHeap(fromArray array: [T]) {
    for value in array {
      insert(value)
    }
  }
```

We simply call `insert()` for each of the values in the array. Simple enough but not very efficient. This takes **O(n log n)** time in total because there are **n** elements and each insertion takes **log n** time.

If you didn't gloss over the math section, you'd have seen that for any heap the elements at array indices *n/2* to *n-1* are the leaves of the tree. We can simply skip those leaves. We only have to process the other nodes, since they are parents with one or more children and therefore may be in the wrong order.

我们只是为数组中的每个值调用`insert()`。 简单但不是很有效。 这总共需要**O(n log n)**时间，因为有**n**个元素，每个插入需要**log n**时间。

如果你没有掩盖数学部分，你已经看到，对于任何堆，数组索引*n / 2*到*n-1*的元素都是树的叶子。 我们可以简单地跳过那些叶子。 我们只需要处理其他节点，因为它们是有一个或多个孩子的父母，因此可能是错误的顺序。

In code:

```swift
  private mutating func buildHeap(fromArray array: [T]) {
    elements = array
    for i in stride(from: (nodes.count/2-1), through: 0, by: -1) {
      shiftDown(index: i, heapSize: elements.count)
    }
  }
```

Here, `elements` is the heap's own array. We walk backwards through this array, starting at the first non-leaf node, and call `shiftDown()`. This simple loop puts these nodes, as well as the leaves that we skipped, in the correct order. This is known as Floyd's algorithm and only takes **O(n)** time. Win!
这里，`elements`是堆自己的数组。 我们从第一个非叶子节点开始向后遍历这个数组，并调用`shiftDown()`。 这个简单的循环以正确的顺序放置这些节点以及我们跳过的叶子。 这被称为Floyd算法，只需要**O(n)**时间。 赢得！

## Searching the heap
## 搜索堆

Heaps are not made for fast searches, but if you want to remove an arbitrary element using `removeAtIndex()` or change the value of an element with `replace()`, then you need to obtain the index of that element. Searching is one way to do this, but it is slow.
堆不是用于快速搜索，但如果要使用`removeAtIndex()`删除任意元素或使用`replace()`更改元素的值，则需要获取该元素的索引。搜索是一种方法，但速度很慢。

In a [binary search tree](../Binary%20Search%20Tree/), depending on the order of the nodes, a fast search can be guaranteed. Since a heap orders its nodes differently, a binary search will not work, and you need to check every node in the tree.
在[二叉搜索树](../Binary%20Search%20Tree/)中，根据节点的顺序，可以保证快速搜索。 由于堆以不同方式对其节点进行排序，因此二进制搜索将不起作用，您需要检查树中的每个节点。

Let's take our example heap again:

![The heap](Images/Heap1.png)

If we want to search for the index of node `(1)`, we could just step through the array `[ 10, 7, 2, 5, 1 ]` with a linear search.

Even though the heap property was not conceived with searching in mind, we can still take advantage of it. We know that in a max-heap a parent node is always larger than its children, so we can ignore those children (and their children, and so on...) if the parent is already smaller than the value we are looking for.

Let's say we want to see if the heap contains the value `8` (it doesn't). We start at the root `(10)`. This is not what we are looking for, so we recursively look at its left and right child. The left child is `(7)`. That is also not what we want, but since this is a max-heap, we know there is no point in looking at the children of `(7)`. They will always be smaller than `7` and are therefore never equal to `8`; likewise, for the right child, `(2)`.

Despite this small optimization, searching is still an **O(n)** operation.

如果我们想要搜索节点`(1）`的索引，我们可以通过线性搜索单步执行数组`[10,7,2,5,1]`。

即使堆积属性没有考虑到搜索，我们仍然可以利用它。 我们知道在*max-heap*中父节点总是比它的子节点大，所以如果父节点已经小于我们要查找的值，我们可以忽略那些子节点(及其子节点等等）。

假设我们想要查看堆是否包含值`8`(它没有)。 我们从根`(10)`开始。 这不是我们想要的，所以我们递归地看看它的左右孩子。 左边的孩子是`(7)`。 这也不是我们想要的，但由于这是一个*max-heap*，我们知道查看`(7)`的孩子是没有意义的。 它们总是小于`7`，因此永远不会等于`8`; 同样，对于正确的孩子，`(2)`。

尽管有这么小的优化，搜索仍然是**O(n)**操作。

> **Note:** There is a way to turn lookups into a **O(1)** operation by keeping an additional dictionary that maps node values to indices. This may be worth doing if you often need to call `replace()` to change the "priority" of objects in a [priority queue](../Priority%20Queue/) that's built on a heap.
> **注意：** 有一种方法可以通过保留一个将节点值映射到索引的附加字典来将查找转换为**O(1)**操作。 如果你经常需要调用`replace()`来改变构建在堆上的[priority queue](../Priority%20Queue/)中对象的“优先级”，这可能是值得做的。

## The code
## 代码

See [Heap.swift](Heap.swift) for the implementation of these concepts in Swift. Most of the code is quite straightforward. The only tricky bits are in `shiftUp()` and `shiftDown()`.

You have seen that there are two types of heaps: a max-heap and a min-heap. The only difference between them is in how they order their nodes: largest value first or smallest value first.

Rather than create two different versions, `MaxHeap` and `MinHeap`, there is just one `Heap` object and it takes an `isOrderedBefore` closure. This closure contains the logic that determines the order of two values. You have probably seen this before because it is also how Swift's `sort()` works.
有关在Swift中实现这些概念的信息，请参见[Heap.swift](Heap.swift)。 大多数代码都很简单。 唯一棘手的问题是`shiftUp()`和`shiftDown()`。

您已经看到有两种类型的堆：*max-heap*和*min-heap*。 它们之间的唯一区别在于它们如何对节点进行排序：首先是最大值或最小值。

而不是创建两个不同的版本，`MaxHeap`和`MinHeap`，只有一个`Heap`对象，它需要一个`isOrderedBefore`闭包。 此闭包包含确定两个值的顺序的逻辑。 你之前可能已经看过了，因为它也是Swift的`sort()`的工作原理。

To make a max-heap of integers, you write:
要创建一个最大的整数堆，你写：

```swift
var maxHeap = Heap<Int>(sort: >)
```

And to create a min-heap you write:

```swift
var minHeap = Heap<Int>(sort: <)
```

I just wanted to point this out, because where most heap implementations use the `<` and `>` operators to compare values, this one uses the `isOrderedBefore()` closure.
我只想指出这一点，因为大多数堆实现使用`<`和`>`运算符来比较值，这个使用`isOrderedBefore()`闭包。

## 扩展阅读

[Heap on Wikipedia](https://en.wikipedia.org/wiki/Heap_%28data_structure%29)


*作者：[Kevin Randrup](http://www.github.com/kevinrandrup)， Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  