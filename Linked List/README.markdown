# Linked List
# 链表

> This topic has been tutorialized [here](https://www.raywenderlich.com/144083/swift-algorithm-club-swift-linked-list-data-structure)
> 这个主题已经有辅导[文章](https://www.raywenderlich.com/144083/swift-algorithm-club-swift-linked-list-data-structure)

A linked list is a sequence of data items, just like an array. But where an array allocates a big block of memory to store the objects, the elements in a linked list are totally separate objects in memory and are connected through links:
链表是一系列数据项，就像数组一样。 数组分配了一大块内存来存储对象，而链表中的元素在内存中是完全独立的对象，并通过链接连接：

	+--------+    +--------+    +--------+    +--------+
	|        |    |        |    |        |    |        |
	| node 0 |--->| node 1 |--->| node 2 |--->| node 3 |
	|        |    |        |    |        |    |        |
	+--------+    +--------+    +--------+    +--------+

The elements of a linked list are referred to as *nodes*. The above picture shows a *singly linked list*, where each node only has a reference -- or a "pointer" -- to the next node. In a *doubly linked list*, shown below, nodes also have pointers to the previous node:
链表的元素称为*节点*。 上图显示了*单链表*，其中每个节点只有一个引用 - 或叫做“指针” - 到下一个节点。 在*双向链表*中，如下所示，节点还有指向前一个节点的指针：

	+--------+    +--------+    +--------+    +--------+
	|        |--->|        |--->|        |--->|        |
	| node 0 |    | node 1 |    | node 2 |    | node 3 |
	|        |<---|        |<---|        |<---|        |
	+--------+    +--------+    +--------+    +--------+

You need to keep track of where the list begins. That's usually done with a pointer called the *head*:
您需要跟踪列表的开始位置。 这通常用一个名为*head*的指针完成：

	         +--------+    +--------+    +--------+    +--------+
	head --->|        |--->|        |--->|        |--->|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |<---|        |<---|        |<---|        |<--- tail
	         +--------+    +--------+    +--------+    +--------+

It's also useful to have a reference to the end of the list, known as the *tail*. Note that the "next" pointer of the last node is `nil`, just like the "previous" pointer of the very first node.
引用列表末尾也很有用，称为*tail*。 注意，最后一个节点的“下一个”指针是`nil`，第一个节点的“前一个”指针也是`nil`。

## Performance of linked lists
## 链表的性能

Most operations on a linked list have **O(n)** time, so linked lists are generally slower than arrays. However, they are also much more flexible -- rather than having to copy large chunks of memory around as with an array, many operations on a linked list just require you to change a few pointers.
链表上的大多数操作都有**O(n)**时间，因此链表通常比数组慢。但是，它们也更加灵活 —— 而不是像数组一样复制大块内存，链接列表上的许多操作只需要更改几个指针。

The reason for the **O(n)** time is that you can't simply write `list[2]` to access node 2 from the list. If you don't have a reference to that node already, you have to start at the `head` and work your way down to that node by following the `next` pointers (or start at the `tail` and work your way back using the `previous` pointers).
**O(n)**时间的原因是你不能简单地写`list[2]`来从（链表）列表中访问节点2。 如果你已经没有对该节点的引用，你必须从`head`开始，然后按照`next`指针逐个访问（或者从`tail`开始，使用`previous`指针，逐个访问并找到指定节点）。

But once you have a reference to a node, operations like insertion and deletion are really quick. It's just that finding the node is slow.
但是一旦你有一个节点的引用，插入和删除等操作真的很快。 只是找到节点很慢。

This means that when you're dealing with a linked list, you should insert new items at the front whenever possible. That is an **O(1)** operation. Likewise for inserting at the back if you're keeping track of the `tail` pointer.
这意味着当您处理链接列表时，应尽可能在前面插入新项目。 这是**O(1)**操作。 如果你跟踪`tail`指针，同样插入后面。

## Singly vs doubly linked lists
## 单链表 vs 双链表

A singly linked list uses a little less memory than a doubly linked list because it doesn't need to store all those `previous` pointers.

But if you have a node and you need to find its previous node, you're screwed. You have to start at the head of the list and iterate through the entire list until you get to the right node.

For many tasks, a doubly linked list makes things easier.

单链表使用比双链表更少的内存，因为它不需要存储所有那些`previous`指针。

但是如果你有一个节点而你需要找到它以前的节点，你就搞砸了。 您必须从列表的头部开始并遍历整个列表，直到到达正确的节点。

对于许多任务，双向链表使事情变得更容易。

## Why use a linked list?
## 为什么使用链表？

A typical example of where to use a linked list is when you need a [queue](../Queue/). With an array, removing elements from the front of the queue is slow because it needs to shift down all the other elements in memory. But with a linked list it's just a matter of changing `head` to point to the second element. Much faster.

But to be honest, you hardly ever need to write your own linked list these days. Still, it's useful to understand how they work; the principle of linking objects together is also used with [trees](../Tree/) and [graphs](../Graph/).

使用链表的典型示例是需要[queue](../Queue/)时。 使用数组，从队列前面删除元素很慢，因为它需要向下移动内存中的所有其他元素。 但是通过链接列表，只需将`head`更改为指向第二个元素即可。 快多了。

但说实话，这些天你几乎不需要编写自己的链表。 不过，了解它们的工作方式仍然很有用; 将对象链接在一起的原则也与[树](../Tree/)和[图](../Graph/)一起使用。

## The code
## 代码

We'll start by defining a type to describe the nodes:
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

This is a generic type, so `T` can be any kind of data that you'd like to store in the node. We'll be using strings in the examples that follow.
这是一种泛型类型，因此`T`可以是您想要存储在节点中的任何类型的数据。 我们将在后面的示例中使用字符串。

Ours is a doubly-linked list and each node has a `next` and `previous` pointer. These can be `nil` if there are no next or previous nodes, so these variables must be optionals. (In what follows, I'll point out which functions would need to change if this was just a singly- instead of a doubly-linked list.)
我们是一个双向链表，每个节点都有一个`next`和`previous`指针。 如果没有下一个或前一个节点，则这些可以是`nil`，因此这些变量必须是可选项。 （在下文中，我将指出哪些函数需要更改，如果这只是单个而不是双向链表。）

> **Note:** To avoid ownership cycles, we declare the `previous` pointer to be weak. If you have a node `A` that is followed by node `B` in the list, then `A` points to `B` but also `B` points to `A`. In certain circumstances, this ownership cycle can cause nodes to be kept alive even after you deleted them. We don't want that, so we make one of the pointers `weak` to break the cycle.
> **注意：** 为避免所有权周期，我们声明`previous`指针为弱。 如果列表中有一个节点`A`后面跟着节点`B`，那么`A`指向`B`，而`B`指向`A`。 在某些情况下，即使在删除节点后，此所有权周期也可能导致节点保持活动状态。 我们不希望这样，所以我们使其中一个指针`weak`来打破循环。


Let's start building `LinkedList`. Here's the first bit:
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

Ideally, we would want a class name to be as descriptive as possible, yet, we don't want to type a long name every time we want to use the class, therefore, we're using a typealias so inside `LinkedList` we can write the shorter `Node` instead of `LinkedListNode<T>`.
理想情况下，我们希望类名尽可能具有描述性，但是，我们不希望每次要使用类时都输入长名称，因此，我们在`LinkedList`中使用了一个类型名称 可以编写较短的`Node`而不是`LinkedListNode <T>`。

This linked list only has a `head` pointer, not a tail. Adding a tail pointer is left as an exercise for the reader. (I'll point out which functions would be different if we also had a tail pointer.)
这个链表只有一个`head`指针，而不是尾部。 添加尾指针留给读者练习。 （如果我们还有一个尾指针，我会指出哪些函数会有所不同。）

The list is empty if `head` is nil. Because `head` is a private variable, I've added the property `first` to return a reference to the first node in the list.
如果`head`为nil，则列表为空。 因为`head`是一个私有变量，所以我添加了属性`first`来返回对列表中第一个节点的引用。

You can try it out in a playground like this:
在playground中测试：

```swift
let list = LinkedList<String>()
list.isEmpty   // true
list.first     // nil
```

Let's also add a property that gives you the last node in the list. This is where it starts to become interesting:
我们还添加一个属性，为您提供列表中的最后一个节点。 这是它开始变得有趣的地方：

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

If you're new to Swift, you've probably seen `if let` but maybe not `if var`. It does the same thing -- it unwraps the `head` optional and puts the result in a new local variable named `node`. The difference is that `node` is not a constant but an actual variable, so we can change it inside the loop.
如果你是Swift的新手，你可能已经看过`if let`但也许不是`if var`。 它做了同样的事情 - 它解开`head`可选项并将结果放入一个名为`node`的新局部变量中。 区别在于`node`不是常量而是实际变量，因此我们可以在循环内更改它。

The loop also does some Swift magic. The `while let next = node.next` bit keeps looping until `node.next` is nil. You could have written this as follows:
循环也做了一些Swift魔法。 `while let next = node.next`位保持循环，直到`node.next`为`nil`。 您可以写如下：

```swift
      var node: Node? = head
      while node != nil && node!.next != nil {
        node = node!.next
      }
```

But that doesn't feel very Swifty to me. We might as well make use of Swift's built-in support for unwrapping optionals. You'll see a bunch of these kinds of loops in the code that follows.
但这对我来说并不是很开心。 我们不妨利用Swift对解包选项的内置支持。 你会在随后的代码中看到一堆这样的循环。

> **Note:** If we kept a tail pointer, `last` would simply do `return tail`. But we don't, so it has to step through the entire list from beginning to the end. It's an expensive operation, especially if the list is long.
> **注意：** 如果我们保留一个尾指针，`last`只会做`return tail`。 但我们没有，所以它必须从头到尾逐步完成整个列表。 这是一项昂贵的操作，特别是如果列表很长的话。

Of course, `last` only returns nil because we don't have any nodes in the list. Let's add a method that adds a new node to the end of the list:
当然，`last`只返回nil，因为列表中没有任何节点。 让我们添加一个方法，将新节点添加到列表的末尾：

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

The `append()` method first creates a new `Node` object and then asks for the last node using the `last` property we've just added. If there is no such node, the list is still empty and we make `head` point to this new `Node`. But if we did find a valid node object, we connect the `next` and `previous` pointers to link this new node into the chain. A lot of linked list code involves this kind of `next` and `previous` pointer manipulation.
`append()`方法首先创建一个新的`Node`对象，然后使用我们刚刚添加的`last`属性请求最后一个节点。 如果没有这样的节点，列表仍然是空的，我们使`head`指向这个新的`Node`。 但是如果我们确实找到了一个有效的节点对象，我们连接`next`和`previous`指针将这个新节点链接到链中。 许多链表代码涉及这种`next`和`previous`指针操作。

Let's test it in the playground:
在playground中测试：


```swift
list.append("Hello")
list.isEmpty         // false
list.first!.value    // "Hello"
list.last!.value     // "Hello"
```

The list looks like this:
这个列表看上去是：

	         +---------+
	head --->|         |---> nil
	         | "Hello" |
	 nil <---|         |
	         +---------+

Now add a second node:
增加第二个节点：

```swift
list.append("World")
list.first!.value    // "Hello"
list.last!.value     // "World"
```

And the list looks like:
现在列表看上去是：

	         +---------+    +---------+
	head --->|         |--->|         |---> nil
	         | "Hello" |    | "World" |
	 nil <---|         |<---|         |
	         +---------+    +---------+

You can verify this for yourself by looking at the `next` and `previous` pointers:
您可以通过查看`next`和`previous`指针来自行验证：

```swift
list.first!.previous          // nil
list.first!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil
```

Let's add a method to count how many nodes are in the list. This will look very similar to what we did already:
让我们添加一个方法来计算列表中有多少个节点。 这与我们已经完成的工作非常相似：

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

It loops through the list in the same manner but this time increments a counter as well.
它以相同的方式循环遍历列表，但这次也增加了一个计数器。

> **Note:** One way to speed up `count` from **O(n)** to **O(1)** is to keep track of a variable that counts how many nodes are in the list. Whenever you add or remove a node, you also update this variable.
> **注意：** 加速`count`从**O(n)**到**O(1)**的一种方法是跟踪一个计算列表中有多少节点的变量。 无论何时添加或删除节点，都会更新此变量。

What if we wanted to find the node at a specific index in the list? With an array we can just write `array[index]` and it's an **O(1)** operation. It's a bit more involved with linked lists, but again the code follows a similar pattern:
如果我们想在列表中的特定索引处找到节点，该怎么办？ 使用数组我们可以编写`array [index]`并且它是一个**O(1)**操作。 它更多地涉及链接列表，但代码遵循类似的模式：

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

First we check whether the given index is 0 or not. Because if it is 0, it returns the head as it is.
However, when the given index is greater than 0, it starts at head then keeps following the node.next pointers to step through the list.
The difference from count method at this time is that there are two termination conditions.
One is when the for-loop statement reaches index, and we were able to acquire the node of the given index.
The second is when `node.next` in `for-loop` statement returns nil and cause break. (`*1`)
This means that the given index is out of bounds and it causes a crash.

首先，我们检查给定的索引是否为0。 因为如果它是0，它会按原样返回头部。
但是，当给定索引大于0时，它从头开始，然后继续跟随node.next指针逐步执行列表。
与此时计数方法的不同之处在于存在两种终止条件。
一种是当for循环语句到达索引时，我们能够获取给定索引的节点。
第二个是`for-loop`语句中的`node.next`返回nil并导致break。（`*1`）
这意味着给定的索引超出范围并导致崩溃。

Try it out:
测试一下：

```swift
list.nodeAt(0)!.value    // "Hello"
list.nodeAt(1)!.value    // "World"
// list.nodeAt(2)           // crash
```

For fun we can implement a `subscript` method too:

```swift
  public subscript(index: Int) -> T {
    let node = node(atIndex: index)
    return node.value
  }
```

Now you can write the following:

```swift
list[0]   // "Hello"
list[1]   // "World"
list[2]   // crash!
```

It crashes on `list[2]` because there is no node at that index.

So far we've written code to add new nodes to the end of the list, but that's slow because you need to find the end of the list first. (It would be fast if we used a tail pointer.) For this reason, if the order of the items in the list doesn't matter, you should insert at the front of the list instead. That's always an **O(1)** operation.

它在`list [2]`上崩溃，因为该索引上没有节点。

到目前为止，我们已经编写了将新节点添加到列表末尾的代码，但这很慢，因为您需要先找到列表的末尾。 （如果我们使用尾指针会很快。）因此，如果列表中项目的顺序无关紧要，则应插入列表的前面。 这总是一个**O(1)**操作。


Let's write a method that lets you insert a new node at any index in the list.
让我们编写一个方法，允许您在列表中的任何索引处插入新节点。

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

As with node(atIndex :) method, `insert(_: at:)` method also branches depending on whether the given index is 0 or not.
First let's look at the former case. Suppose we have the following list and the new node(C).
与`node(at:)`方法一样，`insert(_:at:)`方法也会根据索引参数是否为0进行判断。
首先让我们来看看前一种情况（译注：也就是`index == 0`，插入最前面的情况）。 假设我们有以下列表和新节点（C）。

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
    
Now put the new node before the first node. In this way: 
现在将新节点放在第一个节点之前。 通过这种方式：

    new.next = head
    head.previous = new
    
             +---------+            +---------+     +---------+
     new --->|         |--> head -->|         |---->|         |-----//----->
             |    C    |            |    A    |     |    B    |
             |         |<-----------|         |<----|         |<----//------
             +---------+            +---------+     +---------+ 


Finally, replace the head with the new node.
最后，用新节点作为头部。

    head = new
    
             +---------+    +---------+     +---------+
    head --->|         |--->|         |---->|         |-----//----->
             |    C    |    |    A    |     |    B    |
     nil <---|         |<---|         |<----|         |<----//------
             +---------+    +---------+     +---------+ 
                 [0]            [1]             [2]


However, when the given index is greater than 0, it is necessary to get the node previous and next index and insert between them.
You can also obtain the previous and next node using node(atIndex:) as follows:
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

Now insert new node between the prev and the next.
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


Try it out:
测试：

```swift
list.insert(LinedListNode(value: "Swift"), at: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World
```

Also try adding new nodes to the front and back of the list, to verify that this works properly.
> **Note:** The `node(atIndex:)` and `insert(_: atIndex:)` functions can also be used with a singly linked list because we don't depend on the node's `previous` pointer to find the previous element.

还可以尝试在列表的正面和背面添加新节点，以验证其是否正常工作。
> **注意：** `node(at:)` 和 `insert(_:at:)`函数也可以与单链表一起使用，因为我们不依赖于节点的`previous`指针来查找前一个元素。

What else do we need? Removing nodes, of course! First we'll do `removeAll()`, which is really simple:
我们还需要什么？ 当然要删除节点！ 首先我们要做`removeAll()`，这很简单：

```swift
  public func removeAll() {
    head = nil
  }
```

If you had a tail pointer, you'd set it to `nil` here too.

Next we'll add some functions that let you remove individual nodes. If you already have a reference to the node, then using `remove()` is the most optimal because you don't need to iterate through the list to find the node first.

如果你有一个尾指针，你也可以在这里设置为`nil`。

接下来，我们将添加一些可以删除单个节点的函数。 如果你已经有了对节点的引用，那么使用`remove()`是最优的，因为你不需要遍历列表来首先找到节点。

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

When we take this node out of the list, we break the links to the previous node and the next node. To make the list whole again we must connect the previous node to the next node.

Don't forget the `head` pointer! If this was the first node in the list then `head` needs to be updated to point to the next node. (Likewise for when you have a tail pointer and this was the last node). Of course, if there are no more nodes left, `head` should become nil.

当我们将此节点从列表中取出时，我们将断开指向上一个节点和下一个节点的链接。 要使列表再次完整，我们必须将前一个节点连接到下一个节点。

不要忘记`head`指针！ 如果这是列表中的第一个节点，则需要更新`head`以指向下一个节点。 （同样，当你有一个尾指针，这是最后一个节点）。 当然，如果没有剩余的节点，`head`应该变为`nil`。

Try it out:
尝试一下：

```swift
list.remove(node: list.first!)   // "Hello"
list.count                     // 2
list[0]                        // "Swift"
list[1]                        // "World"
```

If you don't have a reference to the node, you can use `removeLast()` or `removeAt()`:
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

All these removal functions also return the value from the removed element.
所有这些删除函数都返回已删除元素的值。

```swift
list.removeLast()              // "World"
list.count                     // 1
list[0]                        // "Swift"

list.remove(at: 0)          // "Swift"
list.count                     // 0
```

> **Note:** For a singly linked list, removing the last node is slightly more complicated. You can't just use `last` to find the end of the list because you also need a reference to the second-to-last node. Instead, use the `nodesBeforeAndAfter()` helper method. If the list has a tail pointer, then `removeLast()` is really quick, but you do need to remember to make `tail` point to the previous node.
> **注意：** 对于单链表，删除最后一个节点稍微复杂一些。 您不能只使用`last`来查找列表的末尾，因为您还需要对倒数第二个节点的引用。 相反，使用`nodesBeforeAndAfter()`辅助方法。 如果列表有一个尾指针，那么`removeLast()`非常快，但你需要记住让`tail`指向前一个节点。

There's a few other fun things we can do with our `LinkedList` class. It's handy to have some sort of readable debug output:
我们的`LinkedList`类还可以做一些有趣的事情。 有一些可读的调试输出很方便：

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

This will print the list like so:
这将如下形式打印列表：

	[Hello, Swift, World]

How about reversing a list, so that the head becomes the tail and vice versa? There is a very fast algorithm for that:
如何反转列表，使头部成为尾部，反之亦然？ 有一个非常快速的算法：

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

This loops through the entire list and simply swaps the `next` and `previous` pointers of each node. It also moves the `head` pointer to the very last element. (If you had a tail pointer you'd also need to update it.) You end up with something like this:
这循环遍历整个列表，并简单地交换每个节点的`next`和`previous`指针。 它还将`head`指针移动到最后一个元素。 （如果你有一个尾部指针，你还需要更新它。）你最终得到这样的东西：

	         +--------+    +--------+    +--------+    +--------+
	tail --->|        |<---|        |<---|        |<---|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |--->|        |--->|        |--->|        |<--- head
	         +--------+    +--------+    +--------+    +--------+

Arrays have `map()` and `filter()` functions, and there's no reason why linked lists shouldn't either.
数组有`map()`和`filter()`函数，那么没有理由说链接列表没有。

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

You can use it like this:
使用如下：（译注：创建一个新列表，用来存放之前列表中字符串的长度）

```swift
let list = LinkedList<String>()
list.append("Hello")
list.append("Swifty")
list.append("Universe")

let m = list.map { s in s.count }
m  // [5, 6, 8]
```

And here's filter:
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

And a silly example:
一个简单的使用例子：（译注：筛选出列表中字符串长度大于5的元素并组成新的列表）

```swift
let f = list.filter { s in s.count > 5 }
f    // [Universe, Swifty]
```

Exercise for the reader: These implementations of `map()` and `filter()` aren't very fast because they `append()` the new node to the end of the new list. Recall that append is **O(n)** because it needs to scan through the entire list to find the last node. Can you make this faster? (Hint: keep track of the last node that you added.)
为读者练习：`map()` 和`filter()` 的这些实现不是很快，因为它们将新节点追加到新列表的末尾。 回想一下，append是**O(n)**，因为它需要扫描整个列表以找到最后一个节点。 你能加快速度吗？ （提示：跟踪您添加的最后一个节点。）

## An alternative approach
## 另一种方法

The version of `LinkedList` you've seen so far uses nodes that are classes and therefore have reference semantics. Nothing wrong with that, but that does make them a bit more heavyweight than Swift's other collections such as `Array` and `Dictionary`.
到目前为止，您看到的`LinkedList`版本使用的是类，因此具有引用语义。 这没有什么不对，但这确实使它们比Swift的其他集合（例如`Array`和`Dictionary`）更重要。

It is possible to implement a linked list with value semantics using an enum. That would look somewhat like this:
可以使用枚举实现具有值语义的链表。 这看起来有点像这样：

```swift
enum ListNode<T> {
  indirect case node(T, next: ListNode<T>)
  case end
}
```

The big difference with the class-based version is that any modification you make to this list will result in a *new copy* being created. Whether that's what you want or not depends on the application.
与基于类的版本的最大区别在于，您对此列表所做的任何修改都将导致创建*新副本*。 这是否是您想要的取决于应用程序。

[I might fill out this section in more detail if there's a demand for it.]
[如果有需求，我可能会更详细地填写此部分。]

## Conforming to the Collection protocol
## 符合Collection协议

Types that conform to the Sequence protocol, whose elements can be traversed multiple times, nondestructively, and accessed by indexed subscript should conform to the Collection protocol defined in Swift's Standard Library.
符合Sequence协议的类型，其元素可以多次遍历，非破坏性地通过索引的下标访问，应该符合Swift标准库中定义的Collection协议。

Doing so grants access to a very large number of properties and operations that are common when dealing collections of data. In addition to this, it lets custom types follow the patterns that are common to Swift developers.
这样做可以访问处理数据集合时常见的大量属性和操作。 除此之外，它还允许自定义类型遵循Swift开发人员常用的模式。

In order to conform to this protocol, classes need to provide:
  1 `startIndex` and `endIndex` properties.
  2 Subscript access to elements as O(1). Diversions of this time complexity need to be documented.

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

Becuase collections are responsible for managing their own indexes, the implementation below keeps a reference to a node in the list. A tag property in the index represents the position of the node in the list.
Becuase集合负责管理自己的索引，下面的实现保留对列表中节点的引用。 索引中的标记属性表示列表中节点的位置。

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

Finally, the linked is is able to calculate the index after a given one with the following implementation.
最后，链接能够通过以下实现计算给定的索引之后的索引。

```swift
public func index(after idx: Index) -> Index {
  return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag+1)
}
```

## Some things to keep in mind
## 要注意的一些事情

Linked lists are flexible but many operations are **O(n)**.

When performing operations on a linked list, you always need to be careful to update the relevant `next` and `previous` pointers, and possibly also the `head` and `tail` pointers. If you mess this up, your list will no longer be correct and your program will likely crash at some point. Be careful!

When processing lists, you can often use recursion: process the first element and then recursively call the function again on the rest of the list. You’re done when there is no next element. This is why linked lists are the foundation of functional programming languages such as LISP.

链接列表是灵活的，但许多操作是**O(n)**。

在链表上执行操作时，您总是需要小心更新相关的`next`和`previous`指针，还可能更新`head`和`tail`指针。 如果你搞砸了，你的列表将不再正确，你的程序可能会在某些时候崩溃。 小心！

处理列表时，通常可以使用递归：处理第一个元素，然后在列表的其余部分再次递归调用该函数。 当没有下一个元素时你就完成了。 这就是链表是LISP等函数式编程语言的基础的原因。

*Originally written by Matthijs Hollemans for Ray Wenderlich's Swift Algorithm Club*

*作者：Matthijs Hollemans*      
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
