# Merge Sort
# 归并排序

> This topic has been tutorialized [here](https://www.raywenderlich.com/154256/swift-algorithm-club-swift-merge-sort)
> 这个主题已经有教程 [here](https://www.raywenderlich.com/154256/swift-algorithm-club-swift-merge-sort)

Goal: Sort an array from low to high (or high to low)
目标：将数组从低到高（或从高到低）排序

Invented in 1945 by John von Neumann, merge-sort is an efficient algorithm with a best, worst, and average time complexity of **O(n log n)**.
归并排序是1945年由John von Neumann发明的，是一种有效的算法，具有**O(n log n)** 的最佳，最差和平均时间复杂度。

The merge-sort algorithm uses the **divide and conquer** approach which is to divide a big problem into smaller problems and solve them. I think of the merge-sort algorithm as **split first** and **merge after**.
归并排序算法使用**分而治之**方法，即将一个大问题分解为较小的问题并解决它们。 我认为归并排序算法为 **拆分** 和 **合并**。

Assume you need to sort an array of *n* numbers in the right order. The merge-sort algorithm works as follows:
假设您需要按正确的顺序对 *n* 数字的数组进行排序。 归并排序算法的工作原理如下：
 
- Put the numbers in an unsorted pile.
- Split the pile into two. Now, you have **two unsorted piles** of numbers.
- Keep splitting the resulting piles until you cannot split anymore. In the end, you will have *n* piles with one number in each pile.
- Begin to **merge** the piles together by pairing them sequentially. During each merge, put the contents in sorted order. This is fairly easy because each individual pile is already sorted.
- 将数字放在未分类的堆中。
- 将堆分成两部分。 现在，你有**两个未分类的数字**。
- 保持分裂所产生的堆，直到你不能分裂为止。 最后，你将拥有 *n* 堆，每堆中有一个数字。
- 通过顺序配对，开始**合并**堆。 在每次合并期间，将内容按排序顺序排列。 这很容易，因为每个单独的堆已经排序。

## An example
## 一个例子

### Splitting
### 分裂

Assume you are given an array of *n* numbers as`[2, 1, 5, 4, 9]`. This is an unsorted pile. The goal is to keep splitting the pile until you cannot split anymore.
假设给你一个 *n* 数组作为`[2,1,5,4,9]`。 这是一个未分类的堆。 目标是不断分裂堆，直到你不能分裂为止。

First, split the array into two halves: `[2, 1]` and `[5, 4, 9]`. Can you keep splitting them? Yes, you can!
首先，将数组分成两半：`[2,1]`和`[5,4,9]`。 你能继续拆分吗？ 是的你可以！

Focus on the left pile. Split`[2, 1]` into `[2]` and `[1]`. Can you keep splitting them? No. Time to check the other pile.
专注于左边堆。 将`[2,1]`拆分为`[2]`和`[1]`。 你能继续拆分吗？ 没时间检查另一堆。


Split `[5, 4, 9]` into `[5]` and `[4, 9]`. Unsurprisingly, `[5]` cannot be split anymore, but `[4, 9]` can be split into `[4]` and `[9]`.
将`[5,4,9]`拆分为`[5]`和`[4,9]`。 不出所料，`[5]`不能再拆分了，但是`[4,9]`可以分成`[4]`和`[9]`。

The splitting process ends with the following piles: `[2]` `[1]` `[5]` `[4]` `[9]`. Notice that each pile consists of just one element.
分裂过程以下列结尾：`[2]``[1]``[5]``[4]``[9]`。 请注意，每个堆只包含一个元素。

### Merging
### 合并

Now that you have split the array, you should **merge** the piles together **while sorting them**. Remember, the idea is to solve many small problems rather than a big one. For each merge iteration, you must be concerned at merging one pile with another.
现在您已经拆分了数组，您应该将 **堆合在一起** 同时对它们进行排序。 请记住，这个想法是解决许多小问题而不是大问题。 对于每次合并迭代，您必须关注将一堆与另一堆合并。

Given the piles `[2]` `[1]` `[5]` `[4]` `[9]`, the first pass will result in `[1, 2]` and `[4, 5]` and `[9]`. Since `[9]` is the odd one out, you cannot merge it with anything during this pass.
鉴于堆`[2]` `[1]``[5]``[4]``[9]`，第一遍将导致`[1,2]`和`[4,5]` 和`[9]`。 由于`[9]`是奇数输出，所以在此过程中你不能将它与任何东西合并。

The next pass will merge `[1, 2]` and `[4, 5]` together. This results in `[1, 2, 4, 5]`, with the `[9]` left out again because it is the odd one out.
下一遍将合并`[1,2]`和`[4,5]`。 这导致`[1,2,4,5]`，再次省略`[9]`，因为它是奇数的。

You are left with only two piles `[1, 2, 4, 5]` and `[9]`, finally gets its chance to merge, resulting in the sorted array as `[1, 2, 4, 5, 9]`.
你只剩下两堆`[1,2,4,5]`和`[9]`，最终有机会合并，排玩序数组为`[1,2,4,5,9]`。


## Top-down implementation
## 自上而下的实施

Here's what merge sort may look like in Swift:
这是Swift中归并排序的样子：

```swift
func mergeSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }    // 1

  let middleIndex = array.count / 2              // 2

  let leftArray = mergeSort(Array(array[0..<middleIndex]))             // 3

  let rightArray = mergeSort(Array(array[middleIndex..<array.count]))  // 4

  return merge(leftPile: leftArray, rightPile: rightArray)             // 5
}
```

A step-by-step explanation of how the code works:

1. If the array is empty or contains a single element, there is no way to split it into smaller pieces. You must just return the array.

2. Find the middle index.

3. Using the middle index from the previous step, recursively split the left side of the array.

4. Also, recursively split the right side of the array.

5. Finally, merge all the values together, making sure that it is always sorted.
有关代码如何工作的逐步说明：

1.如果数组为空或包含单个元素，则无法将其拆分为更小的部分。 你必须只返回数组。

2.找到中间指数。

3.使用上一步中的中间索引，递归地分割数组的左侧。

4.此外，递归地分割数组的右侧。

5.最后，将所有值合并在一起，确保它始终排序。

Here's the merging algorithm:
这儿是合并的算法：

```swift
func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
  // 1
  var leftIndex = 0
  var rightIndex = 0

  // 2
  var orderedPile = [Int]()

  // 3
  while leftIndex < leftPile.count && rightIndex < rightPile.count {
    if leftPile[leftIndex] < rightPile[rightIndex] {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
    } else if leftPile[leftIndex] > rightPile[rightIndex] {
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    } else {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    }
  }

  // 4
  while leftIndex < leftPile.count {
    orderedPile.append(leftPile[leftIndex])
    leftIndex += 1
  }

  while rightIndex < rightPile.count {
    orderedPile.append(rightPile[rightIndex])
    rightIndex += 1
  }

  return orderedPile
}
```

This method may look scary, but it is quite straightforward:

1. You need two indexes to keep track of your progress for the two arrays while merging.

2. This is the merged array. It is empty right now, but you will build it up in subsequent steps by appending elements from the other arrays.

3. This while-loop will compare the elements from the left and right sides and append them into the `orderedPile` while making sure that the result stays in order.

4. If control exits from the previous while-loop, it means that either the `leftPile` or the `rightPile` has its contents completely merged into the `orderedPile`. At this point, you no longer need to do comparisons. Just append the rest of the contents of the other array until there is no more to append.
这种方法可能看起来很可怕，但它非常简单：

1.在合并时，您需要两个索引来跟踪两个阵列的进度。

这是合并的数组。 它现在是空的，但是你将通过附加其他数组中的元素在后续步骤中构建它。

3.这个while循环将比较左侧和右侧的元素，并将它们附加到`orderedPile`，同时确保结果保持有序。

4.如果控制退出前一个while循环，则意味着`leftPile`或`rightPile`的内容完全合并到`orderedPile`中。 此时，您不再需要进行比较。 只需追加另一个数组的其余内容，直到没有其他内容可以追加。

As an example of how `merge()` works, suppose that we have the following piles: `leftPile = [1, 7, 8]` and `rightPile = [3, 6, 9]`. Note that each of these piles is individually sorted already -- that is always true with merge sort. These are merged into one larger sorted pile in the following steps:
`merge()`如何工作的一个例子，假设我们有以下几个堆：`leftPile = [1,7,8]`和`rightPile = [3,6,9]`。 请注意，这些堆中的每一个都已单独排序 -- 对于合并排序始终为真。 这些在以下步骤中合并为一个更大的排序堆：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ ]
      l              r

The left index, here represented as `l`, points at the first item from the left pile, `1`. The right index, `r`, points at `3`. Therefore, the first item we add to `orderedPile` is `1`. We also move the left index `l` to the next item.
左侧索引（此处表示为`l`）指向左侧堆的第一个项目`1`。 正确的索引`r`指向`3`。 因此，我们添加到`orderedPile`的第一项是`1`。 我们还将左侧索引`l`移动到下一个项目。

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1 ]
      -->l           r

Now `l` points at `7` but `r` is still at `3`. We add the smallest item to the ordered pile, so that is `3`. The situation is now:
现在`l`指向`7`但是`r`仍然处于`3`。 我们将最小的项添加到有序堆中，因此它是“3”。 现在的情况是：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3 ]
         l           -->r

This process repeats. At each step, we pick the smallest item from either the `leftPile` or the `rightPile` and add the item into the `orderedPile`:
这个过程重复。 在每一步中，我们从`leftPile`或`rightPile`中选择最小的项，并将该项添加到`orderedPile`中：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6 ]
         l              -->r

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7 ]
         -->l              r

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7, 8 ]
            -->l           r

Now, there are no more items in the left pile. We simply add the remaining items from the right pile, and we are done. The merged pile is `[ 1, 3, 6, 7, 8, 9 ]`.
现在，左堆中没有更多物品了。 我们只需从正确的堆中添加剩余的项目，我们就完成了。 合并的堆是`[1,3,6,7,8,9]`。

Notice that, this algorithm is very simple: it moves from left-to-right through the two piles and at every step picks the smallest item. This works because we guarantee that each of the piles is already sorted.
请注意，此算法非常简单：它从左向右移动通过两个堆，并在每个步骤选择最小的项目。 这是有效的，因为我们保证每个堆都已经排序。

## Bottom-up implementation
## 自下而上的实施

The implementation of the merge-sort algorithm you have seen so far is called the "top-down" approach because it first splits the array into smaller piles and then merges them. When sorting an array (as opposed to, say, a linked list) you can actually skip the splitting step and immediately start merging the individual array elements. This is called the "bottom-up" approach.
到目前为止你看到的合并排序算法的实现被称为“自上而下”的方法，因为它首先将数组拆分成更小的堆然后合并它们。排序数组（而不是链接列表）时，实际上可以跳过拆分步骤并立即开始合并各个数组元素。 这被称为“自下而上”的方法。

Time to step up the game a little. :-) Here is a complete bottom-up implementation in Swift:
是时候加强游戏了。 :-) 这是Swift中一个完整的自下而上的实现：
```swift
func mergeSortBottomUp<T>(_ a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
  let n = a.count

  var z = [a, a]      // 1
  var d = 0

  var width = 1
  while width < n {   // 2

    var i = 0
    while i < n {     // 3

      var j = i
      var l = i
      var r = i + width

      let lmax = min(l + width, n)
      let rmax = min(r + width, n)

      while l < lmax && r < rmax {                // 4
        if isOrderedBefore(z[d][l], z[d][r]) {
          z[1 - d][j] = z[d][l]
          l += 1
        } else {
          z[1 - d][j] = z[d][r]
          r += 1
        }
        j += 1
      }
      while l < lmax {
        z[1 - d][j] = z[d][l]
        j += 1
        l += 1
      }
      while r < rmax {
        z[1 - d][j] = z[d][r]
        j += 1
        r += 1
      }

      i += width*2
    }

    width *= 2
    d = 1 - d      // 5
  }
  return z[d]
}
```

It looks a lot more intimidating than the top-down version, but notice that the main body includes the same three `while` loops from `merge()`.
它看起来比自上而下的版本更令人生畏，但请注意主体包含与`merge()`相同的三个`while`循环。

Notable points:
值得注意的要点：

1. The Merge-sort algorithm needs a temporary working array because you cannot merge the left and right piles and at the same time overwrite their contents. Because allocating a new array for each merge is wasteful, we are using two working arrays, and we will switch between them using the value of `d`, which is either 0 or 1. The array `z[d]` is used for reading, and `z[1 - d]` is used for writing. This is called *double-buffering*.
1. 归并排序算法需要一个临时工作数组，因为你不能合并左右堆并同时覆盖它们的内容。 因为为每个合并分配一个新数组是浪费，我们使用两个工作数组，我们将使用`d`的值在它们之间切换，它是0或1。数组`z [d]`用于读，`z [1 - d]`用于写。 这称为 *双缓冲*。

2. Conceptually, the bottom-up version works the same way as the top-down version. First, it merges small piles of one element each, then it merges piles of two elements each, then piles of four elements each, and so on. The size of the pile is given by `width`. Initially, `width` is `1` but at the end of each loop iteration, we multiply it by two, so this outer loop determines the size of the piles being merged, and the subarrays to merge become larger in each step.
2.从概念上讲，自下而上版本的工作方式与自上而下版本相同。首先，它合并每个元素的小堆，然后它合并每个堆两个元素，然后每个堆成四个元素，依此类推。堆的大小由“宽度”给出。 最初，`width`是`1`但是在每次循环迭代结束时，我们将它乘以2，所以这个外循环确定要合并的堆的大小，并且要合并的子阵列在每一步中变得更大。

3. The inner loop steps through the piles and merges each pair of piles into a larger one. The result is written in the array given by `z[1 - d]`.
3. 内圈循环穿过堆并将每对堆合并成一个较大的堆。 结果写在`z [1 - d]`给出的数组中。

4. This is the same logic as in the top-down version. The main difference is that we're using double-buffering, so values are read from `z[d]` and written into `z[1 - d]`. It also uses an `isOrderedBefore` function to compare the elements rather than just `<`, so this merge-sort algorithm is generic, and you can use it to sort any kind of object you want.
4. 这与自上而下版本的逻辑相同。 主要区别在于我们使用双缓冲，因此从`z [d]`读取值并写入`z [1 - d]`。它还使用`isOrderedBefore`函数来比较元素而不仅仅是`<`，因此这种合并排序算法是通用的，您可以使用它来对任何类型的对象进行排序。

5. At this point, the piles of size `width` from array `z[d]` have been merged into larger piles of size `width * 2` in array `z[1 - d]`. Here, we swap the active array, so that in the next step we'll read from the new piles we have just created.
5.此时，数组`z [d]`的大小`width`的堆已经合并为数组`z [1-d]`中更大的大小`width * 2`。在这里，我们交换活动数组，以便在下一步中我们将从我们刚刚创建的新堆中读取。

This function is generic, so you can use it to sort any type you desire, as long as you provide a proper `isOrderedBefore` closure to compare the elements.
这个函数是通用的，所以你可以使用它来对你想要的任何类型进行排序，只要你提供一个正确的`isOrderedBefore`闭包来比较元素。

Example of how to use it:
怎么使用它的示例：

```swift
let array = [2, 1, 5, 4, 9]
mergeSortBottomUp(array, <)   // [1, 2, 4, 5, 9]
```

## Performance
## 性能

The speed of the merge-sort algorithm is dependent on the size of the array it needs to sort. The larger the array, the more work it needs to do.
归并排序算法的速度取决于它需要排序的数组的大小。 数组越大，它需要做的工作就越多。

Whether or not the initial array is sorted already does not affect the speed of the merge-sort algorithm since you will be doing the same amount splits and comparisons regardless of the initial order of the elements.
初始数组是否已经排序不会影响归并排序算法的速度，因为无论元素的初始顺序如何，您都将进行相同数量的拆分和比较。

Therefore, the time complexity for the best, worst, and average case will always be **O(n log n)**.
因此，最佳，最差和平均情况的时间复杂度将始终为 **O(n log n)**。

A disadvantage of the merge-sort algorithm is that it needs a temporary "working" array equal in size to the array being sorted. It is not an **in-place** sort, unlike for example [quicksort](../Quicksort/).
归并排序算法的一个缺点是它需要一个临时的“工作”数组，其大小与被排序的数组相同。 它不是**原地**排序，不像例如[quicksort](../Quicksort/README_zh.md)。

Most implementations of the merge-sort algorithm produce a **stable** sort. This means that array elements that have identical sort keys will stay in the same order relative to each other after sorting. This is not important for simple values such as numbers or strings, but it can be an issue when sorting more complex objects.
归并排序算法的大多数实现产生**稳定的**排序。这意味着具有相同排序键的数组元素在排序后将保持相对于彼此的相同顺序。这对于数字或字符串等简单值并不重要，但在排序更复杂的对象时可能会出现问题。

## See also
## 扩展阅读

[Merge sort on Wikipedia](https://en.wikipedia.org/wiki/Merge_sort)
[归并排序的维基百科](https://en.wikipedia.org/wiki/Merge_sort)

*Written by Kelvin Lau. Additions by Matthijs Hollemans.*
*作者：Kelvin Lau. Additions ， Matthijs Hollemans*  
*翻译：Andy Ron*