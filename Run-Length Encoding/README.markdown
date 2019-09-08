# Run-Length Encoding (RLE)
# 变动长度编码法(Run-Length Encoding, RLE)

RLE is probably the simplest way to do compression. Let's say you have data that looks like this:
RLE可能是进行压缩的最简单方法。 假设您的数据如下所示：

	aaaaabbbcdeeeeeeef...

then RLE encodes it as follows:
然后RLE将其编码为：

	5a3b1c1d7e1f...

Instead of repeating bytes, you first write how often that byte occurs and then the byte's actual value. So `5a` means `aaaaa`. If the data has a lot of "byte runs", that is lots of repeating bytes, then RLE can save quite a bit of space. It works quite well on images.
您首先要写出该字节出现的频率，然后再写出字节的实际值，而不是重复字节。所以`5a`的意思是`aaaaa`。如果数据有很多“字节运行”，那就是很多重复的字节，那么RLE可以节省相当多的空间。 它在图像上运行良好。

There are many different ways you can implement RLE. Here's an extension of `Data` that does a version of RLE inspired by the old [PCX image file format](https://en.wikipedia.org/wiki/PCX).
有许多不同的方法可以实现RLE。 这是`Data`的扩展，它使旧的[PCX图像文件格式](https://en.wikipedia.org/wiki/PCX)启发了一个RLE版本。

The rules are these:
规则如下：

- Each byte run, i.e. when a certain byte value occurs more than once in a row, is compressed using two bytes: the first byte records the number of repetitions, the second records the actual value. The first byte is stored as: `191 + count`. This means encoded byte runs can never be more than 64 bytes long.
- 每个字节运行，即当某个字节值连续出现一次时，使用两个字节进行压缩：第一个字节记录重复次数，第二个字节记录实际值。 第一个字节存储为：`191 + count`。 这意味着编码的字节运行时间永远不会超过64个字节。

- A single byte in the range 0 - 191 is not compressed and is copied without change.
- 0 - 191范围内的单个字节未压缩，无需更改即可复制。

- A single byte in the range 192 - 255 is represented by two bytes: first the byte 192 (meaning a run of 1 byte), followed by the actual value.
- 192 - 255范围内的单个字节由两个字节表示：首先是字节192（表示1个字节的运行），然后是实际值。

Here is the compression code. It returns a new `Data` object containing the run-length encoded bytes:
这是压缩代码。 它返回一个包含变动长度编码字节的新`Data`对象：

```swift
extension Data {
    public func compressRLE() -> Data {
        var data = Data()
        self.withUnsafeBytes { (uPtr: UnsafePointer<UInt8>) in
            var ptr = uPtr
            let end = ptr + count
            while ptr < end { 						//1
                var count = 0
                var byte = ptr.pointee
                var next = byte

                while next == byte && ptr < end && count < 64 { //2
                    ptr = ptr.advanced(by: 1)
                    next = ptr.pointee
                    count += 1
                }

                if count > 1 || byte >= 192 {       // 3
                    var size = 191 + UInt8(count)
                    data.append(&size, count: 1)
                    data.append(&byte, count: 1)
                } else {                            // 4
                    data.append(&byte, count: 1)
                }
            }
        }
        return data
    }
 }
```

How it works:
怎么运行的：

1. We use an `UnsafePointer` to step through the bytes of the original `Data` object.

2. At this point we've read the current byte value into the `byte` variable. If the next byte is the same, then we keep reading until we find a byte value that is different, or we reach the end of the data. We also stop if the run is 64 bytes because that's the maximum we can encode.

3. Here, we have to decide how to encode the bytes we just read. The first possibility is that we've read a run of 2 or more bytes (up to 64). In that case we write out two bytes: the length of the run followed by the byte value. But it's also possible we've read a single byte with a value >= 192. That will also be encoded with two bytes.

4. The third possibility is that we've read a single byte < 192. That simply gets copied to the output verbatim.

1. 我们使用`UnsafePointer`来逐步执行原始`Data`对象的字节。

2. 此时我们已将当前字节值读入`byte`变量。 如果下一个字节是相同的，那么我们继续读取，直到找到不同的字节值，或者我们到达数据的末尾。 如果运行是64字节，我们也会停止，因为这是我们可以编码的最大值。

3. 在这里，我们必须决定如何编码我们刚刚读取的字节。 第一种可能性是我们已经读取了2个或更多字节（最多64个）的运行。 在这种情况下，我们写出两个字节：运行的长度，后跟字节值。 但是我们也可以读取值> = 192的单个字节。这也将用两个字节编码。

4. 第三种可能性是我们读取了单个字节<192。这只是逐字复制到输出。

You can test it like this in a playground:
在 playground 测试：

```swift
let originalString = "aaaaabbbcdeeeeeeef"
let utf8 = originalString.data(using: String.Encoding.utf8)!
let compressed = utf8.compressRLE()
```

The compressed `Data` object should be `<c461c262 6364c665 66>`. Let's decode that by hand to see what has happened:
压缩的`Data`对象应该是`<c461c262 6364c665 66>`。 让我们手动解码，看看发生了什么：

	c4    This is 196 in decimal. It means the next byte appears 5 times.
	61    The data byte "a".
	c2    The next byte appears 3 times.
	62    The data byte "b".
	63    The data byte "c". Because this is < 192, it's a single data byte.
	64    The data byte "d". Also appears just once.
	c6    The next byte will appear 7 times.
	65    The data byte "e".
	66    The data byte "f". Appears just once.

So that's 9 bytes encoded versus 18 original. That's a savings of 50%. Of course, this was only a simple test case... If you get unlucky and there are no byte runs at all in your original data, then this method will actually make the encoded data twice as large! So it really depends on the input data.
所以这是9个字节的编码而不是18个原始的。 这节省了50％。 当然，这只是一个简单的测试用例...如果你运气不好并且原始数据中根本没有字节运行，那么这种方法实际上会使编码数据的数量增加一倍！ 所以它真的取决于输入数据。

Here is the decompression code:
这是解压缩代码：

```swift
public func decompressRLE() -> Data {
        var data = Data()
        self.withUnsafeBytes { (uPtr: UnsafePointer<UInt8>) in
            var ptr = uPtr
            let end = ptr + count

            while ptr < end {
                // Read the next byte. This is either a single value less than 192,
                // or the start of a byte run.
                var byte = ptr.pointee							// 1
                ptr = ptr.advanced(by: 1)

                if byte < 192 {                     // 2
                    data.append(&byte, count: 1)
                } else if ptr < end {               // 3
                    // Read the actual data value.
                    var value = ptr.pointee
                    ptr = ptr.advanced(by: 1)

                    // And write it out repeatedly.
                    for _ in 0 ..< byte - 191 {
                        data.append(&value, count: 1)
                    }
                }
            }
        }
        return data
    }

```

1. Again this uses an `UnsafePointer` to read the `Data`. Here we read the next byte; this is either a single value less than 192, or the start of a byte run.

2. If it's a single value, then it's just a matter of copying it to the output.

3. But if the byte is the start of a run, we have to first read the actual data value and then write it out repeatedly.

1. 再次，它使用`UnsafePointer`来读取`Data`。 这里我们读下一个字节; 这可以是小于192的单个值，也可以是字节运行的开始。

2. 如果它是单个值，那么只需将其复制到输出即可。

3. 但是如果字节是运行的开始，我们必须首先读取实际数据值，然后重复写出。

To turn the compressed data back into the original, you'd do:
要将压缩数据恢复为原始数据，您需要执行以下操作：

```swift
let decompressed = compressed.decompressRLE()
let restoredString = String(data: decompressed, encoding: NSUTF8StringEncoding)
```

And now `originalString == restoredString` must be true!
现在`originalString == restoredString`必须是真的！

Footnote: The original PCX implementation is slightly different. There, a byte value of 192 (0xC0) means that the following byte will be repeated 0 times. This also limits the maximum run size to 63 bytes. Because it makes no sense to store bytes that don't occur, in my implementation 192 means the next byte appears once, and the maximum run length is 64 bytes.
脚注：最初的PCX实现略有不同。 在那里，字节值192（0xC0）意味着后续字节将重复0次。 这也将最大运行大小限制为63个字节。 因为存储不存在的字节没有意义，所以在我的实现中192表示下一个字节出现一次，最大运行长度为64字节。

This was probably a trade-off when they designed the PCX format way back when. If you look at it in binary, the upper two bits indicate whether a byte is compressed. (If both bits are set then the byte value is 192 or more.) To get the run length you can simply do `byte & 0x3F`, giving you a value in the range 0 to 63.
当他们设计PCX格式的时候，这可能是一种权衡。 如果以二进制形式查看，则高两位表示是否压缩了一个字节。 （如果两个位都置位，则字节值为192或更大。）要获得运行长度，您只需执行`byte＆0x3F`，为您提供0到63范围内的值。

*Written for Swift Algorithm Club by Matthijs Hollemans*
*Migrated to Swift3 by Jaap Wijnen*

*作者：Matthijs Hollemans, Jaap Wijnen*   
*翻译：[Andy Ron](https://github.com/andyRon)*
