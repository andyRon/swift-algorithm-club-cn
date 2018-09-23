# 统计出现次数(Count Occurrences)

目标：计算某个值在数组中出现的次数。

显而易见的方法是从数组的开头直到结束的[线性搜索](../Linear％20Search/)，计算您遇到该值的次数。 这是一个 **O(n)** 算法。

但是，如果数组已经排过序的，则可以通过使用修改[二分搜索](../Binary％20Search/)来更快的完成这个任务，时间复杂度为**O(logn)**。

假设我们有以下数组：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

如果我们想知道值`3`出现的次数，我们可以进行常规二分搜索。 这可以获得四个`3`索引中的一个：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	           *  *  *  *

但是，这仍然没有告诉你有多少其它的`3`。 要找到那些其它的`3`，你仍然需要在左边进行线性搜索，在右边进行线性搜索。 在大多数情况下，这将是足够快的，但在最坏的情况下 —— 当这个数组中除了之前的一个`3`之外就没有其它`3`了 —— 这样时间复杂度依然是**O(n)**。

一个诀窍是使用两个二分搜索，一个用于查找`3`开始（左边界）的位置，另一个用于查找`3`结束的位置（右边界）。

代码如下：

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

请注意，辅助函数`leftBoundary()`和`rightBoundary()`与[二分搜索](../Binary％20Search/)算法非常相似。最大的区别在于，当它们找到*搜索键*时，它们不会停止，而是继续前进。

要测试此算法，将代码复制到 playground，然后执行以下操作：

```swift
let a = [ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

countOccurrencesOfKey(3, inArray: a)  // returns 4
```

> **请记住：** 使用的数组，确保已经排序过！

来看看这个例子的过程。 该数组是：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

为了找到左边界，我们从`low = 0`和`high = 12`开始。 第一个中间索引是`6`：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

通过常规二分搜索，你现在就可以完成了，但是我们不只是查看是否出现了值`3` —— 而是想要找到它*第一次*出现的位置。

由于该算法遵循与二分搜索相同的原理，我们现在忽略数组的右半部分并计算新的中间索引：

	[ 0, 1, 1, 3, 3, 3 | x, x, x, x, x, x ]
	           *

我们再次找到了一个`3`，这是第一个。 但算法不知道，所以我们再次拆分数组：

	[ 0, 1, 1 | x, x, x | x, x, x, x, x, x ]
	     *

还没完， 再次拆分，但这次使用右半部分：

	[ x, x | 1 | x, x, x | x, x, x, x, x, x ]
	         *

数组不能再被拆分，这意味着左边界在索引3处。

现在让我们重新开始，尝试找到右边界。 这非常相似，所以我将向您展示不同的步骤：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

	[ x, x, x, x, x, x, x | 6, 8, 10, 11, 11 ]
	                              *

	[ x, x, x, x, x, x, x | 6, 8, | x, x, x ]
	                           *

	[ x, x, x, x, x, x, x | 6 | x | x, x, x ]
	                        *

右边界位于索引7处。两个边界之间的差异是7 - 3 = 4，因此数字`3`在此数组中出现四次。

每个二分搜索需要4个步骤，所以总共这个算法需要8个步骤。 在仅有12个项的数组上获得的收益不是很大，但是数组越大，该算法的效率就越高。 对于具有1,000,000个项目的排序数组，只需要2 x 20 = 40个步骤来计算任何特定值的出现次数。

顺便说一句，如果你要查找的值不在数组中，那么`rightBoundary()`和`leftBoundary()`返回相同的值，因此它们之间的差值为0。

这是一个如何修改基本二分搜索以解决其它算法问题的示例。 当然，它需要先对数组进行排序。

*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
