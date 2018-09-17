# Z-Algorithm String Search
# Z-算法字符串搜索

Goal: Write a simple linear-time string matching algorithm in Swift that returns the indexes of all the occurrencies of a given pattern. 
目标：在Swift中编写一个简单的线性时间字符串匹配算法，返回给定模式的所有副本的索引。

In other words, we want to implement an `indexesOf(pattern: String)` extension on `String` that returns an array `[Int]` of integers, representing all occurrences' indexes of the search pattern, or `nil` if the pattern could not be found inside the string.
换句话说，我们想在`String`上实现一个`indicesOf(pattern: String)`扩展，它返回一个整数的数组`[Int]`，表示搜索模式的所有出现的索引，如果是，则返回`nil` 在字符串中找不到模式。

For example:
例子：

```swift
let str = "Hello, playground!"
str.indexesOf(pattern: "ground")   // Output: [11]

let traffic = "🚗🚙🚌🚕🚑🚐🚗🚒🚚🚎🚛🚐🏎🚜🚗🏍🚒🚲🚕🚓🚌🚑"
traffic.indexesOf(pattern: "🚑") // Output: [4, 21]
```

Many string search algorithms use a pre-processing function to compute a table that will be used in successive stage. This table can save some time during the pattern search stage because it allows to avoid un-needed characters comparisons. The [Z-Algorithm]() is one of these functions. It borns as a pattern pre-processing function (this is its role in the [Knuth-Morris-Pratt algorithm](../Knuth-Morris-Pratt/) and others) but, just like we will show here, it can be used also as a single string search algorithm.
许多字符串搜索算法使用预处理函数来计算将在连续阶段中使用的表。 此表可以在模式搜索阶段节省一些时间，因为它允许避免不需要的字符比较。 [Z-Algorithm]()是这些功能之一。 它具有图案预处理功能（这是它在[Knuth-Morris-Pratt算法](../Knuth-Morris-Pratt/)等中的作用）但是，就像我们将在这里展示的那样，它可以是 也用作单字符串搜索算法。

### Z-Algorithm as pattern pre-processor
### Z-算法作为模式预处理器

As we said, the Z-Algorithm is foremost an algorithm that process a pattern in order to calculate a skip-comparisons-table.
The computation of the Z-Algorithm over a pattern `P` produces an array (called `Z` in the literature) of integers in which each element, call it `Z[i]`, represents the length of the longest substring of `P` that starts at `i` and matches a prefix of `P`. In simpler words, `Z[i]` records the longest prefix of `P[i...|P|]` that matches a prefix of `P`. As an example, let's consider `P = "ffgtrhghhffgtggfredg"`. We have that `Z[5] = 0 (f...h...)`, `Z[9] = 4 (ffgtr...ffgtg...)` and `Z[15] = 1 (ff...fr...)`.
在模式`P`上计算Z-算法会产生一个整数的数组（在文献中称为`Z`），其中每个元素称为`Z[i]`，表示最长子串的长度。 `P`从`i`开始并匹配前缀`P`。 简单来说，`Z[i]`记录匹配前缀为`P`的`P [i ... | P |]`的最长前缀。 举个例子，让我们考虑`P ="ffgtrhghhffgtggfredg"`。 我们有`Z[5] = 0(f ... h ...)`，`Z[9] = 4(ffgtr ... ffgtg ...)`和`Z[15] = 1(ff...... FR)`。

But how do we compute `Z`? Before we describe the algorithm we must indroduce the concept of Z-box. A Z-box is a pair `(left, right)` used during the computation that records the substring of maximal length that occurs also as a prefix of `P`. The two indices `left` and `right` represent, respectively, the left-end index and the right-end index of this substring. 
The definition of the Z-Algorithm is inductive and it computes the elements of the array for every position `k` in the pattern, starting from `k = 1`. The following values (`Z[k + 1]`, `Z[k + 2]`, ...) are computed after `Z[k]`. The idea behind the algorithm is that previously computed values can speed up the calculus of `Z[k + 1]`, avoiding some character comparisons that were already done before. Consider this example: suppose we are at iteration `k = 100`, so we are analyzing position `100` of the pattern. All the values between `Z[1]` and `Z[99]` were correctly computed and `left = 70` and `right = 120`. This means that there is a substring of length `51` starting at position `70` and ending at position `120` that matches the prefix of the pattern/string we are considering. Reasoning on it a little bit we can say that the substring of length `21` starting at position `100` matches the substring of length `21` starting at position `30` of the pattern (because we are inside a substring that matches a prefix of the pattern). So we can use `Z[30]` to compute `Z[100]` without additional character comparisons.
This a simple description of the idea that is behind this algorithm. There are a few cases to manage when the use of pre-computed values cannot be directly applied and some comparisons are to be made.
但是我们如何计算`Z`？在我们描述算法之前，我们必须产生Z-box的概念。 Z-box是在计算过程中使用的一对`(left, right)`，它记录了最大长度的子串，它也作为`P`的前缀出现。两个索引`left`和`right`分别表示该子字符串的左端索引和右端索引。
Z算法的定义是归纳的，它计算模式中每个位置“k”的数组元素，从`k = 1`开始。在Z [k]之后计算以下值（`Z[k + 1]`，`Z[k + 2]`，...）。该算法背后的想法是，先前计算的值可以加速`Z[k + 1]`的计算，避免了之前已经完成的一些字符比较。考虑这个例子：假设我们处于迭代`k = 100`，所以我们正在分析模式的位置`100`。 `Z[1]`和`Z[99]`之间的所有值都被正确计算，`left = 70`和`right = 120`。这意味着有一个长度为`51`的子字符串，从位置`70`开始，到“120”结尾，与我们正在考虑的模式/字符串的前缀相匹配。稍微推理一下，我们可以说从位置`100`开始的长度为`21`的子串与从模式的位置“30”开始的长度为`21`的子串相匹配（因为我们在匹配a的子串内)模式的前缀）。所以我们可以使用`Z[30]`来计算`Z[100]`而无需额外的字符比较。
这是对该算法背后的想法的简单描述。当无法直接应用预先计算的值的使用并且要进行一些比较时，有一些情况需要管理。

Here is the code of the function that computes the Z-array:
以下是计算Z数组的函数的代码：

```swift
func ZetaAlgorithm(ptrn: String) -> [Int]? {

    let pattern = Array(ptrn.characters)
    let patternLength: Int = pattern.count

    guard patternLength > 0 else {
        return nil
    }

    var zeta: [Int] = [Int](repeating: 0, count: patternLength)

    var left: Int = 0
    var right: Int = 0
    var k_1: Int = 0
    var betaLength: Int = 0
    var textIndex: Int = 0
    var patternIndex: Int = 0

    for k in 1 ..< patternLength {
        if k > right {  // Outside a Z-box: compare the characters until mismatch
            patternIndex = 0

            while k + patternIndex < patternLength  &&
                pattern[k + patternIndex] == pattern[patternIndex] {
                patternIndex = patternIndex + 1
            }

            zeta[k] = patternIndex

            if zeta[k] > 0 {
                left = k
                right = k + zeta[k] - 1
            }
        } else {  // Inside a Z-box
            k_1 = k - left + 1
            betaLength = right - k + 1

            if zeta[k_1 - 1] < betaLength { // Entirely inside a Z-box: we can use the values computed before
                zeta[k] = zeta[k_1 - 1]
            } else if zeta[k_1 - 1] >= betaLength { // Not entirely inside a Z-box: we must proceed with comparisons too
                textIndex = betaLength
                patternIndex = right + 1

                while patternIndex < patternLength && pattern[textIndex] == pattern[patternIndex] {
                    textIndex = textIndex + 1
                    patternIndex = patternIndex + 1
                }

                zeta[k] = patternIndex - k
                left = k
                right = patternIndex - 1
            }
        }
    }
    return zeta
}
```

Let's make an example reasoning with the code above. Let's consider the string `P = “abababbb"`. The algorithm begins with `k = 1`, `left = right = 0`. So, no Z-box is "active" and thus, because `k > right` we start with the character comparisons beetwen `P[1]` and `P[0]`.
让我们用上面的代码作一个例子推理。 让我们考虑字符串`P ="abababbb"`。算法以`k = 1`，`left = right = 0`开头。所以，没有Z-box是“活跃的”因此，因为`k > right`我们 从字符比较 `P[1]`和`P[0]`开始。
  
    
       01234567
    k:  x
       abababbb
       x
    Z: 00000000
    left:  0
    right: 0

We have a mismatch at the first comparison and so the substring starting at `P[1]` does not match a prefix of `P`. So, we put `Z[1] = 0` and let `left` and `right` untouched. We begin another iteration with `k = 2`, we have `2 > 0` and again we start comparing characters `P[2]` with `P[0]`. This time the characters match and so we continue the comparisons until a mismatch occurs. It happens at position `6`. The characters matched are `4`, so we put `Z[2] = 4` and set `left = k = 2` and `right = k + Z[k] - 1 = 5`. We have our first Z-box that is the substring `"abab"` (notice that it matches a prefix of `P`) starting at position `left = 2`.
我们在第一次比较时有不匹配，所以从`P [1]`开始的子串与`P`的前缀不匹配。 所以，我们把`Z [1] = 0`并让'left`和`right`保持不变。 我们用`k = 2`开始另一次迭代，我们有`2> 0`并且我们再次开始将字符`P [2]'与`P [0]`进行比较。 这次字符匹配，因此我们继续比较直到发生不匹配。 它发生在位置“6”。 匹配的字符是`4`，所以我们把'Z[2] = 4`并设置`left = k = 2`和`right = k + Z [k] - 1 = 5`。 我们有第一个Z-box，它是子串`"abab"`（注意它匹配`P`的前缀），从位置'left = 2`开始。

       01234567
    k:   x
       abababbb
       x
    Z: 00400000
    left:  2
    right: 5

We then proceed with `k = 3`. We have `3 <= 5`. We are inside the Z-box previously found and inside a prefix of `P`. So we can look for a position that has a previously computed value. We calculate `k_1 = k - left = 1` that is the index of the prefix's character equal to `P[k]`. We check `Z[1] = 0` and `0 < (right - k + 1 = 3)` and we find that we are exactly inside the Z-box. We can use the previously computed value, so we put `Z[3] = Z[1] = 0`, `left` and `right` remain unchanged.
At iteration `k = 4` we initially execute the `else` branch of the outer `if`. Then in the inner `if` we have that `k_1 = 2` and `(Z[2] = 4) >= 5 - 4 + 1`. So, the substring `P[k...r]` matches for `right - k + 1 = 2` chars the prefix of `P` but it could not for the following characters. We must then compare the characters starting at `r + 1 = 6` with those starting at `right - k + 1 = 2`. We have `P[6] != P[2]` and so we have to set `Z[k] = 6 - 4 = 2`, `left = 4` and `right = 5`.
然后我们继续`k = 3`。 我们有`3 <= 5`。 我们在之前找到的Z-box里面，在`P`的前缀里面。 因此，我们可以查找具有先前计算值的位置。 我们计算`k_1 = k - left = 1`，它是前缀字符的索引，等于`P[k]`。 我们检查`Z [1] = 0`和`0 <（right - k + 1 = 3）`我们发现我们正好在Z-box内。 我们可以使用先前计算的值，因此我们将`Z [3] = Z [1] = 0`，`left`和`right`保持不变。
在迭代`k = 4`时，我们最初执行外部`if`的`else`分支。 然后在内部`if`中我们有`k_1 = 2`和`（Z [2] = 4）> = 5 - 4 + 1`。 因此，子串`P [k ... r]`匹配`right-k + 1 = 2`字符`P`的前缀，但它不能用于后面的字符。 然后我们必须将从`r + 1 = 6`开始的字符与从`right-k + 1 = 2`开始的字符进行比较。 我们有`P[6]！= P [2]`所以我们必须设置`Z[k] = 6 - 4 = 2`，`left = 4`和`right = 5`。


       01234567
    k:     x
       abababbb
       x
    Z: 00402000
    left:  4
    right: 5

With iteration `k = 5` we have `k <= right` and then `(Z[k_1] = 0) < (right - k + 1 = 1)` and so we set `z[k] = 0`. In iteration `6` and `7` we execute the first branch of the outer `if` but we only have mismatches, so the algorithms terminates returning the Z-array as `Z = [0, 0, 4, 0, 2, 0, 0, 0]`.
在迭代“k = 5”时，我们有`k <= right`然后`（Z [k_1] = 0）<（right - k + 1 = 1）`所以我们设置`z [k] = 0`。 在迭代`6`和`7`中，我们执行外部`if`的第一个分支，但我们只有不匹配，所以算法终止返回Z数组为`Z = [0,0,4,0,2， 0,0,0]`。

The Z-Algorithm runs in linear time. More specifically, the Z-Algorithm for a string `P` of size `n` has a running time of `O(n)`.
Z算法以线性时间运行。 更具体地说，对于大小为`n`的字符串`P`的Z算法具有“O(n)”的运行时间。

The implementation of Z-Algorithm as string pre-processor is contained in the [ZAlgorithm.swift](./ZAlgorithm.swift) file.
Z-Algorithm作为字符串预处理器的实现包含在[ZAlgorithm.swift](./ZAlgorithm.swift)文件中。

### Z-Algorithm as string search algorithm 
### Z-算法作为字符串搜索算法

The Z-Algorithm discussed above leads to the simplest linear-time string matching algorithm. To obtain it, we have to simply concatenate the pattern `P` and text `T` in a string `S = P$T` where `$` is a character that does not appear neither in `P` nor `T`. Then we run the algorithm on `S` obtaining the Z-array. All we have to do now is scan the Z-array looking for elements equal to `n` (which is the pattern length). When we find such value we can report an occurrence.
上面讨论的Z算法导致最简单的线性时间串匹配算法。 为了获得它，我们必须简单地在一个字符串`S = P $ T`中连接模式`P`和文本`T`，其中`$`是一个既不出现在'P`也不出现'T`的字符。 然后我们在`S`上运行算法获得Z阵列。 我们现在要做的就是扫描Z阵列，寻找等于“n”的元素（即模式长度）。 当我们找到这样的值时，我们可以报告一个事件。

```swift
extension String {

    func indexesOf(pattern: String) -> [Int]? {
        let patternLength: Int = pattern.characters.count
        /* Let's calculate the Z-Algorithm on the concatenation of pattern and text */
        let zeta = ZetaAlgorithm(ptrn: pattern + "💲" + self)

        guard zeta != nil else {
            return nil
        }

        var indexes: [Int] = [Int]()

        /* Scan the zeta array to find matched patterns */
        for i in 0 ..< zeta!.count {
            if zeta![i] == patternLength {
                indexes.append(i - patternLength - 1)
            }
        }

        guard !indexes.isEmpty else {
            return nil
        }

        return indexes
    }
}
```

Let's make an example. Let `P = “CATA“` and `T = "GAGAACATACATGACCAT"` be the pattern and the text. Let's concatenate them with the character `$`. We have the string `S = "CATA$GAGAACATACATGACCAT"`. After computing the Z-Algorithm on `S` we obtain:
我们举个例子吧。 设`P =“CATA”` 和`T =“GAGAACATACATGACCAT”` 是模式和文本。 让我们将它们与字符`$`连接起来。 我们有字符串`S =“CATA $ GAGAACATACATGACCAT”`。 在迭代`S`上计算Z算法后，我们得到：

                1         2
      01234567890123456789012
      CATA$GAGAACATACATGACCAT
    Z 00000000004000300001300
                ^

We scan the Z-array and at position `10` we find `Z[10] = 4 = n`. So we can report a match occuring at text position `10 - n - 1 = 5`.

As said before, the complexity of this algorithm is linear. Defining `n` and `m` as pattern and text lengths, the final complexity we obtain is `O(n + m + 1) = O(n + m)`.
我们扫描Z阵列，在位置“10”，我们发现`Z[10] = 4 = n`。 所以我们可以报告在文本位置`10 - n - 1 = 5`发生的匹配。

如前所述，该算法的复杂性是线性的。 将`n`和`m`定义为模式和文本长度，我们得到的最终复杂度是“O（n + m + 1）= O（n + m）”。


Credits: This code is based on the handbook ["Algorithm on String, Trees and Sequences: Computer Science and Computational Biology"](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) by Dan Gusfield, Cambridge University Press, 1997. 
致谢：此代码基于手册[“字符串，树和序列算法：计算机科学和计算生物学”]（https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y ）Dan Gusfield，剑桥大学出版社，1997年。

*Written for Swift Algorithm Club by Matteo Dunnhofer*
*作者：Matteo Dunnhofer*  
*翻译：[Andy Ron](https://github.com/andyRon)*
