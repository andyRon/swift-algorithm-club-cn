# 固定大小数组(Fixed-Size Arrays)


早期的编程语言没有非常奇特的数组。 您将创建具有固定大小的数组，从那时起它将永远不会增长或缩小。 甚至C和Objective-C中的标准数组仍然是这种类型。

当您定义这样的数组时，

	int myArray[10];

编译器分配一个可以容纳40个字节的连续内存块（假设`int`是4个字节）：

![An array with room for 10 elements](Images/array.png)

那就是你的数组。 它总是这么大。 如果你需要超过10个元素，那你就不幸了......没有空间。

要获得一个在装满时增容的数组，你需要使用[动态数组](https://en.wikipedia.org/wiki/Dynamic_array)对象，比如在Objective-C中的`NSMutableArray`或在C ++中的`std::vector`。当然，像Swift这样的语言，其数组本身可以根据需要增加容量。

旧式数组的一个主要缺点是它们空间需求太大或者空间不足。 如果它们太大你就会浪费内存。 并且您需要注意由于缓冲区溢出导致的安全漏洞和崩溃。 总之，固定大小数组不灵活，但不会留下错误。

也就是说，**我喜欢固定大小的数组**因为它们简单，快速且可预测。

以下典型的数组操作：

- 在最后附加一个新元素
- 在开头或中间某处插入一个新元素
- 删除元素
- 按索引查找元素
- 计算数组的大小

对于固定大小的数组，只要数组尚未满，则添加很容易：

![Appending a new element](Images/append.png)

按索引查找也很简单：

![Indexing the array](Images/indexing.png)

这两个操作复杂度是**O(1)**，这意味着执行它们所花费的时间与数组的大小无关。

对于可以增长的数组，关于添加：如果数组已满，则必须分配新内存并将旧内容复制到新的内存缓冲区。 平均而言，添加仍然是**O(1)**操作，但是在之后发生的事情是不太可预测的。

昂贵的操作是插入和删除。 当你在一个不在末尾的某个地方插入一个元素时，它需要将数组的其余部分往后移动一个位置。 这涉及相对昂贵的内存复制操作。 例如，在数组的中间插入值`7`：

![Insert requires a memory copy](Images/insert.png)

如果您的代码使用的索引超过了插入点，但这些索引现在引用了错误的对象。

删除需要相反的操作：

![Delete also requires a memory copy](Images/delete.png)

顺便说一下，对于`NSMutableArray`或Swift数组也是如此。 插入和删除是**O(n)**操作 —— 数组越大，所需的时间越长。

固定大小数组是一个很好的解决方案：

1. 您事先知道您需要的最大元素数量。 在游戏中，这可能是一次可以激活的精灵数量。 对此加以限制并非没有道理。 （对于游戏，最好事先分配你需要的所有对象。）
2. 数组没有必要排序，即元素的顺序无关紧要。

如果数组不需要排序，则不需要`insertAt(index)`操作。 您可以简单地将任何新元素附加到末尾，直到数组已满。

添加元素的代码变为：

```swift
func append(_ newElement: T) {
  if count < maxSize {
    array[count] = newElement
    count += 1
  }
}
```

`count`变量跟踪数组的大小，可以认为是最后一个元素之后的索引。 这也就是您将插入新元素的索引。

确定数组中元素的数量只是读取`count`变量，**O(1)**操作。

删除元素的代码同样简单：

```swift
func removeAt(index: Int) {
  count -= 1
  array[index] = array[count]
}
```

这会将最后一个元素复制到删除的元素的位置，然后减小数组的大小。

![Deleting just means copying one element](Images/delete-no-copy.png)

这就是数组不排序的原因。 为了避免昂贵的数组复制，我们只复制一个元素，但这确实改变了元素的顺序。

现在在数组中有两个元素`6`的副本，但之前的最后一个元素不再是活动数组的一部分。 它只是垃圾数据 —— 下次添加新元素时，这个旧的`6`将被覆盖。

在这两个约束条件下 —— 元素数量和不排序数组的限制 —— 固定大小的数组仍然非常适合在现代软件中使用。

这是Swift中的一个实现：

```swift
struct FixedSizeArray<T> {
  private var maxSize: Int
  private var defaultValue: T
  private var array: [T]
  private (set) var count = 0
  
  init(maxSize: Int, defaultValue: T) {
    self.maxSize = maxSize
    self.defaultValue = defaultValue
    self.array = [T](repeating: defaultValue, count: maxSize)
  }
  
  subscript(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    return array[index]
  }
  
  mutating func append(_ newElement: T) {
    assert(count < maxSize)
    array[count] = newElement
    count += 1
  }
  
  mutating func removeAt(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    count -= 1
    let result = array[index]
    array[index] = array[count]
    array[count] = defaultValue
    return result
  }
  
  mutating func removeAll() {
    for i in 0..<count {
      array[i] = defaultValue
    }
    count = 0
  }
}
```

创建数组时，指定最大大小和默认值：

```swift
var a = FixedSizeArray(maxSize: 10, defaultValue: 0)
```

注意`removeAt(index: Int)`用这个`defaultValue`覆盖最后一个元素来清理留下的“垃圾”对象。 通常将重复的对象留在数组中并不重要，但是如果它是一个类或结构，它可能具有对其他对象的强引用，将这些对象归零是很好的做法。



*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*   
*校对：[Andy Ron](https://github.com/andyRon)*   

