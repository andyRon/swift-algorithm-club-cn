# 布隆过滤器(Bloom Filter)

## Introduction
## 介绍

A Bloom Filter is a space-efficient data structure that tells you whether or not an element is present in a set.
布隆过滤器是一种节省空间的数据结构，可以告诉您元素是否存在于集合中。

This is a probabilistic data structure: a query to a Bloom filter either returns `false`, meaning the element is definitely not in the set, or `true`, meaning that the element *might* be in the set.
这是一个概率数据结构：对布隆过滤器的查询返回`false`，意味着该元素肯定不在集合中，或者是`true`，这意味着元素*可能*在集合中。

There is a small probability of false positives, where the element isn't actually in the set even though the query returned `true`. But there will never any false negatives: you're guaranteed that if the query returns `false`, then the element really isn't in the set.
误报的可能性很小，即使查询返回`true`，元素实际上也不在集合中。 但是永远不会有任何漏报：如果查询返回`false`，你可以保证，那么元素确实不在集合中。

So a Bloom Filter tells you, "definitely not" or "probably yes".
所以布隆过滤器告诉你，“绝对不是”或“可能是的”。

At first, this may not seem too useful. However, it's important in applications like cache filtering and data synchronization.
起初，这似乎不太有用。 但是，它在缓存过滤和数据同步等应用程序中很重要。

An advantage of the Bloom Filter over a hash table is that the former maintains constant memory usage and constant-time insert and search. For sets with a large number of elements, the performance difference between a hash table and a Bloom Filter is significant, and it is a viable option if you do not need the guarantee of no false positives.
布隆过滤器优于哈希表的一个优点是前者保持恒定的内存使用和恒定时间插入和搜索。 对于具有大量元素的集合，哈希表和布隆过滤器之间的性能差异很大，如果您不需要保证不存在误报，则它是可行的选项。

> **Note:** Unlike a hash table, the Bloom Filter does not store the actual objects. It just remembers what objects you’ve seen (with a degree of uncertainty) and which ones you haven’t.
> **注意：**与哈希表不同，布隆过滤器不存储实际对象。 它只会记住你看过的物体（有一定程度的不确定性）以及你没有看过的物体。

## Inserting objects into the set
## 将对象插入集合中

A Bloom Filter is essentially a fixed-length [bit vector](../Bit%20Set/), an array of bits. When we insert objects, we set some of these bits to `1`, and when we query for objects we check if certain bits are `0` or `1`. Both operations use hash functions.
布隆过滤器本质上是一个固定长度的[位向量](../Bit%20Set/)，一个位数组。 当我们插入对象时，我们将其中一些位设置为`1`，当我们查询对象时，我们检查某些位是`0`还是`1`。 两个操作都使用哈希函数。

To insert an element in the filter, the element is hashed with several different hash functions. Each hash function returns a value that we map to an index in the array. We then set the bits at these indices to `1` or true.
要在过滤器中插入元素，可以使用多个不同的哈希函数对元素进行哈希。 每个哈希函数返回一个我们映射到数组中索引的值。 然后，我们将这些索引处的位设置为`1`或“真”。

For example, let's say this is our array of bits. We have 17 bits and initially they are all `0` or false:
例如，假设这是我们的位数组。 我们有17位，最初它们都是`0`或假：

	[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

Now we want to insert the string `"Hello world!"` into the Bloom Filter. We apply two hash functions to this string. The first one gives the value 1999532104120917762. We map this hash value to an index into our array by taking the modulo of the array length: `1999532104120917762 % 17 = 4`. This means we set the bit at index 4 to `1` or true:
现在我们要在布隆过滤器中插入字符串`"Hello world!"`。 我们对此字符串应用两个哈希函数。第一个给出值1999532104120917762。我们通过取数组长度的模数将此哈希值映射到数组的索引：`1999532104120917762 % 17 = 4`。 这意味着我们将索引4处的位设置为`1`或者为真：

	[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

Then we hash the original string again but this time with a different hash function. It gives the hash value 9211818684948223801. Modulo 17 that is 12, and we set the bit at index 12 to `1` as well:
然后我们再次散列原始字符串，但这次使用不同的散列函数。 它给出哈希值9211818684948223801。模数17为12，我们也将索引12处的位设置为`1`：

	[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ]

These two 1-bits are enough to tell the Bloom Filter that it now contains the string `"Hello world!"`. Of course, it doesn't contain the actual string, so you can't ask the Bloom Filter, "give me a list of all the objects you contain". All it has is a bunch of ones and zeros.
这两个1位足以告诉布隆过滤器它现在包含字符串 `"Hello world!"`。 当然，它不包含实际的字符串，所以你不能要求布隆过滤器，“给我一个你包含的所有对象的列表”。 所有它都是一堆零和零。

## Querying the set
## 查询集合

Querying, similarly to inserting, is accomplished by first hashing the expected value, which gives several array indices, and then checking to see if all of the bits at those indices are `1`. If even one of the bits is not `1`, the element could not have been inserted and the query returns `false`. If all the bits are `1`, the query returns `true`.
类似于插入，查询是通过首先对期望值进行哈希来实现的，该期望值给出几个数组索引，然后检查这些索引处的所有位是否为`1`。 如果其中一个位不是`1`，则无法插入该元素，并且查询返回`false`。 如果所有位都是`1`，则查询返回`true`。

For example, if we query for the string `"Hello WORLD"`, then the first hash function returns 5383892684077141175, which modulo 17 is 12. That bit is `1`. But the second hash function gives 5625257205398334446, which maps to array index 9. That bit is `0`. This means the string `"Hello WORLD"` is not in the filter and the query returns `false`.
例如，如果我们查询字符串`"Hello WORLD"`，那么第一个哈希函数返回5383892684077141175，其中模17是12.该位是`1`。但是第二个哈希函数给出5625257205398334446，它映射到数组索引9.该位为`0`。 这意味着字符串`"Hello WORLD"`不在过滤器中，查询返回`false`。

The fact that the first hash function mapped to a `1` bit is a coincidence (it has nothing to do with the fact that both strings start with `"Hello "`). Too many such coincidences can lead to "collisions". If there are collisions, the query may erroneously return `true` even though the element was not inserted -- bringing about the issue with false positives mentioned earlier.
第一个哈希函数映射到`1`位的事实是巧合（它与两个字符串以`"Hello "`开头的事实无关）。 太多这样的巧合可能导致“碰撞”。 如果存在冲突，即使未插入元素，查询也可能错误地返回`true` - 导致前面提到的误报问题。

Let's say we insert some other element, `"Bloom Filterz"`, which sets bits 7 and 9. Now the array looks like this:
假设我们插入了一些其他元素，`"Bloom Filterz"`，它设置了第7位和第9位。现在数组看起来像这样：

	[ 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0 ]

If you query for `"Hello WORLD"` again, the filter sees that bit 12 is true and bit 9 is now true as well. It reports that `"Hello WORLD"` is indeed present in the set, even though it isn't... because we never inserted that particular string. It's a false positive. This example shows why a Bloom Filter will never say, "definitely yes", only "probably yes".
如果再次查询`"Hello WORLD"`，则过滤器会看到第12位为真，第9位现在也为真。 它报告说`"Hello WORLD"`确实出现在集合中，即使它不是......因为我们从未插入过那个特定的字符串。这是误报。这个例子说明了为什么布隆过滤器永远不会说“绝对是”，只有“可能是”。

You can fix such issues by using an array with more bits and using additional hash functions. Of course, the more hash functions you use the slower the Bloom Filter will be. So you have to strike a balance.
您可以通过使用具有更多位的数组并使用其他哈希函数来解决此类问题。 当然，使用的哈希函数越多，布隆过滤器就越慢。 所以你必须取得平衡。

Deletion is not possible with a Bloom Filter, since any one bit might belong to multiple elements. Once you add an element, it's in there for good.
使用布隆过滤器无法删除，因为任何一个位都可能属于多个元素。 一旦你添加了一个元素，它就在那里。

Performance of a Bloom Filter is **O(k)** where **k** is the number of hashing functions.
布隆过滤器的性能是**O(k)**其中 **k**是哈希函数的数量。

## The code
## 代码

The code is quite straightforward. The internal bit array is set to a fixed length on initialization, which cannot be mutated once it is initialized.
代码非常简单。 内部位数组在初始化时设置为固定长度，初始化后不能进行突变。

```swift
public init(size: Int = 1024, hashFunctions: [(T) -> Int]) {
	self.array = [Bool](repeating: false, count: size)
  self.hashFunctions = hashFunctions
}
```

Several hash functions should be specified at initialization. Which hash functions you use will depend on the datatypes of the elements you'll be adding to the set. You can see some examples in the playground and the tests -- the `djb2` and `sdbm` hash functions for strings.
应在初始化时指定几个哈希函数。 您使用哪些哈希函数将取决于您将添加到集合的元素的数据类型。 你可以在游乐场和测试中看到一些例子 - 字符串的`djb2`和`sdbm`哈希函数。

Insertion just flips the required bits to `true`:
插入只是将所需的位翻转为`true`：

```swift
public func insert(_ element: T) {
  for hashValue in computeHashes(element) {
    array[hashValue] = true
  }
}
```

This uses the `computeHashes()` function, which loops through the specified `hashFunctions` and returns an array of indices:
这使用`computeHashes()`函数，它循环遍历指定的`hashFunctions`并返回索引数组：

```swift
private func computeHashes(_ value: T) -> [Int] {
  return hashFunctions.map() { hashFunc in abs(hashFunc(value) % array.count) }
}
```

And querying checks to make sure the bits at the hashed values are `true`:
并查询检查以确保哈希值处的位为`true`：

```swift
public func query(_ value: T) -> Bool {
  let hashValues = computeHashes(value)
  let results = hashValues.map() { hashValue in array[hashValue] }
	let exists = results.reduce(true, { $0 && $1 })
  return exists
}
```

If you're coming from another imperative language, you might notice the unusual syntax in the `exists` assignment. Swift makes use of functional paradigms when it makes code more consise and readable, and in this case `reduce` is a much more consise way to check if all the required bits are `true` than a `for` loop.
如果你来自另一种命令式语言，你可能会注意到`exists`赋值中的不寻常语法。 当Swift使代码更加简洁和可读时，Swift使用函数范例，在这种情况下，`reduce`是一种更加简洁的方法来检查所有必需的位是否为`true`而不是`for`循环。

*Written for Swift Algorithm Club by Jamil Dhanani. Edited by Matthijs Hollemans.*  
*作者：Jamil Dhanani，Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)* 
