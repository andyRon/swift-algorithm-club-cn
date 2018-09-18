# 线性搜索（Linear Search）

目标：在数组中查找特定值。


我们有一组通用对象。 通过线性搜索，我们迭代数组中的所有对象，并将每个对象与我们正在寻找的对象进行比较。 如果两个对象相等，我们停止并返回当前对象在数组中的索引。 如果不相等，只要数组中还有对象，我们就会继续寻找下一个。

## 一个例子

假设我们有一个数组`[5,2,4,7]`，我们想检查数组是否包含数字`2`。

我们首先将数组中的第一个数字`5`与我们正在寻找的数字`2`进行比较。 它们显然不一样，所以我们继续比较下一个数组元素。

我们将数组中的数字`2`与数字`2`进行比较，注意到它们是相等的。 现在我们可以停止迭代并返回1，这是数组中数字`2`的索引。

## 代码

这是Swift线性搜索的简单实现：

```swift
func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerated() where obj == object {
    return index
  }
  return nil
}
```

将此代码放在playground里测试：

```swift
let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1
```

## 性能

线性搜索性能是**O(n)** 。它将我们要查找的对象与数组中的每个对象进行比较，因此它所花费的时间与数组长度成正比。在最坏的情况下，我们需要查看数组中的所有元素。

最好的情况是 **O(1)**，但这种情况很少见，因为我们要查找的对象必须位于数组的开头才能立即找到。你可能会很幸运，但大部分时间你都不会。平均而言，线性搜索需要查看数组中对象的一半。

## 扩展阅读

[线性搜索的维基百科](https://en.wikipedia.org/wiki/Linear_search)

*作者：[Patrick Balestra](http://www.github.com/BalestraPatrick)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*

