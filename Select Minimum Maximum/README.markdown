# Select Minimum / Maximum
# 查找最大／最小值

Goal: Find the minimum/maximum object in an unsorted array.
目标：查找未排序数组中的最大/最小值。

## Maximum or minimum
## 最大或最小

We have an array of generic objects and we iterate over all the objects keeping track of the minimum/maximum element so far.
我们有一个通用对象数组，我们迭代所有对象，跟踪到目前为止的最小/最大元素。

### An example
### 例子


Let's say the we want to find the maximum value in the unsorted list `[ 8, 3, 9, 4, 6 ]`.

Pick the first number, `8`, and store it as the maximum element so far. 

Pick the next number from the list, `3`, and compare it to the current maximum. `3` is less than `8` so the maximum `8` does not change.

Pick the next number from the list, `9`, and compare it to the current maximum. `9` is greater than `8` so we store `9` as the maximum.

Repeat this process until the all elements in the list have been processed.
假设我们想在未排序列表`[8,3,9,4,6]`中找到最大值。

选择第一个数字`8`，并将其存储为目前为止的最大元素。

从列表中选择下一个数字`3`，并将其与当前最大值进行比较。 `3`小于`8`所以最大'8'不会改变。

从列表中选择下一个数字`9`，并将其与当前最大值进行比较。 `9`大于`8`所以我们存储`9`作为最大值。

重复此过程，直到处理完列表中的所有元素。

### The code
### 代码

Here is a simple implementation in Swift:
这是Swift中的一个简单实现：

```swift
func minimum<T: Comparable>(_ array: [T]) -> T? {
  guard var minimum = array.first else {
    return nil
  }

  for element in array.dropFirst() {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

func maximum<T: Comparable>(_ array: [T]) -> T? {
  guard var maximum = array.first else {
    return nil
  }

  for element in array.dropFirst() {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}
```

Put this code in a playground and test it like so:
将此代码放在 playground 测试：

```swift
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
```

### In the Swift standard library
### 在Swift标准库中

The Swift library already contains an extension to `SequenceType` that returns the minimum/maximum element in a sequence.
Swift库已经包含`SequenceType`的扩展，它返回序列中的最小/最大元素。

```swift
let array = [ 8, 3, 9, 4, 6 ]
array.minElement()   // This will return 3
array.maxElement()   // This will return 9
```

```swift
let array = [ 8, 3, 9, 4, 6 ]
//swift3
array.min()   // This will return 3
array.max()   // This will return 9
```

## Maximum and minimum
## 最大值和最小值

To find both the maximum and minimum values contained in array while minimizing the number of comparisons we can compare the items in pairs. 
要同时查找数组中包含的最大值和最小值，同时最小化比较次数，我们可以成对比较项目。

### An example
### 例子

Let's say the we want to find the minimum and maximum value in the unsorted list `[ 8, 3, 9, 6, 4 ]`.

Pick the first number, `8`, and store it as the minimum and maximum element so far. 

Because we have an odd number of items we remove `8` from the list which leaves the pairs `[ 3, 9 ]` and `[ 6, 4 ]`.

Pick the next pair of numbers from the list, `[ 3, 9 ]`. Of these two numbers, `3` is the smaller one, so we compare `3` to the current minimum `8`, and we compare `9` to the current maximum `8`. `3` is less than `8` so the new minimum is `3`. `9` is greater than `8` so the new maximum is `9`.

Pick the next pair of numbers from the list, `[ 6, 4 ]`. Here, `4` is the smaller one, so we compare `4` to the current minimum `3`, and we compare `6` to the current maximum `9`. `4` is greater than `3` so the minimum does not change. `6` is less than `9` so the maximum does not change.

The result is a minimum of `3` and a maximum of `9`.

假设我们想要在未排序列表`[8,3,9,6,4]`中找到最小值和最大值。

选择第一个数字`8`，并将其存储为目前为止的最小和最大元素。

因为我们有一个奇数项目，我们从列表中删除`8`，留下对`[3,9]`和`[6,4]`。

从列表中选择下一对数字，`[3,9]`。 在这两个数字中，`3`是较小的数字，因此我们将`3`与当前最小值`8`进行比较，并将`9`与当前最大值`8`进行比较。 `3`小于`8`所以新的最小值是`3`。 `9`大于`8`所以新的最大值是`9`。

从列表中选择下一对数字，`[6,4]`。 这里，`4`是较小的一个，所以我们将`4`与当前最小`3`进行比较，并将`6`与当前最大`9`进行比较。 `4`大于`3`，所以最小值不会改变。 `6`小于`9`，因此最大值不会改变。

结果是最小值为`3`，最大值为`9`。

### The code
### 代码

Here is a simple implementation in Swift:
这是Swift中的一个简单实现：

```swift
func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
  guard var minimum = array.first else {
    return nil
  }
  var maximum = minimum

  // if 'array' has an odd number of items, let 'minimum' or 'maximum' deal with the leftover
  let start = array.count % 2 // 1 if odd, skipping the first element
  for i in stride(from: start, to: array.count, by: 2) {
    let pair = (array[i], array[i+1])

    if pair.0 > pair.1 {
      if pair.0 > maximum {
        maximum = pair.0
      }
      if pair.1 < minimum {
        minimum = pair.1
      }
    } else {
      if pair.1 > maximum {
        maximum = pair.1
      }
      if pair.0 < minimum {
        minimum = pair.0
      }
    }
  }

  return (minimum, maximum)
}
```

Put this code in a playground and test it like so:
将此代码放在playground测试：

```swift
let result = minimumMaximum(array)!
result.minimum   // This will return 3
result.maximum   // This will return 9
```

By picking elements in pairs and comparing their maximum and minimum with the running minimum and maximum we reduce the number of comparisons to 3 for every 2 elements.
通过成对挑选元素并将其最大值和最小值与运行的最小值和最大值进行比较，我们将每2个元素的比较次数减少到3次。

## Performance
## 性能

These algorithms run at **O(n)**. Each object in the array is compared with the running minimum/maximum so the time it takes is proportional to the array length.
这些算法以**O(n)**运行。 将数组中的每个对象与运行的最小值/最大值进行比较，以便所花费的时间与数组长度成比例。

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
*作者：[Chris Pilcher](https://github.com/chris-pilcher)*  
*翻译：[Andy Ron](https://github.com/andyRon)*
