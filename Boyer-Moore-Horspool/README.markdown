# Boyer-Moore String Search
# Boyer-Moore字符串搜索

> This topic has been tutorialized [here](https://www.raywenderlich.com/163964/swift-algorithm-club-booyer-moore-string-search-algorithm)
> 这个主题已经有教程 [here](https://www.raywenderlich.com/163964/swift-algorithm-club-booyer-moore-string-search-algorithm)

Goal: Write a string search algorithm in pure Swift without importing Foundation or using `NSString`'s `rangeOfString()` method.
目标：在纯Swift中编写字符串搜索算法，而无需导入Foundation或使用`NSString`的`rangeOfString()`方法。

In other words, we want to implement an `indexOf(pattern: String)` extension on `String` that returns the `String.Index` of the first occurrence of the search pattern, or `nil` if the pattern could not be found inside the string.
换句话说，我们想在`String`上实现一个`indexOf(pattern：String)`扩展，它返回在字符串里面第一次出现搜索模式的`String.Index`，如果找不到模式则返回`nil` 。

For example:
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

> **Note:** The index of the cow is 6, not 3 as you might expect, because the string uses more storage per character for emoji. The actual value of the `String.Index` is not so important, just that it points at the right character in the string.
> **注意：** 牛的索引是6，而不是你想象的3，因为字符串为表情符号使用每个字符更多的存储空间。`String.Index`的实际值并不那么重要，只是它指向字符串中的正确字符。

The [brute-force approach](../Brute-Force%20String%20Search/) works OK, but it's not very efficient, especially on large chunks of text. As it turns out, you don't need to look at _every_ character from the source string -- you can often skip ahead multiple characters.
[暴力方法](../Brute-Force％20String％20Search/)工作正常，但效率不高，尤其是在大块文本上。 事实证明，您不需要从源字符串中查看 _every_ 字符 -- 您通常可以跳过多个字符。

The skip-ahead algorithm is called [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer–Moore_string_search_algorithm) and it has been around for a long time. It is considered the benchmark for all string search algorithms.
跳过算法被称为[Boyer-Moore](https://en.wikipedia.org/wiki/Boyer-Moore_string_search_algorithm)，它已存在很长时间了。它被认为是所有字符串搜索算法的基准。

Here's how you could write it in Swift:
以下是您在Swift中编写它的方法：

```swift
extension String {
    func index(of pattern: String) -> Index? {
        // Cache the length of the search pattern because we're going to
        // use it a few times and it's expensive to calculate.
        let patternLength = pattern.characters.count
        guard patternLength > 0, patternLength <= characters.count else { return nil }

        // Make the skip table. This table determines how far we skip ahead
        // when a character from the pattern is found.
        var skipTable = [Character: Int]()
        for (i, c) in pattern.characters.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

        // This points at the last character in the pattern.
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]

        // The pattern is scanned right-to-left, so skip ahead in the string by
        // the length of the pattern. (Minus 1 because startIndex already points
        // at the first character in the source string.)
        var i = index(startIndex, offsetBy: patternLength - 1)

        // This is a helper function that steps backwards through both strings
        // until we find a character that doesn’t match, or until we’ve reached
        // the beginning of the pattern.
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

        // The main loop. Keep going until the end of the string is reached.
        while i < endIndex {
            let c = self[i]

            // Does the current character match the last character from the pattern?
            if c == lastChar {

                // There is a possible match. Do a brute-force search backwards.
                if let k = backwards() { return k }

                // If no match, we can only safely skip one character ahead.
                i = index(after: i)
            } else {
                // The characters are not equal, so skip ahead. The amount to skip is
                // determined by the skip table. If the character is not present in the
                // pattern, we can skip ahead by the full pattern length. However, if
                // the character *is* present in the pattern, there may be a match up
                // ahead and we can't skip as far.
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

The algorithm works as follows. You line up the search pattern with the source string and see what character from the string matches the _last_ character of the search pattern:
该算法的工作原理如下。 您使用源字符串排列搜索模式，并查看字符串中的哪个字符与搜索模式的 _last_ 字符匹配：

```
source string:  Hello, World
search pattern: World
                    ^
```

There are three possibilities:

1. The two characters are equal. You've found a possible match.

2. The characters are not equal, but the source character does appear in the search pattern elsewhere.

3. The source character does not appear in the search pattern at all.
有三种可能性：

这两个字是相同的。 你找到了可能的匹配。

2.字符不相等，但源字符确实出现在其他地方的搜索模式中。

3.源角色根本不会出现在搜索模式中。

In the example, the characters `o` and `d` do not match, but `o` does appear in the search pattern. That means we can skip ahead several positions:
在示例中，字符`o`和`d`不匹配，但`o`确实出现在搜索模式中。 这意味着我们可以跳过几个位置：

```
source string:  Hello, World
search pattern:    World
                       ^
```

Note how the two `o` characters line up now. Again you compare the last character of the search pattern with the search text: `W` vs `d`. These are not equal but the `W` does appear in the pattern. So skip ahead again to line up those two `W` characters:
注意两个`o`字符现在是如何对齐的。 再次，您将搜索模式的最后一个字符与搜索文本进行比较：`W` vs`d`。 这些不相等，但`W`确实出现在模式中。 因此，再次跳过以排列这两个`W`字符：

```
source string:  Hello, World
search pattern:        World
                           ^
```

This time the two characters are equal and there is a possible match. To verify the match you do a brute-force search, but backwards, from the end of the search pattern to the beginning. And that's all there is to it.
这次两个字符相等并且可能匹配。 要验证匹配，您需要进行强力搜索，但是从搜索模式的末尾开始向后搜索。 这就是它的全部。

The amount to skip ahead at any given time is determined by the "skip table", which is a dictionary of all the characters in the search pattern and the amount to skip by. The skip table in the example looks like:
在任何给定时间跳过的数量由“跳过表”确定，“跳过表”是搜索模式中所有字符的字典和跳过的数量。 示例中的跳过表如下所示：

```
W: 4
o: 3
r: 2
l: 1
d: 0
```

The closer a character is to the end of the pattern, the smaller the skip amount. If a character appears more than once in the pattern, the one nearest to the end of the pattern determines the skip value for that character.
字符越接近模式的末尾，跳过量越小。 如果某个字符在模式中出现多次，则最接近该模式结尾的字符将确定该字符的跳过值。

> **Note:** If the search pattern consists of only a few characters, it's faster to do a brute-force search. There's a trade-off between the time it takes to build the skip table and doing brute-force for short patterns.
> **注意：** 如果搜索模式只包含几个字符，则执行强力搜索会更快。 在构建跳过表和为短模式执行暴力之间需要进行权衡。

Credits: This code is based on the article ["Faster String Searches" by Costas Menico](http://www.drdobbs.com/database/faster-string-searches/184408171) from Dr Dobb's magazine, July 1989 -- Yes, 1989! Sometimes it's useful to keep those old magazines around.
致谢：此代码基于1989年7月Dobb博士杂志撰写的文章[["Faster String Searches" by Costas Menico](http://www.drdobbs.com/database/faster-string-searches/184408171)  -- 对 ，1989年！ 有时保留那些旧杂志是有用的。

See also: [a detailed analysis](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm) of the algorithm.
扩展阅读：[a detailed analysis](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm)

## Boyer-Moore-Horspool algorithm
## Boyer-Moore-Horspool 算法

A variation on the above algorithm is the [Boyer-Moore-Horspool algorithm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm).
上面算法的一个变体是[Boyer-Moore-Horspool algorithm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm)。

Like the regular Boyer-Moore algorithm, it uses the `skipTable` to skip ahead a number of characters. The difference is in how we check partial matches. In the above version, if a partial match is found but it's not a complete match, we skip ahead by just one character. In this revised version, we also use the skip table in that situation.
像常规的Boyer-Moore算法一样，它使用`skipTable`来跳过许多字符。 不同之处在于我们如何检查部分匹配。在上面的版本中，如果找到了部分匹配，但它不是完全匹配，我们只跳过一个字符。在这个修订版本中，我们也在那种情况下使用跳过表。

Here's an implementation of the Boyer-Moore-Horspool algorithm:
这是Boyer-Moore-Horspool算法的一个实现：

```swift
extension String {
    func index(of pattern: String) -> Index? {
        // Cache the length of the search pattern because we're going to
        // use it a few times and it's expensive to calculate.
        let patternLength = pattern.characters.count
        guard patternLength > 0, patternLength <= characters.count else { return nil }

        // Make the skip table. This table determines how far we skip ahead
        // when a character from the pattern is found.
        var skipTable = [Character: Int]()
        for (i, c) in pattern.characters.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

        // This points at the last character in the pattern.
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]

        // The pattern is scanned right-to-left, so skip ahead in the string by
        // the length of the pattern. (Minus 1 because startIndex already points
        // at the first character in the source string.)
        var i = index(startIndex, offsetBy: patternLength - 1)

        // This is a helper function that steps backwards through both strings
        // until we find a character that doesn’t match, or until we’ve reached
        // the beginning of the pattern.
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

        // The main loop. Keep going until the end of the string is reached.
        while i < endIndex {
            let c = self[i]

            // Does the current character match the last character from the pattern?
            if c == lastChar {

                // There is a possible match. Do a brute-force search backwards.
                if let k = backwards() { return k }

                // Ensure to jump at least one character (this is needed because the first
                // character is in the skipTable, and `skipTable[lastChar] = 0`)
                let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
            } else {
                // The characters are not equal, so skip ahead. The amount to skip is
                // determined by the skip table. If the character is not present in the
                // pattern, we can skip ahead by the full pattern length. However, if
                // the character *is* present in the pattern, there may be a match up
                // ahead and we can't skip as far.
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

In practice, the Horspool version of the algorithm tends to perform a little better than the original. However, it depends on the tradeoffs you're willing to make.
在实践中，Horspool版本的算法往往比原始版本略好一些。 但是，这取决于你愿意做出的权衡。

Credits: This code is based on the paper: [R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)
致谢：此代码基于论文：[R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)

_Written for Swift Algorithm Club by Matthijs Hollemans, updated by Andreas Neusüß_, [Matías Mazzei](https://github.com/mmazzei).
*作者：Matthijs Hollemans，Andreas Neusüß，[Matías Mazzei](https://github.com/mmazzei)*  
*译者：[Andy Ron](https://github.com/andyRon)*

