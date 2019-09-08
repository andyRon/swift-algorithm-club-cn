# 哈夫曼编码（Huffman Coding）

The idea: To encode objects that occur often with a smaller number of bits than objects that occur less frequently.
想法：编码通常让编码对象的位数减少。

Although any type of objects can be encoded with this scheme, it is common to compress a stream of bytes. Suppose you have the following text, where each character is one byte:
尽管可以使用此方案对任何类型的对象进行编码，但通常会压缩字节流。 假设您有以下文本，其中每个字符是一个字节：

	so much words wow many compression

If you count how often each byte appears, you can see some bytes occur more than others:
如果计算每个字节出现的频率，您可以看到一些字节比其他字节更多：

	space: 5                  u: 1
	    o: 5                  h: 1
	    s: 4                  d: 1
	    m: 3                  a: 1
	    w: 3                  y: 1
	    c: 2                  p: 1
	    r: 2                  e: 1
	    n: 2                  i: 1

We can assign bit strings to each of these bytes. The more common a byte is, the fewer bits we assign to it. We might get something like this:
我们可以为每个字节分配位串。 一个字节越常见，我们分配给它的位越少。 我们可能得到这样的东西：

	space: 5    010           u: 1    11001
	    o: 5    000	          h: 1    10001
	    s: 4    101	          d: 1    11010
	    m: 3    111	          a: 1    11011
	    w: 3    0010          y: 1    01111
	    c: 2    0011          p: 1    11000
	    r: 2    1001          e: 1    01110
	    n: 2    0110          i: 1    10000

Now if we replace the original bytes with these bit strings, the compressed output becomes:
现在，如果我们用这些位串替换原始字节，压缩输出将变为：

	101 000 010 111 11001 0011 10001 010 0010 000 1001 11010 101
	s   o   _   m   u     c    h     _   w    o   r    d     s

	010 0010 000 0010 010 111 11011 0110 01111 010 0011 000 111
	_   w    o   w    _   m   a     n    y     _   c    o   m

	11000 1001 01110 101 101 10000 000 0110 0
	p     r    e     s   s   i     o   n

The extra 0-bit at the end is there to make a full number of bytes. We were able to compress the original 34 bytes into merely 16 bytes, a space savings of over 50%!
最后的额外0位用于生成完整的字节数。 我们能够将原来的34个字节压缩成16个字节，节省的空间超过50％！

To be able to decode these bits, we need to have the original frequency table. That table needs to be transmitted or saved along with the compressed data. Otherwise, the decoder does not know how to interpret the bits. Because of the overhead of this frequency table (about 1 kilobyte), it is not beneficial to use Huffman encoding on small inputs.
为了能够解码这些位，我们需要具有原始频率表。该表需要与压缩数据一起传输或保存。否则，解码器不知道如何解释这些比特。由于该频率表（约1千字节）的开销，在小输入上使用霍夫曼编码是不利的。

## How it works
## 怎么运行的

When compressing a stream of bytes, the algorithm first creates a frequency table that counts how often each byte occurs. Based on this table, the algorithm creates a binary tree that describes the bit strings for each of the input bytes.
压缩字节流时，算法首先创建一个频率表，计算每个字节出现的频率。 基于此表，该算法创建一个二叉树，用于描述每个输入字节的位串。

For our example, the tree looks like this:
对于我们的示例，树看起来像这样：

![The compression tree](Images/Tree.png)

Note that the tree has 16 leaf nodes (the grey ones), one for each byte value from the input. Each leaf node also shows the count of how often it occurs. The other nodes are "intermediate" nodes. The number shown in these nodes is the sum of the counts of their child nodes. The count of the root node is therefore the total number of bytes in the input.
请注意，树有16个叶节点（灰色节点），每个节点对应一个输入的字节值。 每个叶节点还显示其发生频率的计数。 其他节点是“过渡”节点。 这些节点中显示的数字是其子节点的计数总和。 因此，根节点的计数是输入中的总字节数。

The edges between the nodes are either "1" or "0". These correspond to the bit-encodings of the leaf nodes. Notice how each left branch is always 1 and each right branch is always 0.
节点之间的边是“1”或“0”。 这些对应于叶节点的位编码。 注意每个左分支始终为1，每个右分支始终为0。

Compression is then a matter of looping through the input bytes and for each byte traversing the tree from the root node to that byte's leaf node. Every time we take a left branch, we emit a 1-bit. When we take a right branch, we emit a 0-bit.
然后，压缩是循环输入字节以及从根节点到该字节的叶节点遍历树的每个字节的问题。 每次我们采用左分支，我们发出1位。 当我们采用右分支时，我们发出一个0位。

For example, to go from the root node to `c`, we go right (`0`), right again (`0`), left (`1`), and left again (`1`). This gives the Huffman code as `0011` for `c`.
例如，从根节点到`c`，我们向右（`0`），再向右（`0`），向左（`1`），再向左（`1`）。 这使得霍夫曼代码为`c`为`0011`。

Decompression works in exactly the opposite way. It reads the compressed bits one-by-one and traverses the tree until it reaches to a leaf node. The value of that leaf node is the uncompressed byte. For example, if the bits are `11010`, we start at the root and go left, left again, right, left, and a final right to end up at `d`.
解压的作用完全相反。 它逐个读取压缩位并遍历树，直到它到达叶节点。 该叶节点的值是未压缩的字节。 例如，如果位是`11010`，我们从根开始向左，向左，向左，向左，最后向右，以`d`结束。

## The code
## 代码

Before we get to the actual Huffman coding scheme, it is useful to have some helper code that can write individual bits to an `NSData` object. The smallest piece of data that `NSData` understands is the byte, but we are dealing in bits, so we need to translate between the two.
在我们开始实际的霍夫曼编码方案之前，有一些辅助代码可以将单个位写入`NSData`对象。`NSData`理解的最小数据是字节，但我们处理的是比特，所以我们需要在两者之间进行转换。

```swift
public class BitWriter {
  public var data = NSMutableData()
  var outByte: UInt8 = 0
  var outCount = 0

  public func writeBit(bit: Bool) {
    if outCount == 8 {
      data.append(&outByte, length: 1)
      outCount = 0
    }
    outByte = (outByte << 1) | (bit ? 1 : 0)
    outCount += 1
  }

  public func flush() {
    if outCount > 0 {
      if outCount < 8 {
        let diff = UInt8(8 - outCount)
        outByte <<= diff
      }
      data.append(&outByte, length: 1)
    }
  }
}
```

To add a bit to the `NSData`, you can call `writeBit()`. This helper object stuffs each new bit into the `outByte` variable. Once you have written 8 bits, `outByte` gets added to the `NSData` object for real.
要向`NSData`添加一点，可以调用`writeBit()`。 这个帮助器对象将每个新位填充到`outByte`变量中。 一旦你写了8位，`outByte`就会被添加到`NSData`对象中。

The `flush()` method is used for outputting the very last byte. There is no guarantee that the number of compressed bits is a nice round multiple of 8, in which case there may be some spare bits at the end. If so, `flush()` adds a few 0-bits to make sure that we write a full byte.
`flush()`方法用于输出最后一个字节。 不能保证压缩位的数量是8的精确倍数，在这种情况下，最后可能会有一些备用位。 如果是这样，`flush()`会添加几个0位以确保我们写一个完整的字节。

Here is a similar helper object for reading individual bits from `NSData`:
这是一个类似的辅助对象，用于从`NSData`读取各个位：

```swift
public class BitReader {
  var ptr: UnsafePointer<UInt8>
  var inByte: UInt8 = 0
  var inCount = 8

  public init(data: NSData) {
    ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
  }

  public func readBit() -> Bool {
    if inCount == 8 {
      inByte = ptr.pointee    // load the next byte
      inCount = 0
      ptr = ptr.successor()
    }
    let bit = inByte & 0x80  // read the next bit
    inByte <<= 1
    inCount += 1
    return bit == 0 ? false : true
  }
}
```

By using this helper object, we can read one whole byte from the `NSData` object and put it in `inByte`. Then, `readBit()` returns the individual bits from that byte. Once `readBit()` has been called 8 times, we read the next byte from the `NSData`.
通过使用这个辅助对象，我们可以从`NSData`对象读取一个完整的字节并将其放在`inByte`中。 然后，`readBit()`返回该字节的各个位。 一旦`readBit()`被调用了8次，我们就从`NSData`读取下一个字节。

> **Note:** If you are unfamiliar with this type of bit manipulation, just know that these two helper objects make it simple for us to write and read bits.
> **注意：** 如果您不熟悉这种类型的位操作，只需知道这两个辅助对象使我们可以轻松地写和读取比特。

## The frequency table
## 频率表

The first step in the Huffman compression is to read the entire input stream and build a frequency table. This table contains a list of all 256 possible byte values and shows how often each of these bytes occurs in the input data.
霍夫曼压缩的第一步是读取整个输入流并构建频率表。 该表包含所有256个可能字节值的列表，并显示每个字节在输入数据中出现的频率。

We could store this frequency information in a dictionary or an array, but since we need to build a tree, we might store the frequency table as the leaves of the tree.
我们可以将这个频率信息存储在字典或数组中，但由于我们需要构建一个树，我们可能会将频率表存储为树的叶节点。

Here are the definitions we need:
以下是我们需要的定义：

```swift
class Huffman {
  typealias NodeIndex = Int

  struct Node {
    var count = 0
    var index: NodeIndex = -1
    var parent: NodeIndex = -1
    var left: NodeIndex = -1
    var right: NodeIndex = -1
  }

  var tree = [Node](repeating: Node(), count: 256)

  var root: NodeIndex = -1
}
```

The tree structure is stored in the `tree` array and will be made up of `Node` objects. Since this is a [binary tree](../Binary%20Tree/), each node needs two children, `left` and `right`, and a reference back to its `parent` node. Unlike a typical binary tree, these nodes do not use pointers to refer to each other but use simple integer indices in the `tree` array. (We also store the array `index` of the node itself; the reason for this will become clear later.)
树结构存储在`tree`数组中，并由`Node`对象组成。 由于这是[二叉树](../Binary%20Tree/)，每个节点需要两个子节点，`left`和`right`，以及一个返回其`parent`节点的引用。 与典型的二叉树不同，这些节点不使用指针相互引用，而是在`tree`数组中使用简单的整数索引。 （我们还存储节点本身的数组`index`;之后会明白这个原因。）

Note that the `tree` currently has room for 256 entries. These are for the leaf nodes because there are 256 possible byte values. Of course, not all of those may end up being used, depending on the input data. Later, we will add more nodes as we build up the actual tree. For the moment, there is not a tree yet. It includes 256 separate leaf nodes with no connections between them. All the node counts are 0.
请注意，`tree`目前有256个条目的空间。 这些用于叶节点，因为有256个可能的字节值。 当然，并非所有这些都可能最终被使用，具体取决于输入数据。 稍后，我们将在构建实际树时添加更多节点。 目前还没有一棵树。 它包括256个单独的叶节点，它们之间没有连接。 所有节点计数均为0。

We use the following method to count how often each byte occurs in the input data:
我们使用以下方法计算输入数据中每个字节出现的频率：

```swift
  fileprivate func countByteFrequency(inData data: NSData) {
    var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
    for _ in 0..<data.length {
      let i = Int(ptr.pointee)
      tree[i].count += 1
      tree[i].index = i
      ptr = ptr.successor()
    }
  }
```

This steps through the `NSData` object from beginning to end and for each byte increments the `count` of the corresponding leaf node. After `countByteFrequency()` completes, the first 256 `Node` objects in the `tree` array represent the frequency table.
这从头到尾逐步执行`NSData`对象，并且每个字节递增相应叶节点的`count`。 `countByteFrequency()`完成后，`tree`数组中的前256个`Node`对象代表频率表。

To decompress a Huffman-encoded block of data, we need to have the original frequency table. If we were writing the compressed data to a file, then somewhere in the file we should include the frequency table.
要解压缩霍夫曼编码的数据块，我们需要拥有原始频率表。 如果我们将压缩数据写入文件，那么文件中的某个位置应该包含频率表。

We could dump the first 256 elements from the `tree` array, but that is not efficient. Not all of these 256 elements will be used, and we do not need to serialize the `parent`, `right`, and `left` pointers. All we need is the frequency information and not the entire tree.
我们可以从`tree`数组转储前256个元素，但效率不高。 并非所有这256个元素都将被使用，我们不需要序列化`parent`，`right`和`left`指针。 我们所需要的只是频率信息，而不是整个树。

Instead, we will add a method to export the frequency table without all the pieces we do not need:
相反，我们将添加一个方法来导出频率表，而不需要我们不需要的所有部分：

```swift
  struct Freq {
    var byte: UInt8 = 0
    var count = 0
  }

  func frequencyTable() -> [Freq] {
    var a = [Freq]()
    for i in 0..<256 where tree[i].count > 0 {
      a.append(Freq(byte: UInt8(i), count: tree[i].count))
    }
    return a
  }
```

The `frequencyTable()` method looks at those first 256 nodes from the tree but keeps only those that are used, without the `parent`, `left`, and `right` pointers. It returns an array of `Freq` objects. You have to serialize this array along with the compressed data, so that it can be properly decompressed later.
`frequencyTable()`方法查看树中的前256个节点，但只保留那些使用的节点，没有`parent`，`left`和`right`指针。 它返回一个`Freq`对象数组。 您必须将此数组与压缩数据一起序列化，以便以后可以正确解压缩。

## The tree
## 树

As a reminder, there is the compression tree for the example:
作为提醒，示例中有压缩树：

![The compression tree](Images/Tree.png)

The leaf nodes represent the actual bytes that are present in the input data. The intermediary nodes connect the leaves in such a way that the path from the root to a frequently-used byte value is shorter than the path to a less common byte value. As you can see, `m`, `s`, space, and `o` are the most common letters in our input data and the highest up in the tree.
叶节点表示输入数据中存在的实际字节。 中间节点以这样的方式连接叶子，即从根到经常使用的字节值的路径比到不常见的字节值的路径短。 正如您所看到的，`m`，`s`，space和`o`是输入数据中最常见的字母，树中最高的字母。

To build the tree, we do the following:
要构建树，我们执行以下操作：

1. Find the two nodes with the smallest counts that do not have a parent node yet.
2. Create a new parent node that links these two nodes together.
3. This repeats over and over until only one node with no parent remains. This becomes the root node of the tree.

1. 找到具有最小计数但尚未具有父节点的两个节点。
2. 创建将这两个节点链接在一起的新父节点。
3. 这反复重复，直到只剩下一个没有父节点的节点。 这将成为树的根节点。

This is an ideal place to use a [priority queue](../Priority%20Queue/). A priority queue is a data structure that is optimized, so that finding the minimum value is always fast. Here, we repeatedly need to find the node with the smallest count.
这是使用[优先级队列](../Priority％20Queue/)的理想场所。 优先级队列是优化的数据结构，因此查找最小值总是很快。 在这里，我们一再需要找到计数最小的节点。

The function `buildTree()` then becomes:
然后函数`buildTree()`变为：

```swift
  fileprivate func buildTree() {
    var queue = PriorityQueue<Node>(sort: { $0.count < $1.count })
    for node in tree where node.count > 0 {
      queue.enqueue(node)                            // 1
    }

    while queue.count > 1 {
      let node1 = queue.dequeue()!                   // 2
      let node2 = queue.dequeue()!

      var parentNode = Node()                        // 3
      parentNode.count = node1.count + node2.count
      parentNode.left = node1.index
      parentNode.right = node2.index
      parentNode.index = tree.count
      tree.append(parentNode)

      tree[node1.index].parent = parentNode.index    // 4
      tree[node2.index].parent = parentNode.index

      queue.enqueue(parentNode)                      // 5
    }

    let rootNode = queue.dequeue()!                  // 6
    root = rootNode.index
  }
```

Here is how it works step-by-step:
以下是一步一步的工作原理：

1. Create a priority queue and enqueue all the leaf nodes that have at least a count of 1. (If the count is 0, then this byte value did not appear in the input data.) The `PriorityQueue` object sorts the nodes by their count, so that the node with the lowest count is always the first one that gets dequeued.

2. While there are at least two nodes left in the queue, remove the two nodes that are at the front of the queue. Since this is a min-priority queue, this gives us the two nodes with the smallest counts that do not have a parent node yet.

3. Create a new intermediate node that connects `node1` and `node2`. The count of this new node is the sum of the counts of `node1` and `node2`. Because the nodes are connected using array indices instead of real pointers, we use `node1.index` and `node2.index` to find these nodes in the `tree` array. (This is why a `Node` needs to know its own index.)

4. Link the two nodes into their new parent node. Now this new intermediate node has become part of the tree.

5. Put the new intermediate node back into the queue. At this point we are done with `node1` and `node2`, but the `parentNode` still needs to be connected to other nodes in the tree.

6. Repeat steps 2-5 until there is only one node left in the queue. This becomes the root node of the tree, and we are done.

1. 创建一个优先级队列，并将所有至少计数为1的叶节点入队。（如果计数为0，则此字节值不会出现在输入数据中。）`PriorityQueue`对象按节点排序它们的计数，以便计数最少的节点始终是第一个出列的节点。

2. 虽然队列中至少有两个节点，但请删除队列前面的两个节点。由于这是一个最小优先级队列，因此这为我们提供了两个具有最小计数但尚未拥有父节点的节点。

3. 创建一个连接`node1`和`node2`的新中间节点。这个新节点的计数是`node1`和`node2`的计数之和。因为节点是使用数组索引而不是真实指针连接的，所以我们使用`node1.index`和`node2.index`在`tree`数组中找到这些节点。 （这就是为什么`Node`需要知道它自己的索引。）

4. 将两个节点链接到新的父节点。现在，这个新的中间节点已成为树的一部分。

5. 将新的中间节点放回队列中。此时我们完成了`node1`和`node2`，但`parentNode`仍然需要连接到树中的其他节点。

6. 重复步骤2-5，直到队列中只剩下一个节点。这成为树的根节点，我们就完成了。

The animation shows what the process looks like:
动画显示了该过程的样子：

![Building the tree](Images/BuildTree.gif)

> **Note:** Instead of using a priority queue, you can repeatedly iterate through the `tree` array to find the next two smallest nodes, but that makes the compressor slow as **O(n^2)**. Using the priority queue, the running time is only **O(n log n)** where **n** is the number of nodes.
> **注意：** 不是使用优先级队列，而是可以重复遍历`tree`数组以查找接下来的两个最小节点，但这会使压缩器变慢为**O(n^2)**。 使用优先级队列，运行时间仅为**O(nlogn)**，其中**n**是节点数。

> **Fun fact:** Due to the nature of binary trees, if we have *x* leaf nodes we can at most add *x - 1* additional nodes to the tree. Given that at most there will be 256 leaf nodes, the tree will never contain more than 511 nodes total.
> **有趣的事实：** 由于二叉树的性质，如果我们有*x*叶节点，我们最多可以向树中添加*x - 1*个额外节点。 鉴于最多将有256个叶节点，该树将永远不会包含超过511个节点。

## Compression
## 压缩

Now that we know how to build the compression tree from the frequency table, we can use it to compress the contents of an `NSData` object. Here is the code:
现在我们知道如何从频率表构建压缩树，我们可以使用它来压缩`NSData`对象的内容。 这是代码：

```swift
  public func compressData(data: NSData) -> NSData {
    countByteFrequency(inData: data)
    buildTree()

    let writer = BitWriter()
    var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
    for _ in 0..<data.length {
      let c = ptr.pointee
      let i = Int(c)
      traverseTree(writer: writer, nodeIndex: i, childIndex: -1)
      ptr = ptr.successor()
    }
    writer.flush()
    return writer.data
  }
```

This first calls `countByteFrequency()` to build the frequency table and then calls `buildTree()` to put together the compression tree. It also creates a `BitWriter` object for writing individual bits.
这首先调用`countByteFrequency()`来构建频率表，然后调用`buildTree()`来组合压缩树。 它还创建了一个用于写入各个位的`BitWriter`对象。

Then, it loops through the entire input and calls `traverseTree()`for each byte. This method will step through the tree nodes and for each node write a 1 or 0 bit. Finally, we return the `BitWriter`'s data object.
然后，它遍历整个输入并为每个字节调用`traverseTree（）`。 此方法将逐步执行树节点，并为每个节点写入1或0位。 最后，我们返回`BitWriter`的数据对象。

> **Note:** Compression always requires two passes through the entire input data: first to build the frequency table, and second to convert the bytes to their compressed bit sequences.
> **注意：** 压缩总是需要两次遍历整个输入数据：首先构建频率表，然后将字节转换为压缩的位序列。

The interesting stuff happens in `traverseTree()`. This is a recursive method:
有趣的东西发生在`traverseTree()`中。 这是一种递归方法：

```swift
  private func traverseTree(writer: BitWriter, nodeIndex h: Int, childIndex child: Int) {
    if tree[h].parent != -1 {
      traverseTree(writer: writer, nodeIndex: tree[h].parent, childIndex: h)
    }
    if child != -1 {
      if child == tree[h].left {
        writer.writeBit(bit: true)
      } else if child == tree[h].right {
        writer.writeBit(bit: false)
      }
    }
  }
```

When we call this method from `compressData()`, the `nodeIndex` parameter is the array index of the leaf node for the byte that we need to encode. This method recursively walks the tree from a leaf node up to the root and then back again.
当我们从`compressData()`调用这个方法时，`nodeIndex`参数是我们需要编码的字节的叶节点的数组索引。 此方法递归地将树从叶节点向上移动到根，然后再返回。

As we are going back from the root to the leaf node, we write a 1 bit or a 0 bit for every node we encounter. If a child is the left node, we emit a 1; if it is the right node, we emit a 0.
当我们从根节点回到叶节点时，我们为每个遇到的节点写一个1位或0位。 如果一个孩子是左边的节点，我们发出1; 如果它是正确的节点，我们发出一个0。

In a picture:
图片：

![How compression works](Images/Compression.png)

Even though the illustration of the tree shows a 0 or 1 for each edge between the nodes, the bit values 0 and 1 are not actually stored in the tree! The rule is that we write a 1 bit if we take the left branch and a 0 bit if we take the right branch, so just knowing the direction we are going in is enough to determine what bit value to write.
即使树的图示为节点之间的每条边显示0或1，位值0和1实际上也不存储在树中！规则是如果我们采用左分支则写入1位，如果采用右分支则写入0位，因此只要知道我们进入的方向就足以确定要写入的位值。

You use the `compressData()` method as follows:
您使用`compressData()`方法如下：

```swift
let s1 = "so much words wow many compression"
if let originalData = s1.dataUsingEncoding(NSUTF8StringEncoding) {
  let huffman1 = Huffman()
  let compressedData = huffman1.compressData(originalData)
  print(compressedData.length)
}
```

## Decompression
## 减压缩

Decompression is the compression in reverse. However, the compressed bits are useless without the frequency table. As mentioned, the `frequencyTable()` method returns an array of `Freq` objects. If we were saving the compressed data into a file or sending it across the network, we'd also save that `[Freq]` array along with it.
减压是反向压缩。 但是，没有频率表，压缩位是无用的。 如上所述，`frequencyTable()`方法返回一个`Freq`对象数组。如果我们将压缩数据保存到文件中或通过网络发送它，我们也会保存`[Freq]`数组。

We first need some way to turn the `[Freq]` array back into a compression tree:
我们首先需要一些方法将`[Freq]`数组转换回压缩树：

```swift
  fileprivate func restoreTree(fromTable frequencyTable: [Freq]) {
    for freq in frequencyTable {
      let i = Int(freq.byte)
      tree[i].count = freq.count
      tree[i].index = i
    }
    buildTree()
  }
```

We convert the `Freq` objects into leaf nodes and then call `buildTree()` to do the rest.
我们将`Freq`对象转换为叶节点，然后调用`buildTree()`来完成剩下的工作。

Here is the code for `decompressData()`, which takes an `NSData` object with Huffman-encoded bits and a frequency table, and it returns the original data:
这是`decompressData()`的代码，它采用带有霍夫曼编码位和频率表的`NSData`对象，并返回原始数据：

```swift
  func decompressData(data: NSData, frequencyTable: [Freq]) -> NSData {
    restoreTree(fromTable: frequencyTable)

    let reader = BitReader(data: data)
    let outData = NSMutableData()
    let byteCount = tree[root].count

    var i = 0
    while i < byteCount {
      var b = findLeafNode(reader: reader, nodeIndex: root)
      outData.append(&b, length: 1)
      i += 1
    }
    return outData
  }
```

This also uses a helper method to traverse the tree:
这也使用辅助方法遍历树：

```swift
  private func findLeafNode(reader reader: BitReader, nodeIndex: Int) -> UInt8 {
    var h = nodeIndex
    while tree[h].right != -1 {
      if reader.readBit() {
        h = tree[h].left
      } else {
        h = tree[h].right
      }
    }
    return UInt8(h)
  }
```

`findLeafNode()` walks the tree from the root down to the leaf node given by `nodeIndex`. At each intermediate node, we read a new bit and then step to the left (bit is 1) or the right (bit is 0). When we get to the leaf node, we simply return its index, which is equal to the original byte value.
`findLeafNode()`将树从根向下走到`nodeIndex`给出的叶节点。 在每个中间节点，我们读取一个新位然后向左（位为1）或向右（位为0）。 当我们到达叶节点时，我们只返回它的索引，它等于原始字节值。

In a picture:
图片：

![How decompression works](Images/Decompression.png)

Here is how we use the decompression method:
以下是我们如何使用解压缩方法：

```swift
  let frequencyTable = huffman1.frequencyTable()

  let huffman2 = Huffman()
  let decompressedData = huffman2.decompressData(compressedData, frequencyTable: frequencyTable)

  let s2 = String(data: decompressedData, encoding: NSUTF8StringEncoding)!
```

First we get the frequency table from somewhere (in this case the `Huffman` object we used to encode the data) and then call `decompressData()`. The string that results should be equal to the one we compressed in the first place.
首先，我们从某处获取频率表（在本例中是我们用于编码数据的`Huffman`对象），然后调用`decompressData()`。 结果的字符串应该等于我们首先压缩的字符串。

we can see how this works in more detail in the Playground.
我们可以在Playground中更详细地了解它的工作原理。

## See also
## 扩展阅读


[哈夫曼编码的维基百科](https://en.wikipedia.org/wiki/Huffman_coding)

The code is loosely based on Al Stevens' C Programming column from Dr.Dobb's Magazine, February 1991 and October 1992.
该代码基于1991年2月和1992年10月Dr.Dobb杂志的Al Stevens的C编程专栏。

*Written for Swift Algorithm Club by Matthijs Hollemans*  
*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*
