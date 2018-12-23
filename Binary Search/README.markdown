# 二分搜索(Binary Search)

目标：在数组中快速寻找一个元素。


假设你有一个数字数组，你想确定一个特定的数字是否在该数组中，如果在，那么获得这个数字的索引。

对于上面的情况，Swift的`indexOf()`函数足够完成：

```swift
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

numbers.indexOf(43)  // returns 15
```

内置的`indexOf()`函数执行的是[线性搜索](../Linear%20Search/)。代码大概是：

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

使用如下：

```swift
linearSearch(numbers, 43)  // returns 15
```

有什么问题呢？ `linearSearch（）`从头开始遍历整个数组，直到找到你正在寻找的元素。 在最坏的情况是数值不在数组中，那么之前的遍历就白费。

平均而言，线性搜索算法需要查看数组中一半的值。 如果您的数组足够大，这将会变得非常慢！

## 分而治之

提升速度的经典方法是使用 *二分搜索*。 诀窍是将数组分成两半，直到找到值。

对于大小为`n`的数组，性能不是线性搜索的**O(n)**，而是只有 **O(log n)**。换句话说，对具有1,000,000个元素的数组进行二分搜索只需要大约20个步骤来查找要查找的内容，因为`log_2（1,000,000）= 19.9`。对于具有十亿个元素的数组，它只需要30步。 （然而，你上一次使用数十亿项的数组是什么时候？）

听起来很棒，但使用二分搜索有一个缺点：数组必须被排好序的。 在实践中，这通常不是问题。

下面二分搜索的工作原理：

- 将数组分成两半，并确定您要查找的内容（称为*搜索键*）是在左半部分还是在右半部分。
- 您如何确定*搜索键*的键在哪一半呢？ 这就是首先要对数组进行排序的原因，排好序你就可以做一个简单的`<`或`>`比较。
- 如果*搜索键*位于左半部分，则在那里重复该过程：将左半部分分成两个更小的部分，并查看*搜索键*位于哪一块。 （同样，对于右半部分同样处理。）
- 重复此操作直到找到*搜索键*。 如果无法进一步拆分数组，则必须遗憾地得出结论，*搜索键*不在数组中。

现在你知道为什么它被称为“二分”搜索：在每一步中它将数组分成两半。 *分而治之* 可以快速缩小*搜索键*所在的位置。

## 代码

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

尝试一下，将代码复制到 playground 并执行以下操作：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43, range: 0 ..< numbers.count)  // gives 13
```

请注意，`numbers`数组已排序。 否则二分搜索算法不能工作！

二分搜索通过将数组分成两半来搜索，但我们实际上并没有创建两个新数组。 我们使用Swift`Range`对象跟踪这些拆分。起初，此范围涵盖整个数组，`0 .. <numbers.count`。 当我们拆分数组时，范围变得越来越小。

> **注意：** 需要注意的一点是`range.upperBound`总是指向最后一个元素之后的元素。 在这个例子中，范围是`0 .. <19`，因为数组中有19个数字，所以`range.lowerBound = 0`和`range.upperBound = 19`。但是在我们的数组中，最后一个元素是在索引18而不是19，因为我们从0开始计数。在处理范围时要记住这一点：`upperBound`总是比最后一个元素的索引多一。

## 分步执行示例

查看算法的详细工作方式或许是很有用的。

上例中的数组由19个数字组成，排序后如下所示：

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

我们试图确定数字`43`是否在这个数组中。

将数组拆分为一半，我们需要知道中间对象的索引。 这是由这行代码确定：

```swift
let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
```

最初，范围有`lowerBound = 0`和`upperBound = 19`。 细看，我们发现`midIndex`是`0 +（19 - 0）/ 2 = 19/2 = 9`。 它实际上是`9.5`，但因为我们使用的是整数，所以答案是向下舍入了。

在下图中，`*`处表示中间项。 如您所见，每侧的项目数相同，因此我们将在中间分开。

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
                                      *

二分搜索将确定使用哪一半的相关代码是：

```swift
if a[midIndex] > key {
    // use left half
} else if a[midIndex] < key {
    // use right half
} else {
    return midIndex
}
```

在这种情况下，`a[midIndex] = 29`。 这比*搜索键*的值小，所以我们可以得出结论，*搜索键*永远不会出现在数组的左半部分。毕竟，左半部分只包含小于`29`的数字。 因此，*搜索键*肯定位于右半部分（或根本不在数组中）。

现在我们可以简单地重复二分搜索，数组间距从`midIndex + 1`到`range.upperBound`：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

由于我们不再需要关注数组的左半部分，我用`x`标记了它。 从现在开始，我们只看右半部分，从数组索引10开始。

我们计算新的中间元素的索引：`midIndex = 10 +（19 - 10）/ 2 = 14`，然后再将数组从中间拆分。

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
	                                                 *

正如你所看到的，`a [14]`是数组右半部分的中间元素。

*搜索键*是大于还是小于`a [14]`？ 小，因为`43 <47`。 这次我们取左半边并忽略右边较大的数字：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]

新的`midIndex`如下：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
	                                     *

*搜索键*大于`37`，因此继续右侧：

	[ x, x, x, x, x, x, x, x, x, x | x, x | 41, 43 | x, x, x, x, x ]
	                                        *

同样，*搜索键*更大，因此再次拆分并采取右侧：

	[ x, x, x, x, x, x, x, x, x, x | x, x | x | 43 | x, x, x, x, x ]
	                                            *

现在我们已经完成了。搜索键等于我们正在查看的数组元素，所以我们终于找到了我们要搜索的内容：数字`43`位于数组索引`13`。 

这可能看起来像很多工作，但实际上只需要四个步骤就能找到数组中的*搜索键*，因为`log_2（19）= 4.23`。通过线性搜索，它将花费14个步骤。

如果我们要搜索`42`而不是`43`会发生什么？在这种情况下，最后我们不能再进一步拆分数组。 `range.upperBound`变得小于`range.lowerBound`。这告诉算法搜索键不在数组中，它返回`nil`。

> **注意：** 二分搜索许多执行会计算 `midIndex = (lowerBound + upperBound) / 2`。这包含了一个在非常大的数组中会出现的细微bug，因为`lowerBound + upperBound`可能溢出一个整数可以容纳的最大数。这种情况不太可能发生在64位CPU上，但绝对可能在32位机器上发生。

## 迭代与递归

二分搜索本质上是递归的，因为您将相同的逻辑一遍又一遍地应用于越来越小的子数组。 但是，这并不意味着您必须将`binarySearch()`实现为递归函数。 将递归算法转换为迭代版本通常更有效，使用简单的循环而不是大量的递归函数调用。

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

如您所见，代码与递归版本非常相似。 主要区别在于使用`while`循环。

使用迭代实现：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43)  // gives 13
```

## 结束

数组必须先排序是一个问题？ 排序是需要时间的 —— 二分搜索和排序的组合可能比进行简单的线性搜索要慢。但是在您只排序一次然后进行多次搜索的情况下，二分搜索会起到大作用。

[二分搜索的维基百科](https://en.wikipedia.org/wiki/Binary_search_algorithm)  

*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*
