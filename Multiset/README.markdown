# 多重集合（Multiset）

A multiset (also known as a bag) is a data structure similar to a regular set, but it can store multiple instances of the same element.
多重集合（也称为bag，也简称多重集）是一种类似于常规集的数据结构，但它可以存储同一元素的多个实例。

For example, if I added the elements 1, 2, 2 to a regular set, the set would only contain two items, since adding 2 a second time has no effect.
例如，如果我将元素1,2,2添加到常规集中，则该集将仅包含两个项，因为第二次添加2无效。

```
var set = Set<Int>()
set.add(1) // set is now [1]
set.add(2) // set is now [1, 2]
set.add(2) // set is still [1, 2]
```

By comparison, after adding the elements 1, 2, 2 to a multiset, it would contain three items.
相比之下，在将元素1,2,2添加到多重集之后，它将包含三个项目。

```
var set = Multiset<Int>()
set.add(1) // set is now [1]
set.add(2) // set is now [1, 2]
set.add(2) // set is now [1, 2, 2]
```

You might be thinking that this looks an awful lot like an array. So why would you use a multiset? Let's consider the differences between the two…
你可能会认为这看起来很像一个数组。 那你为什么要用多重集呢？ 让我们考虑两者之间的差异......

- Ordering: arrays maintain the order of items added to them, multisets do not
- Testing for membership: testing whether an element is a member of the collection is O(N) for arrays, O(1) for multisets.
- Testing for subset: testing whether collection X is a subset of collection Y is a simple operation for a multiset, but complex for arrays

- 排序：数组维护添加到它们的项目的顺序，多重集合没有
- 测试成员资格：测试元素是否是数组成员是O(N)，而多重集合的O(1)。
- 测试子集：测试集合X是否是集合Y的子集，对于多重集而言是一个简单的操作，但对于数组来说是复杂的

Typical operations on a multiset are:

- Add an element
- Remove an element
- Get the count for an element (the number of times it's been added)
- Get the count for the whole set (the number of items that have been added)
- Check whether it is a subset of another multiset

多重集的典型操作是：

- 添加元素
- 删除元素
- 获取元素的计数（添加的次数）
- 获取整个集合的计数（已添加的项数）
- 检查它是否是另一个多重集的子集

One real-world use of multisets is to determine whether one string is a partial anagram of another. For example, the word "cacti" is a partial anagrams of "tactical". (In other words, I can rearrange the letters of "tactical" to make "cacti", with some letters left over.)
在实际使用中，可使用多重集合来确定一个字符串是否是另一个字符串的部分。例如，“cacti”这个词是“tactical”的部分。（换句话说，我可以重新整理“tactical”字母来得到“cacti”，以及余下的一些字母。）

``` swift
var cacti = Multiset<Character>("cacti")
var tactical = Multiset<Character>("tactical")
cacti.isSubSet(of: tactical) // true!
```

## Implementation
## 实施

Under the hood, this implementation of Multiset uses a dictionary to store a mapping of elements to the number of times they've been added.
在幕后，Multiset的实现使用字典来存储元素到它们被添加的次数的映射。

Here's the essence of it:
这是它的本质：

``` swift
public struct Multiset<Element: Hashable> {
  private var storage: [Element: UInt] = [:]
  
  public init() {}
```

And here's how you'd use this class to create a multiset of strings:
以下是如何使用此类创建多重集的字符串：

``` swift
var set = Multiset<String>()
```

Adding an element is a case of incrementing the counter for that element, or setting it to 1 if it doesn't already exist:
添加元素是递增该元素的计数器，或者如果它尚不存在则将其设置为1：

``` swift
public mutating func add (_ elem: Element) {
  storage[elem, default: 0] += 1
}
```

Here's how you'd use this method to add to the set we created earlier:
以下是使用此方法添加到我们之前创建的集合的方法：

```swift
set.add("foo")
set.add("foo") 
set.allItems // returns ["foo", "foo"]
```

Our set now contains two elements, both the string "foo".

Removing an element works much the same way as adding; decrement the counter for the element, or remove it from the underlying dictionary if its value is 1 before removal.

我们的集合现在包含两个元素，字符串“foo”。

删除元素与添加元素的工作方式大致相同; 递减元素的计数器，或者如果在删除之前其值为1，则将其从基础字典中删除。

``` swift
public mutating func remove (_ elem: Element) {
  if let currentCount = storage[elem] {
    if currentCount > 1 {
      storage[elem] = currentCount - 1
    } else {
      storage.removeValue(forKey: elem)
    }
  }
}
```

Getting the count for an item is simple: we just return the value for the given item in the internal dictionary.
获取项目的计数很简单：我们只返回内部字典中给定项目的值。

``` swift
public func count(for key: Element) -> UInt {
  return storage[key] ?? 0
}
```


*作者：Simon Whitaker*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
