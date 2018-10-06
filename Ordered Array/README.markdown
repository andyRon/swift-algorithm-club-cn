# Ordered Array
# 有序数组

This is an array that is always sorted from low to high. Whenever you add a new item to this array, it is inserted in its sorted position.
这是一个始终从低到高排序的数组。 每当您向此数组添加新项目时，它都会插入到其排序位置。

An ordered array is useful for when you want your data to be sorted and you're inserting new items relatively rarely. In that case, it's faster than sorting the entire array. However, if you need to change the array often, it's probably faster to use a regular array and sort it manually.
当您希望对数据进行排序并且相对较少地插入新项时，有序数组非常有用。 在这种情况下，它比排序整个数组更快。 但是，如果您需要经常更改数组，则使用常规数组并手动对其进行排序可能会更快。

The implementation is quite basic. It's simply a wrapper around Swift's built-in array:
实施是非常基础的。 它只是Swift内置数组的包装器：

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

As you can see, all these methods simply call the corresponding method on the internal `array` variable.
如您所见，所有这些方法只是在内部`array`变量上调用相应的方法。

What remains is the `insert()` function. Here is an initial stab at it:
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

The helper function `findInsertionPoint()` simply iterates through the entire array, looking for the right place to insert the new element.
辅助函数`findInsertionPoint()`只是遍历整个数组，寻找插入新元素的正确位置。

> **Note:** Quite conveniently, `array.insert(... atIndex: array.count)` adds the new object to the end of the array, so if no suitable insertion point was found we can simply return `array.count` as the index.
> **注意：** 很方便，`array.insert(... atIndex:array.count)`将新对象添加到数组的末尾，所以如果没有找到合适的插入点，我们可以简单地返回`array.count`作为索引。

Here's how you can test it in a playground:
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

The array's contents will always be sorted from low to high, now matter what.
数组的内容将始终从低到高排序，现在无关紧要。

Unfortunately, the current `findInsertionPoint()` function is a bit slow. In the worst case, it needs to scan through the entire array. We can speed this up by using a [binary search](../Binary%20Search) to find the insertion point.
不幸的是，当前的`findInsertionPoint()`函数有点慢。 在最坏的情况下，它需要扫描整个阵列。 我们可以通过使用[二分搜索](../Binary%20Search)来查找插入点来加快速度。

Here is the new version:
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

The big difference with a regular binary search is that this doesn't return `nil` when the value can't be found, but the array index where the element would have been. That's where we insert the new object.
与常规二进制搜索的最大区别在于，当找不到值时，这不会返回`nil`，而是元素本身所在的数组索引。 这就是我们插入新对象的地方。

Note that using binary search doesn't change the worst-case running time complexity of `insert()`. The binary search itself takes only **O(log n)** time, but inserting a new object in the middle of an array still involves shifting all remaining elements in memory. So overall, the time complexity is still **O(n)**. But in practice this new version definitely is a lot faster, especially on large arrays.
请注意，使用二进制搜索不会改变`insert()`的最坏情况运行时复杂性。 二进制搜索本身只需要**O(log n)**时间，但在数组中间插入一个新对象仍然需要移动内存中的所有剩余元素。 总的来说，时间复杂度仍然是**O(n)**。 但实际上这个新版本肯定要快得多，特别是在大型阵列上。

A more complete and production ready [SortedArray](https://github.com/ole/SortedArray) is avalible from [Ole Begemann](https://github.com/ole). The [accompanying article](https://oleb.net/blog/2017/02/sorted-array/) explains the advantages and tradeoffs.
更完整和生产就绪[SortedArray](https://github.com/ole/SortedArray)可以从[Ole Begemann](https://github.com/ole)获得。 [随附文章](https://oleb.net/blog/2017/02/sorted-array/)解释了优势和权衡。

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
