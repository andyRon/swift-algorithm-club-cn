# Brute-Force String Search
# 暴力字符串搜索

How would you go about writing a string search algorithm in pure Swift if you were not allowed to import Foundation and could not use `NSString`'s `rangeOfString()` method?
如果不允许导入Foundation并且不能使用`NSString`的`rangeOfString()`方法，那么如何在纯Swift中编写字符串搜索算法呢？

The goal is to implement an `indexOf(pattern: String)` extension on `String` that returns the `String.Index` of the first occurrence of the search pattern, or `nil` if the pattern could not be found inside the string.
目标是在`String`上实现`indexOf(pattern: String)`扩展，返回第一次出现的搜索模式的`String.Index`，如果在字符串中找不到模式，则返回`nil`。
 
For example:
例子：

```swift
// Input: 
let s = "Hello, World"
s.indexOf("World")

// Output:
<String.Index?> 7

// Input:
let animals = "🐶🐔🐷🐮🐱"
animals.indexOf("🐮")

// Output:
<String.Index?> 6
```

> **Note:** The index of the cow is 6, not 3 as you might expect, because the string uses more storage per character for emoji. The actual value of the `String.Index` is not so important, just that it points at the right character in the string.
> **注意：** 牛的索引是6，而不是你想象的3，因为字符串为表情符号使用每个字符更多的存储空间。 `String.Index`的实际值并不那么重要，只要它指向字符串中的正确字符。

Here is a brute-force solution:
这是暴力解决方案：

```swift
extension String {
  func indexOf(_ pattern: String) -> String.Index? {
    for i in self.characters.indices {
        var j = i
        var found = true
        for p in pattern.characters.indices{
            if j == self.characters.endIndex || self[j] != pattern[p] {
                found = false
                break
            } else {
                j = self.characters.index(after: j)
            }
        }
        if found {
            return i
        }
    }
    return nil
  }
}
```

This looks at each character in the source string in turn. If the character equals the first character of the search pattern, then the inner loop checks whether the rest of the pattern matches. If no match is found, the outer loop continues where it left off. This repeats until a complete match is found or the end of the source string is reached.
这将依次查看源字符串中的每个字符。 如果字符等于搜索模式的第一个字符，则内部循环检查模式的其余部分是否匹配，如果未找到匹配项，则外循环将从中断处继续。 重复此过程直到找到完全匹配或到达源字符串的结尾。

The brute-force approach works OK, but it's not very efficient (or pretty). It should work fine on small strings, though. For a smarter algorithm that works better with large chunks of text, check out [Boyer-Moore](../Boyer-Moore-Horspool) string search.
暴力方法运行正常，但效率不高（或漂亮）。 不过，它应该可以在小字符串上正常工作。 对于使用大块文本更好的智能算法，请查看[Boyer-Moore](../Boyer-Moore-Horspool/README_zh.md)字符串搜索。

*Written for Swift Algorithm Club by Matthijs Hollemans*

*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*
