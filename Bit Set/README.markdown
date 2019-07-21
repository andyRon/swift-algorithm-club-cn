# 比特集合(Bit Set)

固定大小的*n*个比特序列。 也称为位数组或位向量。

要存储某些内容是真还是假使用`Bool`类型。 每个程序员都知道......但是如果你需要记住10,000个事物是真是假呢？

你可以制作一个包含10,000个布尔值的数组，但你也可以使用10,000比特代替。 这更加紧凑，因为在64位CPU上，10,000比特正好小于160个`Int`。（译注：`160*64=10240`）

因为操纵单个比特有点棘手，所以你可以使用`BitSet`来隐藏棘手的工作。

## 代码

比特集只是数组的简单封装。 该数组不存储单个比特，而是存储称为“words”的较大整数。 `BitSet`的主要工作是将比特映射到正确的word。

```swift
public struct BitSet {
  private(set) public var size: Int

  private let N = 64
  public typealias Word = UInt64
  fileprivate(set) public var words: [Word]

  public init(size: Int) {
    precondition(size > 0)
    self.size = size

    // Round up the count to the next multiple of 64.
    let n = (size + (N-1)) / N
    words = [Word](repeating: 0, count: n)
  }
```

`N`是word的比特大小。 它是64，因为我们将这些比特存储在无符号64位整数列表中。 （将`BitSet`改为使用32位字也相当容易。）

> **译注：** 本文的word，如果直接翻译成单词，可能会引起误解，所以就不翻译直接用word，它表示由固定数目的比特组成的部分。

如果你这样写：

```swift
var bits = BitSet(size: 140)
```

然后`BitSet`分配一个由三个word组成的数组。每个word有64位，因此三个word可以容纳192比特。我们只使用140个这样的比特，所以我们浪费了一点空间（当然我们永远不会使用这一整个word）。

> **注意：** `words`数组中的第一个条目是最不重要的单词，因此这些单词以小端序存储在数组中。（译注：关于小端序可查看[字节顺序](https://zh.wikipedia.org/wiki/字节序)）

## 查找比特

`BitSet`上的大多数操作都将比特的索引作为参数，因此有一种方法可以找到包含某比特的word。

```swift
  private func indexOf(_ i: Int) -> (Int, Word) {
    precondition(i >= 0)
    precondition(i < size)
    let o = i / N
    let m = Word(i - o*N)
    return (o, 1 << m)
  }
```

`indexOf()`函数返回word的数组索引，以及一个“掩码”，它显示该比特在该word内的确切位置。

例如，`indexOf(2)`返回元组`(0,4)`，因为第2位在第一个字（索引0）中。 掩码为4。在二进制中，掩码如下所示：

	0010000000000000000000000000000000000000000000000000000000000000

那1指向该word的第二个比特。

> **注意：** 请记住，所有内容都以小端序显示，包括比特本身。 比特0位于最左侧，比特63位于最右侧。

另一个例子：`indexOf(127)`返回元组`(1, 9223372036854775808)` （9223372036854775808 = 2^63）。 这是第二个word的最后一个比特。 掩码是：

	0000000000000000000000000000000000000000000000000000000000000001

请注意，掩码总是64位，因为我们一次查看一个word的数据。

## 设置和获取比特

现在我们知道在哪里找到比特，将其设置为1很容易：

```swift
  public mutating func set(_ i: Int) {
    let (j, m) = indexOf(i)
    words[j] |= m
  }
```

这会查找word索引和掩码，然后在该word和掩码之间执行按位OR。 如果该位为0则变为1.如果已经设置，则它保持设置。

清除该位 - 即将其更改为0 - 同样简单：

```swift
  public mutating func clear(_ i: Int) {
    let (j, m) = indexOf(i)
    words[j] &= ~m
  }
```

我们现在使用掩码的反转进行按位AND，而不是按位OR。 因此，如果掩码是`00100000 ... 0`，那么反转是`11011111 ... 1`。 除了我们想要设置为0的位之外，所有位都是1.由于`＆`的工作方式，这会使所有其他位保持不变，并且只将该位更改为0。

要查看是否设置了位，我们还使用按位AND但不反转：

```swift
  public func isSet(_ i: Int) -> Bool {
    let (j, m) = indexOf(i)
    return (words[j] & m) != 0
  }
```

我们可以添加一个下标函数来使这一切非常自然地表达：

```swift
  public subscript(i: Int) -> Bool {
    get { return isSet(i) }
    set { if newValue { set(i) } else { clear(i) } }
  }
```

现在你可以这样写：

```swift
var bits = BitSet(size: 140)
bits[2] = true
bits[99] = true
bits[128] = true
print(bits)
```

这将打印140位`BitSet`用于存储所有内容的三个单词：

```swift
0010000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000010000000000000000000000000000
1000000000000000000000000000000000000000000000000000000000000000
```

其他有趣的事情就是翻转它们。 这会将0变为1，将1变为0.这里是`flip()`：

```swift
  public mutating func flip(_ i: Int) -> Bool {
    let (j, m) = indexOf(i)
    words[j] ^= m
    return (words[j] & m) != 0
  }
```

这使用剩余的按位运算符“异或”来进行翻转。 该函数还返回该位的新值。

## 忽略未使用的比特

很多`BitSet`函数都很容易实现。 例如，`clearAll()`，它将所有位重置为0：

```swift
  public mutating func clearAll() {
    for i in 0..<words.count {
      words[i] = 0
    }
  }
```

还有`setAll()`来创建所有位1.然而，这必须处理一个微妙的问题。

```swift
  public mutating func setAll() {
    for i in 0..<words.count {
      words[i] = allOnes
    }
    clearUnusedBits()
  }
```

首先，我们将数据复制到数组中的所有ward中。 该数组现在是：

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
```

但这是不正确的......因为我们不使用最后一个word的大部分，所以我们应该将这些位保留为0：

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111110000000000000000000000000000000000000000000000000000
```

我们现在只有140个一位，而不是192位。 事实上，最后一个字可能没有被完全填满，这意味着我们总是要特别对待这个最后一个字。

将那些“剩余”比特设置为0是`clearUnusedBits()`辅助函数的作用。 如果`BitSet`的大小不是`N`的倍数（即64），那么我们必须清除我们没有使用的比特。 如果我们不这样做，两个不同大小的`BitSet`之间的按位运算将出错（下面是一个例子）。

这使用了一些高级位操作，因此请仔细注意：

```swift
  private func lastWordMask() -> Word {
    let diff = words.count*N - size       // 1
    if diff > 0 {
      let mask = 1 << Word(63 - diff)     // 2
      return mask | (mask - 1)            // 3
    } else {
      return ~Word()
    }
  }

  private mutating func clearUnusedBits() {
    words[words.count - 1] &= lastWordMask()   // 4
  }  
```

这是它的作用，分步是：

1) `diff`是“剩余”比特的数量。 在上面的例子中，因为`3 * 64 - 140 = 52`是52。

2) 创建一个全0的掩码，除了仍然有效的最高位是1.在我们的例子中，那将是：

	0000000000010000000000000000000000000000000000000000000000000000

3) 减去1把它变成：

	1111111111100000000000000000000000000000000000000000000000000000

并将高位添加回来获取：

	1111111111110000000000000000000000000000000000000000000000000000

这个词现在有12位，因为`140 - 2 * 64 = 12`。

4) 最后，关闭所有高的比特。 最后一个word中的任何剩余位现在都是0。

这个重要的一个例子就是当你组合两个不同大小的`BitSet`时。 为了便于说明，我们采用两个8比特值之间的按位OR：

	10001111  size=4
	00100011  size=8

第一个只使用前4位; 第二个使用8位。 第一个应该是`10000000`但让我们假装忘记在最后清除那些1。 然后两者之间的按位OR导致：

	10001111  
	00100011  
	-------- OR
	10101111

这是错误的，因为这些1位中的两个不应该在这里。 正确的方法是：

	10000000       unused bits set to 0 first!
	00100011  
	-------- OR
	10100011

下面是`|`运算符的实现方式：

```swift
public func |(lhs: BitSet, rhs: BitSet) -> BitSet {
  var out = copyLargest(lhs, rhs)
  let n = min(lhs.words.count, rhs.words.count)
  for i in 0..<n {
    out.words[i] = lhs.words[i] | rhs.words[i]
  }
  return out
}
```

请注意，我们`|`整个word，而不是单个比特。 那太慢了！ 如果左侧和右侧具有不同的位数，我们还需要做一些额外的工作：我们将两个`BitSet`s中最大的一个复制到`out`变量然后将它与单词组合 来自较小的`BitSet`。

例子：

```swift
var a = BitSet(size: 4)
a.setAll()
a[1] = false
a[2] = false
a[3] = false
print(a)

var b = BitSet(size: 8)
b[2] = true
b[6] = true
b[7] = true
print(b)

let c = a | b
print(c)        // 1010001100000000...0
```

按位AND（`＆`），异或（`^`）和反转（`~`）以类似的方式实现。

## 计算1-bits的数目

要计算设置为1的位数，我们可以扫描整个数组 —— **O(n)**操作 —— 但是有一个更聪明的方法：

```swift
  public var cardinality: Int {
    var count = 0
    for var x in words {
      while x != 0 {
        let y = x & ~(x - 1)  // find lowest 1-bit
        x = x ^ y             // and erase it
        ++count
      }
    }
    return count
  }
```

当你写 `x & ~(x - 1)` 时，它会给你一个只设置一个位的新值。 这是最低的一个。 例如，取这个8位值（再次，我用左边最低位显示这个值）：

	00101101

首先我们减去1得到：

	11001101

然后我们反转它，翻转所有比特：

	00110010

并与原始值按位AND：

	00101101
	00110010
	-------- AND
	00100000

它们共有的唯一值是最低（或最不重要）的1位。 然后我们使用异或从原始值中删除它：

	00101101
	00100000
	-------- XOR
	00001101

这是原始值，但删除了最低的1位。

我们不断重复此过程，直到该值包含全部为零。 时间复杂度是**O(s)**其中 **s** 是1位的数量。

## 扩展阅读

[Bit Twiddling Hacks](http://graphics.stanford.edu/~seander/bithacks.html)


*作者： Matthijs Hollemans*  
*翻译： [Andy Ron](https://github.com/andyRon)*  
*校对： [Andy Ron](https://github.com/andyRon)*  
