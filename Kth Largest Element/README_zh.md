# k-th Largest Element Problem
# 第K大元素问题

You're given an integer array `a`. Write an algorithm that finds the *k*-th largest element in the array.
你得到一个整数数组`a`。 编写一个算法，在数组中找到第*k*最大的元素。

For example, the 1-st largest element is the maximum value that occurs in the array. If the array has *n* elements, the *n*-th largest element is the minimum. The median is the *n/2*-th largest element.
例如，第1个最大元素是数组中出现的最大值。 如果数组具有 *n* 个元素，则第 *n* 最大元素是最小值。 中位数是第 *n/2* 最大元素。

## The naive solution
## 朴素的解决方案

The following solution is semi-naive. Its time complexity is **O(n log n)** since it first sorts the array, and therefore also uses additional **O(n)** space.
以下解决方案是半朴素的。 它的时间复杂度是 **O(nlogn)**，因为它首先对数组进行排序，因此也使用额外的 **O(n)** 空间。

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

The `kthLargest()` function takes two parameters: the array `a` consisting of integers, and `k`. It returns the *k*-th largest element.
`kthLargest()` 函数有两个参数：由整数组成的数组`a`和`k`。 它返回第*k*最大元素。

Let's take a look at an example and run through the algorithm to see how it works. Given `k = 4` and the array:
让我们看一个例子并运行算法来看看它是如何工作的。 给定`k = 4`和数组：

```swift
[ 7, 92, 23, 9, -1, 0, 11, 6 ]
```

Initially there's no direct way to find the k-th largest element, but after sorting the array it's rather straightforward. Here's the sorted array:
最初没有找到第k个最大元素的直接方法，但在对数组进行排序之后，它非常简单。 这是排完序的数组：

```swift
[ -1, 0, 6, 7, 9, 11, 23, 92 ]
```

Now, all we must do is take the value at index `a.count - k`:
现在，我们所要做的就是获取索引`a.count - k`的值：

```swift
a[a.count - k] = a[8 - 4] = a[4] = 9
```

Of course, if you were looking for the k-th *smallest* element, you'd use `a[k-1]`.
当然，如果你正在寻找第k个*最小的*元素，你会使用`a [k-1]`。

## A faster solution
## 更快的解决方案

There is a clever algorithm that combines the ideas of [binary search](../Binary%20Search/) and [quicksort](../Quicksort/) to arrive at an **O(n)** solution.
有一种聪明的算法结合了[二元搜索](../Binary％20Search/README_zh.md)和[快速排序](../Quicksort/README_zh.md)的思想来达到**O(n)**解决方案。

Recall that binary search splits the array in half over and over again, to quickly narrow in on the value you're searching for. That's what we'll do here too.
回想一下，二分搜索会一次又一次地将数组分成两半，以便快速缩小您要搜索的值。 这也是我们在这里所做的。

Quicksort also splits up arrays. It uses partitioning to move all smaller values to the left of the pivot and all greater values to the right. After partitioning around a certain pivot, that pivot value will already be in its final, sorted position. We can use that to our advantage here.
快速排序还会拆分数组。 它使用分区将所有较小的值移动到数据透视表的左侧，将所有较大的值移动到右侧。 在围绕某个枢轴进行分区之后，该枢轴值将已经处于其最终的排序位置。 我们可以在这里利用它。

Here's how it works: We choose a random pivot, partition the array around that pivot, then act like a binary search and only continue in the left or right partition. This repeats until we've found a pivot that happens to end up in the *k*-th position.
以下是它的工作原理：我们选择一个随机数据透视表，围绕该数据透视表对数组进行分区，然后像二分搜索一样运行，只在左侧或右侧分区中继续。 这一过程重复进行，直到我们找到一个恰好位于第*k*位置的枢轴。

Let's look at the original example again. We're looking for the 4-th largest element in this array:
让我们再看看原始的例子。 我们正在寻找这个数组中的第4大元素：

	[ 7, 92, 23, 9, -1, 0, 11, 6 ]

The algorithm is a bit easier to follow if we look for the k-th *smallest* item instead, so let's take `k = 4` and look for the 4-th smallest element.
如果我们寻找第k个*最小*项，那么算法会更容易理解，所以让我们采用`k = 4`并寻找第4个最小元素。

Note that we don't have to sort the array first. We pick one of the elements at random to be the pivot, let's say `11`, and partition the array around that. We might end up with something like this:
请注意，我们不必先对数组进行排序。 我们随机选择其中一个元素作为枢轴，让我们说`11`，并围绕它分割数组。 我们最终会得到这样的结论：

	[ 7, 9, -1, 0, 6, 11, 92, 23 ]
	 <------ smaller    larger -->

As you can see, all values smaller than `11` are on the left; all values larger are on the right. The pivot value `11` is now in its final place. The index of the pivot is 5, so the 4-th smallest element must be in the left partition somewhere. We can ignore the rest of the array from now on:
如您所见，所有小于`11`的值都在左侧; 所有更大的值都在右边。 枢轴值`11`现在处于最终位置。 枢轴的索引是5，因此第4个最小元素必须位于左侧分区中的某个位置。 从现在开始我们可以忽略数组的其余部分：

	[ 7, 9, -1, 0, 6, x, x, x ]

Again let's pick a random pivot, let's say `6`, and partition the array around it. We might end up with something like this:
再次让我们选择一个随机的枢轴，让我们说`6`，然后围绕它划分数组。 我们最终会得到这样的结论：

	[ -1, 0, 6, 9, 7, x, x, x ]

Pivot `6` ended up at index 2, so obviously the 4-th smallest item must be in the right partition. We can ignore the left partition:
Pivot`6`在索引2处结束，所以显然第4个最小的项必须在右侧分区中。 我们可以忽略左侧分区：

	[ x, x, x, 9, 7, x, x, x ]

Again we pick a pivot value at random, let's say `9`, and partition the array:
我们再次随机选择一个数据透视值，让我们说`9`，并对数组进行分区：

	[ x, x, x, 7, 9, x, x, x ]

The index of pivot `9` is 4, and that's exactly the *k* we're looking for. We're done! Notice how this only took a few steps and we did not have to sort the array first.
枢轴`9`的索引是4，这正是我们正在寻找的 *k*。 我们完成了！ 注意这只需要几个步骤，我们不必先对数组进行排序。

The following function implements these ideas:
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

To keep things readable, the functionality is split into three inner functions:
为了保持可读性，功能分为三个内部功能：

- `randomPivot()` picks a random number and puts it at the end of the current partition (this is a requirement of the Lomuto partitioning scheme, see the discussion on [quicksort](../Quicksort/) for more details).
- `randomPivot()`选择一个随机数并将其放在当前分区的末尾（这是Lomuto分区方案的要求，有关详细信息，请参阅[快速排序](../Quicksort/README_zh.md)上的讨论）。

- `randomizedPartition()` is Lomuto's partitioning scheme from quicksort. When this completes, the randomly chosen pivot is in its final sorted position in the array. It returns the array index of the pivot.
- `randomizedPartition()`是Lomuto的快速排序分区方案。 完成后，随机选择的枢轴位于数组中的最终排序位置。 它返回数据透视表的数组索引。

- `randomizedSelect()` does all the hard work. It first calls the partitioning function and then decides what to do next. If the index of the pivot is equal to the *k*-th number we're looking for, we're done. If `k` is less than the pivot index, it must be in the left partition and we'll recursively try again there. Likewise for when the *k*-th number must be in the right partition.
- `randomizedSelect()`做了所有艰苦的工作。 它首先调用分区函数，然后决定下一步做什么。 如果枢轴的索引等于我们正在寻找的*k*号，我们就完成了。 如果`k`小于pivot索引，它必须在左分区中，我们将在那里递归再次尝试。 同样地，当第*k*数必须在右分区中时。

Pretty cool, huh? Normally quicksort is an **O(n log n)** algorithm, but because we only partition smaller and smaller slices of the array, the running time of `randomizedSelect()` works out to **O(n)**.
很酷，对吧？ 通常，快速排序是一种 **O(nlogn)** 算法，但由于我们只对数组中较小和较小的切片进行分区，因此`randomizedSelect()`的运行时间为 **O(n)**。

> **Note:** This function calculates the *k*-th smallest item in the array, where *k* starts at 0. If you want the *k*-th largest item, call it with `a.count - k`.
> **注意：** 此函数计算数组中第*k*最小项，其中*k*从0开始。如果你想要第*k*最大项，请用`a.count - k`。

*Written by Daniel Speiser. Additions by Matthijs Hollemans.*
*作者：Matthijs Hollemans，Daniel Speiser补充*  
*翻译：[Andy Ron](https://github.com/andyRon)*