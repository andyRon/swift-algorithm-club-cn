# 快速排序(Quicksort)

目标：将数组从低到高（或从高到低）排序。

快速排序是历史上最着名的算法之一。 它是由Tony Hoare于1959年发明的，当时递归仍然是一个相当模糊的概念。

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

> 译注：pivot 中心点，枢轴，基准。本文的pivot都翻译成“基准”。

将此代码放在playground 进行测试：

```swift
let list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
quicksort(list)
```

谈一谈工作原理。 给定一个数组时，`quicksort()`根据“基准”变量将它分成三部分。这里，基准被视为数组中间的元素（稍后您将看到选择基准的其他方法）。

比基准元素小的所有元素都进入一个名为`less`的新数组。 所有等于基准元素都进入`equal`数组。你猜对了，所有比基准更大的元素进入第三个数组，`greater`。 这就是泛型类型`T`必须符合`Comparable`协议的原因，因为我们需要将元素与`<`，`==`和`>`进行比较。

一旦我们有了这三个数组，`quicksort()`递归地对`less`数组和`more`数组进行排序，然后将那些已排序的子数组与`equal`数组组合在一起，得到最终结果。

## 一个例子

让我们来看看这个例子。 数组最初是：

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

首先，我们选择基准`8`，因为它在数组的中间。 现在我们将数组拆分为少，相等和大的部分：

	less:    [ 0, 3, 2, 1, 5, -1 ]
	equal:   [ 8, 8 ]
	greater: [ 10, 9, 14, 27, 26 ]

这是一个很好的拆分，因为`less`和`greater`大致包含相同数量的元素。 所以我们选择了一个很好的基准，将数组从中间分开。

请注意，`less`和`greater`数组尚未排序，因此我们再次调用`quicksort()`来排序这两个子数组。这与之前完全相同：选择一个中间元素并将子数组分成三个更小的部分。

来看看`less`数组：

	[ 0, 3, 2, 1, 5, -1 ]

基准元素是中间的`1`（你也可以选择`2`，这没关系）。我们再次围绕基准元素创建了三个子数组：

	less:    [ 0, -1 ]
	equal:   [ 1 ]
	greater: [ 3, 2, 5 ]

我们还没有完成，`quicksort()`再次在`less`和`more`数组上被递归调用。 让我们再看一下`less`：

	[ 0, -1 ]

这次基准元素选择`-1`。 现在的子数组是：

	less:    [ ]
	equal:   [ -1 ]
	greater: [ 0 ]

`less`数组是空的，因为没有小于`-1`的值; 其他数组各包含一个元素。 这意味着我们已经完成了递归，现在我们返回以对前一个`greater`数组进行排序。

`greater`数组是:

	[ 3, 2, 5 ]

这与以前的工作方式相同：我们选择中间元素`2`作为基准元素，子数组为：

	less:    [ ]
	equal:   [ 2 ]
	greater: [ 3, 5 ]

请注意，如果在这里选择`3`作为基准会更好 —— 会早点完成。 然而现在我们必须再次递归到`greater`数组以确保它被排序。这就体现，选择好的基准有多重要了。当你选择太多“bad”基准时，快速排序实际上变得非常慢。 之后会有更多说明。

当对`greater`子数组进行分区时，我们发现：

	less:    [ 3 ]
	equal:   [ 5 ]
	greater: [ ]

现在我们已经完成了这层递归，因为我们无法进一步拆分数组。

重复此过程，直到所有子数组都已排序。 过程图：

![Example](Images/Example.png)

现在，如果您从左到右阅读彩色框，则会获得已排序的数组：

	[ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]

这表明`8`是一个很好的初始基准，因为它也出现在排好序数组的中间。

我希望这已经清楚地表明快速排序的工作原理了。 不幸的是，这个版本的快速排序不是很快，因为我们对相同的数组使用`filter()`三次。有更聪明的方法分割数组。


## 分区

围绕数据块划分数组称为 *分区*，并且存在一些不同的分区方案。
如果一个数组是，

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

然后我们选择中间元素`8`作为一个数据块，然后分区后数组如下：

	[ 0, 3, 2, 1, 5, -1, 8, 8, 10, 9, 14, 27, 26 ]
	  -----------------        -----------------
	  all elements < 8         all elements > 8


要实现上面操作的关键是，在分区之后，基准元素已经处于其最终排序位置。 其余的数字尚未排序，它们只是以基准数分区了。 快速排序对数组进行多次分区，直到所有值都在最终位置。



无法保证每次分区将元素保持在相同的相对顺序中，因此在使用基准“8”进行分区之后，也可能得到类似这样的内容：

	[ 3, 0, 5, 2, -1, 1, 8, 8, 14, 26, 10, 27, 9 ]


唯一可以保证的是在基准元素左边是所有较小的元素，而右边是所有较大的元素。 因为分区改变相等元素的原始顺序，所以快速排序不会产生“稳定”排序（与[归并排序](../Merge%20Sort/)不同）。 这大部分时间都不是什么大不了的事。


## Lomuto的分区方案


在快速排序的第一个例子中，我告诉你，分区是通过调用Swift的`filter()`函数三次来完成的。 这不是很高效。 因此，让我们看一个更智能的分区算法，它可以 *in place*，即通过修改原始数组。

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

在playground中测试：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
let p = partitionLomuto(&list, low: 0, high: list.count - 1)
list  // show the results
```

注意`list`需要是`var`，因为`partitionLomuto()`直接改变数组的内容（使用`inout`参数传递）。 这比分配新的数组对象更有效。

`low`和`high`参数是必要的，因为当在快速排序时并不一定排序整个数组，可能只是在某个区间。


以前我们使用中间数组元素作为基准，现在Lomuto方案的基准总是使用*最后*元素，`a [high]` 。 因为之前我们一直在以`8`作为基准，所以我在示例中交换了`8`和`26`的位置，以便`8`位于数组的最后并且在这里也用作枢基准。

经过Lomuto方案分区后，数组如下所示：

	[ 0, 3, 2, 1, 5, 8, -1, 8, 9, 10, 14, 26, 27 ]
	                        *

变量`p`是`partitionLomuto()`的调用的返回值，是7。这是新数组中的基准元素的索引（用星号标记）。

左分区从0到`p-1`，是`[0,3,2,1,5,8，-1]`。 右分区从`p + 1`到结尾，并且是`[9,10,14,26,27]`（右分区已经排序的实属是巧合）。

您可能会注意到一些有趣的东西......值`8`在数组中出现不止一次。 其中一个`8`并没有整齐地在中间，而是在左分区。 这是Lomuto算法的一个小缺点，如果存在大量重复元素，它会使快速排序变慢。

那么Lomuto算法实际上是如何工作的呢？ 魔术发生在`for`循环中。 此循环将数组划分为四个区域：

1. `a [low ... i]` 包含 `<= pivot` 的所有值
2. `a [i + 1 ... j-1]` 包含 `> pivot` 的所有值
3. `a [j ... high-1]` 是我们“未查看”的值
4. `a [high]`是基准值

In ASCII art the array is divided up like this:
用ASCII字符表示，数组按如下方式划分：

	[ values <= pivot | values > pivot | not looked at yet | pivot ]
	  low           i   i+1        j-1   j          high-1   high

循环依次查看从`low`到`high-1`的每个元素。 如果当前元素的值小于或等于基准，则使用swap将其移动到第一个区域。

> **注意：** 在Swift中，符号`(x, y) = (y, x)`是在`x`和`y`的值之间执行交换的便捷方式。 你也可以使用`swap（＆x，＆y）`。

循环结束后，基准仍然是数组中的最后一个元素。 所以我们将它与第一个大于基准的元素交换。 现在，基准位于<=和>区域之间，并且数组已正确分区。

让我们逐步完成这个例子。 我们开始的数组是：

	[| 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                       high
	   i
	   j

最初，“未查看”区域从索引0延伸到11。基准位于索引12。“values <= pivot”和“values> pivot”区域为空，因为我们还没有查看任何值。

看第一个值，`10`。 这比基准小吗？ 不，跳到下一个元素。  

	[| 10 | 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                        high
	   i
	       j

现在“未查看”区域从索引1到11，“values> pivot”区域包含数字“10”，“values <= pivot”仍为空。

看第二个值，`0`。 这比基准小吗？ 是的，所以将`10`与`0`交换，然后将`i`向前移动一个。

	[ 0 | 10 | 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	      i
	           j

现在“未查看”区域从索引2到11，“values> pivot”仍然包含“10”，“values <= pivot”包含数字“0”。

看第三个值，`3`。 这比基准小，所以用`10`换掉它得到：

	[ 0, 3 | 10 | 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	             j

“values <= pivot”区域现在是`[0,3]`。 让我们再做一次......`9`大于枢轴，所以简单地向前跳：

	[ 0, 3 | 10, 9 | 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	                 j

现在“values> pivot”区域包含`[10,9]`。 如果我们继续这样做，那么我们最终会得到：

	[ 0, 3, 2, 1, 5, 8, -1 | 27, 9, 10, 14, 26 | 8 ]
	  low                                        high
	                         i                   j

最后要做的是通过将`a[i]`与`a[high]`交换来将基准放到特定位置：

	[ 0, 3, 2, 1, 5, 8, -1 | 8 | 9, 10, 14, 26, 27 ]
	  low                                       high
	                         i                  j

然后我们返回`i`，基准元素的索引。



> ** 注意：** 如果您仍然不完全清楚算法是如何工作的，我建议您在playground 试验一下，以确切了解循环如何创建这四个区域。



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

现在这非常简单。 我们首先调用`partitionLomuto()`来以基准元素（它始终是数组中的最后一个元素）重新排序数组。 然后我们递归调用`quicksortLomuto()`来对左右分区进行排序。

试试看：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
quicksortLomuto(&list, low: 0, high: list.count - 1)
```


Lomuto方案不是唯一的分区方案，但它可能是最容易理解的。 它不如Hoare的方案有效，后者需要的交换操作更少。



## Hoare的分区方案

这种分区方案是由快速排序的发明者Hoare完成的。

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
      a.swapAt(i, j)
    } else {
      return j
    }
  }
}
```

在playground中测试：

```swift
var list = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
let p = partitionHoare(&list, low: 0, high: list.count - 1)
list  // show the results
```


注意，使用Hoare的方案，基准总是数组中的 *first* 元素，`a [low]`。 同样，我们使用`8`作为基准元素。
结果是：

	[ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]

请注意，这次基准根本不在中间。 与Lomuto的方案不同，返回值不一定是新数组中基准元素的索引。

结果，数组被划分为区域`[low ... p]`和`[p + 1 ... high]`。 这里，返回值`p`是6，因此两个分区是`[-1,0,3,8,2,5,1]`和`[27,10,14,9,8,26]`。

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

Hoare的分区方案是如何工作的？我将把它作为练习让读者自己弄清楚。:-)



## 选择一个好的基准

Lomuto的分区方案总是为基准选择最后一个数组元素。 Hoare的分区方案使用第一个元素。 但这都不能保证这些基准是好的。

以下是为基准选择错误值时会发生的情况。 如果一个数组是：

	[ 7, 6, 5, 4, 3, 2, 1 ]

我们使用Lomuto的方案。 基准是最后一个元素，`1`。 分区后：

	   less than pivot: [ ]
	    equal to pivot: [ 1 ]
	greater than pivot: [ 7, 6, 5, 4, 3, 2 ]

现在以递归方式对“更大的”子数组进行分区，得到：

	   less than pivot: [ ]
	    equal to pivot: [ 2 ]
	greater than pivot: [ 7, 6, 5, 4, 3 ]

再次：

	   less than pivot: [ ]
	    equal to pivot: [ 3 ]
	greater than pivot: [ 7, 6, 5, 4 ]

等等。。。


这并不好，因为这样的快速排序可能比[插入排序](../Insertion%20Sort/)更慢。 为了使快速排序高效，需要将数组分成两个大约相等的部分。

这个例子的最佳基准是`4`，所以我们得到：

	   less than pivot: [ 3, 2, 1 ]
	    equal to pivot: [ 4 ]
	greater than pivot: [ 7, 6, 5 ]

您可能认为这意味着我们应该始终选择中间元素而不是第一个或最后一个，但想象在以下情况下会发生什么：

	[ 7, 6, 5, 1, 4, 3, 2 ]

现在，中间元素是`1`，它给出了与前一个例子相同的糟糕结果。


理想情况下，基准是您要分区的数组的 *中位数*（译注：大小在中间的） 元素，即位于排玩序数组中间的元素。当然，在你对数组进行排序之前，你不会知道中位数是什么，所以这就回到 *鸡蛋和鸡* 问题了。然而，有一些技巧可以改进。

一个技巧是“三个中间值”，您可以在找到数组中第一个，中间和最后一个的中位数。 从理论上讲，这通常可以很好地接近真实的中位数。

另一种常见的解决方案是随机选择基准。 有时这可能会选择次优的基准，但平均而言，这会产生非常好的结果。

以下是如何使用随机选择的基准进行快速排序：

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

与之前有两个重要的区别：

1. `random(min:max:)`函数返回`min...max`范围内的整数，这是我们基准的索引。
2. 因为Lomuto方案期望`a[high]`成为基准，我们将`a[pivotIndex]`与`a[high]`交换，将基准元素放在末尾，然后再调用`partitionLomuto()`。


在类似排序函数中使用随机数似乎很奇怪，但让快速排序在所有情况下都能有效地运行，这是有必要的。 坏的基准，快速排序的表现可能非常糟糕，**O(n^2)**。 但是如果平均选择好的基准，例如使用随机数生成器，预期的运行时间将变为**O(nlogn)**，这是好的排序算法。



## 荷兰国旗🇳🇱分区

还有更多改进！ 在我向您展示的第一个快速排序示例中，我们最终得到了一个像这样分区的数组：

	[ values < pivot | values equal to pivot | values > pivot ]

但是正如您在Lomuto分区方案中看到的那样，如果多次出现基准元素，则重复项最后会在左分区。 而通过Hoare方案，重复基准元素可以遍布任意分区。 解决这个问题的方法是“荷兰国旗”分区，以[荷兰国旗](https://en.wikipedia.org/wiki/Flag_of_the_Netherlands)有三个频段命名，就像我们想拥有三个分区一样。

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

这与Lomuto方案的工作方式非常相似，只是循环将数组划分为四个（可能为空）区域：

- `[low ... smaller-1]` 包含`< pivot` 的所有值
- `[less ... equal-1]` 包含 `== pivot` 的所有值
- `[equal ... larger]`包含 `> pivot` 的所有值
- `[large ... high]` 是我们“未查看”的值

Note that this doesn't assume the pivot is in `a[high]`. Instead, you have to pass in the index of the element you wish to use as a pivot.
请注意，这并不假设基准处于`a[high]`。 而是，必须传入要用作基准的元素的索引。

如何使用它的一个例子：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
partitionDutchFlag(&list, low: 0, high: list.count - 1, pivotIndex: 10)
list  // show the results
```

只是为了好玩，我们这次给它的另一个`8`的索引。 结果是：

	[ -1, 0, 3, 2, 5, 1, 8, 8, 27, 14, 9, 26, 10 ]

注意两个`8`现在是如何在中间的。 `partitionDutchFlag()`的返回值是一个元组，`(6,7)`。 这是包含基准的范围。

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

如果数组包含许多重复元素，则使用荷兰国旗分区可以提高效率。 （而且我不只是这么说，因为我是荷兰人！）



> **注意：** `partitionDutchFlag()`的上述实现使用自定义`swap()`来交换两个数组元素的内容。 与Swift自带的`swapAt()`不同，当两个索引引用相同的数组元素时，这不会产生错误。 
>
> ```swift
> public func swap<T>(_ a: inout [T], _ i: Int, _ j: Int) {
>     if i != j {
>         a.swapAt(i, j)
>     }
> }
> ```



## 扩展阅读


[快速排序的维基百科](https://en.wikipedia.org/wiki/Quicksort)

*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  