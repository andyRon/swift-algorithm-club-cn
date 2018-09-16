# Count Occurrences
# 统计出现次数

Goal: Count how often a certain value appears in an array.
目标：计算某个值在数组中出现的频率。

The obvious way to do this is with a [linear search](../Linear%20Search/) from the beginning of the array until the end, keeping count of how often you come across the value. That is an **O(n)** algorithm.
显而易见的方法是从数组的开头直到结束的[线性搜索](../Linear％20Search/)，计算您遇到该值的频率。 这是一个 **O(n)** 算法。

However, if the array is sorted you can do it much faster, in **O(log n)** time, by using a modification of [binary search](../Binary%20Search/).
但是，如果对数组进行排序，则可以通过使用[二分搜索](../Binary％20Search/)的修改，在**O(logn)**时间内更快地执行此操作。

Let's say we have the following array:
假设我们有以下数组：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

If we want to know how often the value `3` occurs, we can do a regular binary search for `3`. That could give us any of these four indices:
如果我们想知道值`3`出现的频率，我们可以对`3`进行常规二分搜索。 这可以给我们这四个索引中的任何一个：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	           *  *  *  *

But that still doesn't tell you how many other `3`s there are. To find those other `3`s, you'd still have to do a linear search to the left and a linear search to the right. That will be fast enough in most cases, but in the worst case -- when the array consists of nothing but `3`s -- it still takes **O(n)** time.
但是，这仍然没有告诉你有多少其他的`3`。 要找到那些其他的`3`，你仍然需要在左边进行线性搜索，在右边进行线性搜索。 在大多数情况下，这将是足够快的，但在最坏的情况下 - 当阵列除了`3`之外什么都没有 —— 它仍然需要**O(n)**时间。

The trick is to use two binary searches, one to find where the `3`s start (the left boundary), and one to find where they end (the right boundary).
诀窍是使用两个二分搜索，一个用于查找`3`开始（左边界）的位置，另一个用于查找它们结束的位置（右边界）。

In code this looks as follows:
在代码中，这看起来如下：

```swift
func countOccurrencesOfKey(_ key: Int, inArray a: [Int]) -> Int {
  func leftBoundary() -> Int {
    var low = 0
    var high = a.count
    while low < high {
      let midIndex = low + (high - low)/2
      if a[midIndex] < key {
        low = midIndex + 1
      } else {
        high = midIndex
      }
    }
    return low
  }

  func rightBoundary() -> Int {
    var low = 0
    var high = a.count
    while low < high {
      let midIndex = low + (high - low)/2
      if a[midIndex] > key {
        high = midIndex
      } else {
        low = midIndex + 1
      }
    }
    return low
  }

  return rightBoundary() - leftBoundary()
}
```

Notice that the helper functions `leftBoundary()` and `rightBoundary()` are very similar to the [binary search](../Binary%20Search/) algorithm. The big difference is that they don't stop when they find the search key, but keep going.
请注意，辅助函数`leftBoundary()`和`rightBoundary()`与[二分搜索](../Binary％20Search/)算法非常相似。最大的区别在于，当他们找到搜索键时，他们不会停止，而是继续前进。

To test this algorithm, copy the code to a playground and then do:
要测试此算法，请将代码复制到 playground，然后执行以下操作：

```swift
let a = [ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

countOccurrencesOfKey(3, inArray: a)  // returns 4
```

> **Remember:** If you use your own array, make sure it is sorted first!
> **请记住：** 如果您使用自己的数组，请确保先排序！

Let's walk through the example. The array is:
让我们来看看这个例子。 该数组是：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

To find the left boundary, we start with `low = 0` and `high = 12`. The first mid index is `6`:
为了找到左边界，我们从`low = 0`和`high = 12`开始。 第一个中间指数是`6`：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

With a regular binary search you'd be done now, but here we're not just looking whether the value `3` occurs or not -- instead, we want to find where it occurs *first*.
通过常规二进制搜索，你现在就可以完成了，但是我们不只是查看是否出现了值`3` - 相反，我们想要找到它出现的位置 *first*。

Since this algorithm follows the same principle as binary search, we now ignore the right half of the array and calculate the new mid index:
由于该算法遵循与二分搜索相同的原理，我们现在忽略数组的右半部分并计算新的中间索引：

	[ 0, 1, 1, 3, 3, 3 | x, x, x, x, x, x ]
	           *

Again, we've landed on a `3`, and it's the very first one. But the algorithm doesn't know that, so we split the array again:
我们再次登上了一个`3`，这是第一个。 但算法不知道，所以我们再次拆分数组：

	[ 0, 1, 1 | x, x, x | x, x, x, x, x, x ]
	     *

Still not done. Split again, but this time use the right half:
还没完成。 再次拆分，但这次使用右半部分：

	[ x, x | 1 | x, x, x | x, x, x, x, x, x ]
	         *

The array cannot be split up any further, which means we've found the left boundary, at index 3.
数组不能再被拆分，这意味着我们在索引3处找到了左边界。

Now let's start over and try to find the right boundary. This is very similar, so I'll just show you the different steps:
现在让我们重新开始，尝试找到合适的边界。 这非常相似，所以我将向您展示不同的步骤：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

	[ x, x, x, x, x, x, x | 6, 8, 10, 11, 11 ]
	                              *

	[ x, x, x, x, x, x, x | 6, 8, | x, x, x ]
	                           *

	[ x, x, x, x, x, x, x | 6 | x | x, x, x ]
	                        *

The right boundary is at index 7. The difference between the two boundaries is 7 - 3 = 4, so the number `3` occurs four times in this array.
右边界位于索引7处。两个边界之间的差异是7 - 3 = 4，因此数字`3`在此数组中出现四次。

Each binary search took 4 steps, so in total this algorithm took 8 steps. Not a big gain on an array of only 12 items, but the bigger the array, the more efficient this algorithm becomes. For a sorted array with 1,000,000 items, it only takes 2 x 20 = 40 steps to count the number of occurrences for any particular value.
每个二分搜索需要4个步骤，所以总共这个算法需要8个步骤。 在仅有12个项目的数组上获得的收益不是很大，但是数组越大，该算法的效率就越高。 对于具有1,000,000个项目的排序数组，只需要2 x 20 = 40个步骤来计算任何特定值的出现次数。

By the way, if the value you're looking for is not in the array, then `rightBoundary()` and `leftBoundary()` return the same value and so the difference between them is 0.
顺便说一句，如果你要查找的值不在数组中，那么`rightBoundary()`和`leftBoundary()`返回相同的值，因此它们之间的差值为0。

This is an example of how you can modify the basic binary search to solve other algorithmic problems as well. Of course, it does require that the array is sorted.
这是一个如何修改基本二分搜索以解决其他算法问题的示例。 当然，它确实需要对数组进行排序。

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*
