# Selection Sort
# 选择排序

Goal: To sort an array from low to high (or high to low).
目标：将数组从低到高（或从高到低）排序。

You are given an array of numbers and need to put them in the right order. The selection sort algorithm divides the array into two parts: the beginning of the array is sorted, while the rest of the array consists of the numbers that still remain to be sorted.
您将获得一系列数字，需要按正确的顺序排列。 选择排序算法将数组分为两部分：数组的开头是排序的，而数组的其余部分包含仍然需要排序的数字。

	[ ...sorted numbers... | ...unsorted numbers... ]

This is similar to [insertion sort](../Insertion%20Sort/), but the difference is in how new numbers are added to the sorted portion.
这类似于[插入排序](../Insertion％20Sort/README_zh.md)，但区别在于如何将新数字添加到已排序部分。

It works as follows:
它的工作原理如下：

- Find the lowest number in the array. You must start at index 0, loop through all the numbers in the array, and keep track of what the lowest number is.
- Swap the lowest number with the number at index 0. Now, the sorted portion consists of just the number at index 0.
- Go to index 1.
- Find the lowest number in the rest of the array. This time you start looking from index 1. Again you loop until the end of the array and keep track of the lowest number you come across.
- Swap  the lowest number with the number at index 1. Now, the sorted portion contains two numbers and extends from index 0 to index 1.
- Go to index 2.
- Find the lowest number in the rest of the array, starting from index 2, and swap it with the one at index 2. Now, the array is sorted from index 0 to 2; this range contains the three lowest numbers in the array.
- And continue until no numbers remain to be sorted.
- 找到数组中的最小数字。 您必须从索引0开始，遍历数组中的所有数字，并跟踪最低数字是什么。
- 使用索引0处的数字交换最小数字。现在，已排序部分仅包含索引0处的数字。
- 转到索引1。
- 找到数组其余部分中的最小数字。 这次你从索引1开始查看。再次循环直到数组结束并跟踪你遇到的最低数字。
- 使用索引1处的数字交换最小数字。现在，已排序部分包含两个数字，并从索引0扩展到索引1。
- 转到索引2。
- 从索引2开始，找到数组其余部分中的最小数字，并将其与索引2处的数字交换。现在，数组从索引0到2排序; 此范围包含数组中的三个最小数字。
- 并继续，直到没有数字仍然排序。

It is called a "selection" sort because at every step you search through the rest of the array to select the next lowest number.
它被称为“选择”排序，因为在每个步骤中，您搜索数组的其余部分以选择下一个最低数字。

## An example
## 例子

Suppose the numbers to sort are `[ 5, 8, 3, 4, 6 ]`. We also keep track of where the sorted portion of the array ends, denoted by the `|` symbol.
假设要排序的数字是`[5,8,3,4,6]`。 我们还跟踪数组的已排序部分的结束位置，用`|`符号表示。

Initially, the sorted portion is empty:
最初，排序部分为空：

	[| 5, 8, 3, 4, 6 ]

Now we find the lowest number in the array. We do that by scanning through the array from left to right, starting at the `|` bar. We find the number `3`.
现在我们找到数组中的最小数字。 我们通过从左到右扫描数组来做到这一点，从`|`栏开始。 我们找到数字`3`。

To put this number into the sorted position, we swap it with the number next to the `|`, which is `5`:
要将此数字放入已排序的位置，我们将它与`|`旁边的数字交换，即`5`：

	[ 3 | 8, 5, 4, 6 ]
	  *      *

The sorted portion is now `[ 3 ]` and the rest is `[ 8, 5, 4, 6 ]`.
排序部分现在是`[3]`，其余部分是`[8,5,4,6]`。

Again, we look for the lowest number, starting from the `|` bar. We find `4` and swap it with `8` to get:
再一次，我们从`|`栏开始寻找最低的数字。 我们找到`4`并用`8`交换它得到：

	[ 3, 4 | 5, 8, 6 ]
	     *      *

With every step, the `|` bar moves one position to the right. We again look through the rest of the array and find `5` as the lowest number. There is no need to swap `5` with itself, and we simply move forward:
每一步，`|`栏都会向右移动一个位置。 我们再次查看数组的其余部分，找到`5`作为最低数字。 没有必要与自己交换`5`，我们只需前进：

	[ 3, 4, 5 | 8, 6 ]
	        *

This process repeats until the array is sorted. Note that everything to the left of the `|` bar is always in sorted order and always contains the lowest numbers in the array. Finally, we end up with:
重复此过程，直到对数组进行排序。 请注意，`|`栏左侧的所有内容始终按排序顺序排列，并且始终包含数组中的最小数字。 最后，我们最终得到：

	[ 3, 4, 5, 6, 8 |]

The selection sort is an *in-place* sort because everything happens in the same array without using additional memory. You can also implement this as a *stable* sort so that identical elements do not get swapped around relative to each other (note that the version given below is not stable).
选择排序是*就地*排序，因为所有内容都发生在同一个数组中而不使用额外的内存。您也可以将其实现为 *stable*sort，以便相同的元素不会相互交换（请注意，下面给出的版本不稳定）。

## The code
## 代码

Here is an implementation of selection sort in Swift:
这是Swift中选择排序的一个实现：

```swift
func selectionSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }  // 1

  var a = array                    // 2

  for x in 0 ..< a.count - 1 {     // 3

    var lowest = x
    for y in x + 1 ..< a.count {   // 4
      if a[y] < a[lowest] {
        lowest = y
      }
    }

    if x != lowest {               // 5
      a.swapAt(x, lowest)
    }
  }
  return a
}
```

Put this code in a playground and test it like so:
将此代码放在 playground 测试：

```swift
let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
selectionSort(list)
```

A step-by-step explanation of how the code works:
有关代码如何工作的逐步说明：

1. If the array is empty or only contains a single element, then there is no need to sort.

2. Make a copy of the array. This is necessary because we cannot modify the contents of the `array` parameter directly in Swift. Like the Swift's `sort()` function, the `selectionSort()` function will return a sorted *copy* of the original array.

3. There are two loops inside this function. The outer loop looks at each of the elements in the array in turn; this is what moves the `|` bar forward.

4. This is the inner loop. It finds the lowest number in the rest of the array.

5. Swap the lowest number with the current array index. The `if` check is necessary because you can't `swap()` an element with itself in Swift.
1.如果数组为空或仅包含单个元素，则无需排序。

2.制作数组的副本。 这是必要的，因为我们不能直接在Swift中修改`array`参数的内容。 与Swift的`sort（）`函数一样，`selectionSort（）`函数将返回原始数组的排序*副本*。

3.此功能内有两个循环。 外循环依次查看数组中的每个元素; 这就是向前移动`|`栏的原因。

这是内循环。 它找到数组其余部分中的最小数字。

5.使用当前数组索引交换最小数字。 `if`检查是必要的，因为你不能在Swift中`swap（）`一个元素。

In summary: For each element of the array, the selection sort swaps positions with the lowest value from the rest of the array. As a result, the array gets sorted from the left to the right. (You can also do it right-to-left, in which case you always look for the largest number in the array. Give that a try!)
总结：对于数组的每个元素，选择排序使用数组其余部分中的最小值交换位置。结果，数组从左到右排序。（你也可以从右到左进行，在这种情况下你总是寻找数组中最大的数字。试一试！）

> **Note:** The outer loop ends at index `a.count - 2`. The very last element will automatically be in the correct position because at that point there are no other smaller elements left.
> **注意：** 外部循环以索引`a.count - 2`结束。 最后一个元素将自动处于正确的位置，因为此时没有剩下其他较小的元素。

The source file [SelectionSort.swift](SelectionSort.swift) has a version of this function that uses generics, so you can also use it to sort strings and other data types.
源文件[SelectionSort.swift](SelectionSort.swift)是一个使用泛型的函数版本，因此您也可以使用它来对字符串和其他数据类型进行排序。

## Performance
## 性能

The selection sort is easy to understand but it performs slow as **O(n^2)**. It is worse than [insertion sort](../Insertion%20Sort/) but better than [bubble sort](../Bubble%20Sort/). Finding the lowest element in the rest of the array is slow, especially since the inner loop will be performed repeatedly.

The [Heap sort](../Heap%20Sort/) uses the same principle as selection sort but has a fast method for finding the minimum value in the rest of the array. The heap sort' performance is **O(n log n)**.
选择排序很容易理解，但执行速度慢 **O(n^2)**。 它比[插入排序](../Insertion％20Sort/README_zh.md)更糟，但优于[冒泡排序](../Bubble％20Sort/README_zh.md)。 查找数组其余部分中的最低元素很慢，特别是因为内部循环将重复执行。

[堆排序](../Heap％20Sort/README_zh.md)使用与选择排序相同的原则，但有一种快速方法可以在数组的其余部分中查找最小值。 堆排序性能是 **O(nlogn)**。

## 扩展阅读

[选择排序的维基百科](https://en.wikipedia.org/wiki/Selection_sort)

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*
