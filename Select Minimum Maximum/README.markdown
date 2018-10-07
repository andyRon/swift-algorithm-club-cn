
# 查找最大／最小值(Select Minimum / Maximum)

目标：查找未排序数组中的最大/最小值。

## 最大值或最小值

我们有一个通用对象数组，我们迭代所有对象，跟踪遇到的最小/最大元素。

### 例子


假设我们想在未排序列表`[8,3,9,4,6]`中找到最大值。

选择第一个数字`8`，并将其存储作为目前为止的最大元素。

从列表中选择下一个数字`3`，并将其与当前最大值进行比较。 `3`小于`8`所以最大值`8`不会改变。

从列表中选择下一个数字`9`，并将其与当前最大值进行比较。 `9`大于`8`所以我们存储`9`作为最大值。

重复此过程，直到处理完列表中的所有元素。

### 代码

在Swift中的一个简单实现：

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

将代码放在 playground 测试：

```swift
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
```

### Swift的标准库

Swift库已经包含一个叫做`SequenceType`的扩展，它可返回序列中的最小/最大元素。

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

## 最大值和最小值

要同时查找数组中包含的最大值和最小值，为了最小化比较次数，我们可以成对比较。

### 例子


假设我们想要在未排序列表`[8,3,9,6,4]`中找到最小值和最大值。

选择第一个数字`8`，并将其存储为目前为止的最小和最大值。

因为我们有一个奇数项目，我们从列表中删除`8`，留下两队`[3,9]`和`[6,4]`。

从列表中选择下一对数字，`[3,9]`。 在这两个数字中，`3`是较小的数字，因此我们将`3`与当前最小值`8`进行比较，并将`9`与当前最大值`8`进行比较。 `3`小于`8`，所以新的最小值是`3`。 `9`大于`8`，所以新的最大值是`9`。

从列表中选择下一对数字，`[6,4]`。 这里，`4`是较小的一个，所以我们将`4`与当前最小`3`进行比较，并将`6`与当前最大`9`进行比较。 `4`大于`3`，所以最小值不会改变。 `6`小于`9`，因此最大值不会改变。

结果是最小值为`3`，最大值为`9`。

### 代码

在Swift中的一个简单实现：

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

在playground测试：

```swift
let result = minimumMaximum(array)!
result.minimum   // This will return 3
result.maximum   // This will return 9
```

通过成对挑选元素并将其最大值和最小值与当前的最小值和最大值进行比较，我们将每2个元素的比较次数减少到3次。

## 性能

这些算法以**O(n)**运行。 将数组中的每个对象与当前的最小值/最大值进行比较，所花费的时间与数组长度成比例。


*作者：[Chris Pilcher](https://github.com/chris-pilcher)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
