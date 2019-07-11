# 有序集（Ordered Set）

Let's look into how to implement [Ordered Set](https://developer.apple.com/documentation/foundation/nsorderedset).
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

The significant difference is the the array is not sorted. The elements in the array are the same when insert them. Image the array without duplicates and with `O(logn)` or `O(1)` search time.
显着的区别是数组没有排序。 插入时，数组中的元素是相同的。 将数组映像为不重复且具有 `O(logn)` 或 `O(1)` 搜索时间。

The idea here is using a data structure to provide `O(1)` or `O(logn)` time complexity, so it's easy to think about hash table.
这里的想法是使用数据结构来提供  `O(1)` 或  `O(logn)` 时间复杂度，因此很容易考虑哈希表。

```swift
var indexOfKey: [T: Int]
var objects: [T]
```

`indexOfKey` is used to track the index of the element. `objects` is array holding elements.
`indexOfKey` 用于跟踪元素的索引。 `objects`是数组保持元素。

We will go through some key functions details here.
我们将在这里详细介绍一些关键功能。

### Add
### 添加

Update `indexOfKey` and insert element in the end of `objects`
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

### Insert
### 插入

Insert in a random place of the array will cost `O(n)` time.
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

If the `object` already existed in the `OrderedSet`, do nothing. Otherwise, we need to update the `indexOfkey` and `objects`.
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

Remove element in the array will cost `O(n)`. At the same time, we need to update all elements's index after the removed element.
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
