# 有序数组(Ordered Array)


这是一个始终从低到高排序的数组。 每当您向此数组添加新元素时，它都会插入到其排序位置。

当您希望对数据进行排序并且相对较少地插入新元素时，有序数组非常有用。在这种情况下，它比排序整个数组更快。但是，如果您需要经常更改数组，则使用常规数组并手动对其进行排序可能会更快。

实现是非常基础的。 它只是Swift内置数组的包装器：

```swift
public struct OrderedArray<T: Comparable> {
  fileprivate var array = [T]()

  public init(array: [T]) {
    self.array = array.sorted()
  }

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public subscript(index: Int) -> T {
    return array[index]
  }

  public mutating func removeAtIndex(index: Int) -> T {
    return array.remove(at: index)
  }

  public mutating func removeAll() {
    array.removeAll()
  }
}

extension OrderedArray: CustomStringConvertible {
  public var description: String {
    return array.description
  }
}
```

如您所见，所有这些方法只是在内部`array`变量上调用相应的方法。

剩下的是`insert()`函数。 这是对它的初步尝试：

```swift
  public mutating func insert(_ newElement: T) -> Int {
    let i = findInsertionPoint(newElement)
    array.insert(newElement, at: i)
    return i
  }

  private func findInsertionPoint(_ newElement: T) -> Int {
    for i in 0..<array.count {
      if newElement <= array[i] {
        return i
      }
    }
    return array.count  // insert at the end
  }
```

辅助函数`findInsertionPoint()`只是遍历整个数组，寻找插入新元素的正确位置。

> **注意：** `array.insert(... atIndex: array.count)` 将新对象添加到数组的末尾，所以如果没有找到合适的插入点，我们可以简单地返回`array.count`作为索引。

在playground中测试：

```swift
var a = OrderedArray<Int>(array: [5, 1, 3, 9, 7, -1])
a              // [-1, 1, 3, 5, 7, 9]

a.insert(4)    // inserted at index 3
a              // [-1, 1, 3, 4, 5, 7, 9]

a.insert(-2)   // inserted at index 0
a.insert(10)   // inserted at index 8
a              // [-2, -1, 1, 3, 4, 5, 7, 9, 10]
```

数组的内容将始终从低到高排序。

不幸的是，当前的`findInsertionPoint()`函数有点慢。 在最坏的情况下，它需要扫描整个数组。 我们可以通过使用[二分搜索](../Binary%20Search)查找插入点来加快速度。

新的版本：

```swift
  private func findInsertionPoint(_ newElement: T) -> Int {
    var startIndex = 0
    var endIndex = array.count

    while startIndex < endIndex {
        let midIndex = startIndex + (endIndex - startIndex) / 2
        if array[midIndex] == newElement {
            return midIndex
        } else if array[midIndex] < newElement {
            startIndex = midIndex + 1
        } else {
            endIndex = midIndex
        }
    }
    return startIndex
  }
```

与常规二分搜索的最大区别在于，当找不到值时，不会返回`nil`，而是返回元素本身所在的数组索引。 这就是我们插入新对象的地方。

请注意，使用二分搜索不会改变`insert()`的最坏情况运行时复杂性。二分搜索本身只需要**O(log n)**时间，但在数组中间插入一个新对象仍然需要移动内存中的所有剩余元素。 总的来说，时间复杂度仍然是**O(n)**。但实际上这个新版本肯定要快得多，特别是在大型数组上。

更完整的代码可以查看[Ole Begemann](https://github.com/ole)的[排序数组](https://github.com/ole/SortedArray)。 [对应的文章](https://oleb.net/blog/2017/02/sorted-array/)解释了优势和权衡。



*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*    
*校对：[Andy Ron](https://github.com/andyRon)*    
