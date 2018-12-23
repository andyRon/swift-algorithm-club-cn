# 比特集(Bit Set)

A fixed-size sequence of *n* bits. Also known as bit array or bit vector.
固定大小的 *n* 位序列。 也称为位数组或位向量。

To store whether something is true or false you use a `Bool`. Every programmer knows that... But what if you need to remember whether 10,000 things are true or not?
要存储某些内容是 真还是假 使用`Bool`类型。 每个程序员都知道......但是如果你需要记住10,000件事情是否是真呢？

You could make an array of 10,000 booleans but you can also go hardcore and use 10,000 bits instead. That's a lot more compact because 10,000 bits fit in less than 160 `Int`s on a 64-bit CPU.
你可以制作一个包含10,000个布尔值的数组，但你也可以使用10,000位代替。 这更加紧凑，因为在64位CPU上，10,000位正好小于160个`Int`。

Since manipulating individual bits is a little tricky, you can use `BitSet` to hide the dirty work.
因为操纵单个位有点棘手，所以你可以使用`BitSet`来隐藏棘手的工作。

## 代码

A bit set is simply a wrapper around an array. The array doesn't store individual bits but larger integers called the "words". The main job of `BitSet` is to map the bits to the right word.
比特集只是数组的包装器。 该数组不存储单个位，而是存储称为“words”的较大整数。 `BitSet`的主要工作是将位映射到正确的单词。

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

`N` is the bit size of the words. It is 64 because we store the bits in a list of unsigned 64-bit integers. (It's fairly easy to change `BitSet` to use 32-bit words instead.)
`N`是单词的位大小。 它是64，因为我们将这些位存储在无符号64位整数列表中。 （将“BitSet”改为使用32位字相当容易。）

If you write,
如果你这样写：

```swift
var bits = BitSet(size: 140)
```

then the `BitSet` allocates an array of three words. Each word has 64 bits and therefore three words can hold 192 bits. We only use 140 of those bits so we're wasting a bit of space (but of course we can never use less than a whole word).
然后`BitSet`分配一个由三个单词组成的数组。每个字有64位，因此三个字可以容纳192位。我们只使用140个这样的位，所以我们浪费了一点空间（但当然我们永远不会使用不到一个字）。

> **Note:** The first entry in the `words` array is the least-significant word, so these words are stored in little endian order in the array.
> **注意：** `words`数组中的第一个条目是最不重要的单词，因此这些单词以小端顺序存储在数组中。

## Looking up the bits
## 查找位

Most of the operations on `BitSet` take the index of the bit as a parameter, so it's useful to have a way to find which word contains that bit.
`BitSet`上的大多数操作都将该位的索引作为参数，因此有一种方法可以找到包含该位的字。

```swift
  private func indexOf(_ i: Int) -> (Int, Word) {
    precondition(i >= 0)
    precondition(i < size)
    let o = i / N
    let m = Word(i - o*N)
    return (o, 1 << m)
  }
```

The `indexOf()` function returns the array index of the word, as well as a "mask" that shows exactly where the bit sits inside that word.
`indexOf()`函数返回单词的数组索引，以及一个“掩码”，它显示该位在该单词内的确切位置。

For example, `indexOf(2)` returns the tuple `(0, 4)` because bit 2 is in the first word (index 0). The mask is 4. In binary the mask looks like the following:
例如，`indexOf(2)`返回元组`(0,4)`，因为第2位在第一个字（索引0）中。 掩码为4。在二进制中，掩码如下所示：

	0010000000000000000000000000000000000000000000000000000000000000

That 1 points at the second bit in the word.
那1指向该词的第二位。

> **Note:** Remember that everything is shown in little-endian order, including the bits themselves. Bit 0 is on the left, bit 63 on the right.
> **注意：** 请记住，所有内容都以小端顺序显示，包括位本身。 位0位于最左侧，位63位于最右侧。

Another example: `indexOf(127)` returns the tuple `(1, 9223372036854775808)`. It is the last bit of the second word. The mask is:
另一个例子：`indexOf(127)`返回元组`（1,9223372036854775808）` （9223372036854775808 = 2^63）。 这是第二个单词的最后一点。 掩码是：

	0000000000000000000000000000000000000000000000000000000000000001

Note that the mask is always 64 bits because we look at the data one word at a time.
请注意，掩码总是64位，因为我们一次查看一个字的数据。

## Setting and getting bits
## 设置和获取位

Now that we know where to find a bit, setting it to 1 is easy:
现在我们知道在哪里找到一点，将其设置为1很容易：

```swift
  public mutating func set(_ i: Int) {
    let (j, m) = indexOf(i)
    words[j] |= m
  }
```

This looks up the word index and the mask, then performs a bitwise OR between that word and the mask. If the bit was 0 it becomes 1. If it was already set, then it remains set.
这会查找单词索引和掩码，然后在该单词和掩码之间执行按位OR。 如果该位为0则变为1.如果已经设置，则它保持设置。

Clearing the bit -- i.e. changing it to 0 -- is just as easy:
清除该位 - 即将其更改为0 - 同样简单：

```swift
  public mutating func clear(_ i: Int) {
    let (j, m) = indexOf(i)
    words[j] &= ~m
  }
```

Instead of a bitwise OR we now do a bitwise AND with the inverse of the mask. So if the mask was `00100000...0`, then the inverse is `11011111...1`. All the bits are 1, except for the bit we want to set to 0. Due to the way `&` works, this leaves all other bits alone and only changes that single bit to 0.
我们现在使用掩码的反转进行按位AND，而不是按位OR。 因此，如果掩码是`00100000 ... 0`，那么逆是`11011111 ... 1`。 除了我们想要设置为0的位之外，所有位都是1.由于`＆`的工作方式，这会使所有其他位保持不变，并且只将该位更改为0。

To see if a bit is set we also use the bitwise AND but without inverting:
要查看是否设置了位，我们还使用按位AND但不反转：

```swift
  public func isSet(_ i: Int) -> Bool {
    let (j, m) = indexOf(i)
    return (words[j] & m) != 0
  }
```

We can add a subscript function to make this all very natural to express:
我们可以添加一个下标函数来使这一切非常自然地表达：

```swift
  public subscript(i: Int) -> Bool {
    get { return isSet(i) }
    set { if newValue { set(i) } else { clear(i) } }
  }
```

Now you can write things like:
现在你可以这样写：

```swift
var bits = BitSet(size: 140)
bits[2] = true
bits[99] = true
bits[128] = true
print(bits)
```

This will print the three words that the 140-bit `BitSet` uses to store everything:
这将打印140位`BitSet`用于存储所有内容的三个单词：

```swift
0010000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000010000000000000000000000000000
1000000000000000000000000000000000000000000000000000000000000000
```

Something else that's fun to do with bits is flipping them. This changes 0 into 1 and 1 into 0. Here's `flip()`:
其他有趣的事情就是翻转它们。 这会将0变为1，将1变为0.这里是`flip()`：

```swift
  public mutating func flip(_ i: Int) -> Bool {
    let (j, m) = indexOf(i)
    words[j] ^= m
    return (words[j] & m) != 0
  }
```

This uses the remaining bitwise operator, exclusive-OR, to do the flipping. The function also returns the new value of the bit.
这使用剩余的按位运算符“异或”来进行翻转。 该函数还返回该位的新值。

## Ignoring the unused bits
## 忽略未使用的位

A lot of the `BitSet` functions are quite easy to implement. For example, `clearAll()`, which resets all the bits to 0:
很多`BitSet`函数都很容易实现。 例如，`clearAll()`，它将所有位重置为0：

```swift
  public mutating func clearAll() {
    for i in 0..<words.count {
      words[i] = 0
    }
  }
```

There is also `setAll()` to make all the bits 1. However, this has to deal with a subtle issue.
还有`setAll()`来创建所有位1.然而，这必须处理一个微妙的问题。

```swift
  public mutating func setAll() {
    for i in 0..<words.count {
      words[i] = allOnes
    }
    clearUnusedBits()
  }
```

First, we copy ones into all the words in our array. The array is now:
首先，我们将数据复制到数组中的所有单词中。 该数组现在是：

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
```

But this is incorrect... Since we don't use most of the last word, we should leave those bits at 0:
但这是不正确的......因为我们不使用大部分的最后一个字，所以我们应该将这些位保留为0：

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111110000000000000000000000000000000000000000000000000000
```

Instead of 192 one-bits we now have only 140 one-bits. The fact that the last word may not be completely filled up means that we always have to treat this last word specially.
我们现在只有140个一位，而不是192位。 事实上，最后一个字可能没有被完全填满，这意味着我们总是要特别对待这个最后一个字。

Setting those "leftover" bits to 0 is what the `clearUnusedBits()` helper function does. If the `BitSet`'s size is not a multiple of `N` (i.e. 64), then we have to clear out the bits that we're not using. If we don't do this, bitwise operations between two differently sized `BitSet`s will go wrong (an example follows).
将那些“剩余”位设置为0是`clearUnusedBits()`辅助函数的作用。 如果`BitSet`的大小不是`N`的倍数（即64），那么我们必须清除我们没有使用的位。 如果我们不这样做，两个不同大小的`BitSet`s之间的按位运算将出错（下面是一个例子）。

This uses some advanced bit manipulation, so pay close attention:
这使用了一些高级位操作，因此请密切关注：

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

Here's what it does, step-by-step:
这是它的作用，分步是：

1) `diff` is the number of "leftover" bits. In the above example that is 52 because `3*64 - 140 = 52`.
1) `diff`是“剩余”位的数量。 在上面的例子中，因为`3 * 64 - 140 = 52`是52。

2) Create a mask that is all 0's, except the highest bit that's still valid is a 1. In our example, that would be:
2) 创建一个全0的掩码，除了仍然有效的最高位是1.在我们的例子中，那将是：

	0000000000010000000000000000000000000000000000000000000000000000

3) Subtract 1 to turn it into:
3) 减去1把它变成：

	1111111111100000000000000000000000000000000000000000000000000000

and add the high bit back in to get:
并将高位添加回来获取：

	1111111111110000000000000000000000000000000000000000000000000000

There are now 12 one-bits in this word because `140 - 2*64 = 12`.
这个词现在有12位，因为`140 - 2 * 64 = 12`。

4) Finally, turn all the higher bits off. Any leftover bits in the last word are now all 0.
4) 最后，关闭所有高位。 最后一个字中的任何剩余位现在都是0。

An example of where this is important is when you combine two `BitSet`s of different sizes. For the sake of illustration, let's take the bitwise OR between two 8-bit values:
这个重要的一个例子就是当你组合两个不同大小的`BitSet`时。 为了便于说明，我们采用两个8位值之间的按位OR：

	10001111  size=4
	00100011  size=8

The first one only uses the first 4 bits; the second one uses 8 bits. The first one should really be `10000000` but let's pretend we forgot to clear out those 1's at the end. Then a bitwise OR between the two results in:
第一个只使用前4位; 第二个使用8位。 第一个应该是`10000000`但让我们假装忘记在最后清除那些1。 然后两者之间的按位OR导致：

	10001111  
	00100011  
	-------- OR
	10101111

That is wrong since two of those 1-bits aren't supposed to be here. The correct way to do it is:
这是错误的，因为这些1位中的两个不应该在这里。 正确的方法是：

	10000000       unused bits set to 0 first!
	00100011  
	-------- OR
	10100011

Here's how the `|` operator is implemented:
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

Note that we `|` entire words together, not individual bits. That would be way too slow! We also need to do some extra work if the left-hand side and right-hand side have a different number of bits: we copy the largest of the two `BitSet`s into the `out` variable and then combine it with the words from the smaller `BitSet`.
请注意，我们`|`整个单词，而不是单个位。 那太慢了！ 如果左侧和右侧具有不同的位数，我们还需要做一些额外的工作：我们将两个`BitSet`s中最大的一个复制到`out`变量然后将它与单词组合 来自较小的`BitSet`。

Example:

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

Bitwise AND (`&`), exclusive-OR (`^`), and inversion (`~`) are implemented in a similar manner.
按位AND（`＆`），异或（`^`）和反转（`~`）以类似的方式实现。

## Counting the number of 1-bits
## 计算1位数

To count the number of bits that are set to 1 we could scan through the entire array -- an **O(n)** operation -- but there's a more clever method:
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

When you write `x & ~(x - 1)`, it gives you a new value with only a single bit set. This is the lowest bit that is one. For example take this 8-bit value (again, I'm showing this with the least significant bit on the left):
当你写 `x & ~(x - 1)` 时，它会给你一个只设置一个位的新值。 这是最低的一个。 例如，取这个8位值（再次，我用左边最低位显示这个值）：

	00101101

First we subtract 1 to get:
首先我们减去1得到：

	11001101

Then we invert it, flipping all the bits:
然后我们反转它，翻转所有位：

	00110010

And take the bitwise AND with the original value:
并使用原始值按位AND：

	00101101
	00110010
	-------- AND
	00100000

The only value they have in common is the lowest (or least significant) 1-bit. Then we erase that from the original value using exclusive-OR:
它们共有的唯一值是最低（或最不重要）的1位。 然后我们使用异或从原始值中删除它：

	00101101
	00100000
	-------- XOR
	00001101

This is the original value but with the lowest 1-bit removed.
这是原始值，但删除了最低的1位。

We keep repeating this process until the value consists of all zeros. The time complexity is **O(s)** where **s** is the number of 1-bits.
我们不断重复此过程，直到该值包含全部为零。 时间复杂度是**O(s)**其中 **s** 是1位的数量。

## See also
## 扩展阅读

[Bit Twiddling Hacks](http://graphics.stanford.edu/~seander/bithacks.html)

*Written for Swift Algorithm Club by Matthijs Hollemans*

*作者： Matthijs Hollemans*  
*翻译： [Andy Ron](https://github.com/andyRon)*
