# 哈希集合（Hash Set）

A set is a collection of elements that is kind of like an array but with two important differences: the order of the elements in the set is unimportant and each element can appear only once.
集合是元素的集合，有点像数组但有两个重要的区别：集合中元素的顺序不重要，每个元素只能出现一次。

If the following were arrays, they'd all be different. However, they all represent the same set:
如果以下是数组，它们都会有所不同。 但是，它们都代表相同的集合：

```swift
[1 ,2, 3]
[2, 1, 3]
[3, 2, 1]
[1, 2, 2, 3, 1]
```

Because each element can appear only once, it doesn't matter how often you write the element down -- only one of them counts.
因为每个元素只能出现一次，所以将元素写入的次数并不重要 —— 只有其中一个元素有效。

> **Note:** I often prefer to use sets over arrays when I have a collection of objects but don't care what order they are in. Using a set communicates to the programmer that the order of the elements is unimportant. If you're using an array, then you can't assume the same thing.
> **注意：**当我有一组对象但不关心它们的顺序时，我经常更喜欢使用数组上的集合。使用集合与程序员通信，元素的顺序并不重要。 如果你正在使用数组，那么你不能假设同样的事情。

Typical operations on a set are:

- insert an element
- remove an element
- check whether the set contains an element
- take the union with another set
- take the intersection with another set
- calculate the difference with another set

一组的典型操作是：

- 插入元素
- 删除元素
- 检查集合是否包含元素
- 与另一组合并
- 与另一组交叉
- 计算与另一组的差异

Union, intersection, and difference are ways to combine two sets into a single one:
并集，交集和差集是将两个集合组合成一个集合的方法：

![Union, intersection, difference](Images/CombineSets.png)

As of Swift 1.2, the standard library includes a built-in `Set` type but here I'll show how you can make your own. You wouldn't use this in production code, but it's instructive to see how sets are implemented.
从Swift 1.2开始，标准库包含一个内置的`Set`类型，但在这里我将展示如何制作自己的类型。 您不会在生产代码中使用它，但了解如何实现集合是有益的。

It's possible to implement a set using a simple array but that's not the most efficient way. Instead, we'll use a dictionary. Since `Swift`'s dictionary is built using a hash table, our own set will be a hash set.
使用简单数组实现集合是可能的，但这不是最有效的方法。 相反，我们将使用字典。由于`Swift`的字典是使用哈希表构建的，因此我们自己的集合将是一个哈希集。

## The code
## 代码

Here are the beginnings of `HashSet` in Swift:
以下是Swift中`HashSet`的开头：

```swift
public struct HashSet<T: Hashable> {
    fileprivate var dictionary = Dictionary<T, Bool>()

    public init() {

    }

    public mutating func insert(_ element: T) {
        dictionary[element] = true
    }

    public mutating func remove(_ element: T) {
        dictionary[element] = nil
    }

    public func contains(_ element: T) -> Bool {
        return dictionary[element] != nil
    }

    public func allElements() -> [T] {
        return Array(dictionary.keys)
    }

    public var count: Int {
        return dictionary.count
    }

    public var isEmpty: Bool {
        return dictionary.isEmpty
    }
}
```

The code is really very simple because we rely on Swift's built-in `Dictionary` to do all the hard work. The reason we use a dictionary is that dictionary keys must be unique, just like the elements from a set. In addition, a dictionary has **O(1)** time complexity for most of its operations, making this set implementation very fast.
代码非常简单，因为我们依靠Swift的内置`Dictionary`来完成所有的艰苦工作。 我们使用字典的原因是字典键必须是唯一的，就像集合中的元素一样。 此外，字典在其大多数操作中具有**O(1)**时间复杂度，使得该集合实现非常快。

Because we're using a dictionary, the generic type `T` must conform to `Hashable`. You can put any type of object into our set, as long as it can be hashed. (This is true for Swift's own `Set` too.)
因为我们使用的是字典，所以通用类型`T`必须符合`Hashable`。 您可以将任何类型的对象放入我们的集合中，只要它可以进行哈希处理即可。 （对于Swift自己的`Set`也是如此。）

Normally, you use a dictionary to associate keys with values, but for a set we only care about the keys. That's why we use `Bool` as the dictionary's value type, even though we only ever set it to `true`, never to `false`. (We could have picked anything here but booleans take up the least space.)
通常，您使用字典将键与值关联，但对于一个集合，我们只关心键。 这就是为什么我们使用`Bool`作为字典的值类型，即使我们只将它设置为`true`，而不是`false`。 （我们本可以选择任何东西，但布尔占用的空间最小。）

Copy the code to a playground and add some tests:
将代码复制到 playground 并添加一些测试：

```swift
var set = HashSet<String>()

set.insert("one")
set.insert("two")
set.insert("three")
set.allElements()      // ["one, "three", "two"]

set.insert("two")
set.allElements()      // still ["one, "three", "two"]

set.contains("one")    // true
set.remove("one")
set.contains("one")    // false
```

The `allElements()` function converts the contents of the set into an array. Note that the order of the elements in that array can be different than the order in which you added the items. As I said, a set doesn't care about the order of the elements (and neither does a dictionary).
`allElements()`函数将集合的内容转换为数组。 请注意，该数组中元素的顺序可能与添加项目的顺序不同。 正如我所说，一个集合并不关心元素的顺序（也不是字典）。


## Combining sets
## 合并集合

A lot of the usefulness of sets is in how you can combine them. (If you've ever used a vector drawing program like Sketch or Illustrator, you'll have seen the Union, Subtract, Intersect options to combine shapes. Same thing.)
集合的很多用处在于如何合并它们。（如果你曾经使用像Sketch或Illustrator这样的矢量绘图程序，你会看到Union，Subtract，Intersect选项来组合形状。这边也是同样的事情。）

Here is the code for the union operation:
这是union操作的代码：

```swift
extension HashSet {
    public func union(_ otherSet: HashSet<T>) -> HashSet<T> {
        var combined = HashSet<T>()
        for obj in self.dictionary.keys {
            combined.insert(obj)
        }
        for obj in otherSet.dictionary.keys {
            combined.insert(obj)
        }
        return combined
    }
}
```

The *union* of two sets creates a new set that consists of all the elements in set A plus all the elements in set B. Of course, if there are duplicate elements they count only once.
两个集合的 *union* 创建一个新集合，它由集合A中的所有元素加上集合B中的所有元素组成。当然，如果存在重复元素，它们只计算一次。

Example:

```swift
var setA = HashSet<Int>()
setA.insert(1)
setA.insert(2)
setA.insert(3)
setA.insert(4)

var setB = HashSet<Int>()
setB.insert(3)
setB.insert(4)
setB.insert(5)
setB.insert(6)

let union = setA.union(setB)
union.allElements()           // [5, 6, 2, 3, 1, 4]
```

As you can see, the union of the two sets contains all of the elements now. The values `3` and `4` still appear only once, even though they were in both sets.
如您所见，两个集合的并集现在包含所有元素。 值`3`和`4`仍然只出现一次，即使它们都在两组中。

The *intersection* of two sets contains only the elements that they have in common. Here is the code:
两个集合的*intersection*仅包含它们共有的元素。 这是代码：

```swift
extension HashSet {
    public func intersect(_ otherSet: HashSet<T>) -> HashSet<T> {
        var common = HashSet<T>()
        for obj in dictionary.keys {
            if otherSet.contains(obj) {
                common.insert(obj)
            }
        }
        return common
    }
}
```

测试:

```swift
let intersection = setA.intersect(setB)
intersection.allElements()
```

This prints `[3, 4]` because those are the only objects from set A that are also in set B.
这打印 `[3, 4]` 因为那些是集合A中也是集合B的唯一对象。

Finally, the *difference* between two sets removes the elements they have in common. The code is as follows:
最后，两组之间的*difference*删除了它们共有的元素。 代码如下：

```swift
extension HashSet {
    public func difference(_ otherSet: HashSet<T>) -> HashSet<T> {
        var diff = HashSet<T>()
        for obj in dictionary.keys {
            if !otherSet.contains(obj) {
                diff.insert(obj)
            }
        }
        return diff
    }
}
```

It's really the opposite of `intersect()`. Try it out:
它实际上与`intersect()`相反。 试试看：

```swift
let difference1 = setA.difference(setB)
difference1.allElements()                // [2, 1]

let difference2 = setB.difference(setA)
difference2.allElements()                // [5, 6]
```

## Where to go from here?
## 从这往哪儿走？

If you look at the [documentation](http://swiftdoc.org/v2.1/type/Set/) for Swift's own `Set`, you'll notice it has tons more functionality. An obvious extension would be to make `HashSet` conform to `SequenceType` so that you can iterate it with a `for`...`in` loop.
如果你看一下Swift自己的`Set`的[文档](http://swiftdoc.org/v2.1/type/Set/)，你会发现它有更多的功能。 一个明显的扩展是使`HashSet`符合`SequenceType`，这样你就可以用`for` ...`in`循环迭代它。

Another thing you could do is replace the `Dictionary` with an actual [hash table](../Hash%20Table), but one that just stores the keys and doesn't associate them with anything. So you wouldn't need the `Bool` values anymore.
您可以做的另一件事是将`Dictionary`替换为实际的[哈希表](../Hash%20Table)，但是只存储键并且不将它们与任何东西相关联。 所以你不再需要`Bool`值了。

If you often need to look up whether an element belongs to a set and perform unions, then the [union-find](../Union-Find/) data structure may be more suitable. It uses a tree structure instead of a dictionary to make the find and union operations very efficient.
如果您经常需要查找元素是否属于集合并执行并集，那么[并查集](../Union-Find/)数据结构可能更合适。它使用树结构而不是字典来使查找和并集操作非常有效。

> **Note:** I'd like to make `HashSet` conform to `ArrayLiteralConvertible` so you can write `let setA: HashSet<Int> = [1, 2, 3, 4]` but currently this crashes the compiler.
> **注意：**我想让`HashSet`符合`ArrayLiteralConvertible`，这样你就可以编写`let setA: HashSet<Int> = [1, 2, 3, 4]`但是目前这会使编译器崩溃。

*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
