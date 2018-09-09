# Binary Search
# 二分搜索

Goal: Quickly find an element in an array.
目标：在数组中快速寻找一个元素。


Let's say you have an array of numbers and you want to determine whether a specific number is in that array, and if so, at which index.
假设你有一个数字数组，你想确定一个特定的数字是否在该数组中，如果在，那么获得那个数字的索引。

In most cases, Swift's `indexOf()` function is good enough for that:
对于上面的要求，Swift的`indexOf()`函数很容易达成：

```swift
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

numbers.indexOf(43)  // returns 15
```

The built-in `indexOf()` function performs a [linear search](../Linear%20Search/). In code that looks something like this:
内置的`indexOf()`函数实现的是[线性搜索](../Linear%20Search/README_zh.md)。代码看样子如下：

```swift
func linearSearch<T: Equatable>(_ a: [T], _ key: T) -> Int? {
    for i in 0 ..< a.count {
        if a[i] == key {
            return i
        }
    }
    return nil
}
```

And you'd use it like this:
使用如下：

```swift
linearSearch(numbers, 43)  // returns 15
```

So what's the problem? `linearSearch()` loops through the entire array from the beginning, until it finds the element you're looking for. In the worst case, the value isn't even in the array and all that work is done for nothing.
所以有什么问题？ `linearSearch（）`从头开始遍历整个数组，直到找到你正在寻找的元素。 在最坏的情况下，数值甚至不在数组中，所有工作都是无效的。

On average, the linear search algorithm needs to look at half the values in the array. If your array is large enough, this starts to become very slow!
平均而言，线性搜索算法需要查看数组中一半的值。 如果您的数组足够大，这将开始变得非常慢！

## Divide and conquer
## 分而治之

The classic way to speed this up is to use a *binary search*. The trick is to keep splitting the array in half until the value is found.
加快这一速度的经典方法是使用*二分搜索*。 诀窍是将数组分成两半，直到找到值。

For an array of size `n`, the performance is not **O(n)** as with linear search but only **O(log n)**. To put that in perspective, binary search on an array with 1,000,000 elements only takes about 20 steps to find what you're looking for, because `log_2(1,000,000) = 19.9`. And for an array with a billion elements it only takes 30 steps. (Then again, when was the last time you used an array with a billion items?)
对于大小为“n”的数组，性能不是**O(n)**，与线性搜索一样，但只有**O(log n)**。换句话说，对具有1,000,000个元素的数组进行二进制搜索只需要大约20个步骤来查找要查找的内容，因为`log_2（1,000,000）= 19.9`。 对于具有十亿个元素的数组，它只需要30步。 （然而，你最后一次使用数十亿项的数组是什么时候？）

Sounds great, but there is a downside to using binary search: the array must be sorted. In practice, this usually isn't a problem.
听起来很棒，但使用二进制搜索有一个缺点：必须对数组进行排序。 在实践中，这通常不是问题。

Here's how binary search works:
这是二分搜索的工作原理：

- Split the array in half and determine whether the thing you're looking for, known as the *search key*, is in the left half or in the right half.
- How do you determine in which half the search key is? This is why you sorted the array first, so you can do a simple `<` or `>` comparison.
- If the search key is in the left half, you repeat the process there: split the left half into two even smaller pieces and look in which piece the search key must lie. (Likewise for when it's the right half.)
- This repeats until the search key is found. If the array cannot be split up any further, you must regrettably conclude that the search key is not present in the array.
- 将数组分成两半，并确定您要查找的内容（称为*搜索键*）是在左半部分还是在右半部分。
- 您如何确定搜索值的键在哪一半呢？ 这就是你首先对数组进行排序的原因，这样你就可以做一个简单的`<`或`>`比较。
- 如果搜索键位于左半部分，则在那里重复该过程：将左半部分分成两个甚至更小的部分，并查看搜索键位于哪一块。 （同样，对于右半部分同样处理。）
- 重复此操作直到找到搜索关键字。 如果无法进一步拆分数组，则必须遗憾地得出结论，数组中不存在搜索关键字。

Now you know why it's called a "binary" search: in every step it splits the array into two halves. This process of *divide-and-conquer* is what allows it to quickly narrow down where the search key must be.
现在你知道为什么它被称为“二分”搜索：在每一步中它将数组分成两半。 *分而治之*的过程允许它快速缩小搜索键所在的位置。

## The code
## 代码

Here is a recursive implementation of binary search in Swift:
这是Swift中二分搜索的递归实现：

```swift
func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
    if range.lowerBound >= range.upperBound {
        // If we get here, then the search key is not present in the array.
        return nil

    } else {
        // Calculate where to split the array.
        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

        // Is the search key in the left half?
        if a[midIndex] > key {
            return binarySearch(a, key: key, range: range.lowerBound ..< midIndex)

        // Is the search key in the right half?
        } else if a[midIndex] < key {
            return binarySearch(a, key: key, range: midIndex + 1 ..< range.upperBound)

        // If we get here, then we've found the search key!
        } else {
            return midIndex
        }
    }
}
```

To try this out, copy the code to a playground and do:
尝试一下，将代码复制到Playground并执行以下操作：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43, range: 0 ..< numbers.count)  // gives 13
```

Note that the `numbers` array is sorted. The binary search algorithm does not work otherwise!
请注意，`numbers`数组已排序。 否则二分搜索算法不起作用！

I said that binary search works by splitting the array in half, but we don't actually create two new arrays. Instead, we keep track of these splits using a Swift `Range` object. Initially, this range covers the entire array, `0 ..< numbers.count`.  As we split the array, the range becomes smaller and smaller.
我说二分搜索通过将数组分成两半来工作，但我们实际上并没有创建两个新数组。 相反，我们使用Swift`Range`对象跟踪这些拆分。最初，此范围涵盖整个数组，`0 .. <numbers.count`。 当我们拆分数组时，范围变得越来越小。

> **Note:** One thing to be aware of is that `range.upperBound` always points one beyond the last element. In the example, the range is `0..<19` because there are 19 numbers in the array, and so `range.lowerBound = 0` and `range.upperBound = 19`. But in our array the last element is at index 18, not 19, since we start counting from 0. Just keep this in mind when working with ranges: the `upperBound` is always one more than the index of the last element.
> **注意：**需要注意的一点是`range.upperBound`总是指向最后一个元素之外的一个。 在这个例子中，范围是`0 .. <19`，因为数组中有19个数字，所以`range.lowerBound = 0`和`range.upperBound = 19`。但是在我们的数组中，最后一个元素是在索引18而不是19，因为我们从0开始计数。在处理范围时要记住这一点：`upperBound`总是比最后一个元素的索引多一个。

## Stepping through the example
## 单步执行示例

It might be useful to look at how the algorithm works in detail.
查看算法的详细工作方式可能很有用。

The array from the above example consists of 19 numbers and looks like this when sorted:
上例中的数组由19个数字组成，在排序后如下所示：

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

We're trying to determine if the number `43` is in this array.
我们试图确定数字`43`是否在这个数组中。

To split the array in half, we need to know the index of the object in the middle. That's determined by this line:
要将数组拆分为一半，我们需要知道中间对象的索引。 这是由这条线决定的：

```swift
let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
```

Initially, the range has `lowerBound = 0` and `upperBound = 19`. Filling in these values, we find that `midIndex` is `0 + (19 - 0)/2 = 19/2 = 9`. It's actually `9.5` but because we're using integers, the answer is rounded down.
最初，范围有`lowerBound = 0`和`upperBound = 19`。 填写这些值，我们发现`midIndex`是`0 +（19 - 0）/ 2 = 19/2 = 9`。 它实际上是`9.5`，但因为我们使用的是整数，所以答案是四舍五入的。

In the next figure, the `*` shows the middle item. As you can see, the number of items on each side is the same, so we're split right down the middle.
在下图中，`*`处表示中间项。 如您所见，每侧的项目数相同，因此我们将在中间分开。

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
                                      *

Now binary search will determine which half to use. The relevant section from the code is:
现在二分搜索将确定使用哪一半。 代码中的相关部分是：

```swift
if a[midIndex] > key {
    // use left half
} else if a[midIndex] < key {
    // use right half
} else {
    return midIndex
}
```

In this case, `a[midIndex] = 29`. That's less than the search key, so we can safely conclude that the search key will never be in the left half of the array. After all, the left half only contains numbers smaller than `29`. Hence, the search key must be in the right half somewhere (or not in the array at all).
在这种情况下，`a [midIndex] = 29`。 这比搜索的值少，所以我们可以得出结论，搜索的值永远不会出现在数组的左半部分。毕竟，左半部分只包含小于“29”的数字。 因此，搜索的值必须位于右半部分（或根本不在数组中）。

Now we can simply repeat the binary search, but on the array interval from `midIndex + 1` to `range.upperBound`:
现在我们可以简单地重复二分搜索，从`midIndex + 1`到`range.upperBound`的数组间隔：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

Since we no longer need to concern ourselves with the left half of the array, I've marked that with `x`'s. From now on we'll only look at the right half, which starts at array index 10.
由于我们不再需要关注数组的左半部分，我用`x`标记了它。 从现在开始，我们只看右半部分，从数组索引10开始。

We calculate the index of the new middle element: `midIndex = 10 + (19 - 10)/2 = 14`, and split the array down the middle again.
我们计算新中间元素的索引：`midIndex = 10 +（19 - 10）/ 2 = 14`，然后再将数组从中间拆分。

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
	                                                 *

As you can see, `a[14]` is indeed the middle element of the array's right half.
正如你所看到的，`a [14]`确实是数组右半部分的中间元素。

Is the search key greater or smaller than `a[14]`? It's smaller because `43 < 47`. This time we're taking the left half and ignore the larger numbers on the right:
搜索关键字是大于还是小于`a [14]`？ 小，因为`43 <47`。 这次我们取左半边并忽略右边较大的数字：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]

The new `midIndex` is here:
新的`midIndex`如下：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
	                                     *

The search key is greater than `37`, so continue with the right side:
搜索的值大于`37`，因此继续右侧：

	[ x, x, x, x, x, x, x, x, x, x | x, x | 41, 43 | x, x, x, x, x ]
	                                        *

Again, the search key is greater, so split once more and take the right side:
同样，搜索键更大，因此再次拆分并采取右侧：

	[ x, x, x, x, x, x, x, x, x, x | x, x | x | 43 | x, x, x, x, x ]
	                                            *

And now we're done. The search key equals the array element we're looking at, so we've finally found what we were searching for: number `43` is at array index `13`. w00t!
现在我们已经完成了。搜索键等于我们正在查看的数组元素，所以我们终于找到了我们要搜索的内容：数字`43`位于数组索引`13`。 w00t！

It may have seemed like a lot of work, but in reality it only took four steps to find the search key in the array, which sounds about right because `log_2(19) = 4.23`. With a linear search, it would have taken 14 steps.
它可能看起来像很多工作，但实际上只需要四个步骤就能找到数组中的搜索键，这听起来是正确的，因为`log_2（19）= 4.23`。通过线性搜索，它将花费14个步骤。

What would happen if we were to search for `42` instead of `43`? In that case, we can't split up the array any further. The `range.upperBound` becomes smaller than `range.lowerBound`. That tells the algorithm the search key is not in the array and it returns `nil`.
如果我们要搜索`42`而不是`43`会发生什么？在这种情况下，我们不能再进一步拆分数组。 `range.upperBound`变得小于`range.lowerBound`。这告诉算法搜索键不在数组中，它返回`nil`。

> **Note:** Many implementations of binary search calculate `midIndex = (lowerBound + upperBound) / 2`. This contains a subtle bug that only appears with very large arrays, because `lowerBound + upperBound` may overflow the maximum number an integer can hold. This situation is unlikely to happen on a 64-bit CPU, but it definitely can on 32-bit machines.
> **注意：**二进制搜索的许多实现计算`midIndex =（lowerBound + upperBound）/ 2`。这包含一个只出现在非常大的数组中的细微错误，因为`lowerBound + upperBound`可能溢出一个整数可以容纳的最大数。这种情况不太可能发生在64位CPU上，但绝对可以在32位机器上发生。

## Iterative vs recursive
## 迭代与递归

Binary search is recursive in nature because you apply the same logic over and over again to smaller and smaller subarrays. However, that does not mean you must implement `binarySearch()` as a recursive function. It's often more efficient to convert a recursive algorithm into an iterative version, using a simple loop instead of lots of recursive function calls.
二分搜索本质上是递归的，因为您将相同的逻辑一遍又一遍地应用于越来越小的子阵列。 但是，这并不意味着您必须将`binarySearch（）`实现为递归函数。 将递归算法转换为迭代版本通常更有效，使用简单的循环而不是大量的递归函数调用。

Here is an iterative implementation of binary search in Swift:
这是Swift中二分搜索的迭代实现：

```swift
func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if a[midIndex] == key {
            return midIndex
        } else if a[midIndex] < key {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    return nil
}
```

As you can see, the code is very similar to the recursive version. The main difference is in the use of the `while` loop.
如您所见，代码与递归版本非常相似。 主要区别在于使用`while`循环。

Use it like this:
像这样用它：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43)  // gives 13
```

## The end
## 结束

Is it a problem that the array must be sorted first? It depends. Keep in mind that sorting takes time -- the combination of binary search plus sorting may be slower than doing a simple linear search. Binary search shines in situations where you sort just once and then do many searches.
数组必须先排序是一个问题吗？ 这取决于。 请记住，排序需要时间 -- 二分搜索和排序的组合可能比进行简单的线性搜索要慢。在您只排序一次然后进行多次搜索的情况下，二分搜索会起到大作用。

See also [Wikipedia](https://en.wikipedia.org/wiki/Binary_search_algorithm).
[二分搜索的维基百科](https://en.wikipedia.org/wiki/Binary_search_algorithm)

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*
*译者：[Andy Ron](https://github.com/andyRon)*
