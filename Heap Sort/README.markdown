# 堆排序(Heap Sort)



使用堆将数组从低到高排序。( **译注：** 也可以从高到低排序)

[堆](../Heap/)是一个部分排序的二叉树，存储在数组中。 堆排序算法利用堆的结构来执行快速排序。

要从最低到最高排序，堆排序首先将未排序的数组转换为*max-heap*，让数组中的第一个元素是最大的。

假设，需要排序的数组为：

	[ 5, 13, 2, 25, 7, 17, 20, 8, 4 ]

首先变成了一个如下所示的*max-heap*：

![The max-heap](Images/MaxHeap.png)

这个堆的数组是：

	[ 25, 13, 20, 8, 7, 17, 2, 5, 4 ]

这几乎不是想要的从低到高排序！ 

现在开始排序：我们将第一个元素（索引*0*）与索引*n-1*的最后一个元素交换，得到：

	[ 4, 13, 20, 8, 7, 17, 2, 5, 25 ]
	  *                          *

现在新的根节点`4`小于其子节点，因此我们使用*shift down*或“堆化(heapify)”将0到n-2元素修复成*max-heap*。 修复堆后，新的根节点现在是数组中的第二大项：

	[20, 13, 17, 8, 7, 4, 2, 5 | 25]

重要提示：当我们修复堆时，我们忽略索引为*n-1*的最后一项。 最后一项是数组中的最大值，因此它已经在最终排序的位置了。 `|`栏表示数组的已排序部分的开始位置。 从现在开始，我们将单独除了数组余下的部分（`|`前面的部分）。

同样，我们将第一个元素与最后一个元素交换（这次是在索引*n-2*）：

	[5, 13, 17, 8, 7, 4, 2, 20 | 25]
	 *                      *

并修复堆以使其再次成为有效的*max-heap*：

	[17, 13, 5, 8, 7, 4, 2 | 20, 25]

正如您所看到的，最大项正在向后移动。 我们重复这个过程，直到到达根节点，也就对整个数组进行了排序。



> **注意：** 此过程与[选择排序](../Selection%20Sort/) 非常相似，它重复查找数组其余部分中的最小项。 提取最小值或最大值是堆擅长做的。


堆排序的性能最佳，最差和平均情况下都是**O(n lg n)**。 因为我们直接修改数组，所以可以就地执行堆排序。 但它不是一个稳定的类型：不保留相同元素的相对顺序。

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

为[堆](../Heap/)实现添加了一个`sort()`函数。 这个函数的使用方式：

```swift
var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let a1 = h1.sort()
```

因为我们需要一个*max-heap*来从低到高排序，你需要给`Heap`提供sort函数的反向排序。 要对`<`进行排序，必须使用`>`作为sort函数创建`Heap`对象。 换句话说，从低到高的排序会创建一个max-heap并将其转换为min-heap（ **译注：** 这边的意思就是排完序以后就变成了一个从小到大的特殊的min-heap）。

我们可以为此编写一个方便的辅助函数：

```swift
public func heapsort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
  let reverseOrder = { i1, i2 in sort(i2, i1) }
  var h = Heap(array: a, sort: reverseOrder)
  return h.sort()
}
```

使用方式：

```swift
let a2 = heapsort([5, 13, 2, 25, 7, 17, 20, 8, 4], <)
print(a2)
```





*作者： Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  