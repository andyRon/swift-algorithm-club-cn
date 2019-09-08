# Boyer-Moore字符串搜索(Boyer-Moore String Search)

> 这个主题已经有教程 [here](https://www.raywenderlich.com/163964/swift-algorithm-club-booyer-moore-string-search-algorithm)

目标：在纯Swift中编写字符串搜索算法，而无需导入`Foundation`或使用`NSString`的`rangeOfString()`方法。

换句话说，我们想在`String`上实现一个`indexOf(pattern：String)`扩展，它返回在字符串里面第一次出现搜索模式的`String.Index`，如果找不到模式则返回`nil` 。

例子：

```swift
// Input:
let s = "Hello, World"
s.indexOf(pattern: "World")

// Output:
<String.Index?> 7

// Input:
let animals = "🐶🐔🐷🐮🐱"
animals.indexOf(pattern: "🐮")

// Output:
<String.Index?> 6
```

> **注意：** 牛的索引是6，而不是你想象的3，因为字符串为表情符号使用更多的存储空间。`String.Index`的实际值并不那么重要，只是它指向字符串中的正确字符。

[暴力方法](../Brute-Force%20String%20Search/)工作正常，但效率不高，尤其是在大块文本上。 事实证明，您不需要从源字符串中查看 _每个_ 字符 —— 通常可以跳过多个字符。

这种跳过算法被称为[Boyer-Moore](https://en.wikipedia.org/wiki/Boyer-Moore_string_search_algorithm)算法，它已存在很长时间了。它被认为是所有字符串搜索算法的基准。


以下是您在Swift中编写它的方法：

```swift
extension String {
    func index(of pattern: String) -> Index? {

        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= self.count else { return nil }

        var skipTable = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]

        var i = index(startIndex, offsetBy: patternLength - 1)

        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }

        while i < endIndex {
            let c = self[i]

            if c == lastChar {

                if let k = backwards() { return k }

                i = index(after: i)
            } else {
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```


该算法的工作原理如下。 让源字符与搜索模式字符头部对齐排列，并查看字符串中的哪个字符与搜索模式的 _最后_ 字符匹配：

```
source string:  Hello, World
search pattern: World
                    ^
```

有三种可能性：

1. 这两个字符是相同的。 你找到了可能的匹配。

2. 字符不相等，但源字符确实有出现在搜索模式其他位置中。

3. 源字符完全没有出现在搜索模式中。


在示例中，字符`o`和`d`不匹配，但`o`确实出现在搜索模式中。 这意味着我们可以跳过几个位置：

```
source string:  Hello, World
search pattern:    World
                       ^
```

注意两个`o`字符现在是如何对齐的。 再次，您将搜索模式的最后一个字符与搜索文本进行比较：`W` vs`d`。 它们是不相同的，但`W`确实出现在搜索模式中。 因此，再次跳过一个位置，让两个`W`字符在相同位置：

```
source string:  Hello, World
search pattern:        World
                           ^
```

这次两个字符相等并且可能匹配。 要验证匹配，您需要进行暴力搜索，但是从搜索模式的末尾开始向前搜索。 这就是它的全部。

在任何给定时间跳过的数量由“跳过表”确定，“跳过表”是搜索模式中所有字符的字典和跳过的数量。 示例中的跳过表如下所示：

```
W: 4
o: 3
r: 2
l: 1
d: 0
```

字符越接近模式的末尾，跳过量越小。 如果某个字符在模式中出现多次，则最接近该模式结尾的字符将确定该字符的跳过值。

> **注意：** 如果搜索模式只包含几个字符，则执行暴力搜索会更快。 在构建跳过表与为短模式执行暴力搜索之间需要进行权衡。

致谢：此代码基于1989年7月Dr Dobb's杂志发表的文章["Faster String Searches" by Costas Menico](http://www.drdobbs.com/database/faster-string-searches/184408171)  —— 对 ，1989年！ 有时保留那些旧杂志是有用的。

扩展阅读：这个算法的[详细分析](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm)


## Boyer-Moore-Horspool 算法



上面算法的一个变体是[Boyer-Moore-Horspool 算法](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm)。

像常规的Boyer-Moore算法一样，它使用`skipTable`来跳过许多字符。 不同之处在于我们如何检查局部匹配。在上面的版本中，如果找到了部分匹配，但不是完全匹配，我们只跳过一个字符。在这个修订版本中，我们也在那种情况下使用跳过表。

这是Boyer-Moore-Horspool算法的一个实现：

```swift
extension String {
    
    func index(of pattern: String, usingHorspoolImprovement: Bool = false) -> Index? {
        
        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= self.count else {
            return nil
        }
        
        var skipTable = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            skipTable[c] = patternLength - i - 1
        }
        
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]
        
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }
        
        while i < endIndex {
            let c = self[i]
            
            if c == lastChar {
                
                if let k = backwards() { return k }
                
                if !usingHorspoolImprovement {
                    i = index(after: i)
                } else {
                    
                    let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                    i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
                }
            } else {
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

在实践中，Horspool版本的算法往往比原始版本略好一些。 但是，这取决于你愿意做出什么样的权衡。

致谢：此代码基于论文：[R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)


*作者：Matthijs Hollemans，Andreas Neusüß，[Matías Mazzei](https://github.com/mmazzei)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  


> **译注：**  阮一峰老师的文章 [字符串匹配的Boyer-Moore算法](http://www.ruanyifeng.com/blog/2013/05/boyer-moore_string_search_algorithm.html) 讲的比较清晰。