# 多重集合（Multiset）

多重集合（也称为bag，简称多重集）是一种类似于常规集的数据结构，但它可以存储同一元素的多个实例。

例如，如果我将元素1,2,2添加到常规集中，则该集将仅包含两个项，因为第二次添加2无效。

```swift
var set = Set<Int>()
set.add(1) // set is now [1]
set.add(2) // set is now [1, 2]
set.add(2) // set is still [1, 2]
```

相比之下，在将元素1,2,2添加到多重集之后，它将包含三个项目。

```swift
var set = Multiset<Int>()
set.add(1) // set is now [1]
set.add(2) // set is now [1, 2]
set.add(2) // set is now [1, 2, 2]
```

你可能会认为这看起来很像一个数组。 那你为什么要用多重集呢？ 让我们考虑两者之间的差异......


- 排序：数组维护添加到它们的项目的顺序，多重集合没有
- 测试成员资格：测试元素是否其成员，数组是O(N)，而多重集合的O(1)。
- 测试子集：测试集合X是否是集合Y的子集，对于多重集而言是一个简单的操作，但对于数组来说是复杂的


多重集的典型操作是：

- 添加元素
- 删除元素
- 获取元素的计数（添加的次数）
- 获取整个集合的计数（已添加的项数）
- 检查它是否是另一个多重集的子集

在实际使用中，可使用多重集合来确定一个字符串是否是另一个字符串的部分。例如，“cacti”这个词是“tactical”的部分。（换句话说，我可以重新整理“tactical”字母来得到“cacti”，以及余下的一些字母。）

``` swift
var cacti = Multiset<Character>("cacti")
var tactical = Multiset<Character>("tactical")
cacti.isSubSet(of: tactical) // true!
```

## 实施

在幕后，Multiset的实现使用字典来存储元素到它们被添加的次数的映射。

这是它的本质：

``` swift
public struct Multiset<Element: Hashable> {
  private var storage: [Element: UInt] = [:]
  
  public init() {}
```

以下是如何使用此类创建多重集的字符串：

``` swift
var set = Multiset<String>()
```

添加元素是递增该元素的计数器，或者如果它尚不存在则将其设置为1：

``` swift
public mutating func add (_ elem: Element) {
  storage[elem, default: 0] += 1
}
```

以下是使用此方法添加到我们之前创建的集合的方法：

```swift
set.add("foo")
set.add("foo") 
set.allItems // returns ["foo", "foo"]
```

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

获取项目的计数很简单：我们只返回内部字典中给定项目的值。

``` swift
public func count(for key: Element) -> UInt {
  return storage[key] ?? 0
}
```


*作者：Simon Whitaker*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
