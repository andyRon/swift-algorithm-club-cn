# Quicksort
# 快速排序

Goal: Sort an array from low to high (or high to low).
目标：将数组从低到高（或从高到低）排序。

Quicksort is one of the most famous algorithms in history. It was invented way back in 1959 by Tony Hoare, at a time when recursion was still a fairly nebulous concept.
Quicksort是历史上最着名的算法之一。 它是由Tony Hoare于1959年发明的，当时递归仍然是一个相当模糊的概念。

Here's an implementation in Swift that should be easy to understand:
这是Swift中的一个实现，应该很容易理解：

```swift
func quicksort<T: Comparable>(_ a: [T]) -> [T] {
  guard a.count > 1 else { return a }

  let pivot = a[a.count/2]
  let less = a.filter { $0 < pivot }
  let equal = a.filter { $0 == pivot }
  let greater = a.filter { $0 > pivot }

  return quicksort(less) + equal + quicksort(greater)
}
```

Put this code in a playground and test it like so:
将此代码放在playground 进行测试：

```swift
let list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
quicksort(list)
```

Here's how it works. When given an array, `quicksort()` splits it up into three parts based on a "pivot" variable. Here, the pivot is taken to be the element in the middle of the array (later on you'll see other ways to choose the pivot).
这是它的工作原理。 给定一个数组时，`quicksort()`根据“pivot”变量将它分成三部分。这里，枢轴被视为数组中间的元素（稍后您将看到选择枢轴的其他方法）。

All the elements less than the pivot go into a new array called `less`. All the elements equal to the pivot go into the `equal` array. And you guessed it, all elements greater than the pivot go into the third array, `greater`. This is why the generic type `T` must be `Comparable`, so we can compare the elements with `<`, `==`, and `>`.
比枢轴小的所有元素都进入一个名为`less`的新数组。 所有等于pivot的元素都进入`equal`数组。 你猜对了，所有比枢轴更大的元素进入第三个数组，“更大”。 这就是泛型类型`T`必须是`Comparable`的原因，所以我们可以将元素与`<`，`==`和`>`进行比较。

Once we have these three arrays, `quicksort()` recursively sorts the `less` array and the `greater` array, then glues those sorted subarrays back together with the `equal` array to get the final result.
一旦我们有了这三个数组，`quicksort()`递归地对`less`数组和`more`数组进行排序，然后将那些已排序的子数组与`equal`数组粘合在一起，得到最终结果。

## An example
## 一个例子

Let's walk through the example. The array is initially:
让我们来看看这个例子。 该数组最初是：

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

First, we pick the pivot element. That is `8` because it's in the middle of the array. Now we split the array into the less, equal, and greater parts:
首先，我们选择枢轴元素。 那是`8`因为它在数组的中间。 现在我们将数组拆分为更少，相等和更大的部分：

	less:    [ 0, 3, 2, 1, 5, -1 ]
	equal:   [ 8, 8 ]
	greater: [ 10, 9, 14, 27, 26 ]

This is a good split because `less` and `greater` roughly contain the same number of elements. So we've picked a good pivot that chopped the array right down the middle.
这是一个很好的分裂，因为`less`和`greater`大致包含相同数量的元素。 所以我们选择了一个很好的枢轴，将数组从中间切下来。

Note that the `less` and `greater` arrays aren't sorted yet, so we call `quicksort()` again to sort those two subarrays. That does the exact same thing: pick a pivot and split the subarray into three even smaller parts.
请注意，`less`和`greater`数组尚未排序，因此我们再次调用`quicksort()`来排序这两个子数组。这完全相同：选择一个枢轴并将子数组分成三个甚至更小的部分。

Let's just take a look at the `less` array:
我们来看看`less`数组：

	[ 0, 3, 2, 1, 5, -1 ]

The pivot element is the one in the middle, `1`. (You could also have picked `2`, it doesn't matter.) Again, we create three subarrays around the pivot:
枢轴元素是中间的`1`（你也可以选择`2`，这没关系）。再次，我们围绕枢轴创建了三个子数组：

	less:    [ 0, -1 ]
	equal:   [ 1 ]
	greater: [ 3, 2, 5 ]

We're not done yet and `quicksort()` again is called recursively on the `less` and `greater` arrays. Let's look at `less` again:
我们还没有完成，并且`quicksort（）`再次在`less`和`more`数组上被递归调用。 让我们再看一下`less`：

	[ 0, -1 ]

As pivot we pick `-1`. Now the subarrays are:
作为枢轴我们选择`-1`。 现在的子数组是：

	less:    [ ]
	equal:   [ -1 ]
	greater: [ 0 ]

The `less` array is empty because there was no value smaller than `-1`; the other arrays contain a single element each. That means we're done at this level of the recursion, and we go back up to sort the previous `greater` array.
`less`数组是空的，因为没有小于`-1`的值; 其他数组各包含一个元素。 这意味着我们已经完成了递归的这个级别，并且我们返回以对先前的`more`数组进行排序。

That `greater` array was:
`less`数组是:

	[ 3, 2, 5 ]

This works just the same way as before: we pick the middle element `2` as the pivot and fill up the subarrays:
这与以前的工作方式相同：我们选择中间元素`2`作为枢轴并填充子数组：

	less:    [ ]
	equal:   [ 2 ]
	greater: [ 3, 5 ]

Note that here it would have been better to pick `3` as the pivot -- we would have been done sooner. But now we have to recurse into the `greater` array again to make sure it is sorted. This is why picking a good pivot is important. When you pick too many "bad" pivots, quicksort actually becomes really slow. More on that below.
请注意，在这里选择`3`作为支点会更好 -- 我们会早点完成。 但是现在我们必须再次递归到`more`数组以确保它被排序。这就是选择好的支点很重要的原因。当你选择太多“坏”支点时，快速排序实际上变得非常慢。 更多关于以下内容。

When we partition the `greater` subarray, we find:
当我们对`more`子数组进行分区时，我们发现：

	less:    [ 3 ]
	equal:   [ 5 ]
	greater: [ ]

And now we're done at this level of the recursion because we can't split up the arrays any further.
现在我们已经完成了递归的这个级别，因为我们无法进一步拆分数组。

This process repeats until all the subarrays have been sorted. In a picture:
重复此过程，直到所有子数组都已排序。 例子图：

![Example](Images/Example.png)

Now if you read the colored boxes from left to right, you get the sorted array:
现在，如果您从左到右阅读彩色框，则会获得已排序的数组：

	[ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]

This shows that `8` was a good initial pivot because it appears in the middle of the sorted array too.
这表明`8`是一个很好的初始枢轴，因为它也出现在排序数组的中间。

I hope this makes the basic principle clear of how quicksort works. Unfortunately, this version of quicksort isn't very quick, because we `filter()` the same array three times. There are more clever ways to split up the array.
我希望这使得基本原理清楚地表明quicksort的工作原理。 不幸的是，这个版本的quicksort不是很快，因为我们`filter()`相同的数组三次。 有更聪明的方法来分割阵列。

## Partitioning
## 分区

Dividing the array around the pivot is called *partitioning* and there are a few different partitioning schemes.
围绕数据块划分数组称为 *分区*，并且存在一些不同的分区方案。

If the array is,
如果数组是，

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

and we choose the middle element `8` as a pivot then after partitioning the array will look like this:
然后我们选择中间元素`8`作为一个数据块，然后分区后数组将如下所示：

	[ 0, 3, 2, 1, 5, -1, 8, 8, 10, 9, 14, 27, 26 ]
	  -----------------        -----------------
	  all elements < 8         all elements > 8

The key thing to realize is that after partitioning the pivot element is in its final sorted place already. The rest of the numbers are not sorted yet, they are simply partitioned around the pivot value. Quicksort partitions the array many times over, until all the values are in their final places.
要实现的关键是，在分区之后，枢轴元素已经处于其最终排序位置。 其余的数字尚未排序，它们只是围绕数值分区。 Quicksort对数组进行多次分区，直到所有值都在最终位置。

There is no guarantee that partitioning keeps the elements in the same relative order, so after partitioning around pivot `8` you could also end up with something like this:
无法保证分区将元素保持在相同的相对顺序中，因此在使用pivot“8”进行分区之后，您最终也会得到类似这样的内容：

	[ 3, 0, 5, 2, -1, 1, 8, 8, 14, 26, 10, 27, 9 ]

The only guarantee is that to the left of the pivot are all the smaller elements and to the right are all the larger elements. Because partitioning can change the original order of equal elements, quicksort does not produce a "stable" sort (unlike [merge sort](../Merge%20Sort/), for example). Most of the time that's not a big deal.
唯一的保证是在枢轴的左边是所有较小的元素，而右边是所有较大的元素。 因为分区可以改变相等元素的原始顺序，所以quicksort不会产生“稳定”排序（例如，与[归并排序](../Merge％20Sort/)不同）。 大部分时间都不是什么大不了的事。

## Lomuto's partitioning scheme
## Lomuto的分区方案

In the first example of quicksort I showed you, partitioning was done by calling Swift's `filter()` function three times. That is not very efficient. So let's look at a smarter partitioning algorithm that works *in place*, i.e. by modifying the original array.
在快速排序的第一个例子中，我告诉你，分区是通过调用Swift的`filter()`函数三次来完成的。 这不是很有效。 因此，让我们看一个更智能的分区算法，它可以*就地*，即通过修改原始数组。

Here's an implementation of Lomuto's partitioning scheme in Swift:
这是在Swift中实现Lomuto的分区方案：

```swift
func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
  let pivot = a[high]

  var i = low
  for j in low..<high {
    if a[j] <= pivot {
      (a[i], a[j]) = (a[j], a[i])
      i += 1
    }
  }

  (a[i], a[high]) = (a[high], a[i])
  return i
}
```

To test this in a playground, do:
在playground中测试：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
let p = partitionLomuto(&list, low: 0, high: list.count - 1)
list  // show the results
```

Note that `list` needs to be a `var` because `partitionLomuto()` directly changes the contents of the array (it is passed as an `inout` parameter). That is much more efficient than allocating a new array object.
注意`list`需要是`var`，因为`partitionLomuto()`直接改变数组的内容（它作为`inout`参数传递）。 这比分配新的数组对象更有效。

The `low` and `high` parameters are necessary because when this is used inside quicksort, you don't always want to (re)partition the entire array, only a limited range that becomes smaller and smaller.
`low`和`high`参数是必要的，因为当在quicksort中使用它时，你并不总是想要（重新）分区整个数组，只有有限的范围变得越来越小。

Previously we used the middle array element as the pivot but it's important to realize that the Lomuto algorithm always uses the *last* element, `a[high]`, for the pivot. Because we've been pivoting around `8` all this time, I swapped the positions of `8` and `26` in the example so that `8` is at the end of the array and is used as the pivot value here too.
以前我们使用中间数组元素作为枢轴，但重要的是要意识到Lomuto算法总是使用 *last* 元素，`a [high]` 作为数据透视表。 因为我们一直在绕着`8`旋转，所以我在示例中交换了`8`和`26`的位置，以便`8`位于数组的末尾并且在这里也用作枢轴值。

After partitioning, the array looks like this:
分区后，数组如下所示：

	[ 0, 3, 2, 1, 5, 8, -1, 8, 9, 10, 14, 26, 27 ]
	                        *

The variable `p` contains the return value of the call to `partitionLomuto()` and is 7. This is the index of the pivot element in the new array (marked with a star).
变量`p`包含对`partitionLomuto()`的调用的返回值，并且是7。这是新数组中的pivot元素的索引（用星号标记）。

The left partition goes from 0 to `p-1` and is `[ 0, 3, 2, 1, 5, 8, -1 ]`. The right partition goes from `p+1` to the end, and is `[ 9, 10, 14, 26, 27 ]` (the fact that the right partition is already sorted is a coincidence).
左分区从0到`p-1`并且是`[0,3,2,1,5,8，-1]`。 正确的分区从`p + 1`到结尾，并且是`[9,10,14,26,27]`（右分区已经排序的事实是巧合）。

You may notice something interesting... The value `8` occurs more than once in the array. One of those `8`s did not end up neatly in the middle but somewhere in the left partition. That's a small downside of the Lomuto algorithm as it makes quicksort slower if there are a lot of duplicate elements.
您可能会注意到一些有趣的东西......值`8`在数组中出现不止一次。 其中一个`8`并没有整齐地在中间，而是在左侧分区的某个地方。 这是Lomuto算法的一个小缺点，因为如果存在大量重复元素，它会使快速排序变慢。

So how does the Lomuto algorithm actually work? The magic happens in the `for` loop. This loop divides the array into four regions:
那么Lomuto算法实际上是如何工作的呢？ 魔术发生在`for`循环中。 此循环将数组划分为四个区域：

1. `a[low...i]` contains all values <= pivot
2. `a[i+1...j-1]` contains all values > pivot
3. `a[j...high-1]` are values we haven't looked at yet
4. `a[high]` is the pivot value
1. `a [low ... i]`包含所有值<= pivot
2. `a [i + 1 ... j-1]`包含所有值> pivot
3. `a [j ... high-1]`是我们还没有看过的值
4. `a [high]`是枢轴值

In ASCII art the array is divided up like this:
在ASCII艺术中，数组按如下方式划分：

	[ values <= pivot | values > pivot | not looked at yet | pivot ]
	  low           i   i+1        j-1   j          high-1   high

The loop looks at each element from `low` to `high-1` in turn. If the value of the current element is less than or equal to the pivot, it is moved into the first region using a swap.
循环依次查看从`low`到`high-1`的每个元素。 如果当前元素的值小于或等于pivot，则使用swap将其移动到第一个区域。

> **Note:** In Swift, the notation `(x, y) = (y, x)` is a convenient way to perform a swap between the values of `x` and `y`. You can also write `swap(&x, &y)`.
> **注意：** 在Swift中，符号`（x，y）=（y，x）`是在`x`和`y`的值之间执行交换的便捷方式。 你也可以使用`swap（＆x，＆y）`。

After the loop is over, the pivot is still the last element in the array. So we swap it with the first element that is greater than the pivot. Now the pivot sits between the <= and > regions and the array is properly partitioned.
循环结束后，pivot仍然是数组中的最后一个元素。 所以我们将它与第一个大于枢轴的元素交换。 现在，枢轴位于<=和>区域之间，并且数组已正确分区。

Let's step through the example. The array we're starting with is:
让我们逐步完成这个例子。 我们开始的数组是：

	[| 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                       high
	   i
	   j

Initially, the "not looked at" region stretches from index 0 to 11. The pivot is at index 12. The "values <= pivot" and "values > pivot" regions are empty, because we haven't looked at any values yet.
最初，“未查看”区域从索引0延伸到11。枢轴位于索引12。“values <= pivot”和“values> pivot”区域为空，因为我们还没有查看任何值。

Look at the first value, `10`. Is this smaller than the pivot? No, skip to the next element.	
看第一个值，`10`。 这比枢轴小吗？ 不，跳到下一个元素。  

	[| 10 | 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                        high
	   i
	       j

Now the "not looked at" region goes from index 1 to 11, the "values > pivot" region contains the number `10`, and "values <= pivot" is still empty.
现在“未查看”区域从索引1到11，“values> pivot”区域包含数字“10”，“values <= pivot”仍为空。

Look at the second value, `0`. Is this smaller than the pivot? Yes, so swap `10` with `0` and move `i` ahead by one.
看第二个值，`0`。 这比枢轴小吗？ 是的，所以将`10`与`0`交换，然后将`i`向前移动一个。

	[ 0 | 10 | 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	      i
	           j

Now "not looked at" goes from index 2 to 11, "values > pivot" still contains `10`, and "values <= pivot" contains the number `0`.
现在“未看”从索引2到11，“values> pivot”仍然包含“10”，“values <= pivot”包含数字“0”。

Look at the third value, `3`. This is smaller than the pivot, so swap it with `10` to get:
看第三个值，`3`。 这比枢轴小，所以用`10`换掉它得到：

	[ 0, 3 | 10 | 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	             j

The "values <= pivot" region is now `[ 0, 3 ]`. Let's do one more... `9` is greater than the pivot, so simply skip ahead:
“values <= pivot”区域现在是“[0,3]”。 让我们再做一次......`9`大于枢轴，所以简单地向前跳：

	[ 0, 3 | 10, 9 | 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	                 j

Now the "values > pivot" region contains `[ 10, 9 ]`. If we keep going this way, then eventually we end up with:
现在“values> pivot”区域包含`[10,9]`。 如果我们继续这样做，那么我们最终会得到：

	[ 0, 3, 2, 1, 5, 8, -1 | 27, 9, 10, 14, 26 | 8 ]
	  low                                        high
	                         i                   j

The final thing to do is to put the pivot into place by swapping `a[i]` with `a[high]`:
最后要做的是通过将`a [i]`与`a [high]`交换来将枢轴放到位：

	[ 0, 3, 2, 1, 5, 8, -1 | 8 | 9, 10, 14, 26, 27 ]
	  low                                       high
	                         i                  j

And we return `i`, the index of the pivot element.
然后我们返回`i`，pivot元素的索引。

> **Note:** If you're still not entirely clear on how the algorithm works, I suggest you play with this in the playground to see exactly how the loop creates these four regions.
> **注意：** 如果您仍然不完全清楚算法是如何工作的，我建议您在playground 玩这个，以确切了解循环如何创建这四个区域。

Let's use this partitioning scheme to build quicksort. Here's the code:
让我们使用这个分区方案来构建快速排序。 这是代码：

```swift
func quicksortLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let p = partitionLomuto(&a, low: low, high: high)
    quicksortLomuto(&a, low: low, high: p - 1)
    quicksortLomuto(&a, low: p + 1, high: high)
  }
}
```

This is now super simple. We first call `partitionLomuto()` to reorder the array around the pivot (which is always the last element from the array). And then we call `quicksortLomuto()` recursively to sort the left and right partitions.
现在这非常简单。 我们首先调用`partitionLomuto（）`来重新排序数组周围的数组（它始终是数组中的最后一个元素）。 然后我们递归调用`quicksortLomuto（）`来对左右分区进行排序。

Try it out:
试试看：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
quicksortLomuto(&list, low: 0, high: list.count - 1)
```

Lomuto's isn't the only partitioning scheme but it's probably the easiest to understand. It's not as efficient as Hoare's scheme, which requires fewer swap operations.
Lomuto不是唯一的分区方案，但它可能是最容易理解的。 它不如Hoare的方案有效，后者需要更少的交换操作。

## Hoare's partitioning scheme
## Hoare的分区方案

This partitioning scheme is by Hoare, the inventor of quicksort.
这种分区方案是由quicksort的发明者Hoare完成的。

Here is the code:
下面是代码：

```Swift
func partitionHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
  let pivot = a[low]
  var i = low - 1
  var j = high + 1

  while true {
    repeat { j -= 1 } while a[j] > pivot
    repeat { i += 1 } while a[i] < pivot

    if i < j {
      swap(&a[i], &a[j])
    } else {
      return j
    }
  }
}
```

To test this in a playground, do:
在playground中测试：

```swift
var list = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
let p = partitionHoare(&list, low: 0, high: list.count - 1)
list  // show the results
```

Note that with Hoare's scheme, the pivot is always expected to be the *first* element in the array, `a[low]`. Again, we're using `8` as the pivot element.
注意，使用Hoare的方案，数据总是应该是数组中的 *first* 元素，`a [low]`。 同样，我们使用`8`作为枢轴元素。

The result is:
结果是：

	[ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]

Note that this time the pivot isn't in the middle at all. Unlike with Lomuto's scheme, the return value is not necessarily the index of the pivot element in the new array.
请注意，这次枢轴根本不在中间。 与Lomuto的方案不同，返回值不一定是新数组中pivot元素的索引。

Instead, the array is partitioned into the regions `[low...p]` and `[p+1...high]`. Here, the return value `p` is 6, so the two partitions are `[ -1, 0, 3, 8, 2, 5, 1 ]` and `[ 27, 10, 14, 9, 8, 26 ]`.

The pivot is placed somewhere inside one of the two partitions, but the algorithm doesn't tell you which one or where. If the pivot value occurs more than once, then some instances may appear in the left partition and others may appear in the right partition.
相反，数组被划分为区域`[low ... p]`和`[p + 1 ... high]`。 这里，返回值`p`是6，所以两个分区是`[-1,0,3,8,2,5,1]`和`[27,10,14,9,8,26]`。

Because of these differences, the implementation of Hoare's quicksort is slightly different:
由于存在这些差异，Hoare快速排序的实施略有不同：

```swift
func quicksortHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let p = partitionHoare(&a, low: low, high: high)
    quicksortHoare(&a, low: low, high: p)
    quicksortHoare(&a, low: p + 1, high: high)
  }
}
```

I'll leave it as an exercise for the reader to figure out exactly how Hoare's partitioning scheme works. :-)
我将把它作为练习让读者弄清楚Hoare的分区方案是如何工作的。:-)

## Picking a good pivot
## 选择一个好的支点

Lomuto's partitioning scheme always chooses the last array element for the pivot. Hoare's scheme uses the first element. But there is no guarantee that these pivots are any good.
Lomuto的分区方案总是为枢轴选择最后一个数组元素。 霍尔的计划使用第一个元素。 但不能保证这些枢纽有任何好处。

Here is what happens when you pick a bad value for the pivot. Let's say the array is,
以下是为枢轴选择错误值时会发生的情况。 我们说数组是，

	[ 7, 6, 5, 4, 3, 2, 1 ]

and we're using Lomuto's scheme. The pivot is the last element, `1`. After pivoting, we have the following arrays:
我们正在使用Lomuto的计划。 枢轴是最后一个元素，`1`。 在透视后，我们有以下数组：

	   less than pivot: [ ]
	    equal to pivot: [ 1 ]
	greater than pivot: [ 7, 6, 5, 4, 3, 2 ]

Now recursively partition the "greater than" subarray and get:
现在以递归方式对“大于”子数组进行分区，得到：

	   less than pivot: [ ]
	    equal to pivot: [ 2 ]
	greater than pivot: [ 7, 6, 5, 4, 3 ]

And again:
再次：

	   less than pivot: [ ]
	    equal to pivot: [ 3 ]
	greater than pivot: [ 7, 6, 5, 4 ]

And so on...
等等

That's no good, because this pretty much reduces quicksort to the much slower insertion sort. For quicksort to be efficient, it needs to split the array into roughly two halves.
这并不好，因为这大大减少了快速排序到更慢的插入排序。 为了使quicksort高效，它需要将数组分成大约两半。

The optimal pivot for this example would have been `4`, so we'd get:
这个例子的最佳支点是`4`，所以我们得到：

	   less than pivot: [ 3, 2, 1 ]
	    equal to pivot: [ 4 ]
	greater than pivot: [ 7, 6, 5 ]

You might think this means we should always choose the middle element rather than the first or the last, but imagine what happens in the following situation:
您可能认为这意味着我们应该始终选择中间元素而不是第一个或最后一个，但想象在以下情况下会发生什么：

	[ 7, 6, 5, 1, 4, 3, 2 ]

Now the middle element is `1` and that gives the same lousy results as in the previous example.
现在，中间元素是`1`，它给出了与前一个例子相同的糟糕结果。

Ideally, the pivot is the *median* element of the array that you're partitioning, i.e. the element that sits in the middle of the sorted array. Of course, you won't know what the median is until after you've sorted the array, so this is a bit of a chicken-and-egg problem. However, there are some tricks to choose good, if not ideal, pivots.
理想情况下，pivot是您要分区的数组的 *median* 元素，即位于排序数组中间的元素。当然，在你对数组进行排序之前，你不会知道中位数是什么，所以这有点鸡蛋和鸡蛋问题。然而，有一些技巧可以选择好的，如果不是理想的话。

One trick is "median-of-three", where you find the median of the first, middle, and last element in this subarray. In theory that often gives a good approximation of the true median.
一个技巧是“三个中间值”，您可以在其中找到此子数组中第一个，中间和最后一个元素的中位数。 从理论上讲，这通常可以很好地逼近真实的中位数。

Another common solution is to choose the pivot randomly. Sometimes this may result in choosing a suboptimal pivot but on average this gives very good results.
另一种常见的解决方案是随机选择枢轴。 有时这可能会导致选择次优的枢轴，但平均而言，这会产生非常好的结果。

Here is how you can do quicksort with a randomly chosen pivot:
以下是如何使用随机选择的枢轴进行快速排序：

```swift
func quicksortRandom<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let pivotIndex = random(min: low, max: high)         // 1

    (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])  // 2

    let p = partitionLomuto(&a, low: low, high: high)
    quicksortRandom(&a, low: low, high: p - 1)
    quicksortRandom(&a, low: p + 1, high: high)
  }
}
```

There are two important differences with before:
之前有两个重要的区别：

1. The `random(min:max:)` function returns an integer in the range `min...max`, inclusive. This is our pivot index.
1. `random（min：max：）`函数返回`min ... max`范围内的整数，包括在内。 这是我们的支点指数。

2. Because the Lomuto scheme expects `a[high]` to be the pivot entry, we swap `a[pivotIndex]` with `a[high]` to put the pivot element at the end before calling `partitionLomuto()`.
2.因为Lomuto方案期望`a [high]`成为pivot条目，我们将`a [pivotIndex]`与`a [high]`交换，将pivot元素放在末尾，然后再调用`partitionLomuto（）`。

It may seem strange to use random numbers in something like a sorting function, but it is necessary to make quicksort behave efficiently under all circumstances. With bad pivots, the performance of quicksort can be quite horrible, **O(n^2)**. But if you choose good pivots on average, for example by using a random number generator, the expected running time becomes **O(n log n)**, which is as good as sorting algorithms get.
在类似排序函数的东西中使用随机数似乎很奇怪，但有必要使quicksort在所有情况下都能有效地运行。 有了坏的支点，快速排序的表现可能非常糟糕，**O(n^2)**。 但是如果平均选择好的枢轴，例如使用随机数生成器，预期的运行时间将变为**O(nlogn)**，这与排序算法得到的一样好。



## Dutch national flag partitioning

But there are more improvements to make! In the first example of quicksort I showed you, we ended up with an array that was partitioned like this:
但是还有更多改进！ 在我向您展示的第一个quicksort示例中，我们最终得到了一个像这样分区的数组：

	[ values < pivot | values equal to pivot | values > pivot ]

But as you've seen with the Lomuto partitioning scheme, if the pivot occurs more than once the duplicates end up in the left half. And with Hoare's scheme the pivot can be all over the place. The solution to this is "Dutch national flag" partitioning, named after the fact that the [Dutch flag](https://en.wikipedia.org/wiki/Flag_of_the_Netherlands) has three bands just like we want to have three partitions.
但是正如您在Lomuto分区方案中看到的那样，如果多次出现枢轴，则重复项会在左半部分结束。 而通过Hoare的计划，枢纽可以遍布整个地方。 解决这个问题的方法是“荷兰国旗”分区，以[荷兰国旗](https://en.wikipedia.org/wiki/Flag_of_the_Netherlands)有三个频段命名，就像我们想拥有三个分区一样。


The code for this scheme is:
该方案的代码是：

```swift
func partitionDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
  let pivot = a[pivotIndex]

  var smaller = low
  var equal = low
  var larger = high

  while equal <= larger {
    if a[equal] < pivot {
      swap(&a, smaller, equal)
      smaller += 1
      equal += 1
    } else if a[equal] == pivot {
      equal += 1
    } else {
      swap(&a, equal, larger)
      larger -= 1
    }
  }
  return (smaller, larger)
}
```

This works very similarly to the Lomuto scheme, except that the loop partitions the array into four (possibly empty) regions:
这与Lomuto方案的工作方式非常相似，只是循环将数组划分为四个（可能为空）区域：

- `[low ... smaller-1]` contains all values < pivot
- `[smaller ... equal-1]` contains all values == pivot
- `[equal ... larger]` contains all values > pivot
- `[larger ... high]` are values we haven't looked at yet
- `[low ... smaller-1]` 包含所有值< pivot
- `[less ... equal-1]` 包含所有值 == pivot
- `[等于...更大]`包含所有值> pivot
- `[large ... high]`是我们还没看过的值

Note that this doesn't assume the pivot is in `a[high]`. Instead, you have to pass in the index of the element you wish to use as a pivot.
请注意，这并不假设枢轴处于`a [high]`。 相反，您必须传入要用作枢轴的元素的索引。

An example of how to use it:
如何使用它的一个例子：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
partitionDutchFlag(&list, low: 0, high: list.count - 1, pivotIndex: 10)
list  // show the results
```

Just for fun, we're giving it the index of the other `8` this time. The result is:
只是为了好玩，我们这次给它的另一个`8`的索引。 结果是：

	[ -1, 0, 3, 2, 5, 1, 8, 8, 27, 14, 9, 26, 10 ]

Notice how the two `8`s are in the middle now. The return value from `partitionDutchFlag()` is a tuple, `(6, 7)`. This is the range that contains the pivot value(s).
注意两个`8`现在是如何在中间的。 `partitionDutchFlag()`的返回值是一个元组，`(6,7)`。 这是包含透视值的范围。

Here is how you would use it in quicksort:
以下是如何在快速排序中使用它：

```swift
func quicksortDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let pivotIndex = random(min: low, max: high)
    let (p, q) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: pivotIndex)
    quicksortDutchFlag(&a, low: low, high: p - 1)
    quicksortDutchFlag(&a, low: q + 1, high: high)
  }
}
```

Using Dutch flag partitioning makes for a more efficient quicksort if the array contains many duplicate elements. (And I'm not just saying that because I'm Dutch!)
如果数组包含许多重复元素，则使用荷兰语标记分区可以提高效率。 （而且我不只是这么说，因为我是荷兰人！）

> **Note:** The above implementation of `partitionDutchFlag()` uses a custom `swap()` routine for swapping the contents of two array elements. Unlike Swift's own `swap()`, this doesn't give an error when the two indices refer to the same array element. See [Quicksort.swift](Quicksort.swift) for the code.
> **注意：** `partitionDutchFlag()`的上述实现使用自定义`swap（）`例程来交换两个数组元素的内容。 与Swift自己的`swap（）`不同，当两个索引引用相同的数组元素时，这不会产生错误。 请参阅[Quicksort.swift]（Quicksort.swift）获取代码。

## See also
## 扩展阅读


[快速排序的维基百科](https://en.wikipedia.org/wiki/Quicksort)

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*