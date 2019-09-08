# 暴力字符串搜索(Brute-Force String Search)

如果不允许导入`Foundation`并且不能使用`NSString`的`rangeOfString()`方法，那么如何在纯Swift中编写字符串搜索算法呢？
目标是在`String`上实现`indexOf(pattern: String)`扩展，返回第一次出现的搜索模式的`String.Index`，如果在字符串中找不到模式，则返回`nil`。

例子：

```swift
// Input: 
let s = "Hello, World"
s.indexOf("World")

// Output:
<String.Index?> 7

// Input:
let animals = "🦍🐢🐡🐮🦖🐋🐶🐬🐠🐔🐷🐙🐮🦟🦂🦜🦢🐨🦇🐐🦓"
animals.indexOf("🐮")

// Output:
<String.Index?> 6
```

> **注意：** 牛的索引是6，而不是你想象的3，因为字符串为表情符号使用更多的存储空间。 `String.Index`的实际值并不那么重要，只要它指向字符串中的正确字符。

这是暴力解决方案：

```swift
extension String {
    func indexOf(_ pattern: String) -> String.Index? {
        
        for i in self.indices {
            var j = i
            var found = true
            for p in pattern.indices {
                if j == self.endIndex || self[j] != pattern[p] {
                    found = false
                    break
                } else {
                    j = self.index(after: j)
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

这将依次查看源字符串中的每个字符。 如果字符等于搜索模式的第一个字符，则内部循环检查模式的其余部分是否匹配，如果未找到匹配项，则外循环将从中断处继续。 重复此过程直到找到完全匹配或到达源字符串的结尾。

暴力方法运行正常，但效率不高（或漂亮）。 不过，暴力方法应该可以在小字符串上正常工作。 对于使用大块文本更好的智能算法，请查看[Boyer-Moore](../Boyer-Moore-Horspool/)字符串搜索。



*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

