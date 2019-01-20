# Rabin-Karp string search algorithm
# Rabin-Karp字符串搜索算法

The Rabin-Karp string search algorithm is used to search text for a pattern.
Rabin-Karp字符串搜索算法用于搜索模式的文本。

A practical application of the algorithm is detecting plagiarism. Given source material, the algorithm can rapidly search through a paper for instances of sentences from the source material, ignoring details such as case and punctuation. Because of the abundance of the sought strings, single-string searching algorithms are impractical.
该算法的实际应用是检测抄袭。 在给定源材料的情况下，该算法可以快速在纸张中搜索来自源材料的句子实例，忽略诸如大小写和标点符号之类的细节。 由于所搜索的字符串丰富，单字符串搜索算法是不切实际的。

## Example
## 例子

Given a text of "The big dog jumped over the fox" and a search pattern of "ump" this will return 13.
It starts by hashing "ump" then hashing "The".  If hashed don't match then it slides the window a character
at a time (e.g. "he ") and subtracts out the previous hash from the "T".
鉴于 "The big dog jumped over the fox" 的文字和“ump”的搜索模式，这将返回13。
它首先散列“ump”然后散列“The”。 如果散列不匹配，则它会在窗口中滑动一个字符
一次（例如“他”）并从“T”中减去先前的散列。

## Algorithm
## 算法

The Rabin-Karp algorithm uses a sliding window the size of the search pattern.  It starts by hashing the search pattern, then
hashing the first x characters of the text string where x is the length of the search pattern.  It then slides the window one character over and uses
the previous hash value to calculate the new hash faster.  Only when it finds a hash that matches the hash of the search pattern will it compare
the two strings it see if they are the same (to prevent a hash collision from producing a false positive).
Rabin-Karp算法使用与搜索模式大小相同的滑动窗口。 然后，它通过散列搜索模式开始
散列文本字符串的前x个字符，其中x是搜索模式的长度。 然后它将窗口滑动一个字符并使用
先前的哈希值可以更快地计算新哈希值。 只有当它找到与搜索模式的哈希匹配的哈希时才会进行比较
它们看到的两个字符串是否相同（以防止哈希冲突产生误报）。

## The code
## 代码

The major search method is next.  More implementation details are in rabin-karp.swift
接下来是主要的搜索方法。 更多实现细节在rabin-karp.swift中

```swift
public func search(text: String , pattern: String) -> Int {
    // convert to array of ints
    let patternArray = pattern.flatMap { $0.asInt }
    let textArray = text.flatMap { $0.asInt }

    if textArray.count < patternArray.count {
        return -1
    }

    let patternHash = hash(array: patternArray)
    var endIdx = patternArray.count - 1
    let firstChars = Array(textArray[0...endIdx])
    let firstHash = hash(array: firstChars)

    if (patternHash == firstHash) {
        // Verify this was not a hash collision
        if firstChars == patternArray {
            return 0
        }
    }

    var prevHash = firstHash
    // Now slide the window across the text to be searched
    for idx in 1...(textArray.count - patternArray.count) {
        endIdx = idx + (patternArray.count - 1)
        let window = Array(textArray[idx...endIdx])
        let windowHash = nextHash(prevHash: prevHash, dropped: textArray[idx - 1], added: textArray[endIdx], patternSize: patternArray.count - 1)

        if windowHash == patternHash {
            if patternArray == window {
                return idx
            }
        }

        prevHash = windowHash
    }

    return -1
}
```

This code can be tested in a playground using the following:
可以使用以下代码在 playground 测试此代码：

```swift
  search(text: "The big dog jumped"", "ump")
```

This will return 13 since ump is in the 13 position of the zero based string.
这将返回13，因为ump处于基于零的字符串的13位置。

## Additional Resources
## 扩展阅读

[Rabin-Karp Wikipedia](https://en.wikipedia.org/wiki/Rabin%E2%80%93Karp_algorithm)


*Written by [Bill Barbour](https://github.com/brbatwork)*
*作者：[Bill Barbour](https://github.com/brbatwork)*  
*翻译：[Andy Ron](https://github.com/andyRon)*

