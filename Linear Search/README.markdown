# Linear Search
# 线性搜索

Goal: Find a particular value in an array.
目标：在数组中查找特定值。

We have an array of generic objects. With linear search, we iterate over all the objects in the array and compare each one to the object we're looking for. If the two objects are equal, we stop and return the current array index. If not, we continue to look for the next object as long as we have objects in the array.
我们有一组通用对象。 通过线性搜索，我们迭代数组中的所有对象，并将每个对象与我们正在寻找的对象进行比较。 如果两个对象相等，我们停止并返回当前数组索引。 如果没有，只要我们在数组中有对象，我们就会继续寻找下一个对象。

## An example
## 一个例子

Let's say we have an array of numbers `[5, 2, 4, 7]` and we want to check if the array contains the number `2`.
假设我们有一个数组`[5,2,4,7]`，我们想检查数组是否包含数字`2`。

We start by comparing the first number in the array, `5`, to the number we're looking for, `2`. They are obviously not the same, and so we continue to the next array element.
我们首先将数组中的第一个数字“5”与我们正在寻找的数字`2`进行比较。 它们显然不一样，所以我们继续比较下一个数组元素。

We compare the number `2` from the array to our number `2` and notice they are equal. Now we can stop our iteration and return 1, which is the index of the number `2` in the array.
我们将数组中的数字`2`与数字`2`进行比较，并注意它们是相等的。 现在我们可以停止迭代并返回1，这是数组中数字`2`的索引。

## The code
## 代码

Here is a simple implementation of linear search in Swift:
这是Swift中线性搜索的简单实现：

```swift
func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerated() where obj == object {
    return index
  }
  return nil
}
```

Put this code in a playground and test it like so:
将此代码放在playground里测试：

```swift
let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1
```

## Performance
## 性能


Linear search runs at **O(n)**. It compares the object we are looking for with each object in the array and so the time it takes is proportional to the array length. In the worst case, we need to look at all the elements in the array.
线性搜索以 **O(n)** 运行。它将我们要查找的对象与数组中的每个对象进行比较，因此它所花费的时间与数组长度成正比。在最坏的情况下，我们需要查看数组中的所有元素。

The best-case performance is **O(1)** but this case is rare because the object we're looking for has to be positioned at the start of the array to be immediately found. You might get lucky, but most of the time you won't. On average, linear search needs to look at half the objects in the array.
最好的情况是 **O(1)**， 但这种情况很少见，因为我们要查找的对象必须定位在数组的开头才能立即找到。你可能会很幸运，但大部分时间你都不会。平均而言，线性搜索需要查看数组中对象的一半。

## See also
## 扩展阅读

[线性搜索的维基百科](https://en.wikipedia.org/wiki/Linear_search)

*Written by [Patrick Balestra](http://www.github.com/BalestraPatrick)*
*作者：[Patrick Balestra](http://www.github.com/BalestraPatrick)*  
*译者：[Andy Ron](https://github.com/andyRon)*
