# 第k大元素问题(k-th Largest Element Problem)

你有一个整数数组`a`。 编写一个算法，在数组中找到第*k*大的元素。

例如，第1个最大元素是数组中出现的最大值。 如果数组具有*n*个元素，则第*n*最大元素是最小值。 中位数是第*n/2*最大元素。

## 朴素的解决方案

以下是半朴素的解决方案。 它的时间复杂度是 **O(nlogn)**，因为它首先对数组进行排序，因此也使用额外的 **O(n)** 空间。

```swift
func kthLargest(a: [Int], k: Int) -> Int? {
  let len = a.count
  if k > 0 && k <= len {
    let sorted = a.sorted()
    return sorted[len - k]
  } else {
    return nil
  }
}
```

`kthLargest()` 函数有两个参数：由整数组成的数组`a`，已经整数`k`。 它返回第*k*大元素。

让我们看一个例子并运行算法来看看它是如何工作的。 给定`k = 4`和数组：

```swift
[ 7, 92, 23, 9, -1, 0, 11, 6 ]
```

最初没有找到第k大元素的直接方法，但在对数组进行排序之后，它非常简单。 这是排完序的数组：

```swift
[ -1, 0, 6, 7, 9, 11, 23, 92 ]
```

现在，我们所要做的就是获取索引`a.count - k`的值：

```swift
a[a.count - k] = a[8 - 4] = a[4] = 9
```

当然，如果你正在寻找第k个*最小的*元素，你会使用`a [k-1]`。

## 更快的解决方案

有一种聪明的算法结合了[二分搜索](../Binary%20Search/)和[快速排序](../Quicksort/)的思想来达到**O(n)**解决方案。

回想一下，二分搜索会一次又一次地将数组分成两半，以便快速缩小您要搜索的值。 这也是我们在这里所做的。

快速排序还会拆分数组。它使用分区将所有较小的值移动到数组的左侧，将所有较大的值移动到右侧。在围绕某个基准进行分区之后，该基准值将已经处于其最终的排序位置。 我们可以在这里利用它。

以下是它的工作原理：我们选择一个随机基准，围绕该基准对数组进行分区，然后像二分搜索一样运行，只在左侧或右侧分区中继续。这一过程重复进行，直到我们找到一个恰好位于第*k*位置的基准。

让我们再看看初始的例子。 我们正在寻找这个数组中的第4大元素：

	[ 7, 92, 23, 9, -1, 0, 11, 6 ]

如果我们寻找第k个*最小*项，那么算法会更容易理解，所以让我们采用`k = 4`并寻找第4个最小元素。

请注意，我们不必先对数组进行排序。 我们随机选择其中一个元素作为基准，假设是`11`，并围绕它分割数组。 我们最终会得到这样的结论：

	[ 7, 9, -1, 0, 6, 11, 92, 23 ]
	 <------ smaller    larger -->

如您所见，所有小于`11`的值都在左侧; 所有更大的值都在右边。基准值`11`现在处于最终排完序的位置。基准的索引是5，因此第4个最小元素肯定位于左侧分区中的某个位置。从现在开始我们可以忽略数组的其余部分：

	[ 7, 9, -1, 0, 6, x, x, x ]

再次让我们选择一个随机的枢轴，让我们说`6`，然后围绕它划分数组。 我们最终会得到这样的结论：

	[ -1, 0, 6, 9, 7, x, x, x ]

基准值`6`在索引2处结束，所以显然第4个最小的项必须在右侧分区中。 我们可以忽略左侧分区：

	[ x, x, x, 9, 7, x, x, x ]

我们再次随机选择一个基准值，假设是`9`，并对数组进行分区：

	[ x, x, x, 7, 9, x, x, x ]

基准值`9`的索引是4，这正是我们正在寻找的 *k*。 我们完成了！ 注意这只需要几个步骤，我们不必先对数组进行排序。

以下函数实现了这些想法：

```swift
public func randomizedSelect<T: Comparable>(_ array: [T], order k: Int) -> T {
  var a = array

  func randomPivot<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> T {
    let pivotIndex = random(min: low, max: high)
    a.swapAt(pivotIndex, high)
    return a[high]
  }

  func randomizedPartition<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> Int {
    let pivot = randomPivot(&a, low, high)
    var i = low
    for j in low..<high {
      if a[j] <= pivot {
        a.swapAt(i, j)
        i += 1
      }
    }
    a.swapAt(i, high)
    return i
  }

  func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
    if low < high {
      let p = randomizedPartition(&a, low, high)
      if k == p {
        return a[p]
      } else if k < p {
        return randomizedSelect(&a, low, p - 1, k)
      } else {
        return randomizedSelect(&a, p + 1, high, k)
      }
    } else {
      return a[low]
    }
  }

  precondition(a.count > 0)
  return randomizedSelect(&a, 0, a.count - 1, k)
}
```

为了保持可读性，功能分为三个内部函数：

- `randomPivot()`选择一个随机数并将其放在当前分区的末尾（这是Lomuto分区方案的要求，有关详细信息，请参阅[快速排序](../Quicksort/)上的讨论）。

- `randomizedPartition()`是Lomuto的快速排序分区方案。 完成后，随机选择的基准位于数组中的最终排序位置。它返回基准值的数组索引。

- `randomizedSelect()`做了所有困难的工作。 它首先调用分区函数，然后决定下一步做什么。 如果基准的索引等于我们正在寻找的*k*元素，我们就完成了。 如果`k`小于基准索引，它必须回到左分区中，我们将在那里递归再次尝试。 当第*k*数在右分区中时，同样如此。

很酷，对吧？ 通常，快速排序是一种 **O(nlogn)** 算法，但由于我们只对数组中较小的部分进行分区，因此`randomizedSelect()`的运行时间为 **O(n)**。

> **注意：** 此函数计算数组中第*k*最小项，其中*k*从0开始。如果你想要第*k*最大项，请用`a.count - k`。


*作者：Daniel Speiser，Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  