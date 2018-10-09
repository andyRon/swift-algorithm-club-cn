# 希尔排序(Shell Sort)

Shell sort is based on [insertion sort](../Insertion%20Sort/) as a general way to improve its performance, by breaking the original list into smaller sublists which are then individually sorted using insertion sort.
希尔排序是[插入排序](../Insertion%20Sort/)的一种更高效的改进版本，方法是将原始列表分成较小的子列表，然后使用插入排序对其进行单独排序。

[There is a nice video created at Sapientia University](https://www.youtube.com/watch?v=CmPA7zE8mx0) which shows the process as a Hungarian folk dance.
Sapientia大学创建了一个很好的[视频](https://www.youtube.com/watch?v=CmPA7zE8mx0）)，显示了匈牙利民间舞蹈的过程。（译注：类似希尔排序的过程）

## How it works
## 怎么运行的

Instead of comparing elements that are side-by-side and swapping them if they are out of order, the way insertion sort does it, the shell sort algorithm compares elements that are far apart.
代替比较并排的元素并且如果它们不按顺序交换它们，插入排序的方式就是这样，希尔排序算法会比较相距很远的元素。

The distance between elements is known as the *gap*. If the elements being compared are in the wrong order, they are swapped across the gap. This eliminates many in-between copies that are common with insertion sort.
元素之间的距离称为 *gap*。 如果被比较的元素的顺序错误，则它们会在间隙中交换。 这消除了插入排序中常见的许多中间副本。

The idea is that by moving the elements over large gaps, the array becomes partially sorted quite quickly. This makes later passes faster because they don't have to swap so many items anymore.
这个想法是，通过在大间隙上移动元素，数组变得非常快速地部分排序。 这使得后来的传递更快，因为他们不再需要交换这么多项目。

Once a pass has been completed, the gap is made smaller and a new pass starts.  This repeats until the gap has size 1, at which point the algorithm functions just like  insertion sort. But since the data is already fairly well sorted by then, the final pass can be very quick.
传球完成后，差距变小，新传球开始。 这将重复，直到间隙大小为1，此时算法的功能就像插入排序一样。 但是由于数据已经很好地排序，所以最后的传递可以非常快。

## 例子

Suppose we want to sort the array `[64, 20, 50, 33, 72, 10, 23, -1, 4]` using shell sort.
假设我们想使用希尔排序对数组`[64,20,50,33,72,10,23，-1,4]`进行排序。

We start by dividing the length of the array by 2:
我们首先将数组的长度除以2：

    n = floor(9/2) = 4

This is the gap size.
这是空隙大小。

We create `n` sublists. In each sublist, the items are spaced apart by a gap of size `n`. In our example, we need to make four of these sublists. The sublists are sorted by the `insertionSort()` function.
我们创建`n`子列表。 在每个子列表中，项目间隔一个大小为`n`的间隙。 在我们的示例中，我们需要制作其中四个子列表。 子列表按`insertionSort()`函数排序。

That may not have made a whole lot of sense, so let's take a closer look at what happens.
这可能没有多大意义，所以让我们仔细看看会发生什么。

The first pass is as follows. We have `n = 4`, so we make four sublists:
第一遍如下。 我们有`n = 4`，所以我们制作了四个子列表：

	sublist 0:  [ 64, xx, xx, xx, 72, xx, xx, xx, 4  ]
	sublist 1:  [ xx, 20, xx, xx, xx, 10, xx, xx, xx ]
	sublist 2:  [ xx, xx, 50, xx, xx, xx, 23, xx, xx ]
	sublist 3:  [ xx, xx, xx, 33, xx, xx, xx, -1, xx ]

As you can see, each sublist contains only every 4th item from the original array. The items that are not in a sublist are marked with `xx`. So the first sublist is `[ 64, 72, 4 ]` and the second is `[ 20, 10 ]`, and so on. The reason we use this "gap" is so that we don't have to actually make new arrays. Instead, we interleave them in the original array.
如您所见，每个子列表仅包含原始数组中的每第4个项目。 不在子列表中的项目标用`xx`表示。 所以第一个子列表是`[64,72,4]`，第二个子列表是`[20,10]`，依此类推。 我们使用这个“空隙”的原因是我们不必实际制作新的数组。 相反，我们将它们交织在原始数组中。

We now call `insertionSort()` once on each sublist.
我们现在在每个子列表上调用一次`insertionSort()`。

This particular version of [insertion sort](../Insertion%20Sort/) sorts from the back to the front. Each item in the sublist is compared against the others. If they're in the wrong order, the value is swapped and travels all the way down until we reach the start of the sublist.
[插入排序](../Insertion%20Sort/)的这个特定版本从后面到前面排序。子列表中的每个项目都与其他项目进行比较。如果它们的顺序错误，则交换值并一直向下移动，直到我们到达子列表的开头。

So for sublist 0, we swap `4` with `72`, then swap `4` with `64`. After sorting, this sublist looks like:
因此对于子列表0，我们将`4`与`72`交换，然后将`4`与`64`交换。 排序后，此子列表如下所示：

    sublist 0:  [ 4, xx, xx, xx, 64, xx, xx, xx, 72 ]

The other three sublists after sorting:
排序后的其他三个子列表：

	sublist 1:  [ xx, 10, xx, xx, xx, 20, xx, xx, xx ]
	sublist 2:  [ xx, xx, 23, xx, xx, xx, 50, xx, xx ]
	sublist 3:  [ xx, xx, xx, -1, xx, xx, xx, 33, xx ]
    
The total array looks like this now:
完整的数组看上去是：

	[ 4, 10, 23, -1, 64, 20, 50, 33, 72 ]

It's not entirely sorted yet but it's more sorted than before. This completes the first pass.
它还没有完全排序，但它比以前更加排序。 这完成了第一次通过。

In the second pass, we divide the gap size by two:
在第二轮中，我们将间隙大小除以2：

	n = floor(4/2) = 2

That means we now create only two sublists:
这意味着我们现在只创建两个子列表：

	sublist 0:  [  4, xx, 23, xx, 64, xx, 50, xx, 72 ]
	sublist 1:  [ xx, 10, xx, -1, xx, 20, xx, 33, xx ]

Each sublist contains every 2nd item. Again, we call `insertionSort()` to sort these sublists. The result is:
每个子列表包含每个第二项。 我们再次调用`insertionSort()`来对这些子列表进行排序。 结果是：

	sublist 0:  [  4, xx, 23, xx, 50, xx, 64, xx, 72 ]
	sublist 1:  [ xx, -1, xx, 10, xx, 20, xx, 33, xx ]

Note that in each list only two elements were out of place. So the insertion sort is really fast. That's because we already sorted the array a little in the first pass.
请注意，在每个列表中只有两个元素不合适。 因此插入排序非常快。 那是因为我们已经在第一遍中对数组进行了一些排序。

The total array looks like this now:
总数组现在看起来像这样：

	[ 4, -1, 23, 10, 50, 20, 64, 33, 72 ]

This completes the second pass. The gap size of the final pass is:
这样就完成了第二遍。 最后一次传递的差距是：

	n = floor(2/2) = 1

A gap size of 1 means we only have a single sublist, the array itself, and once again we call `insertionSort()` to sort it. The final sorted array is:
间隙大小为1表示我们只有一个子列表，即数组本身，我们再次调用`insertionSort()`对其进行排序。 最终排序的数组是：

	[ -1, 4, 10, 20, 23, 33, 50, 64, 72 ]

The performance of shell sort is **O(n^2)** in most cases or **O(n log n)** if you get lucky. This algorithm produces an unstable sort; it may change the relative order of elements with equal values.
在大多数情况下，希尔排序的性能为**O(n^2)**，如果幸运，则为 **O(nlogn)**。 该算法是不稳定的排序; 它可能会改变具有相等值的元素的相对顺序。
  
## The gap sequence
## 间隙序列

The "gap sequence" determines the initial size of the gap and how it is made smaller with each iteration. A good gap sequence is important for shell sort to perform well.
“间隙序列”确定间隙的初始大小以及每次迭代如何使间隙变小。 良好的间隙序列对于希尔排序表现良好非常重要。

The gap sequence in this implementation is the one from Shell's original version: the initial value is half the array size and then it is divided by 2 each time. There are other ways to calculate the gap sequence.
此实现中的间隙序列是希尔原始版本中的间隙序列：初始值是数组大小的一半，然后每次除以2。 还有其他方法可以计算间隙序列。

## Just for fun...
## 只是为了好玩...

This is an old Commodore 64 BASIC version of shell sort that Matthijs used a long time ago and ported to pretty much every programming language he ever used:
这是Matthijs很久以前使用的一个旧的Commodore 64 BASIC版本的shell类型，并且移植到他曾经使用的几乎所有编程语言中：

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

Here is an implementation of Shell Sort in Swift:
希尔排序的Swift实现：

```
var arr = [64, 20, 50, 33, 72, 10, 23, -1, 4, 5]

public func shellSort(_ list: inout [Int]) {
    var sublistCount = list.count / 2
    while sublistCount > 0 {
        for pos in 0..<sublistCount {
            insertionSort(&list, start: pos, gap: sublistCount)
        }
        sublistCount = sublistCount / 2
    }
}

shellSort(&arr)
```

## 扩展阅读


[希尔排序的维基百科](https://en.wikipedia.org/wiki/Shellsort)

[Rosetta code的希尔排序](http://rosettacode.org/wiki/Sorting_algorithms/Shell_sort)（译注：大概70种不同语言实现希尔排序😅😓）

*作者：[Mike Taghavi](https://github.com/mitghi)，Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*
