# 归并排序（Merge Sort）

> 这个主题已经有辅导[文章](https://www.raywenderlich.com/154256/swift-algorithm-club-swift-merge-sort)

目标：将数组从低到高（或从高到低）排序

归并排序是1945年由John von Neumann发明的，是一种有效的算法，最佳、最差和平均时间复杂度都是**O(n log n)**。

归并排序算法使用**分而治之**方法，即将一个大问题分解为较小的问题并解决它们。 归并排序算法可分为 **先拆分** 和 **后合并**。

假设您需要按正确的顺序对长度为 *n* 的数组进行排序。 归并排序算法的工作原理如下：
- 将数字放在未排序的堆中。
- 将堆分成两部分。 那么现在就有**两个未排序的数字堆**。
- 继续分裂**两个未排序的数字堆**，直到你不能分裂为止。 最后，你将拥有 *n* 个堆，每堆中有一个数字。
- 通过顺序配对，开始 **合并** 堆。 在每次合并期间，将内容按排序顺序排列。 这很容易，因为每个单独的堆已经排序（译注：单个数字没有所谓的顺序，就是排好序的）。

## 例子

### 拆分

假设给你一个长度为*n*的未排序数组：`[2,1,5,4,9]`。 目标是不断拆分堆，直到你不能拆分为止。

首先，将数组分成两半：`[2,1]`和`[5,4,9]`。 你能继续拆分吗？ 是的你可以！

专注于左边堆。 将`[2,1]`拆分为`[2]`和`[1]`。 你能继续拆分吗？ 不能了。检查右边的堆。


将`[5,4,9]`拆分为`[5]`和`[4,9]`。 不出所料，`[5]`不能再拆分了，但是`[4,9]`可以分成`[4]`和`[9]`。

拆分最终结果为：`[2]``[1]``[5]``[4]``[9]`。 请注意，每个堆只包含一个元素。

### 合并

您已经拆分了数组，您现在应该 **合并并排序** 拆分后的堆。 请记住，这个想法是解决许多小问题而不是一个大问题。 对于每次合并迭代，您必须关注将一堆与另一堆合并。

对于堆 `[2]` `[1]` `[5]` `[4]` `[9]`，第一次合并的结果是`[1,2]`和`[4,5]` 和`[9]`。 由于`[9]`的位置落单，所以在合并过程中没有堆与之合并了。

下一次将合并`[1,2]`和`[4,5]`。 结果`[1,2,4,5]`，再次由于`[9]`的位置落单不需要合并。

只剩下两堆`[1,2,4,5]`和`[9]`，合并后完成排序的数组为`[1,2,4,5,9]`。


## 自上而下的实施(递归法)

归并排序的Swift实现：

```swift
func mergeSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }    // 1

  let middleIndex = array.count / 2              // 2

  let leftArray = mergeSort(Array(array[0..<middleIndex]))             // 3

  let rightArray = mergeSort(Array(array[middleIndex..<array.count]))  // 4

  return merge(leftPile: leftArray, rightPile: rightArray)             // 5
}
```

代码的逐步说明：

1. 如果数组为空或包含单个元素，则无法将其拆分为更小的部分，返回数组就行。

2. 找到中间索引。

3. 使用上一步中的中间索引，递归地分割数组的左侧。

4. 此外，递归地分割数组的右侧。

5. 最后，将所有值合并在一起，确保它始终排序。

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

这种方法可能看起来很可怕，但它非常简单：

1. 在合并时，您需要两个索引来跟踪两个数组的进度。

2. 这是合并后的数组。 它现在是空的，但是你将在下面的步骤中通过添加其他数组中的元素构建它。

3. 这个while循环将比较左侧和右侧的元素，并将它们添加到`orderedPile`，同时确保结果保持有序。

4. 如果前一个while循环完成，则意味着`leftPile`或`rightPile`中的一个的内容已经完全合并到`orderedPile`中。此时，您不再需要进行比较。只需依次添加剩下一个数组的其余内容到`orderedPile`。


`merge()`函数如何工作的例子。假设我们有以两个个堆：`leftPile = [1,7,8]`和`rightPile = [3,6,9]`。 请注意，这两个堆都已单独排序 -- 合并排序总是如此的。 下面的步骤就将它们合并为一个更大的排好序的堆：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ ]
    l              r

左侧索引（此处表示为`l`）指向左侧堆的第一个项目`1`。 右则索引`r`指向`3`。 因此，我们添加到`orderedPile`的第一项是`1`。 我们还将左侧索引`l`移动到下一个项。

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1 ]
    -->l           r

现在`l`指向`7`但是`r`仍然处于`3`。 我们将最小的项`3`添加到有序堆中。 现在的情况是：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3 ]
       l           -->r

重复上面的过程。 在每一步中，我们从`leftPile`或`rightPile`中选择最小的项，并将该项添加到`orderedPile`中：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6 ]
       l              -->r

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7 ]
       -->l              r

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7, 8 ]
          -->l           r

现在，左堆中没有更多物品了。 我们只需从右边的堆中添加剩余的项目，我们就完成了。 合并的堆是`[1,3,6,7,8,9]`。

请注意，此算法非常简单：它从左向右移动通过两个堆，并在每个步骤选择最小的项目。 这是有效的，因为我们保证每个堆都已经排序。

> 译注： 关于自上而下的执行(递归法)的归并排序，我找了一个比较形象的动图，[来源](http://www.algomation.com/player?algorithm=58bb32885b2b830400b05123)
![递归的归并排序](https://upload-images.jianshu.io/upload_images/1678135-b740499f7c9123ba.gif?imageMogr2/auto-orient/strip)

## 自下而上的实施(迭代)

到目前为止你看到的合并排序算法的实现被称为“自上而下”的方法，因为它首先将数组拆分成更小的堆然后合并它们。排序数组（而不是链表）时，实际上可以跳过拆分步骤并立即开始合并各个数组元素。 这被称为“自下而上”的方法。

下面是Swift中一个完整的自下而上的实现：
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

它看起来比自上而下的版本更令人生畏，但请注意主体包含与`merge()`相同的三个`while`循环。

值得注意的要点：

1. 归并排序算法需要一个临时工作数组，因为你不能合并左右堆并同时覆盖它们的内容。 因为为每个合并分配一个新数组是浪费，我们使用两个工作数组，我们将使用`d`的值在它们之间切换，它是0或1。数组`z[d]`用于读，`z[1 - d]`用于写。 这称为 *双缓冲*。

2. 从概念上讲，自下而上版本的工作方式与自上而下版本相同。首先，它合并每个元素的小堆，然后它合并每个堆两个元素，然后每个堆成四个元素，依此类推。堆的大小由`width`给出。 最初，`width`是`1`但是在每次循环迭代结束时，我们将它乘以2，所以这个外循环确定要合并的堆的大小，并且要合并的子数组在每一步中变得更大。

3. 内循环穿过堆并将每对堆合并成一个较大的堆。 结果写在`z[1 - d]`给出的数组中。

4. 这与自上而下版本的逻辑相同。 主要区别在于我们使用双缓冲，因此从`z[d]`读取值并写入`z [1 - d]`。它还使用`isOrderedBefore`函数来比较元素而不仅仅是`<`，因此这种合并排序算法是通用的，您可以使用它来对任何类型的对象进行排序。

5. 此时，数组`z[d]`的大小`width`的堆已经合并为数组`z[1-d]`中更大的大小`width * 2`。在这里，我们交换活动数组，以便在下一步中我们将从我们刚刚创建的新堆中读取。

这个函数是通用的，所以你可以使用它来对你想要的任何类型对象进行排序，只要你提供一个正确的`isOrderedBefore`闭包来比较元素。

怎么使用它的示例：

```swift
let array = [2, 1, 5, 4, 9]
mergeSortBottomUp(array, <)   // [1, 2, 4, 5, 9]
```

> 译注：关于迭代的归并排序，我找到一个图来表示，[来源](http://www.mathcs.emory.edu/~cheung/Courses/171/Syllabus/7-Sort/merge-sort5.html)
![迭代的归并排序](https://upload-images.jianshu.io/upload_images/1678135-2114876be820349b.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 性能

归并排序算法的速度取决于它需要排序的数组的大小。 数组越大，它需要做的工作就越多。

初始数组是否已经排序不会影响归并排序算法的速度，因为无论元素的初始顺序如何，您都将进行相同数量的拆分和比较。

因此，最佳，最差和平均情况的时间复杂度将始终为 **O(n log n)**。

归并排序算法的一个缺点是它需要一个临时的“工作”数组，其大小与被排序的数组相同。 它不是**原地**排序，不像例如[quicksort](../Quicksort/)。

大多数实现归并排序算法是**稳定的**排序。这意味着具有相同排序键的数组元素在排序后将保持相对于彼此的相同顺序。这对于数字或字符串等简单值并不重要，但在排序更复杂的对象时，如果不是**稳定的**排序可能会出现问题。

> 译注：当元素相同时，排序后依然保持排序之前的相对顺序，那么这个排序算法就是**稳定**的。稳定的排序有：[插入排序](../Insertion%20Sort/)、[计数排序](../Counting%20Sort/)、[归并排序](../Merge%20Sort/)、[基数排序](../Radix%20Sort/)等等，详见[穩定的排序](https://zh.wikipedia.org/wiki/排序算法#穩定的排序)。

## 扩展阅读

[归并排序的维基百科](https://en.wikipedia.org/wiki/Merge_sort)  

[归并排序的中文维基百科](https://zh.wikipedia.org/wiki/归并排序)

*作者：Kelvin Lau. Additions ， Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*