# 哈希表(Hash Table)

A hash table allows you to store and retrieve objects by a "key".
哈希表允许您通过“键”存储和检索对象。

A hash table is used to implement structures, such as a dictionary, a map, and an associative array. These structures can be implemented by a tree or a plain array, but it is efficient to use a hash table.
哈希表用于实现一些结构，例如字典，映射和关联数组。 这些结构可以通过树或普通数组实现，但使用哈希表效率更高。

This should explain why Swift's built-in `Dictionary` type requires that keys conform to the `Hashable` protocol: internally it uses a hash table, like the one you will learn about here.
这可以解释为什么Swift的内置`Dictionary`类型要求键符合`Hashable`协议：在内部`Dictionary`使用哈希表实现，就像你将在这里学到的那样。

## 怎么工作的

A hash table is nothing more than an array. Initially, this array is empty. When you put a value into the hash table under a certain key, it uses that key to calculate an index in the array. Here is an example:
哈希表只不过是一个数组。 最初，此数组为空。 将值放入某个键下的哈希表时，它使用该键计算数组中的索引。 这是一个例子：

```swift
hashTable["firstName"] = "Steve"

	The hashTable array:
	+--------------+
	| 0:           |
	+--------------+
	| 1:           |
	+--------------+
	| 2:           |
	+--------------+
	| 3: firstName |---> Steve
	+--------------+
	| 4:           |
	+--------------+
```

In this example, the key `"firstName"` maps to array index 3.
在这个例子中，键`"firstName"`映射到数组索引3。

Adding a value under a different key puts it at another array index:
在不同的键下添加值会将其放在另一个数组索引处：

```swift
hashTable["hobbies"] = "Programming Swift"

	The hashTable array:
	+--------------+
	| 0:           |
	+--------------+
	| 1: hobbies   |---> Programming Swift
	+--------------+
	| 2:           |
	+--------------+
	| 3: firstName |---> Steve
	+--------------+
	| 4:           |
	+--------------+
```

The trick is how the hash table calculates those array indices. That is where the hashing comes in. When you write the following statement,
诀窍是哈希表如何计算这些数组索引。 这就是哈希的用武之地。当你写下面的陈述时，

```swift
hashTable["firstName"] = "Steve"
```

the hash table takes the key `"firstName"` and asks it for its `hashValue` property. Hence, keys must be `Hashable`.
哈希表使用键`"firstName"`并询问它的`hashValue`属性。 因此，键必须符合`Hashable`协议。

When you write `"firstName".hashValue`, it returns a big integer: -4799450059917011053. Likewise, `"hobbies".hashValue` has the hash value 4799450060928805186. (The values you see may vary.)
当你写`"firstName".hashValue`时，它返回一个大整数：-4799450059917011053。 同样，`"hobbies".hashValue`的哈希值为4799450060928805186.（您看到的值可能会有所不同。）

These numbers are big to be used as indices into our array, and one of them is even negative! A common way to make these big numbers  suitable is to first make the hash positive and then take the modulo with the array size.
这些数字很大，可以用作我们数组的索引，其中一个甚至是负数！ 使这些大数字合适的常用方法是首先使哈希值为正，然后数组大小进行取模运算（取余数），这个值就是数组的索引。

Our array has size 5, so the index for the `"firstName"` key becomes `abs(-4799450059917011053) % 5 = 3`. You can calculate that the array index for `"hobbies"` is 1.
我们的数组大小为5，所以`"firstName"`键的索引变为`abs(-4799450059917011053) % 5 = 3`。 你可以计算出`"hobbies"`的数组索引是1（**译注：** `abs(4799450060928805186) % 5 = 1`）。

Using hashes in this manner is what makes the dictionary efficient: to find an element in the hash table, you must hash the key to get an array index and then look up the element in the underlying array. All these operations take a constant amount of time, so inserting, retrieving, and removing are all **O(1)**.
以这种方式使用哈希是使字典有效的原因：要在哈希表中查找元素，必须用键的哈希值以获取数组索引，然后在底层数组中查找元素。 所有这些操作都需要一段时间，因此插入，检索和删除都是 **O(1)**。

> **Note:** It is difficult to predict where in the array your objects end up. Hence, dictionaries do not guarantee any particular order of the elements in the hash table.
> **注意：** 很难预测数组中对象的最终位置。 因此，字典不保证哈希表中元素的任何特定顺序。

## Avoiding collisions
## 避免冲突

There is one problem: because we take the modulo of the hash value with the size of the array, it can happen that two or more keys get assigned the same array index. This is called a collision.
有一个问题：因为我们采用哈希值的模数和数组的大小，可能会发生两个或多个键被赋予相同的数组索引。 这称为冲突。

One way to avoid collisions is to have a large array which reduces the likelihood of two keys mapping to the same index. Another trick is to use a prime number for the array size. However, collisions are bound to occur, so you need to find a way to handle them.
避免冲突的一种方法是使用大型数组，这样可以降低两个键映射到同一索引的可能性。另一个技巧是使用素数作为数组大小。但是，必然会发生冲突，因此您需要找到一种方法来处理冲突。

Because our table is small, it is easy to show a collision. For example, the array index for the key `"lastName"` is also 3, but we do not want to overwrite the value that is already at this array index.
因为我们的表很小，很容易出现冲突。 例如，键`"lastName"` 的数组索引也是3，但我们不想覆盖已在此数组索引处的值。

A common way to handle collisions is to use chaining. The array looks as follows:
处理冲突的常用方法是使用链接。 该数组如下所示：

```swift
	buckets:
	+-----+
	|  0  |
	+-----+     +----------------------------+
	|  1  |---> | hobbies: Programming Swift |
	+-----+     +----------------------------+
	|  2  |
	+-----+     +------------------+     +----------------+
	|  3  |---> | firstName: Steve |---> | lastName: Jobs |
	+-----+     +------------------+     +----------------+
	|  4  |
	+-----+
```

With chaining, keys and their values are not stored directly in the array. Instead, each array element is a list of zero or more key/value pairs. The array elements are usually called the *buckets* and the lists are called the *chains*. Here we have 5 buckets, and two of these buckets have chains. The other three buckets are empty.
使用链接，键和它们的值不会直接存储在数组中。 相反，每个数组元素都是零个或多个键/值对的列表。 数组元素通常称为 *buckets*(可以译为桶)，列表称为 *chains*(可以译为链)。 这里我们有5个*buckets*，其中两个*buckets*有*链*。 其他三个*buckets*都是空的。

If we write the following statement to retrieve an item from the hash table,
如果我们编写以下语句来从哈希表中检索项目，

```swift
let x = hashTable["lastName"]
```

it first hashes the key `"lastName"` to calculate the array index, which is 3. Since bucket 3 has a chain, we step through the list to find the value with the key `"lastName"`. This is done by comparing the keys using a string comparison. The hash table checks that the key belongs to the last item in the chain and returns the corresponding value, `"Jobs"`.
它首先哈希键 `"lastName"` 来计算数组索引，即3。由于桶3有一个链，我们逐步遍历列表，找到带有 `"lastName"` 键的值。这是通过使用字符串比较来比较键来完成的。 哈希表检查键是否属于链中的最后一项，并返回相应的值 `"Jobs"`。

Common ways to implement this chaining mechanism are to use a linked list or another array. Since the order of the items in the chain does not matter, you can think of it as a set instead of a list. (Now you can also imagine where the term "bucket" comes from; we just dump all the objects together into the bucket.)
实现此链机制的常用方法是使用链表或其他数组。 由于链中项目的顺序无关紧要，您可以将其视为集合而不是列表。 （现在你也可以想象术语“桶”的来源;我们只是将所有对象一起转储到桶中。）

Chains should not become long because looking up items in the hash table would become a slow process. Ideally, we would have no chains at all, but in practice it is impossible to avoid collisions. You can improve the odds by giving the hash table enough buckets using high-quality hash functions.
链不应该变长，因为查找哈希表中的项目将变得缓慢。 理想情况下，我们根本没有链条，但实际上不可能避免碰撞。 您可以通过使用高质量哈希函数为哈希表提供足够的桶来提高几率。

> **Note:** An alternative to chaining is "open addressing". The idea is this: if an array index is already taken, we put the element in the next unused bucket. This approach has its own upsides and downsides.
> **注意：** 链接的替代方法是“开放寻址”。 这个想法是这样的：如果已经采用了数组索引，我们将该元素放在下一个未使用的存储桶中。 这种方法有其自身的优点和缺点。

## 代码

Let's look at a basic implementation of a hash table in Swift. We will build it up step-by-step.
让我们看一下Swift中哈希表的基本实现。 我们将逐步建立起来。

```swift
public struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]
  private var buckets: [Bucket]

  private(set) public var count = 0
  
  public var isEmpty: Bool { return count == 0 }

  public init(capacity: Int) {
    assert(capacity > 0)
    buckets = Array<Bucket>(repeatElement([], count: capacity))
  }
```

The `HashTable` is a generic container, and the two generic types are named `Key` (which must be `Hashable`) and `Value`. We also define two other types: `Element` is a key/value pair for using in a chain, and `Bucket` is an array of such `Elements`.
`HashTable`是一个通用容器，两个泛型类型被命名为`Key`（必须是`Hashable`）和`Value`。 我们还定义了另外两种类型：`Element`是在链中使用的键/值对，而`Bucket`是这样的`Elements`的数组。

The main array is named `buckets`. It has a fixed size, the so-called capacity, provided by the `init(capacity)` method. We are also keeping track of how many items have been added to the hash table using the `count` variable.
主数组名为`buckets`。 它有一个固定的大小，即所谓的容量，由`init(capacity)`方法提供。 我们还使用`count`变量跟踪已经向哈希表添加了多少项。

An example of how to create a new hash table object:
如何创建新哈希表对象的示例：

```swift
var hashTable = HashTable<String, String>(capacity: 5)
```

The hash table does not do anything yet, so let's add the remaining functionality. First, add a helper method that calculates the array index for a given key:
哈希表还没有做任何事情，所以让我们添加剩下的功能。 首先，添加一个帮助方法来计算给定键的数组索引：

```swift
  private func index(forKey key: Key) -> Int {
    return abs(key.hashValue) % buckets.count
  }
```

This performs the calculation you saw earlier: it takes the absolute value of the key's `hashValue` modulo the size of the buckets array. We have put this in a function of its own because it gets used in a few different places.
这将执行您之前看到的计算：它将键的`hashValue`的绝对值取为桶数组的大小。 我们已将其置于其自身的功能中，因为它在少数不同的地方使用。

There are four common things you will do with a hash table or dictionary: 
使用哈希表或字典有四种常见的事情：

- insert a new element
- look up an element
- update an existing element
- remove an element
- 插入一个新元素
- 查找元素
- 更新现有元素
- 删除元素

The syntax for these is:
这些的语法是：

```swift
hashTable["firstName"] = "Steve"   // insert
let x = hashTable["firstName"]     // lookup
hashTable["firstName"] = "Tim"     // update
hashTable["firstName"] = nil       // delete
```

We can do all these things with a `subscript` function:
我们可以使用 `subscript` 函数完成所有这些操作：

```swift
  public subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    }
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
```

This calls three helper functions to do the actual work. Let's take a look at `value(forKey:)`which retrieves an object from the hash table.
这需要三个辅助函数来完成实际工作。 让我们看一下`value(forKey:)`，它从哈希表中检索一个对象。

```swift
  public func value(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for element in buckets[index] {
      if element.key == key {
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```
First it calls `index(forKey:)` to convert the key into an array index. That gives us the bucket number, but this bucket may be used by more than one key if there were collisions. The `value(forKey:)` loops through the chain from that bucket and compares the keys one-by-one. If found, it returns the corresponding value, otherwise it returns `nil`.
首先，它调用`index(forKey:)`将键转换为数组索引。 这给了我们桶号，但如果有碰撞，这个桶可能被多个键使用。 `value(forKey:)`从该存储桶循环链并逐个比较密钥。 如果找到，则返回相应的值，否则返回`nil`。

The code to insert a new element or update an existing element lives in `updateValue(_:forKey:)`. This is more complicated:
插入新元素或更新现有元素的代码位于`updateValue(_:forKey:)`中。 这更复杂：

```swift
  public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    
    // Do we already have this key in the bucket?
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }
    
    // This key isn't in the bucket yet; add it to the chain.
    buckets[index].append((key: key, value: value))
    count += 1
    return nil
  }
```

Again, the first step is to convert the key into an array index to find the bucket. Then we loop through the chain for that bucket. If we find the key in the chain, we must update it with the new value. If the key is not in the chain, we insert the new key/value pair to the end of the chain.
同样，第一步是将密钥转换为数组索引以查找存储桶。 然后我们循环通过该桶的链。 如果我们在链中找到密钥，我们必须使用新值更新它。 如果密钥不在链中，我们将新的键/值对插入到链的末尾。

As you can see, it is important to keep the chains short (by making the hash table large enough). Otherwise, you spend excessive time in these `for`...`in` loops and the performance of the hash table will no longer be **O(1)** but more like **O(n)**.
正如您所看到的，保持链短（通过使哈希表足够大）非常重要。 否则，你在这些`for` ...`in`循环中花费的时间过长，哈希表的性能将不再是 **O(1)**，而更像**O(n)**。

Removing is similar in that again it loops through the chain:
删除类似于它，再次遍历链：

```swift
  public mutating func removeValue(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)

    // Find the element in the bucket's chain and remove it.
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        buckets[index].remove(at: i)
        count -= 1
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```

These are the basic functions of the hash table. They all work the same way: convert the key into an array index using its hash value, find the bucket, then loop through that bucket's chain and perform the desired operation.
这些是哈希表的基本功能。 它们都以相同的方式工作：使用其哈希值将密钥转换为数组索引，找到存储桶，然后遍历该存储桶的链并执行所需的操作。

Try this stuff out in a playground. It should work just like a standard Swift `Dictionary`.
在 playground 试试这些东西。 它应该像标准的Swift `Dictionary` 一样工作。

## Resizing the hash table
## 调整哈希表的大小

This version of `HashTable` always uses an array of a fixed size or capacity. If you have many items to store in the hash table, for the capacity, choose a prime number greater than the maximum number of items.
这个版本的`HashTable`总是使用固定大小或容量的数组。 如果要在哈希表中存储许多项目，则对于容量，请选择大于最大项目数的素数。

The *load factor* of a hash table is the percentage of the capacity that is currently used. If there are 3 items in a hash table with 5 buckets, then the load factor is `3/5 = 60%`.
哈希表的*加载因子*是当前使用的容量的百分比。 如果哈希表中有3个项目有5个桶，那么加载因子是“3/5 = 60％”。

If the hash table is small, and the chains are long, the load factor can become greater than 1, that is not a good idea.
如果哈希表很小，并且链很长，那么加载因子可能会大于1，这不是一个好主意。

If the load factor becomes high, greater than 75%, you can resize the hash table. Adding the code for this condition is left as an exercise for the reader. Keep in mind that making the buckets array larger will change the array indices that the keys map to! This requires you to insert all the elements again after resizing the array.
如果加载因子变高，大于75％，则可以调整哈希表的大小。 添加此条件的代码留给读者练习。 请记住，使桶数组更大将改变键映射到的数组索引！ 这要求您在调整数组大小后再次插入所有元素。

## Where to go from here?
## 从这往哪儿走？

`HashTable` is quite basic. It might be efficient to integrate it with the Swift standard library by making it a `SequenceType`.
`HashTable`非常基础。 将它与Swift标准库高效集成为`SequenceType`。

*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

