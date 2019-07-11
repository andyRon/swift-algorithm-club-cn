# 有序集（Ordered Set）

我们来看看苹果如何实现[有序集](https://developer.apple.com/documentation/foundation/nsorderedset)。

Here is the example about how it works
以下是有关其工作原理的示例：

```swift
let s = AppleOrderedSet<Int>()

s.add(1)
s.add(2)
s.add(-1)
s.add(0)
s.insert(4, at: 3)

print(s.all()) // [1, 2, -1, 4, 0]

s.set(-1, at: 0) // 已经有-1在index: 2，因此这个操作不做任何事情

print(s.all()) // [1, 2, -1, 4, 0]

s.remove(-1)

print(s.all()) // [1, 2, 4, 0]

print(s.object(at: 1)) // 2

print(s.object(at: 2)) // 4
```

显着的区别是数组没有排序。 插入时，数组中的元素是相同的。 将数组映像为不重复且具有 `O(logn)` 或 `O(1)` 搜索时间。

这里的想法是使用数据结构来提供  `O(1)` 或  `O(logn)` 时间复杂度，因此很容易考虑哈希表。

```swift
var indexOfKey: [T: Int]
var objects: [T]
```

`indexOfKey` is used to track the index of the element. `objects` is array holding elements.
`indexOfKey` 用于跟踪元素的索引。 `objects`是数组保持元素。

我们将在这里详细介绍一些关键功能。

### 添加

更新`indexOfKey`并在`objects`的末尾插入元素

```swift
// O(1)
public func add(_ object: T) {
	guard indexOfKey[object] == nil else {
		return
	}

	objects.append(object)
	indexOfKey[object] = objects.count - 1
}
```

### 插入

在数组的随机位置插入将花费 `O(n)` 时间。

```swift
// O(n)
public func insert(_ object: T, at index: Int) {
	assert(index < objects.count, "Index should be smaller than object count")
	assert(index >= 0, "Index should be bigger than 0")

	guard indexOfKey[object] == nil else {
		return
	}

	objects.insert(object, at: index)
	indexOfKey[object] = index
	for i in index+1..<objects.count {
		indexOfKey[objects[i]] = i
	}
}
```

###  设置

如果`object`已存在于`OrderedSet`中，则什么也不做。 否则，我们需要更新`indexOfkey`和`objects`。

```swift
// O(1)
public func set(_ object: T, at index: Int) {
	assert(index < objects.count, "Index should be smaller than object count")
	assert(index >= 0, "Index should be bigger than 0")

	guard indexOfKey[object] == nil else {
		return
	}

	indexOfKey.removeValue(forKey: objects[index])
	indexOfKey[object] = index
	objects[index] = object
}
```

### 删除

删除数组中的元素将花费 `O(n)`。 同时，我们需要在删除元素后更新所有元素的索引。

```swift
// O(n)
public func remove(_ object: T) {
	guard let index = indexOfKey[object] else {
		return 
	}

	indexOfKey.removeValue(forKey: object)
	objects.remove(at: index)
	for i in index..<objects.count {
		indexOfKey[objects[i]] = i
	}
}
```

*作者：Kai Chen*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
