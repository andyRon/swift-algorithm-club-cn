# 计数排序(Counting Sort)

Counting sort is an algorithm for sorting a collection of objects according to keys that are small integers. It operates by counting the number of objects that have each distinct key values, and using arithmetic on those counts to determine the positions of each key value in the output sequence.  
计数排序是一种根据小整数键对对象集合进行排序的算法。通过计算具有每个不同键值的对象的数量来操作，并对这些计数使用算术来确定输出序列中每个键值的位置。

## 例子

为了理解算法，让我们来看一个小例子。

考虑数组: `[ 10, 9, 8, 7, 1, 2, 7, 3 ]`

### 第一步：

第一步是计算数组中每个项的总出现次数。 第一步的输出将是一个新的数组，如下所示：

```
Index 0 1 2 3 4 5 6 7 8 9 10
Count 0 1 1 1 0 0 0 2 1 1 1
```

> **译注：** 这边Index的最大值对应于，数组中最大值10。

这是完成第一步的代码：

```swift
  let maxElement = array.max() ?? 0

  var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
  for element in array {
    countArray[element] += 1
  }
```

### 第二步：

在此步骤中，算法尝试确定在每个元素之前放置的元素的数量。通过第一步已经知道每个元素的总出现次数，可以得到。方法就是把前一个计数和当前计数相加存储到每个索引中（对应代码就是`countArray[index] + countArray[index - 1]`）。

计数数组如下：

```
Index 0 1 2 3 4 5 6 7 8 9 10
Count 0 1 2 3 3 3 3 5 6 7 8
```

第二步的代码：

```swift
  for index in 1 ..< countArray.count {
    let sum = countArray[index] + countArray[index - 1]
    countArray[index] = sum
  }
```

### 第三步

这是算法的最后一步。 原始数组中的每个元素都放置在第二步的输出定义的位置。例如，数字10将放在输出数组中的索引7处。 此外，当您放置元素时，您需要将计数减少1，因为从数组中减少了许多元素。

最终的输出是：

```
Index  0 1 2 3 4 5 6 7
Output 1 2 3 7 7 8 9 10
```

以下是最后一步的代码：

```swift
  var sortedArray = [Int](repeating: 0, count: array.count)
  for element in array {
    countArray[element] -= 1
    sortedArray[countArray[element]] = element
  }
  return sortedArray
```

## 性能

该算法使用简单循环对集合进行排序。 因此，运行整个算法的时间是**O(n+k)**其中**O(n)**表示初始化输出数组所需的循环，**O(k)**是创建计数数组所需的循环。

该算法使用长度为**n + 1**和**n**的数组，因此所需的总空间为**O(2n)**。 因此，对于密钥沿着数字线分散在密集区域中的集合，它可以节省空间。


*作者：Ali Hafizji*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

-------

# 翻译后补充

计数排序假设n个输入元素中的每一个都是在0到k区间内的一个整数，其中k为某个整数。当k=O(n)时，排序的运行时间为Θ(n)。

计数排序的思想是，**对每一个输入元素，计算小于它的元素个数**，如果有10个元素小于它，那么它就应该放在11的位置上，如果有17个元素小于它，它就应该放在18的位置上。当有几个元素相同时，这一方案要略做修改，因为不能把它们放在同一个输出位置上。下图（来源于《算法导论》）展示了实际的运行过程。

![基数排序(来源于《算法导论》)](https://upload-images.jianshu.io/upload_images/1678135-f91a4f3d6c19c63d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

构造辅助数组C，C的长度为k。第一次遍历A后，得到[0,k)区间上每个数出现的次数，将这些次数写入C，得到图(a)的结果。然后把C中每个元素变成前面所有元素的累加和，得到图(b)的结果。接下来，再次从后向前遍历数组A，根据取出的元素查找C中对应下标的值，再把这个值作为下标找到B中的位置，即是该元素排序后的位置。例如，图中A的最后一个元素是3，找到C[3]是7，再令B[7]=3即可，然后顺便把C[3]减一，这是防止相同的数被放到同一个位置。

计数排序的时间代价可以这样计算，第一次遍历A并计算C所花时间是Θ(n)，C累加所花时间是Θ(k)，再次遍历A并给B赋值所花时间是Θ(n)，因此，总时间为Θ(k + n)。在实际中，当k=O(n)时，我们一般会采用计数排序，这时的运行时间为Θ(n)。

## 参考 

https://www.jianshu.com/p/ff1797625d66
