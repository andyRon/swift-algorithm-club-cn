# Knuth-Morris-Pratt String Search
# Knuth-Morris-Pratt(KMP)算法

Goal: Write a linear-time string matching algorithm in Swift that returns the indexes of all the occurrencies of a given pattern.
目标：在Swift中编写线性时间字符串匹配算法，返回给定模式的所有出现的索引。

In other words, we want to implement an `indexesOf(pattern: String)` extension on `String` that returns an array `[Int]` of integers, representing all occurrences' indexes of the search pattern, or `nil` if the pattern could not be found inside the string.
换句话说，我们想在`String`上实现了`indicesOf(pattern:String)`方法，它返回一个整数的数组`[Int]`，表示搜索模式的所有出现的索引，如果在字符串中找不到模式，则返回`nil` 。

For example:
例如：

```swift
let dna = "ACCCGGTTTTAAAGAACCACCATAAGATATAGACAGATATAGGACAGATATAGAGACAAAACCCCATACCCCAATATTTTTTTGGGGAGAAAAACACCACAGATAGATACACAGACTACACGAGATACGACATACAGCAGCATAACGACAACAGCAGATAGACGATCATAACAGCAATCAGACCGAGCGCAGCAGCTTTTAAGCACCAGCCCCACAAAAAACGACAATFATCATCATATACAGACGACGACACGACATATCACACGACAGCATA"
dna.indexesOf(ptnr: "CATA")   // Output: [20, 64, 130, 140, 166, 234, 255, 270]

let concert = "🎼🎹🎹🎸🎸🎻🎻🎷🎺🎤👏👏👏"
concert.indexesOf(ptnr: "🎻🎷")   // Output: [6]
```

The [Knuth-Morris-Pratt algorithm](https://en.wikipedia.org/wiki/Knuth–Morris–Pratt_algorithm) is considered one of the best algorithms for solving the pattern matching problem. Although in practice [Boyer-Moore](../Boyer-Moore/) is usually preferred, the algorithm that we will introduce is simpler, and has the same (linear) running time.
[KMP算法](https://en.wikipedia.org/wiki/Knuth-Morris-Pratt_algorithm)被认为是解决模式匹配问题的最佳算法之一。 虽然在实践中[Boyer-Moore算法](../Boyer-Moore-Horspool/)通常是首选，但KMP算法更简单，并且具有相同的（线性）运行时间。

The idea behind the algorithm is not too different from the [naive string search](../Brute-Force%20String%20Search/) procedure. As it, Knuth-Morris-Pratt aligns the text with the pattern and goes with character comparisons from left to right. But, instead of making a shift of one character when a mismatch occurs, it uses a more intelligent way to move the pattern along the text. In fact, the algorithm features a pattern pre-processing stage where it acquires all the informations that will make the algorithm skip redundant comparisons, resulting in larger shifts.
该算法背后的想法与[暴力字符串搜索](../Brute-Force％20String％20Search/)程序没有太大区别。 因此，KMP算法将文本与模式对齐，并从左到右进行字符比较。 但是，当发生不匹配时，不是使一个字符移位，而是使用更智能的方式沿着文本移动模式。 实际上，该算法具有模式预处理阶段，其中它获取将使算法跳过冗余比较的所有信息，从而导致更大的移位。

The pre-processing stage produces an array (called `suffixPrefix` in the code) of integers in which every element `suffixPrefix[i]` records the length of the longest proper suffix of `P[0...i]` (where `P` is the pattern) that matches a prefix of `P`. In other words, `suffixPrefix[i]` is the longest proper substring of `P` that ends at position `i` and that is a prefix of `P`. Just a quick example. Consider `P = "abadfryaabsabadffg"`, then `suffixPrefix[4] = 0`, `suffixPrefix[9] = 2`, `suffixPrefix[14] = 4`.
预处理阶段产生一个整数的数组（在代码中称为`suffixPrefix`），其中每个元素`suffixPrefix[i]`记录最长的正确后缀`P[0 ... i]`的长度（其中 `P`是模式）匹配前缀`P`。 换句话说，`suffixPrefix[i]`是`P`的最长的正确子串，它在位置`i`结束并且是`P`的前缀。 只是一个简单的例子。 考虑`P = "abadfryaabsabadffg"`，然后`suffixPrefix[4] = 0`，`suffixPrefix 9] = 2`，`suffixPrefix[14] = 4`。

There are different ways to obtain the values of `SuffixPrefix` array. We will use the method based on the [Z-Algorithm](../Z-Algorithm/). This function takes in input the pattern and produces an array of integers. Each element represents the length of the longest substring starting at position `i` of `P` and that matches a prefix of `P`. You can notice that the two arrays are similar, they record the same informations but on the different places. We only have to find a method to map `Z[i]` to `suffixPrefix[j]`. It is not that difficult and this is the code that will do for us:
有不同的方法来获取`SuffixPrefix`数组的值。 我们将使用基于[Z-Algorithm](../Z-Algorithm/)的方法。 此函数接受输入模式并生成整数数组。 每个元素表示从`P`的位置`i`开始并且与`P`的前缀匹配的最长子串的长度。 你可以注意到两个数组是相似的，它们记录相同的信息，但是在不同的地方。 我们只需找到一种方法将`Z[i]`映射到`suffixPrefix[j]`。 这并不困难，这是为我们做的代码：

```swift
for patternIndex in (1 ..< patternLength).reversed() {
    textIndex = patternIndex + zeta![patternIndex] - 1
    suffixPrefix[textIndex] = zeta![patternIndex]
}
```

We are simply computing the index of the end of the substring starting at position `i` (as we know matches a prefix of `P`). The element of `suffixPrefix` at that index then it will be set with the length of the substring.
我们只是简单地计算从位置`i`开始的子串结束的索引（因为我们知道匹配`P`的前缀）。 在该索引处的`suffixPrefix`元素然后将使用子字符串的长度进行设置。

Once the shift-array `suffixPrefix` is ready we can begin with pattern search stage. The algorithm first attempts to compare the characters of the text with those of the pattern. If it succeeds, it goes on until a mismatch occurs. When it happens, it checks if an occurrence of the pattern is present (and reports it). Otherwise, if no comparisons are made then the text cursor is moved forward, else the pattern is shifted to the right. The shift's amount is based on the `suffixPrefix` array, and it guarantees that the prefix `P[0...suffixPrefix[i]]` will match its opposing substring in the text. In this way, shifts of more than one character are often made and lot of comparisons can be avoided, saving a lot of time.
一旦移位数组`suffixPrefix`准备就绪，我们就可以从模式搜索阶段开始。 该算法首先尝试将文本的字符与模式的字符进行比较。 如果成功，它会一直持续到发生不匹配为止。 当它发生时，它会检查是否存在模式（并报告）。 否则，如果没有进行比较，则文本光标向前移动，否则图案向右移动。 shift的数量基于`suffixPrefix`数组，它保证前缀`P[0 ... suffixPrefix[i]]`将匹配文本中相反的子字符串。 通过这种方式，通常可以进行多个字符的移位，并且可以避免大量的比较，从而节省大量时间。

Here is the code of the Knuth-Morris-Pratt algorithm:
KMP算法代码：

```swift
extension String {

    func indexesOf(ptnr: String) -> [Int]? {

        let text = Array(self.characters)
        let pattern = Array(ptnr.characters)

        let textLength: Int = text.count
        let patternLength: Int = pattern.count

        guard patternLength > 0 else {
            return nil
        }

        var suffixPrefix: [Int] = [Int](repeating: 0, count: patternLength)
        var textIndex: Int = 0
        var patternIndex: Int = 0
        var indexes: [Int] = [Int]()

        /* Pre-processing stage: computing the table for the shifts (through Z-Algorithm) */
        let zeta = ZetaAlgorithm(ptnr: ptnr)

        for patternIndex in (1 ..< patternLength).reversed() {
            textIndex = patternIndex + zeta![patternIndex] - 1
            suffixPrefix[textIndex] = zeta![patternIndex]
        }

        /* Search stage: scanning the text for pattern matching */
        textIndex = 0
        patternIndex = 0

        while textIndex + (patternLength - patternIndex - 1) < textLength {

            while patternIndex < patternLength && text[textIndex] == pattern[patternIndex] {
                textIndex = textIndex + 1
                patternIndex = patternIndex + 1
            }

            if patternIndex == patternLength {
                indexes.append(textIndex - patternIndex)
            }

            if patternIndex == 0 {
                textIndex = textIndex + 1
            } else {
                patternIndex = suffixPrefix[patternIndex - 1]
            }
        }

        guard !indexes.isEmpty else {
            return nil
        }
        return indexes
    }
}
```

Let's make an example reasoning with the code above. Let's consider the string `P = ACTGACTA"`, the consequentially obtained `suffixPrefix` array equal to `[0, 0, 0, 0, 0, 0, 3, 1]`, and the text `T = "GCACTGACTGACTGACTAG"`. The algorithm begins with the text and the pattern aligned like below. We have to compare `T[0]` with `P[0]`.  
让我们用上面的代码作一个例子推理。 让我们考虑字符串`P = ACTGACTA"`，结果获得的`suffixPrefix`数组等于`[0,0,0,0,0,0,1,1]`，文本`T ="GCACTGACTGACTGACTAG"` 算法从文本和模式开始，如下所示。我们必须比较`T[0]`和`P[0]`。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:      ^
    pattern:        ACTGACTA
    patternIndex:   ^
                    x
    suffixPrefix:   00000031

We have a mismatch and we move on comparing `T[1]` and `P[0]`. We have to check if a pattern occurrence is present but there is not. So, we have to shift the pattern right and by doing so we have to check `suffixPrefix[1 - 1]`. Its value is `0` and we restart by comparing `T[1]` with `P[0]`. Again a mismath occurs, so we go on with `T[2]` and `P[0]`.
我们有一个不匹配，我们继续比较`T[1]`和`P[0]`。 我们必须检查模式是否存在但是没有。 所以，我们必须正确地改变模式，所以我们必须检查`suffixPrefix[1 - 1]`。 它的值为`0`，我们通过将`T[1]`与`P[0]`进行比较来重新启动。 再次出现一个错误，所以我们继续使用`T[2]`和`P[0]`。

                              1      
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:        ^
    pattern:          ACTGACTA
    patternIndex:     ^
    suffixPrefix:     00000031

This time we have a match. And it continues until position `8`. Unfortunately the length of the match is not equal to the pattern length, we cannot report an occurrence. But we are still lucky because we can use the values computed in the `suffixPrefix` array now. In fact, the length of the match is `7`, and if we look at the element `suffixPrefix[7 - 1]` we discover that is `3`. This information tell us that that the prefix of `P` matches the suffix of the susbtring `T[0...8]`. So the `suffixPrefix` array guarantees us that the two substring match and that we do not have to compare their characters, so we can shift right the pattern for more than one character!
The comparisons restart from `T[9]` and `P[3]`.  
这次我们有一个匹配。 它一直持续到位置`8`。 不幸的是，匹配的长度不等于模式长度，我们无法报告发生的事件。 但我们仍然很幸运，因为我们现在可以使用`suffixPrefix`数组中计算的值。 实际上，匹配的长度是`7`，如果我们看一下元素`suffixPrefix[7 - 1]`，我们发现它是`3`。 这个信息告诉我们`P`的前缀匹配susbtring`T [0 ... 8]`的后缀。 所以`suffixPrefix`数组保证我们两个子字符串匹配，并且我们不必比较它们的字符，所以我们可以将模式向右移动多个字符！

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:               ^
    pattern:              ACTGACTA
    patternIndex:            ^
    suffixPrefix:         00000031

They match so we continue the compares until position `13` where a misatch occurs beetwen charcter `G` and `A`. Just like before, we are lucky and we can use the `suffixPrefix` array to shift right the pattern.
它们匹配，所以我们继续比较，直到位置`13`，其中发生了一个错误，发生在字母`G`和`A`之间。 就像以前一样，我们很幸运，我们可以使用`suffixPrefix`数组向右移动模式。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:                   ^
    pattern:                  ACTGACTA
    patternIndex:                ^
    suffixPrefix:             00000031

Again, we have to compare. But this time the comparisons finally take us to an occurrence, at position `17 - 7 = 10`.
再次，我们必须比较。 但这次比较最终将我们发生在位置`17 - 7 = 10`。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:                       ^
    pattern:                  ACTGACTA
    patternIndex:                    ^
    suffixPrefix:             00000031

The algorithm than tries to compare `T[18]` with `P[1]` (because we used the element `suffixPrefix[8 - 1] = 1`) but it fails and at the next iteration it ends its work.
该算法比试图比较`T[18]`和`P[1]`（因为我们使用元素`suffixPrefix [8 - 1] = 1`）但它失败了，在下一次迭代它结束了它的工作。


The pre-processing stage involves only the pattern. The running time of the Z-Algorithm is linear and takes `O(n)`, where `n` is the length of the pattern `P`. After that, the search stage does not "overshoot" the length of the text `T` (call it `m`). It can be be proved that number of comparisons of the search stage is bounded by `2 * m`. The final running time of the Knuth-Morris-Pratt algorithm is `O(n + m)`.
预处理阶段仅涉及模式。 Z算法的运行时间是线性的，取`O(n)`，其中`n`是模式`P`的长度。 之后，搜索阶段不会“超过”文本`T`的长度（称之为`m`）。 可以证明，搜索阶段的比较数量以`2 * m`为界。 KMP算法的最终运行时间是`O(n + m)`。


> **Note:** To execute the code in the [KnuthMorrisPratt.swift](./KnuthMorrisPratt.swift) you have to copy the [ZAlgorithm.swift](../Z-Algorithm/ZAlgorithm.swift) file contained in the [Z-Algorithm](../Z-Algorithm/) folder. The [KnuthMorrisPratt.playground](./KnuthMorrisPratt.playground) already includes the definition of the `Zeta` function.
> **注意：** 要执行[KnuthMorrisPratt.swift](./KnuthMorrisPratt.swift)中的代码，您必须复制[ZAlgorithm.swift](../Z-Algorithm/ZAlgorithm.swift)文件中包含的 [Z-Algorithm](../Z-Algorithm/)文件夹。 [KnuthMorrisPratt.playground](./KnuthMorrisPratt.playground)已经包含了`Zeta`函数的定义。

Credits: This code is based on the handbook ["Algorithm on String, Trees and Sequences: Computer Science and Computational Biology"](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) by Dan Gusfield, Cambridge University Press, 1997.
致谢：此代码基于手册[“字符串，树和序列算法：计算机科学和计算生物学”](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) Dan Gusfield，剑桥大学出版社，1997年。

*Written for Swift Algorithm Club by Matteo Dunnhofer*

*作者：Matteo Dunnhofer*   
*翻译：[Andy Ron](https://github.com/andyRon)*
