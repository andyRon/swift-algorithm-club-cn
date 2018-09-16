# Longest Common Subsequence
# 最长公共子序列

The Longest Common Subsequence (LCS) of two strings is the longest sequence of characters that appear in the same order in both strings.
两个字符串的最长公共子序列（LCS）是在两个字符串中以相同顺序出现的最长字符序列。

For example the LCS of `"Hello World"` and `"Bonjour le monde"` is `"oorld"`. If you go through both strings from left-to-right, you'll find that the characters `o`, `o`, `r`, `l`, `d` appear in both strings in that order.
例如，`"Hello World"` 和 `"Bonjour le monde"` 的LCS是`"oorld"`。 如果你从左到右遍历两个字符串，你会发现字符 `o`, `o`, `r`, `l`, `d`按顺序出现在两个字符串中。

Other possible subsequences are `"ed"` and `"old"`, but these are all shorter than `"oorld"`. 
其他可能的子序列是`"ed"`和`"old"`，但这些都比`"oorld"`更短。

> **Note:** This should not be confused with the Longest Common Substring problem, where the characters must form a substring of both strings, i.e they have to be immediate neighbors. With a subsequence, it's OK if the characters are not right next to each other, but they must be in the same order.
> **注意：** 这不应与最长公共子串问题混淆，其中字符必须形成两个字符串的子串，即它们必须是直接邻居。 如果字符不是彼此相邻，则可以使用子序列，但它们必须处于相同的顺序。

One way to find the LCS of two strings `a` and `b` is using dynamic programming and a backtracking strategy.
找到两个字符串`a`和`b`的LCS的一种方法是使用动态编程和回溯策略。

## Finding the length of the LCS with dynamic programming
## 通过动态编程查找LCS的长度

First, we want to find the length of the longest common subsequence between strings `a` and `b`. We're not looking for the actual subsequence yet, only how long it is.
首先，我们想要找到字符串`a`和`b`之间最长公共子序列的长度。 我们还没有找到实际的后续序列，只需要多长时间。

To determine the length of the LCS between all combinations of substrings of `a` and `b`, we can use a *dynamic programming* technique. Dynamic programming basically means that you compute all possibilities and store them inside a look-up table.
为了确定`a`和`b`的所有子串组合之间LCS的长度，我们可以使用*动态编程*技术。 动态编程基本上意味着您计算所有可能性并将它们存储在查找表中。

> **Note:** During the following explanation, `n` is the length of string `a`, and `m` is the length of string `b`.
> **注意：** 在下面的解释中，`n`是字符串`a`的长度，`m`是字符串`b`的长度。

To find the lengths of all possible subsequences, we use a helper function, `lcsLength(_:)`. This creates a matrix of size `(n+1)` by `(m+1)`, where `matrix[x][y]` is the length of the LCS between the substrings `a[0...x-1]` and `b[0...y-1]`.
为了找到所有可能子序列的长度，我们使用辅助函数`lcsLength(_:)`。 这创建了一个大小为`(n + 1)`by`(m + 1)`的矩阵，其中`matrix[x][y]`是子串之间的LCS长度`a[0 ... x- 1]`和`b [0 ... y-1]`。

Given strings `"ABCBX"` and `"ABDCAB"`, the output matrix of `lcsLength(_:)` is the following:
给定字符串`"ABCBX"`和`"ABDCAB"`，`lcsLength(_ :)`的输出矩阵如下：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | 3 | 3 | 3 |
| B | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
| X | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
```

In this example, if we look at `matrix[3][4]` we find the value `3`. This means the length of the LCS between `a[0...2]` and `b[0...3]`, or between `"ABC"` and `"ABDC"`, is 3. That is correct, because these two substrings have the subsequence `ABC` in common. (Note: the first row and column of the matrix are always filled with zeros.)
在这个例子中，如果我们看一下`matrix[3][4]`，我们找到值`3`。 这意味着`a [0 ... 2]`和`b[0 ... 3]`之间或`"ABC"`和`"ABDC"`之间的LCS长度为3.这是正确的 ，因为这两个子串具有共同的子序列`ABC`。 （注意：矩阵的第一行和第一列始终用零填充。）

Here is the source code for `lcsLength(_:)`; this lives in an extension on `String`:
这是`lcsLength(_ :)`的源代码。 它存在于`String`的扩展中：

```swift
func lcsLength(_ other: String) -> [[Int]] {

  var matrix = [[Int]](repeating: [Int](repeating: 0, count: other.characters.count+1), count: self.characters.count+1)

  for (i, selfChar) in self.characters.enumerated() {
	for (j, otherChar) in other.characters.enumerated() {
	  if otherChar == selfChar {
		// Common char found, add 1 to highest lcs found so far.
		matrix[i+1][j+1] = matrix[i][j] + 1
	  } else {
		// Not a match, propagates highest lcs length found so far.
		matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
	  }
	}
  }

  return matrix
}
```

First, this creates a new matrix -- really a 2-dimensional array -- and fills it with zeros. Then it loops through both strings, `self` and `other`, and compares their characters in order to fill in the matrix. If two characters match, we increment the length of the subsequence. However, if two characters are different, then we "propagate" the highest LCS length found so far.
首先，这会创建一个新的矩阵 - 实际上是一个二维数组 - 并用零填充它。 然后它循环遍历两个字符串，`self`和`other`，并比较它们的字符以填充矩阵。 如果两个字符匹配，我们增加子序列的长度。 但是，如果两个字符不同，那么我们“传播”到目前为止找到的最高LCS长度。

Let's say the following is the current situation:
让我们说以下是目前的情况：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | * |   |   |   |
| B | 0 |   |   |   |   |   |   |
| X | 0 |   |   |   |   |   |   |
```

The `*` marks the two characters we're currently comparing, `C` versus `D`. These characters are not the same, so we propagate the highest length we've seen so far, which is `2`:
`*`表示我们正在比较的两个字符，`C`与`D`。 这些字符不一样，所以我们传播到目前为止我们见过的最高长度，即`2`：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | * |   |   |
| B | 0 |   |   |   |   |   |   |
| X | 0 |   |   |   |   |   |   |
```

Now we compare `C` with `C`. These are equal, and we increment the length to `3`:
现在我们将`C`与`C`进行比较。 这些是相等的，我们将长度增加到`3`：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | 3 | * |   |
| B | 0 |   |   |   |   |   |   |
| X | 0 |   |   |   |   |   |   |
```

And so on... this is how `lcsLength(_:)` fills in the entire matrix.
。。。这就是`lcsLength(_ :)`填充整个矩阵的方式。

## Backtracking to find the actual subsequence
## 回溯找到实际的子序列

So far we've calculated the length of every possible subsequence. The length of the longest subsequence is found in the bottom-right corner of matrix, at `matrix[n+1][m+1]`. In the above example it is 4, so the LCS consists of 4 characters.
到目前为止，我们已经计算了每个可能的子序列的长度。 最长子序列的长度位于矩阵的右下角，在`matrix[n + 1][m + 1]`处。 在上面的示例中，它是4，因此LCS由4个字符组成。

Having the length of every combination of substrings makes it possible to determine *which* characters are part of the LCS itself by using a backtracking strategy.
具有子串的每个组合的长度使得可以通过使用回溯策略来确定*哪个*字符是LCS本身的一部分。

Backtracking starts at `matrix[n+1][m+1]` and walks up and left (in this priority) looking for changes that do not indicate a simple propagation.
回溯从`matrix[n + 1][m + 1]`开始，向上和向左（在此优先级中）寻找不表示简单传播的变化。

```
|   |  Ø|  A|  B|  D|  C|  A|  B|
| Ø |  0|  0|  0|  0|  0|  0|  0|
| A |  0|↖ 1|  1|  1|  1|  1|  1|  
| B |  0|  1|↖ 2|← 2|  2|  2|  2|
| C |  0|  1|  2|  2|↖ 3|← 3|  3|
| B |  0|  1|  2|  2|  3|  3|↖ 4|
| X |  0|  1|  2|  2|  3|  3|↑ 4|
```

Each `↖` move indicates a character (in row/column header) that is part of the LCS.
每个`↖`移动表示一个字符（在行/列标题中），它是LCS的一部分。

If the number on the left and above are different than the number in the current cell, no propagation happened. In that case `matrix[i][j]` indicates a common char between the strings `a` and `b`, so the characters at `a[i - 1]` and `b[j - 1]` are part of the LCS that we're looking for.
如果左侧和上方的数字与当前单元格中的数字不同，则不会发生传播。 在那种情况下`matrix[i][j]`表示字符串`a`和`b`之间的公共字符，所以`a[i - 1]`和`b[j - 1]`的字符是一部分 我们正在寻找的LCS。

One thing to notice is, as it's running backwards, the LCS is built in reverse order. Before returning, the result is reversed to reflect the actual LCS.
需要注意的一点是，当它向后运行时，LCS以相反的顺序构建。 在返回之前，结果反转以反映实际的LCS。

Here is the backtracking code:
这是回溯代码：

```swift
func backtrack(_ matrix: [[Int]]) -> String {
  var i = self.characters.count
  var j = other.characters.count
  
  var charInSequence = self.endIndex
  
  var lcs = String()
  
  while i >= 1 && j >= 1 {
	// Indicates propagation without change: no new char was added to lcs.
	if matrix[i][j] == matrix[i][j - 1] {
	  j -= 1
	}
	// Indicates propagation without change: no new char was added to lcs.
	else if matrix[i][j] == matrix[i - 1][j] {
	  i -= 1
	  charInSequence = self.index(before: charInSequence)
	}
	// Value on the left and above are different than current cell.
	// This means 1 was added to lcs length.
	else {
	  i -= 1
	  j -= 1
	  charInSequence = self.index(before: charInSequence)
	  lcs.append(self[charInSequence])
	}
  }
  
  return String(lcs.characters.reversed())
}
```  

This backtracks from `matrix[n+1][m+1]` (bottom-right corner) to `matrix[1][1]` (top-left corner), looking for characters that are common to both strings. It adds those characters to a new string, `lcs`.
这从`matrix[n + 1][m + 1]`（右下角）回溯到`matrix[1][1]`（左上角），寻找两个字符串共有的字符。 它将这些字符添加到一个新字符串`lcs`中。

The `charInSequence` variable is an index into the string given by `self`. Initially this points to the last character of the string. Each time we decrement `i`, we also move back `charInSequence`. When the two characters are found to be equal, we add the character at `self[charInSequence]` to the new `lcs` string. (We can't just write `self[i]` because `i` may not map to the current position inside the Swift string.)
`charInSequence`变量是`self`给出的字符串的索引。 最初，这指向字符串的最后一个字符。 每当我们减少`i`时，我们也会移回`charInSequence`。 当发现两个字符相等时，我们将`self[charInSequence]`中的字符添加到新的`lcs`字符串中。 （我们不能只写`self[i]`因为`i`可能不会映射到Swift字符串中的当前位置。）

Due to backtracking, characters are added in reverse order, so at the end of the function we call `reversed()` to put the string in the right order. (Appending new characters to the end of the string and then reversing it once is faster than always inserting the characters at the front of the string.)
由于回溯，字符以相反的顺序添加，因此在函数的末尾我们调用`reversed()`来将字符串按正确的顺序排列。 （将新字符附加到字符串的末尾，然后将其反转一次比始终在字符串前面插入字符要快。）

## Putting it all together
## 把它们放在一起

To find the LCS between two strings, we first call `lcsLength(_:)` and then `backtrack(_:)`:
要在两个字符串之间找到LCS，我们首先调用`lcsLength(_ :)`然后调用`backtrack(_ :)`：

```swift
extension String {
  public func longestCommonSubsequence(_ other: String) -> String {

    func lcsLength(_ other: String) -> [[Int]] {
      ...
    }
    
    func backtrack(_ matrix: [[Int]]) -> String {
      ...
    }

    return backtrack(lcsLength(other))
  }
}
```

To keep everything tidy, the two helper functions are nested inside the main `longestCommonSubsequence()` function.
为了保持一切整洁，两个辅助函数嵌套在主`longestCommonSubsequence()`函数中。

Here's how you could try it out in a Playground:
以下是您可以在Playground尝试的方法：

```swift
let a = "ABCBX"
let b = "ABDCAB"
a.longestCommonSubsequence(b)   // "ABCB"

let c = "KLMK"
a.longestCommonSubsequence(c)   // "" (no common subsequence)

"Hello World".longestCommonSubsequence("Bonjour le monde")   // "oorld"
```

*Written for Swift Algorithm Club by Pedro Vereza*
*作者：Pedro Vereza*  
*翻译：[Andy Ron](https://github.com/andyRon)*
