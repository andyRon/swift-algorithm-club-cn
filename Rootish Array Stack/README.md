# Rootish Array Stack
# Rootish数组栈

A *Rootish Array Stack* is an ordered array based structure that minimizes wasted space (based on [Gauss's summation technique](https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/)). A *Rootish Array Stack* consists of an array holding many fixed size arrays in ascending size.  
A *Rootish Array Stack* 是一种基于有序数组的结构，可最大限度地减少浪费的空间（基于[Gauss的求和技术](https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/)）。一个*Rootish Array Stack*由一个数组组成，该数组以递增的大小保存许多固定大小的数组。

![Rootish Array Stack Intro](images/RootishArrayStackIntro.png)

A resizable array holds references to blocks (arrays of fixed size). A block's capacity is the same as it's index in the resizable array. Blocks don't grow/shrink like regular Swift arrays. Instead, when their capacity is reached, a new slightly larger block is created. When a block is emptied the last block is freed. This is a great improvement on what Swift arrays do in terms of wasted space.  
可调整大小的数组保存对块（固定大小的数组）的引用。块的容量与可调整大小的数组中的索引相同。块不像常规Swift阵列那样增长/缩小。相反，当达到它们的容量时，会创建一个稍大的新块。当块被清空时，最后一个块被释放。这是Swift数组在浪费空间方面所做的很大改进。

![Rootish Array Stack Intro](images/RootishArrayStackExample.png)

Here you can see how insert/remove operations would behave (very similar to how a Swift array handles such operations).  
在这里，您可以看到插入/删除操作的行为（非常类似于Swift数组处理此类操作的方式）。

## Gauss' Summation Trick
## 高斯求和技巧

One of the most well known legends about famous mathematician [Carl Friedrich Gauss](https://en.wikipedia.org/wiki/Carl_Friedrich_Gauss) goes back to when he was in primary school. One day, Gauss' teacher asked his class to add up all the numbers from 1 to 100, hoping that the task would take long enough for him to step out for a smoke break. The teacher was shocked when young Gauss had his hand up with the answer `5050`. So soon? The teacher suspected a cheat, but no. Gauss had found a formula to sidestep the problem of manually adding up all the numbers 1 by 1. His formula:  

著名数学家[Carl Friedrich Gauss](https://en.wikipedia.org/wiki/Carl_Friedrich_Gauss)最着名的传说之一可以追溯到他上小学时。 有一天，高斯的老师要求他的班级将所有数字从1加到100，希望这项任务需要足够长的时间让他走出去休息一下。当年轻的高斯举手回答`5050`时，老师很震惊。 真快？ 老师怀疑作弊，但没有。 高斯找到了一个公式来回避手动将所有数字1加1的问题。他的公式：

```
sum from 1...n = n * (n + 1) / 2
```
To understand this imagine `n` blocks where `x` represents `1` unit. In this example let `n` be `5`:  
要理解这个想象`n`块，其中`x`代表`1`单位。 在这个例子中，让`n`为`5`：

```
blocks:     [x] [x x] [x x x] [x x x x] [x x x x x]
# of x's:    1    2      3        4          5
```
_Block `1` has 1 `x`, block `2` as 2 `x`s, block `3` has 3 `x`s, etc..._

If you wanted to take the sum of all the blocks from `1` to `n`, you could go through and count them _one by one_. This is okay, but for a large sequence of blocks that could take a long time! Instead, you could arrange the blocks to look like a _half pyramid_:  
如果你想把所有块的总和从`1`变为`n`，你可以通过 _one by one_ 来计算它们。 这没关系，但对于大量的块可能需要很长时间！ 相反，您可以将块排列为 _half pyramid_：

```
# |  blocks
--|-------------
1 |  x
2 |  x x
3 |  x x x
4 |  x x x x
5 |  x x x x x

```
Then we mirror the _half pyramid_ and rearrange the image so that it fits with the original _half pyramid_ in a rectangular shape:  
然后我们镜像 _half pyramid_ 并重新排列图像，使其与矩形形状的原始 _half pyramid_ 形状相符：

```
x                  o      x o o o o o
x x              o o      x x o o o o
x x x          o o o  =>  x x x o o o
x x x x      o o o o      x x x x o o
x x x x x  o o o o o      x x x x x o
```
Here we have `n` rows and `n + 1` columns. _5 rows and 6 columns_.  
这里我们有 `n` 行和 `n + 1` 列。 _5行和6列_。

We can calculate the sum just as we would an area! Let's also express the width and height in terms of `n`:  
我们可以像计算区域一样计算总和！ 让我们用`n`表示宽度和高度：

```
area of a rectangle = height * width = n * (n + 1)
```
We only want to calculate the amount of `x`s, not the amount of `o`s. Since there's a 1:1 ratio between `x`s and `o`s we can just divide our area by 2!  
我们只想计算`x`s的数量，而不是`o`s的数量。 由于`x`s和`o`之间的比例为 1：1，我们可以将区域除以2！

```
area of only x = n * (n + 1) / 2
```
Voila! A super fast way to take a sum of all the blocks! This equation is useful for deriving fast `block` and `inner block index` equations.  
瞧！ 一个超快速的方法来获取所有块的总和！ 该等式对于导出快速`块`和`内部块索引`方程非常有用。
<!-- TODO: Define block and innerBlockIndex -->

## Get/Set with Speed  
## 获取/设置速度

Next, we want to find an efficient and accurate way to access an element at a random index. For example, which block does `rootishArrayStack[12]` point to? To answer this we will need more math!
Determining the inner block `index` turns out to be easy. If `index` is in some `block` then:

接下来，我们希望找到一种有效且准确的方法来访问随机索引处的元素。 例如，`rootishArrayStack [12]`指向哪个块？ 要回答这个问题，我们需要更多数学！
确定内部块`index`变得容易。 如果`index`在某个`block`中，那么：

```
inner block index = index - block * (block + 1) / 2
```
Determining which `block` an index points to is more difficult. The number of elements up to and including the element requested is: `index + 1` elements. The number of elements in blocks `0...block` is `(block + 1) * (block + 2) / 2` (equation derived above). The relationship between the `block` and the `index` is as follows:  
确定索引指向哪个`block`更加困难。 请求元素的元素数量为：`index + 1`元素。 块`0...block`中的元素数是 `(block + 1) * (block + 2) / 2` （上面导出的等式）。 `block`和`index`之间的关系如下：

```
(block + 1) * (block + 2) / 2 >= index + 1
```
This can be rewritten as:
能被重写为：
```
(block)^2 + (3 * block) - (2 * index) >= 0
```
Using the quadratic formula we get:  
使用二次公式我们得到：
```
block = (-3 ± √(9 + 8 * index)) / 2
```
A negative block doesn't make sense, so we take the positive root instead. In general, this solution is not an integer. However, going back to our inequality, we want the smallest block such that `block => (-3 + √(9 + 8 * index)) / 2`. Next, we take the ceiling of the result:  
负块没有意义，所以我们采用正根。 通常，此解决方案不是整数。 然而，回到我们的不等式，我们想要最小的块，例如`block => (-3 + √(9 + 8 * index)) / 2`。 接下来，我们取结果的上限：
```
block = ⌈(-3 + √(9 + 8 * index)) / 2⌉
```

Now we can figure out what `rootishArrayStack[12]` points to! First, let's see which block the `12` points to:  
现在我们可以弄清楚`rootishArrayStack[12]`指向的是什么！ 首先，让我们看看`12`指向哪个块：

```
block = ⌈(-3 + √(9 + 8 * (12))) / 2⌉
block = ⌈(-3 + √105) / 2⌉
block = ⌈(-3 + (10.246950766)) / 2⌉
block = ⌈(7.246950766) / 2⌉
block = ⌈3.623475383⌉
block = 4
```
Next lets see which `innerBlockIndex` `12` points to:
```
inner block index = (12) - (4) * ((4) + 1) / 2
inner block index = (12) - (4) * (5) / 2
inner block index = (12) - 10
inner block index = 2
```
Therefore, `rootishArrayStack[12]` points to the block at index `4` and at inner block index `2`.  
因此，`rootishArrayStack[12]`指向索引为`4`的块和内部块索引`2`。

![Rootish Array Stack Intro](images/RootishArrayStackExample2.png)

### Interesting Discovery
### 有趣的发现

Using the `block` equation, we can see that the number of `blocks` is proportional to the square root of the number of elements: **O(blocks) = O(√n)**.  
使用`block`方程，我们可以看到`blocks`的数量与元素数量的平方根成正比：**O(blocks) = O(√n)**.  

# Implementation Details
# 实施细节

Let's start with instance variables and struct declaration:  
让我们从实例变量和结构声明开始：

```swift
import Darwin

public struct RootishArrayStack<T> {

  fileprivate var blocks = [Array<T?>]()
  fileprivate var internalCount = 0

  public init() { }

  var count: Int {
    return internalCount
  }

  ...

}

```
The elements are of generic type `T`, so data of any kind can be stored in the list. `blocks` will be a resizable array to hold fixed sized arrays that take type `T?`.
> The reason for the fixed size arrays taking type `T?` is so that references to elements aren't retained after they've been removed. Eg: if you remove the last element, the last index must be set to `nil` to prevent the last element being held in memory at an inaccessible index.

`internalCount` is an internal mutable counter that keeps track of the number of elements. `count` is a read only variable that returns the `internalCount` value. `Darwin` is imported here to provide simple math functions such as `ceil()` and `sqrt()`.

元素是通用类型`T`，因此任何类型的数据都可以存储在列表中。 `blocks`将是一个可调整大小的数组，用于保存类型为`T?`的固定大小的数组。
> 固定大小数组采用类型`T?`的原因是，对元素的引用在删除后不会保留。例如：如果删除最后一个元素，则必须将最后一个索引设置为`nil`，以防止最后一个元素在不可访问的索引中保存在内存中。

The `capacity` of the structure is simply the Gaussian summation trick:  
结构的`capacity`只是高斯求和技巧：

```swift
var capacity: Int {
  return blocks.count * (blocks.count + 1) / 2
}
```

Next, let's look at how we would `get` and `set` elements:  
接下来，让我们看看我们将如何`get`和`set`元素：

```swift
fileprivate func block(fromIndex: Int) -> Int {
  let block = Int(ceil((-3.0 + sqrt(9.0 + 8.0 * Double(index))) / 2))
  return block
}

fileprivate func innerBlockIndex(fromIndex index: Int, fromBlock block: Int) -> Int {
  return index - block * (block + 1) / 2
}

public subscript(index: Int) -> T {
  get {
    let block = self.block(fromIndex: index)
    let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
    return blocks[block][innerBlockIndex]!
  }
  set(newValue) {
    let block = self.block(fromIndex: index)
    let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
    blocks[block][innerBlockIndex] = newValue
  }
}
```
`block(fromIndex:)` and `innerBlockIndex(fromIndex:, fromBlock:)` are wrapping the `block` and `inner block index` equations we derived earlier. `superscript` lets us have `get` and `set` access to the structure with the familiar `[index:]` syntax. For both `get` and `set` in `superscript` we use the same logic:

1. determine the block that the index points to
2. determine the inner block index
3. `get`/`set` the value

`block(fromIndex:)`和 `innerBlockIndex(fromIndex:, fromBlock:)` 包含我们之前导出的 `block` 和 `inner block index` 方程。 `superscript`让我们用熟悉的`[index:]`语法对结构进行`get`和`set`访问。 对于`superscript`中的`get`和`set`，我们使用相同的逻辑：

1.确定索引指向的块
2.确定内部块索引
3.`get` /`set`这个值

Next, let's look at how we would `growIfNeeded()` and `shrinkIfNeeded()`.  
接下来，让我们看看我们将如何`growIfNeeded()`和`shrinkIfNeeded()`。

```swift
fileprivate mutating func growIfNeeded() {
  if capacity - blocks.count < count + 1 {
    let newArray = [T?](repeating: nil, count: blocks.count + 1)
    blocks.append(newArray)
  }
}

fileprivate mutating func shrinkIfNeeded() {
  if capacity + blocks.count >= count {
    while blocks.count > 0 && (blocks.count - 2) * (blocks.count - 1) / 2 >    count {
      blocks.remove(at: blocks.count - 1)
    }
  }
}
```
If our data set grows or shrinks in size, we want our data structure to accommodate the change.
Just like a Swift array, when a capacity threshold is met we will `grow` or `shrink` the size of our structure. For the Rootish Array Stack we want to `grow` if the second last block is full on an `insert` operation, and `shrink` if the two last blocks are empty.  
如果我们的数据集大小增大或缩小，我们希望我们的数据结构适应变化。
就像Swift数组一样，当满足容量阈值时，我们将`grow`或`shrink`我们结构的大小。 对于Rootish数组堆栈，如果第二个最后一个块在`insert`操作中已满，我们想要`grow`，如果最后两个块为空，则`shrink`。

Now to the more familiar Swift array behaviour.  
现在来到更熟悉的Swift数组行为。

```swift
public mutating func insert(element: T, atIndex index: Int) {
	growIfNeeded()
	internalCount += 1
	var i = count - 1
	while i > index {
		self[i] = self[i - 1]
		i -= 1
	}
	self[index] = element
}

public mutating func append(element: T) {
	insert(element: element, atIndex: count)
}

public mutating func remove(atIndex index: Int) -> T {
	let element = self[index]
	for i in index..<count - 1 {
		self[i] = self[i + 1]
	}
	internalCount -= 1
	makeNil(atIndex: count)
	shrinkIfNeeded()
	return element
}

fileprivate mutating func makeNil(atIndex index: Int) {
  let block = self.block(fromIndex: index)
  let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
  blocks[block][innerBlockIndex] = nil
}
```
To `insert(element:, atIndex:)` we move all elements after the `index` to the right by 1. After space has been made for the element, we set the value using the `subscript` convenience method.
`append(element:)` is just a convenience method to `insert` to the end.
To `remove(atIndex:)` we move all the elements after the `index` to the left by 1. After the removed value is covered by it's proceeding value, we set the last value in the structure to `nil`.
`makeNil(atIndex:)` uses the same logic as our `subscript` method but is used to set the root optional at a particular index to `nil` (because setting it's wrapped value to `nil` is something only the user of the data structure should do).
> Setting a optionals value to `nil` is different than setting it's wrapped value to `nil`. An optionals wrapped value is an embedded type within the optional reference. This means that a `nil` wrapped value is actually `.some(.none)` whereas setting the root reference to `nil` is `.none`. To better understand Swift optionals I recommend checking out @SebastianBoldt's article [Swift! Optionals?](https://medium.com/ios-os-x-development/swift-optionals-78dafaa53f3#.rvjobhuzs).

要 `insert(element:, atIndex:)` 我们将`index`之后的所有元素向右移动1.在为元素创建空格之后，我们使用`subscript`方法设置值。
`append(element:)`只是一个方便的方法`insert`到最后。
要删除`(atIndex:)`我们将`index`之后的所有元素向左移动1.在移除的值被其前进值覆盖后，我们将结构中的最后一个值设置为`nil`。
`makeNil(atIndex:)`使用与`subcript`方法相同的逻辑，但是用于将特定索引的根可选设置为`nil`（因为将它的包装值设置为`nil`只是用户的数据结构应该做）。
> 将选项值设置为“nil”与将其包装值设置为“nil”不同。 optionals包装值是可选引用中的嵌入类型。这意味着`nil`包装的值实际上是`.some（.none）`而将根引用设置为`nil`是`.none`。为了更好地理解Swift选项，我建议查看@ SebastianBoldt的文章[Swift! Optionals?](https://medium.com/ios-os-x-development/swift-optionals-78dafaa53f3#.rvjobhuzs)。

# Performance
# 性能

* An internal counter keeps track of the number of elements in the structure. `count` is executed in **O(1)** time.

* `capacity` can be calculated using Gauss' summation trick in an equation which takes **O(1)** time to execute.

* Since `subcript[index:]` uses the `block` and `inner block index` equations, which can be executed in **O(1)** time, all get and set operations take **O(1)**.

* Ignoring the time cost to `grow` and `shrink`, `insert(atIndex:)` and `remove(atIndex:)` operations shift all elements right of the specified index resulting in **O(n)** time.

* 内部计数器跟踪结构中的元素数量。 `count`在**O(1)**时间执行。

* `capacity`可以使用高斯求和技巧在一个等式中计算，该等式需要**O(1)**时间来执行。

* 由于`subcript[index:]`使用`block`和`inner block index`方程式，可以在**O(1)**时间内执行，所有get和set操作都需要**O(1)**。

* 忽略`grow`和`shrink`的时间成本，`insert(atIndex:)`和`remove(atIndex:)`操作会移动指定索引的所有元素，导致**O(n)**时间。


# Analysis of Growing and Shrinking

The performance analysis doesn't account for the cost to `grow` and `shrink`. Unlike a regular Swift array, `grow` and `shrink` operations don't copy all the elements into a backing array. They only allocate or free an array proportional to the number of `blocks`. The number of `blocks` is proportional to the  square root of the number of elements. Growing and shrinking only costs **O(√n)**.  
性能分析没有考虑“增长”和“缩小”的成本。 与常规的Swift数组不同，`grow`和`shrink`操作不会将所有元素复制到后备数组中。 它们只分配或释放与“块”数量成比例的数组。 `blocks`的数量与元素数量的平方根成比例。 增长和萎缩只需要成本 **O(√n)**。

# Wasted Space
Wasted space is how much memory with respect to the number of elements `n` is unused. The Rootish Array Stack never has more than 2 empty blocks and it never has less than 1 empty block. The last two blocks are proportional to the number of blocks, which is proportional to the square root of the number of elements. The number of references needed to point to each block is the same as the number of blocks. Therefore, the amount of wasted space with respect to the number of elements is **O(√n)**.

浪费的空间是关于元素数量n的未使用的内存量。 Rootish Array Stack永远不会有超过2个空块，并且它永远不会有少于1个空块。 最后两个块与块的数量成比例，这与块的数量的平方根成比例。 指向每个块所需的引用数与块数相同。 因此，相对于元素数量的浪费空间量是 **O(√n)**。


_Written for Swift Algorithm Club by @BenEmdon_

_With help from [OpenDataStructures.org](http://opendatastructures.org)_


*作者：@BenEmdon*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
