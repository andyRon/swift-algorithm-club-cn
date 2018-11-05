# 希尔排序(Shell Sort)

希尔排序是[插入排序](../Insertion%20Sort/)的一种更高效的改进版本，方法是将原始列表分成较小的子列表，然后使用插入排序对其进行单独排序。

Sapientia大学创建了一个很好的[视频](https://www.youtube.com/watch?v=CmPA7zE8mx0）)，显示了匈牙利民间舞蹈的过程。（译注：类似希尔排序的过程，油管视频需要翻墙）

## 怎么运行的

插入排序是比较相连的元素，如果它们顺序不对就交换它们，而希尔排序算法会比较相距很远的元素。

元素之间的距离称为 *gap*。 如果被比较的元素的顺序错误，则它们会在 *gap* 中交换。 这消除了插入排序中常见的许多中间副本。

> **译注：** gap已经被翻译成步长/增量/间距等，为了避免歧义，本文就不做翻译，直接写成*gap*


这个想法是，通过在大 *gap* 上移动元素，数组变得非常快速地部分排序。 这使得之后的排序过程更快，因为他们不再需要交换那么多项。

一轮完成后，*gap*变小，新一轮开始。 这将重复，直到 *gap* 大小为1，此时算法的功能就像插入排序一样。 但是由于数据已经很好地排序，所以最后一轮可以非常快。

## 例子

假设我们想使用希尔排序对数组 `[64, 20, 50, 33, 72, 10, 23, -1, 4]` 进行排序。

我们首先将数组的长度除以2：

    n = floor(9/2) = 4

这是 *gap* 大小。

我们创建`n`子列表。 在每个子列表中，每一项的间隔是大小为`n`的*gap* 。 在我们的示例中，我们需要制作其中四个子列表。 子列表按`insertionSort()`函数排序。

这可能没有多大意义，所以让我们仔细看看会发生什么。

第一轮如下。 我们有`n = 4`，所以我们制作了四个子列表：

	sublist 0:  [ 64, xx, xx, xx, 72, xx, xx, xx, 4  ]
	sublist 1:  [ xx, 20, xx, xx, xx, 10, xx, xx, xx ]
	sublist 2:  [ xx, xx, 50, xx, xx, xx, 23, xx, xx ]
	sublist 3:  [ xx, xx, xx, 33, xx, xx, xx, -1, xx ]

如您所见，每个子列表仅包含原始数组中的每间隔4的项。 不在子列表中的项用`xx`表示。 所以第一个子列表是`[64,72,4]`，第二个子列表是`[20,10]`，依此类推。 我们使用这个“*gap*”的原因是我们不必实际制作新的数组。 相反，我们将它们交织在原始数组中。

我们现在在每个子列表上调用一次`insertionSort()`。

[插入排序](../Insertion%20Sort/)的这个特定版本从后面到前面排序。子列表中的每个项目都与其他项目进行比较。如果它们的顺序错误，则交换值并一直向下移动，直到我们到达子列表的开头。

因此对于子列表0，我们将`4`与`72`交换，然后将`4`与`64`交换。 排序后，此子列表如下所示：

    sublist 0:  [ 4, xx, xx, xx, 64, xx, xx, xx, 72 ]

排序后的其他三个子列表：

	sublist 1:  [ xx, 10, xx, xx, xx, 20, xx, xx, xx ]
	sublist 2:  [ xx, xx, 23, xx, xx, xx, 50, xx, xx ]
	sublist 3:  [ xx, xx, xx, -1, xx, xx, xx, 33, xx ]
    
完整的数组看上去是：

	[ 4, 10, 23, -1, 64, 20, 50, 33, 72 ]

它还没有完全排序，但它比以前更加排序。 这完成了第一次轮操作。

在第二轮中，我们将 *gap* 大小除以2：

	n = floor(4/2) = 2

这意味着我们现在只创建两个子列表：

	sublist 0:  [  4, xx, 23, xx, 64, xx, 50, xx, 72 ]
	sublist 1:  [ xx, 10, xx, -1, xx, 20, xx, 33, xx ]

每个子列表包含每个间隔为2的项。 我们再次调用`insertionSort()`来对这些子列表进行排序。 结果是：

	sublist 0:  [  4, xx, 23, xx, 50, xx, 64, xx, 72 ]
	sublist 1:  [ xx, -1, xx, 10, xx, 20, xx, 33, xx ]

请注意，在每个列表中只有两个元素位置顺序不对（译注：**sublist 0**是64和50，**sublist 1**是10和-1）。 因此插入排序非常快。 那是因为我们已经在第一轮中对数组进行了一些排序。

总数组现在看起来像这样：

	[ 4, -1, 23, 10, 50, 20, 64, 33, 72 ]

这样就完成了第二轮。 最后一轮的*gap*是：

	n = floor(2/2) = 1

 *gap* 大小为1表示我们只有一个子列表，即数组本身，我们再次调用`insertionSort()`对其进行排序。 最终排序的数组是：

	[ -1, 4, 10, 20, 23, 33, 50, 64, 72 ]

在大多数情况下，希尔排序的性能为**O(n^2)**，如果幸运，则为 **O(nlogn)**。 该算法是**不稳定的排序**; 它可能会改变具有相等值的元素的相对顺序。
  
##  *gap* 序列

“ *gap* 序列”确定 *gap* 的初始大小以及每次迭代如何使 *gap* 变小。 良好的 *gap* 序列对于希尔排序表现良好非常重要。

上面实现例子中的 *gap* 序列是希尔原始版本中的 *gap* 序列：初始值是数组大小的一半，然后每次除以2。 还有其他方法可以计算 *gap* 序列。


## 只是为了好玩...

这是 Matthijs 很久以前使用的一个旧的Commodore 64 BASIC版本的希尔排序，并且移植到他曾经使用的几乎所有编程语言中：

	61200 REM S is the array to be sorted
	61205 REM AS is the number of elements in S
	61210 W1=AS
	61220 IF W1<=0 THEN 61310
	61230 W1=INT(W1/2): W2=AS-W1
	61240 V=0
	61250 FOR N1=0 TO W2-1
	61260 W3=N1+W1
	61270 IF S(N1)>S(W3) THEN SH=S(N1): S(N1)=S(W3): S(W3)=SH: V=1
	61280 NEXT N1
	61290 IF V>0 THEN 61240
	61300 GOTO 61220
	61310 RETURN

## 代码

希尔排序的Swift实现：

```
public func insertSort(_ list: inout[Int], start: Int, gap: Int) {
    for i in stride(from: (start + gap), to: list.count, by: gap) {
        let currentValue = list[i]
        var pos = i
        while pos >= gap && list[pos - gap] > currentValue {
            list[pos] = list[pos - gap]
            pos -= gap
        }
        list[pos] = currentValue
    }
}

public func shellSort(_ list: inout [Int]) {
    var sublistCount = list.count / 2
    while sublistCount > 0 {
        for pos in 0..<sublistCount {
            insertionSort(&list, start: pos, gap: sublistCount)
        }
        sublistCount = sublistCount / 2
    }
}

var arr = [64, 20, 50, 33, 72, 10, 23, -1, 4, 5]

shellSort(&arr)
```

## 扩展阅读


[希尔排序的维基百科](https://en.wikipedia.org/wiki/Shellsort)

[Rosetta code的希尔排序](http://rosettacode.org/wiki/Sorting_algorithms/Shell_sort)（译注：大概70种不同语言实现希尔排序😅😓）

*作者：[Mike Taghavi](https://github.com/mitghi)，Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  


---------------

# 翻译后补充

希尔排序，也称**递减增量排序算法**，按其设计者希尔（Donald Shell）的名字命名，在1959年公布。

## 定义

希尔排序是**将待排序的数组元素按下标的一定增量分组 ，分成多个子序列，然后对各个子序列进行直接插入排序算法排序；然后依次缩减增量再进行排序，直到增量为1时，进行最后一次直接插入排序，排序结束。**

## 希尔排序的原理图

- 图片一来源：[图解排序算法(二)之希尔排序](https://www.cnblogs.com/chengxiao/p/6104371.html)
![](image/shell_sort_1.png)


- 图片二来源：[排序：希尔排序（算法）](https://www.jianshu.com/p/d730ae586cf3)
![](image/shell_sort_2.png)

- 一个希尔排序的动画

[Comparison Sorting Algorithms](https://www.cs.usfca.edu/~galles/visualization/ComparisonSort.html)

## 参考

[图解排序算法(二)之希尔排序](https://www.cnblogs.com/chengxiao/p/6104371.html)


[排序：希尔排序（算法）](https://www.jianshu.com/p/d730ae586cf3)
