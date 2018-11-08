# 堆排序(Heap Sort)

Sorts an array from low to high using a heap.
使用堆将数组从低到高排序。

A [heap](../Heap/) is a partially sorted binary tree that is stored inside an array. The heap sort algorithm takes advantage of the structure of the heap to perform a fast sort.
[堆](../Heap/)是一个部分排序的二叉树，存储在数组中。 堆排序算法利用堆的结构来执行快速排序。

To sort from lowest to highest, heap sort first converts the unsorted array to a max-heap, so that the first element in the array is the largest.
要从最低到最高排序，堆排序首先将未排序的数组转换为*max-heap*，以便数组中的第一个元素是最大的。

Let's say the array to sort is:
需要排序的数组：

	[ 5, 13, 2, 25, 7, 17, 20, 8, 4 ]

This is first turned into a max-heap that looks like this:
这首先变成了一个如下所示的最大堆：

![The max-heap](Images/MaxHeap.png)

The heap's internal array is then:
然后堆的内部数组是：

	[ 25, 13, 20, 8, 7, 17, 2, 5, 4 ]

That's hardly what you'd call sorted! But now the sorting process starts: we swap the first element (index *0*) with the last one at index *n-1*, to get:
这几乎不是你所谓的排序！ 但现在排序过程开始了：我们将第一个元素（索引*0*）与索引*n-1*的最后一个元素交换，得到：

	[ 4, 13, 20, 8, 7, 17, 2, 5, 25 ]
	  *                          *

Now the new root node, `4`, will be smaller than its children, so we fix up the max-heap up to element *n-2* using the *shift down* or "heapify" procedure. After repairing the heap, the new root is now the second-largest item in the array:
现在新的根节点`4`将小于其子节点，因此我们使用*shift down*或“heapify”过程将max-heap修复到元素*n-2*。 修复堆后，新的根现在是数组中的第二大项：

	[20, 13, 17, 8, 7, 4, 2, 5 | 25]

Important: When we fix the heap, we ignore the last item at index *n-1*. That now contains the array's maximum value, so it is in its final sorted place already. The `|` bar indicates where the sorted portion of the array begins. We'll leave that part of the array alone from now on.
重要提示：当我们修复堆时，我们忽略index *n-1* 处的最后一项。 现在包含数组的最大值，因此它已经在最终排序的位置。 `|`栏表示数组的已排序部分的开始位置。 从现在开始，我们将单独留下数组的那一部分。

Again, we swap the first element with the last one (this time at index *n-2*):
同样，我们将第一个元素与最后一个元素交换（这次是在索引*n-2*）：

	[5, 13, 17, 8, 7, 4, 2, 20 | 25]
	 *                      *

And fix up the heap to make it valid max-heap again:
并修复堆以使其再次成为有效的最大堆：

	[17, 13, 5, 8, 7, 4, 2 | 20, 25]

As you can see, the largest items are making their way to the back. We repeat this process until we arrive at the root node and then the whole array is sorted.
正如您所看到的，最大的物品正在向后推进。 我们重复这个过程，直到我们到达根节点，然后对整个数组进行排序。

> **Note:** This process is very similar to [selection sort](../Selection%20Sort/), which repeatedly looks for the minimum item in the remainder of the array. Extracting the minimum or maximum value is what heaps are good at.
> **注意：** 此过程与[选择排序](../Selection%20Sort/) 非常相似，它重复查找数组其余部分中的最小项。 提取最小值或最大值是堆的擅长。

Performance of heap sort is **O(n lg n)** in best, worst, and average case. Because we modify the array directly, heap sort can be performed in-place. But it is not a stable sort: the relative order of identical elements is not preserved.
堆排序的性能是最佳，最差和平均情况下的**O(n lg n)**。 因为我们直接修改数组，所以可以就地执行堆排序。 但它不是一个稳定的类型：不保留相同元素的相对顺序。

Here's how you can implement heap sort in Swift:
以下是在Swift中实现堆排序的方法：

```swift
extension Heap {
  public mutating func sort() -> [T] {
    for i in stride(from: (elements.count - 1), through: 1, by: -1) {
      swap(&elements[0], &elements[i])
      shiftDown(0, heapSize: i)
    }
    return elements
  }
}
```

This adds a `sort()` function to our [heap](../Heap/) implementation. To use it, you would do something like this:
这为我们的[堆](../Heap/)实现添加了一个`sort()`函数。 要使用它，你会做这样的事情：

```swift
var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let a1 = h1.sort()
```

Because we need a max-heap to sort from low-to-high, you need to give `Heap` the reverse of the sort function. To sort `<`, the `Heap` object must be created with `>` as the sort function. In other words, sorting from low-to-high creates a max-heap and turns it into a min-heap.
因为我们需要一个最大堆来从低到高排序，你需要给`Heap`提供sort函数的反向。 要对`<`进行排序，必须使用`>`作为sort函数创建`Heap`对象。 换句话说，从低到高的排序会创建一个最大堆并将其转换为最小堆。

We can write a handy helper function for that:
我们可以为此编写一个方便的辅助函数：

```swift
public func heapsort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
  let reverseOrder = { i1, i2 in sort(i2, i1) }
  var h = Heap(array: a, sort: reverseOrder)
  return h.sort()
}
```


*作者： Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
