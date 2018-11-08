# 链表(Linked List)

> 这个主题已经有辅导[文章](https://www.raywenderlich.com/144083/swift-algorithm-club-swift-linked-list-data-structure)

链表是一系列数据项，就像数组一样。 数组分配了一大块内存来存储对象，而链表中的元素在内存中是完全独立的对象，并通过链接连接：

	+--------+    +--------+    +--------+    +--------+
	|        |    |        |    |        |    |        |
	| node 0 |--->| node 1 |--->| node 2 |--->| node 3 |
	|        |    |        |    |        |    |        |
	+--------+    +--------+    +--------+    +--------+

链表的元素称为 *节点*。 上图显示了 *单链表*，其中每个节点只有一个引用 - 或叫做“指针” - 到下一个节点。 在 *双向链表*中，如下所示，节点还有指向前一个节点的指针：

	+--------+    +--------+    +--------+    +--------+
	|        |--->|        |--->|        |--->|        |
	| node 0 |    | node 1 |    | node 2 |    | node 3 |
	|        |<---|        |<---|        |<---|        |
	+--------+    +--------+    +--------+    +--------+

您需要跟踪链表的开始位置。 这通常用一个名为 *head* 的指针完成：

	         +--------+    +--------+    +--------+    +--------+
	head --->|        |--->|        |--->|        |--->|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |<---|        |<---|        |<---|        |<--- tail
	         +--------+    +--------+    +--------+    +--------+

引用链表末尾也很有用，称为 *tail*。 注意，最后一个节点的“下一个”指针是`nil`，第一个节点的“前一个”指针也是`nil`。

## 链表的性能

链表上的大多数操作时间复杂度都是 **O(n)** ，因此链表通常比数组慢。但是，它们也更加灵活 —— 而不是像数组一样复制大块内存，链表上的许多操作只需要更改几个指针。

时间复杂度是**O(n)**的原因是你不能简单地写`list[2]`来从链表中访问节点2。 如果你已经没有对该节点的引用，你必须从`head`开始，然后按照`next`指针逐个访问（或者从`tail`开始，使用`previous`指针，逐个访问并找到指定节点）。

但是一旦你有一个节点的引用，插入和删除等操作真的很快。 只是寻找节点慢。

这意味着当您处理链表时，应尽可能在前面插入新项目。 这是**O(1)**操作。 如果你跟踪`tail`指针，同样可以在后面插入。

## 单链表 vs 双链表


单链表使用比双链表使用更少的内存，因为它不需要存储所有那些`previous`指针。

但是如果你需要找到一个节点以前的节点，你就搞砸了。 您必须从头部开始并遍历整个链表，直到到达正确的节点。

对于许多任务，双向链表使事情变得更容易。

## 为什么使用链表？


使用链表的典型示例是[队列](../Queue/)。 使用数组，从队列前面删除元素很慢，因为它需要向下移动内存中的所有其他元素。 但是通过链接链表，只需将`head`更改为指向第二个元素即可。 快多了。

但说实话，现在你几乎不需要编写自己的链表。 不过，了解它们的工作方式仍然很有用; 将对象链接在一起的原则也与[树](../Tree/)和[图](../Graph/)一起使用。

## 代码

我们首先定义一个描述节点的类型：

```swift
public class LinkedListNode<T> {
  var value: T
  var next: LinkedListNode?
  weak var previous: LinkedListNode?

  public init(value: T) {
    self.value = value
  }
}
```

这是一种泛型类型，因此`T`可以是您想要存储在节点中的任何类型的数据。 我们将在后面的示例中使用字符串。

这边定义的是一个双向链表，每个节点都有一个`next`和`previous`指针。 如果没有下一个或前一个节点，则这些可以是`nil`，因此这些变量必须是可选项。 （在下文中，我将指出哪些函数需要更改，如果这只是单个而不是双向链表。）

> **注意：** 为避免循环强引用，我们声明`previous`指针为弱。 如果链表中有一个节点`A`后面跟着节点`B`，那么`A`指向`B`，而`B`指向`A`。 在某些情况下，即使在删除节点后，此循环强引用也可能导致节点保持活动状态。 我们不希望这样，所以我们使其中一个指针`weak`来打破循环。


让我们开始构建`LinkedList`。 这是第一点：

```swift
public class LinkedList<T> {
  public typealias Node = LinkedListNode<T>

  private var head: Node?

  public var isEmpty: Bool {
    return head == nil
  }

  public var first: Node? {
    return head
  }
}
```

理想情况下，我们希望类名尽可能具有描述性，但是，我们不希望每次要使用类时都打长名称，因此，我们在`LinkedList`中给`LinkedListNode<T>`定义了一个短的别名`Node`。


这个链表只有一个`head`指针，没有尾部。 添加尾指针留给读者练习。 （如果我们还有一个尾指针，我会指出哪些函数会有所不同。）

如果`head`为nil，则链表为空。 因为`head`是一个私有变量，所以我添加了属性`first`来返回对链表中第一个节点的引用。

在playground中测试：

```swift
let list = LinkedList<String>()
list.isEmpty   // true
list.first     // nil
```

我们还添加一个属性，为您提供链表中的最后一个节点。 这是将开始变得有趣了：

```swift
  public var last: Node? {
    guard var node = head else {
      return nil
    }
  
    while let next = node.next {
      node = next
    }
    return node
  }
```

如果你是Swift的新手，你可能已经看过`if let`但也许不是`if var`。 它做了同样的事情 - 它解开`head`可选项并将结果放入一个名为`node`的新局部变量中。 区别在于`node`不是常量而是当前运行环境下的变量，因此我们可以在循环内更改它。

循环也做了一些Swift魔法。 `while let next = node.next`保持循环，直到`node.next`为`nil`。 您可以写如下：

```swift
      var node: Node? = head
      while node != nil && node!.next != nil {
        node = node!.next
      }
```

但这对我来说并不是很开心。 我们可以很好地利用Swift对解包选项的内置支持。 你会在随后的代码中看到一堆这样的循环。

> **注意：** 如果我们保留一个尾指针，`last`只会做`return tail`。 但我们没有，所以它必须从头到尾逐步完成整个链表。这是一项昂贵的操作，特别是如果链表很长的话。

当然，`last`只返回nil，因为链表中没有任何节点。 让我们添加一个方法，将新节点添加到链表的末尾：

```swift
  public func append(value: T) {
    let newNode = Node(value: value)
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }
```

`append()`方法首先创建一个新的`Node`对象，然后请求我们刚刚添加的最后一个节点`last`属性。 如果没有这样的节点，链表仍然是空的，我们使`head`指向这个新的`Node`。但是如果我们确实找到了一个有效的最后节点对象，我们连接`next`和`previous`指针将这个新节点链接到链中。许多链表代码涉及这种`next`和`previous`指针操作。

在playground中测试：


```swift
list.append("Hello")
list.isEmpty         // false
list.first!.value    // "Hello"
list.last!.value     // "Hello"
```

The list looks like this:
这个链表目前看上去是：

	         +---------+
	head --->|         |---> nil
	         | "Hello" |
	 nil <---|         |
	         +---------+

增加第二个节点：

```swift
list.append("World")
list.first!.value    // "Hello"
list.last!.value     // "World"
```

现在链表看上去是：

	         +---------+    +---------+
	head --->|         |--->|         |---> nil
	         | "Hello" |    | "World" |
	 nil <---|         |<---|         |
	         +---------+    +---------+

您可以通过查看`next`和`previous`指针来自行验证：

```swift
list.first!.previous          // nil
list.first!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil
```

让我们添加一个方法来计算链表中有多少个节点。 这与我们已经完成的工作非常相似：

```swift
  public var count: Int {
    guard var node = head else {
      return 0
    }
  
    var count = 1
    while let next = node.next {
      node = next
      count += 1
    }
    return count
  }
```

它以相同的方式循环遍历链表，但这次增加了一个计数器。

> **注意：** 加快获得`count`的速度（从**O(n)**到**O(1)**）的一种方法是跟踪一个计算链表中有多少节点的变量。 无论何时添加或删除节点，都会更新此变量。

如果我们想在链表中的特定索引处找到节点，该怎么办？使用数组我们可以编写一个**O(1)**操作`array[index]`。这更多地涉及链接链表，但代码遵循类似的模式：

```swift
  public func node(atIndex index: Int) -> Node {
    if index == 0 {
      return head!
    } else {
      var node = head!.next
      for _ in 1..<index {
        node = node?.next
        if node == nil { //(*1)
          break
        }
      }
      return node!
    }
  }
```

首先，我们检查给定的索引是否为0。 因为如果它是0，它会按原样返回head。
但是，当给定索引大于0时，它从头开始，然后继续追踪node.next指针逐步执行链表。
与此时计数方法的不同之处在于存在两种终止条件。
一种是当for循环语句到达索引时，我们能够获取给定索引的节点。
第二个是`for-loop`语句中的`node.next`返回nil并导致break。（`*1`）
这意味着给定的索引超出范围并导致崩溃。

测试一下：

```swift
list.nodeAt(0)!.value    // "Hello"
list.nodeAt(1)!.value    // "World"
// list.nodeAt(2)           // crash
```

为了好玩，我们也可以实现`subscript`（下标）方法：

```swift
  public subscript(index: Int) -> T {
    let node = node(atIndex: index)
    return node.value
  }
```

现在可以编写如下内容：

```swift
list[0]   // "Hello"
list[1]   // "World"
list[2]   // crash!
```

它在`list [2]`上崩溃，因为该索引上没有节点。

到目前为止，我们已经编写了将新节点添加到链表末尾的代码，但这很慢，因为您需要先找到链表的末尾。（如果我们使用尾指针会很快。）因此，如果链表中项目的顺序无关紧要，则应在链表的前面执行插入操作。 这总是一个**O(1)**操作。


让我们编写一个方法，允许您在链表中的任何索引处插入新节点。

```swift
    public func insert(_ node: Node, at index: Int) {
        let newNode = node
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let prev = self.node(at: index-1)
            let next = prev.next
            
            newNode.previous = prev
            newNode.next = prev.next
            prev.next = newNode
            next?.previous = newNode
        }
    }
```

与`node(at:)`方法一样，`insert(_:at:)`方法也会根据索引参数是否为0进行判断。
首先让我们来看看前一种情况（译注：也就是`index == 0`，插入最前面的情况）。 假设我们有以下链表和新节点（C）。

             +---------+     +---------+
    head --->|         |---->|         |-----//----->
             |    A    |     |    B    |
     nil <---|         |<----|         |<----//------
             +---------+     +---------+ 
                 [0]             [1]
                  
                  
             +---------+ 
     new --->|         |----> nil
             |    C    |
             |         |
             +---------+
    
现在将新节点放在第一个节点之前。 通过这种方式：

    new.next = head
    head.previous = new
    
             +---------+            +---------+     +---------+
     new --->|         |--> head -->|         |---->|         |-----//----->
             |    C    |            |    A    |     |    B    |
             |         |<-----------|         |<----|         |<----//------
             +---------+            +---------+     +---------+ 


最后，用新节点作为头部。

    head = new
    
             +---------+    +---------+     +---------+
    head --->|         |--->|         |---->|         |-----//----->
             |    C    |    |    A    |     |    B    |
     nil <---|         |<---|         |<----|         |<----//------
             +---------+    +---------+     +---------+ 
                 [0]            [1]             [2]


但是，当给定索引大于0时，必须获取节点的上一个和下一个索引并在它们之间插入。
您还可以使用`node(at:)`获取上一个和下一个节点，如下所示：

             +---------+         +---------+     +---------+    
    head --->|         |---//--->|         |---->|         |----
             |         |         |    A    |     |    B    |    
     nil <---|         |---//<---|         |<----|         |<---
             +---------+         +---------+     +---------+    
                 [0]              [index-1]        [index]      
                                      ^               ^ 
                                      |               | 
                                     prev            next
    
    prev = node(at: index-1)
    next = prev.next

现在在prev和next之间插入新节点。

    new.prev = prev; prev.next = new  // connect prev and new.
    new.next = next; next.prev = new  // connect new and next.

             +---------+         +---------+     +---------+     +---------+
    head --->|         |---//--->|         |---->|         |---->|         |
             |         |         |    A    |     |    C    |     |    B    |
     nil <---|         |---//<---|         |<----|         |<----|         |
             +---------+         +---------+     +---------+     +---------+
                 [0]              [index-1]        [index]        [index+1]
                                      ^               ^               ^
                                      |               |               |
                                     prev            new             next


测试：

```swift
list.insert(LinedListNode(value: "Swift"), at: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World
```


还可以尝试在链表的前面和后面添加新节点，以验证其是否正常工作。
> **注意：** `node(at:)` 和 `insert(_:at:)`函数也可以与单链表一起使用，因为我们不依赖于节点的`previous`指针来查找前一个元素。

我们还需要什么？ 当然要删除节点！ 首先我们要做`removeAll()`，这很简单：

```swift
  public func removeAll() {
    head = nil
  }
```


如果你有一个尾指针，你也可以在这里设置为`nil`。

接下来，我们将添加一些可以删除单个节点的函数。 如果你已经有了对节点的引用，那么使用`remove()`是最优的，因为你不需要遍历链表来首先找到节点。

```swift
  public func remove(node: Node) -> T {
    let prev = node.previous
    let next = node.next

    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev

    node.previous = nil
    node.next = nil
    return node.value
  }
```


当我们将此节点从链表中取出时，我们将断开指向上一个节点和下一个节点的链接。 要使链表再次完整，我们必须将前一个节点链接到下一个节点。

不要忘记`head`指针！ 如果这是链表中的第一个节点，则需要更新`head`以指向下一个节点。 （同样，当你有一个尾指针，这是最后一个节点）。 当然，如果没有剩余的节点，`head`应该变为`nil`。

尝试一下：

```swift
list.remove(node: list.first!)   // "Hello"
list.count                     // 2
list[0]                        // "Swift"
list[1]                        // "World"
```

如果你没有对节点的引用，你可以使用`removeLast()`或 `removeAt()`：

```swift
    public func removeLast() -> T {
        assert(!isEmpty)
        return remove(node: last!)
    }
    
    public func remove(at index: Int) -> T {
        let node = self.node(at: index)
        return remove(node: node)
    }
```

所有这些删除函数都返回已删除元素的值。

```swift
list.removeLast()              // "World"
list.count                     // 1
list[0]                        // "Swift"

list.remove(at: 0)          // "Swift"
list.count                     // 0
```


> **注意：** 对于单链表，删除最后一个节点稍微复杂一些。 您不能只使用`last`来查找链表的末尾，因为您还需要对倒数第二个节点的引用。 相反，使用`nodesBeforeAndAfter()`辅助方法。 如果链表有一个尾指针，那么`removeLast()`非常快，但你需要记住让`tail`指向前一个节点。

我们的`LinkedList`类还可以做一些有趣的事情。 一些很方便可读的调试输出：

```swift
extension LinkedList: CustomStringConvertible {
  public var description: String {
    var s = "["
    var node = head
    while node != nil {
      s += "\(node!.value)"
      node = node!.next
      if node != nil { s += ", " }
    }
    return s + "]"
  }
}
```

这将如下形式打印链表：

	[Hello, Swift, World]

如何反转链表，使头部成为尾部，反之亦然？ 有一个非常快速的算法：

```swift
  public func reverse() {
    var node = head
    tail = node           // If you had a tail pointer
    while let currentNode = node {
      node = currentNode.next
      swap(&currentNode.next, &currentNode.previous)
      head = currentNode
    }
  }
```

这循环遍历整个链表，并简单地交换每个节点的`next`和`previous`指针。 它还将`head`指针移动到最后一个元素。 （如果你有一个尾部指针，你还需要更新它。）你最终得到这样的东西：

	         +--------+    +--------+    +--------+    +--------+
	tail --->|        |<---|        |<---|        |<---|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |--->|        |--->|        |--->|        |<--- head
	         +--------+    +--------+    +--------+    +--------+

数组有`map()`和`filter()`函数，那么没有理由说链接链表没有。

```swift
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while node != nil {
            result.append(transform(node!.value))
            node = node!.next
        }
        return result
    }
```

使用如下：（译注：创建一个新链表，用来存放之前链表中字符串的长度）

```swift
let list = LinkedList<String>()
list.append("Hello")
list.append("Swifty")
list.append("Universe")

let m = list.map { s in s.count }
m  // [5, 6, 8]
```

`filter()`函数：

```swift
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while node != nil {
            if predicate(node!.value) {
                result.append(node!.value)
            }
            node = node!.next
        }
        return result
    }
```

一个简单的使用例子：（译注：筛选出链表中字符串长度大于5的元素并组成新的链表）

```swift
let f = list.filter { s in s.count > 5 }
f    // [Universe, Swifty]
```

为读者练习：`map()` 和`filter()` 的这些实现不是很快，因为它们将新节点追加到新链表的末尾。 回想一下，append是**O(n)**，因为它需要扫描整个链表以找到最后一个节点。 你能加快速度吗？ （提示：跟踪您添加的最后一个节点。）

## 另一种方法

到目前为止，您看到的`LinkedList`版本使用的是类，具有引用语义。 这没有什么不对，但这确实使它们比Swift的其他集合（例如`Array`和`Dictionary`）更重要。(**译注：** 这里应该是想表达，`Array`和`Dictionary`都是结构体，链表也可以使用结构体和枚举实现)

可以使用枚举实现具有值语义的链表。 这看起来有点像这样：

```swift
enum ListNode<T> {
  indirect case node(T, next: ListNode<T>)
  case end
}
```

与基于类的版本的最大区别在于，您对此链表所做的任何修改都将导致创建*新副本*。 这是否是您想要的取决于应用程序。

[如果有需求，我可能会更详细地填写此部分。]

## 符合Collection协议

符合Sequence协议的类型，其元素可以多次遍历。非破坏性地通过索引的下标访问，应该符合Swift标准库中定义的Collection协议。

这样做可以访问处理数据集合时常见的大量属性和操作。 除此之外，它还允许自定义类型遵循Swift开发人员常用的模式。


为了符合这个协议，类需要提供：
   1 `startIndex`和`endIndex`属性。
   2 对元素的下标访问为O(1)。 需要记录这种时间复杂性的变化。
  
```swift
/// The position of the first element in a nonempty collection.
public var startIndex: Index {
  get {
    return LinkedListIndex<T>(node: head, tag: 0)
  }
}
  
/// The collection's "past the end" position---that is, the position one
/// greater than the last valid subscript argument.
/// - Complexity: O(n), where n is the number of elements in the list.
///   This diverts from the protocol's expectation.
public var endIndex: Index {
  get {
    if let h = self.head {
      return LinkedListIndex<T>(node: h, tag: count)
    } else {
      return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
    }
  }
}
```

```swift
public subscript(position: Index) -> T {
  get {
    return position.node!.value
  }
}
```

因为集合负责管理自己的索引，下面的实现保留对链表中节点的引用。 索引中的标记属性表示链表中节点的位置。

```swift
/// Custom index type that contains a reference to the node at index 'tag'
public struct LinkedListIndex<T> : Comparable
{
  fileprivate let node: LinkedList<T>.LinkedListNode<T>?
  fileprivate let tag: Int

  public static func==<T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
    return (lhs.tag == rhs.tag)
  }

  public static func< <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
    return (lhs.tag < rhs.tag)
  }
}
```

最后，链接能够通过以下实现计算给定的索引之后的索引。

```swift
public func index(after idx: Index) -> Index {
  return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag+1)
}
```

## 要注意的一些事情

链接链表是灵活的，但许多操作是**O(n)**。

在链表上执行操作时，您总是需要小心更新相关的`next`和`previous`指针，还可能更新`head`和`tail`指针。 如果你搞砸了，你的链表将不再正确，你的程序可能会在某些时候崩溃。 小心！

处理链表时，通常可以使用递归：处理第一个元素，然后在链表的其余部分再次递归调用该函数。 当没有下一个元素时你就完成了。 这就是链表是LISP等函数式编程语言的基础的原因。


*作者：Matthijs Hollemans*      
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
