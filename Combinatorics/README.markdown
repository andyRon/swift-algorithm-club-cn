# Permutations
# 排列组合算法

A *permutation* is a certain arrangement of the objects from a collection. For example, if we have the first five letters from the alphabet, then this is a permutation:
*排列*是来自集合的对象的特定排列。 例如，如果我们有字母表中的前五个字母，那么这是一个排列：

	a, b, c, d, e

This is another permutation:
这是另一个排列：

	b, e, d, a, c

For a collection of `n` objects, there are `n!` possible permutations, where `!` is the "factorial" function. So for our collection of five letters, the total number of permutations you can make is:
对于`n`对象的集合，有`n!`可能的排列，其中`!`是“阶乘”函数。 因此，对于我们五个字母的集合，您可以进行的排列总数为：

	5! = 5 * 4 * 3 * 2 * 1 = 120

A collection of six items has `6! = 720` permutations. For ten items, it is `10! = 3,628,800`. That adds up quick!
六项的集合有`6! = 720`排列。 对于十项，有`10! = 3,628,800`。 这变化非常快！

Where does this `n!` come from? The logic is as follows: we have a collection of five letters that we want to put in some order. To do this, you need to pick up these letters one-by-one. Initially, you have the choice of five letters: `a, b, c, d, e`. That gives 5 possibilities.
这个`n!`来自哪里？ 逻辑如下：我们有一个五个字母的集合，我们想按顺序放置。 要做到这一点，你需要逐个拿起这些字母。 最初，您可以选择五个字母：`a, b, c, d, e`。 这提供了5种可能性。

After picking the first letter, you only have four letters left to choose from. That gives `5 * 4 = 20` possibilities:
选择第一个字母后，您只剩下四个字母可供选择。 这给了`5 * 4 = 20`的可能性：

	a+b    b+a    c+a    d+a    e+a
	a+c    b+c    c+b    d+b    e+b
	a+d    b+d    c+d    d+c    e+c
	a+e    b+e    c+e    d+e    e+d

After picking the second letter, there are only three letters left to choose from. And so on... When you get to the last letter, you don't have any choice because there is only one letter left. That's why the total number of possibilities is `5 * 4 * 3 * 2 * 1`.
选择第二个字母后，只剩下三个字母可供选择。 等等......当你到达最后一字母时，你没有任何选择，因为只留下一字母。 这就是为什么总的可能性是`5 * 4 * 3 * 2 * 1`。

To calculate the factorial in Swift:
在Swift中计算阶乘：

```swift
func factorial(_ n: Int) -> Int {
  var n = n
  var result = 1
  while n > 1 {
    result *= n
    n -= 1
  }
  return result
}
```

Try it out in a playground:

```swift
factorial(5)   // returns 120
```

Note that `factorial(20)` is the largest number you can calculate with this function, or you'll get integer overflow.
请注意，`factorial(20)`是您可以使用此函数计算的最大数字，否则您将获得整数溢出。

Let's say that from that collection of five letters you want to choose only 3 elements. How many possible ways can you do this? Well, that works the same way as before, except that you stop after the third letter. So now the number of possibilities is `5 * 4 * 3 = 60`.
让我们说从五个字母的集合中你只想选择3个元素。 你可以用多少种方法做到这一点？ 好吧，除了你在第三个字母之后停止之外，它的工作方式和以前一样。 所以现在可能的数量是`5 * 4 * 3 = 60`。

The formula for this is:
这个公式是：

	             n!
	P(n, k) = --------
	          (n - k)!

where `n` is the size of your collection and `k` is the size of the group that you're selecting. In our example, `P(5, 3) = 5! / (5 - 3)! = 120 / 2 = 60`.
其中`n`是你的集合的大小，`k`是你选择的组的大小。 在我们的例子中，`P(5, 3) = 5! / (5 - 3)! = 120 / 2 = 60`。

You could implement this in terms of the `factorial()` function from earlier, but there's a problem. Remember that `factorial(20)` is the largest possible number it can handle, so you could never calculate `P(21, 3)`, for example.
您可以根据之前的`factorial()`函数实现这一点，但是存在问题。 请记住，`factorial(20)`是它可以处理的最大可能数，所以你永远不能计算`P(21, 3)`。

Here is an algorithm that can deal with larger numbers:
这是一个可以处理更大数字的算法：

```swift
func permutations(_ n: Int, _ k: Int) -> Int {
  var n = n
  var answer = n
  for _ in 1..<k {
    n -= 1
    answer *= n
  }
  return answer
}
```

Try it out:

```swift
permutations(5, 3)   // returns 60
permutations(50, 6)  // returns 11441304000
permutations(9, 4)   // returns 3024
```

This function takes advantage of the following algebra fact:
此函数利用以下代数事实：

	          9 * 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1
	P(9, 4) = --------------------------------- = 9 * 8 * 7 * 6 = 3024
	                          5 * 4 * 3 * 2 * 1

The denominator cancels out part of the numerator, so there's no need to perform a division and you're not dealing with intermediate results that are potentially too large.
分母取消了分子的一部分，因此不需要执行除法，也不需要处理可能太大的中间结果。

However, there are still limits to what you can calculate; for example the number of groups of size 15 that you can make from a collection of 30 objects -- i.e. `P(30, 15)` -- is ginormous and breaks Swift. Huh, you wouldn't think it would be so large but combinatorics is funny that way.
但是，您可以计算的内容仍有限制; 例如，你可以从30个对象的集合中获得的大小为15的组的数量 - 即`P（30, 15）` - 是巨大的并且打破了Swift。 嗯，你不会认为它会如此之大，但组合学很有趣。

## Generating the permutations
## 生成排列

So far we've counted how many permutations exist for a given collection, but how can we actually create a list of all these permutations?
到目前为止，我们已经计算了给定集合存在多少排列，但我们如何才能真正创建所有这些排列的列表？

Here's a recursive algorithm by Niklaus Wirth:
这是Niklaus Wirth的递归算法：

```swift
func permuteWirth<T>(_ a: [T], _ n: Int) {
    if n == 0 {
        print(a)   // display the current permutation
    } else {
        var a = a
        permuteWirth(a, n - 1)
        for i in 0..<n {
            a.swapAt(i, n)
            permuteWirth(a, n - 1)
            a.swapAt(i, n)
        }
    }
}
```

Use it as follows:

```swift
let letters = ["a", "b", "c", "d", "e"]
permuteWirth(letters, letters.count - 1)
```

This prints all the permutations of the input array to the debug output:
这会将输入数组的所有排列打印到调试输出：

```swift
["a", "b", "c", "d", "e"]
["b", "a", "c", "d", "e"]
["c", "b", "a", "d", "e"]
["b", "c", "a", "d", "e"]
["a", "c", "b", "d", "e"]
...
```

As we've seen before, there will be 120 of them.
正如我们之前看到的，将会有120个。

How does the algorithm work? Good question! Let's step through a simple example with just three elements. The input array is:
算法如何工作？ 好问题！ 让我们通过一个只有三个元素的简单示例。 输入数组是：

	[ "x", "y", "z" ]

We're calling it like so:
我们这样称呼它：

```swift
permuteWirth([ "x", "y", "z" ], 2)
```

Note that the `n` parameter is one less than the number of elements in the array!
请注意，`n`参数比数组中的元素数少一个！

After calling `permuteWirth()` it immediately calls itself recursively with `n = 1`. And that immediately calls itself recursively again with `n = 0`. The call tree looks like this:
在调用`permuteWirth()`之后，它立即用`n = 1`递归调用自身。 然后用`n = 0`再次递归地调用自身。 调用树看起来像这样：

```swift
permuteWirth([ "x", "y", "z" ], 2)
	permuteWirth([ "x", "y", "z" ], 1)
		permuteWirth([ "x", "y", "z" ], 0)   // prints ["x", "y", "z"]
```

When `n` is equal to 0, we print out the current array, which is still unchanged at this point. The recursion has reached the base case, so now we go back up one level and enter the `for` loop.
当`n`等于0时，我们打印出当前数组，此时该数组仍未改变。 递归已达到基本情况，所以现在我们回到一个级别并进入`for`循环。

```swift
permuteWirth([ "x", "y", "z" ], 2)
	permuteWirth([ "x", "y", "z" ], 1)   <--- back to this level
	    swap a[0] with a[1]
        permuteWirth([ "y", "x", "z" ], 0)   // prints ["y", "x", "z"]
	    swap a[0] and a[1] back
```

This swapped `"y"` and `"x"` and printed the result. We're done at this level of the recursion and go back to the top. This time we do two iterations of the `for` loop because `n = 2` here. The first iteration looks like this:
这交换了`"y"`和`"x"`并打印结果。 我们在递归的这个级别完成并返回顶部。 这次我们对`for`循环进行两次迭代，因为这里的`n = 2`。 第一次迭代看起来像这样：

```swift
permuteWirth([ "x", "y", "z" ], 2)   <--- back to this level
    swap a[0] with a[2]
	permuteWirth([ "z", "y", "x" ], 1)
        permuteWirth([ "z", "y", "x" ], 0)   // prints ["z", "y", "x"]
	    swap a[0] with a[1]
        permuteWirth([ "y", "z", "x" ], 0)   // prints ["y", "z", "x"]
	    swap a[0] and a[1] back
    swap a[0] and a[2] back
```

And the second iteration:
第二次迭代：

```swift
permuteWirth([ "x", "y", "z" ], 2)
    swap a[1] with a[2]                 <--- second iteration of the loop
	permuteWirth([ "x", "z", "y" ], 1)
        permuteWirth([ "x", "z", "y" ], 0)   // prints ["x", "z", "y"]
	    swap a[0] with a[1]
        permuteWirth([ "z", "x", "y" ], 0)   // prints ["z", "x", "y"]
	    swap a[0] and a[1] back
    swap a[1] and a[2] back
```

To summarize, first it swaps these items:
总而言之，首先它交换这些项目：

	[ 2, 1, - ]

Then it swaps these:
然后它交换这些：

	[ 3, -, 1 ]

Recursively, it swaps the first two again:
递归地，它再次交换前两个：

	[ 2, 3, - ]

Then it goes back up one step and swaps these:
然后它回到一步并交换这些：

	[ -, 3, 2 ]

And finally the first two again:
最后是前两个：

	[ 3, 1, - ]

Of course, the larger your array is, the more swaps it performs and the deeper the recursion gets.
当然，您的数组越大，它执行的交换越多，递归越深。

If the above is still not entirely clear, then I suggest you give it a go in the playground. That's what playgrounds are great for. :-)
如果以上仍然不完全清楚，那么我建议你在操场上试一试。 这就是 playgrounds 的特色。:-)

For fun, here is an alternative algorithm, by Robert Sedgewick:
为了好玩，这是Robert Sedgewick的另一种算法：

```swift
func permuteSedgewick(_ a: [Int], _ n: Int, _ pos: inout Int) {
  var a = a
  pos += 1
  a[n] = pos
  if pos == a.count - 1 {
    print(a)              // display the current permutation
  } else {
    for i in 0..<a.count {
      if a[i] == 0 {
        permuteSedgewick(a, i, &pos)
      }
    }
  }
  pos -= 1
  a[n] = 0
}
```

You use it like this:

```swift
let numbers = [0, 0, 0, 0]
var pos = -1
permuteSedgewick(numbers, 0, &pos)
```

The array must initially contain all zeros. 0 is used as a flag that indicates more work needs to be done on each level of the recursion.
该数组最初必须包含全零。 0用作标志，指示需要在递归的每个级别上完成更多工作。

The output of the Sedgewick algorithm is:
Sedgewick算法的输出是：

```swift
[1, 2, 3, 0]
[1, 2, 0, 3]
[1, 3, 2, 0]
[1, 0, 2, 3]
[1, 3, 0, 2]
...
```

It can only deal with numbers, but these can serve as indices into the actual array you're trying to permute, so it's just as powerful as Wirth's algorithm.
它只能处理数字，但是它们可以作为你试图置换的实际数组的索引，所以它和Wirth的算法一样强大。

Try to figure out for yourself how this algorithm works!
试着弄清楚这个算法是如何工作的！

## Combinations
## 组合

A combination is like a permutation where the order does not matter. The following are six different permutations of the letters `k` `l` `m` but they all count as the same combination:
组合就像排列无关紧要的排列。 以下是字母`k` `l` `m`的六种不同排列，但它们都算作相同的组合：

	k, l, m      k, m, l      m, l, k
	l, m, k      l, k, m      m, k, l

So there is only one combination of size 3. However, if we're looking for combinations of size 2, we can make three:
因此，只有一个大小为3的组合。但是，如果我们正在寻找大小为2的组合，我们可以制作三个：

	k, l      (is the same as l, k)
	l, m      (is the same as m, l)
	k, m      (is the same as m, k)

The `C(n, k)` function counts the number of ways to choose `k` things out of `n` possibilities. That's why it's also called "n-choose-k". (A fancy mathematical term for this number is "binomial coefficient".)
`C(n, k)`函数计算从`n`可能性中选择`k`事物的方式的数量。 这就是为什么它也被称为"n-choose-k"。 （这个数字的奇特数学术语是“二项式系数”。）

The formula for `C(n, k)` is:
`C(n, k)`的公式：

	               n!         P(n, k)
	C(n, k) = ------------- = --------
	          (n - k)! * k!      k!

As you can see, you can derive it from the formula for `P(n, k)`. There are always more permutations than combinations. You divide the number of permutations by `k!` because a total of `k!` of these permutations give the same combination.
如您所见，您可以从`P(n, k)`的公式推导出它。 总是有更多的排列而不是组合。 你将排列数除以`k!`，因为这些排列的总共`k!`给出了相同的组合。

Above I showed that the number of permutations of `k` `l` `m` is 6, but if you pick only two of those letters the number of combinations is 3. If we use the formula we should get the same answer. We want to calculate `C(3, 2)` because we choose 2 letters out of a collection of 3.
上面我展示了`k` `l` `m`的排列数是6，但是如果你只选择其中两个字母，那么组合的数量是3.如果我们使用公式，我们应该得到相同的答案。 我们想要计算`C(3, 2)`因为我们从3的集合中选择2个字母。

	          3 * 2 * 1    6
	C(3, 2) = --------- = --- = 3
	           1! * 2!     2

Here's a simple function to calculate `C(n, k)`:
这是一个计算 `C(n, k)` 的简单函数：

```swift
func combinations(_ n: Int, choose k: Int) -> Int {
  return permutations(n, k) / factorial(k)
}
```

Use it like this:

```swift
combinations(28, choose: 5)    // prints 98280
```

Because this uses the `permutations()` and `factorial()` functions under the hood, you're still limited by how large these numbers can get. For example, `combinations(30, 15)` is "only" `155,117,520` but because the intermediate results don't fit into a 64-bit integer, you can't calculate it with the given function.
因为它在引擎盖下使用`permutations()`和`factorial()`函数，你仍然受限于这些数字可以得到多大。 例如，`combinations(30, 15)`是“仅” `155,117,520`，但由于中间结果不适合64位整数，因此无法使用给定函数计算它。

There's a faster approach to calculate `C(n, k)` in **O(k)** time and **O(1)** extra space. The idea behind it is that the formula for `C(n, k)` is:
有一种更快的方法来计算**O(k)**时间和**O(1)**额外空间中的`C(n, k)`。 其背后的想法是`C(n, k)`的公式是：

                   n!                      n * (n - 1) * ... * 1
    C(n, k) = ------------- = ------------------------------------------
              (n - k)! * k!      (n - k) * (n - k - 1) * ... * 1 * k!

After the reduction of fractions, we get the following formula:
减少部分后，我们得到以下公式：

                   n * (n - 1) * ... * (n - k + 1)         (n - 0) * (n - 1) * ... * (n - k + 1)
    C(n, k) = --------------------------------------- = -----------------------------------------
                               k!                          (0 + 1) * (1 + 1) * ... * (k - 1 + 1)

We can implement this formula as follows:
我们可以按如下方式实现这个公式：

```swift
func quickBinomialCoefficient(_ n: Int, choose k: Int) -> Int {
  var result = 1
  for i in 0..<k {
    result *= (n - i)
    result /= (i + 1)
  }
  return result
}
```

This algorithm can create larger numbers than the previous method. Instead of calculating the entire numerator (a potentially huge number) and then dividing it by the factorial (also a very large number), here we already divide in each step. That causes the temporary results to grow much less quickly.
该算法可以创建比先前方法更大的数字。 而不是计算整个分子（一个潜在的巨大数字），然后将它除以阶乘（也是一个非常大的数字），这里我们已经分为每一步。 这导致临时结果增长得更快。

Here's how you can use this improved algorithm:
以下是使用此改进算法的方法：

```swift
quickBinomialCoefficient(8, choose: 2)     // prints 28
quickBinomialCoefficient(30, choose: 15)   // prints 155117520
```

This new method is quite fast but you're still limited in how large the numbers can get. You can calculate `C(30, 15)` without any problems, but something like `C(66, 33)` will still cause integer overflow in the numerator.
这种新方法速度非常快，但您仍然可以限制数量的大小。 你可以毫无问题地计算`C(30, 15)`，但像`C(66, 33)`这样的东西仍然会导致分子中的整数溢出。

Here is an algorithm that uses dynamic programming to overcome the need for calculating factorials and doing divisions. It is based on Pascal's triangle:
这是一种算法，它使用动态编程来克服计算阶乘和分割的需要。 它基于Pascal的三角形：

	0:               1
	1:             1   1
	2:           1   2   1
	3:         1   3   3   1
	4:       1   4   6   4   1
	5:     1   5  10   10  5   1
	6:   1   6  15  20   15  6   1

Each number in the next row is made up by adding two numbers from the previous row. For example in row 6, the number 15 is made by adding the 5 and 10 from row 5. These numbers are called the binomial coefficients and as it happens they are the same as `C(n, k)`.
下一行中的每个数字都是通过添加前一行中的两个数字来组成的。例如，在第6行中，数字15是通过从第5行添加5和10来产生的。这些数字称为二项式系数，并且它们与`C(n, k)`相同。

For example, for row 6:

	C(6, 0) = 1
	C(6, 1) = 6
	C(6, 2) = 15
	C(6, 3) = 20
	C(6, 4) = 15
	C(6, 5) = 6
	C(6, 6) = 1

The following code calculates Pascal's triangle in order to find the `C(n, k)` you're looking for:
下面的代码计算Pascal的三角形，以便找到你正在寻找的 `C(n, k)`：

```swift
func binomialCoefficient(_ n: Int, choose k: Int) -> Int {
  var bc = Array(repeating: Array(repeating: 0, count: n + 1), count: n + 1)

  for i in 0...n {
    bc[i][0] = 1
    bc[i][i] = 1
  }

  if n > 0 {
    for i in 1...n {
      for j in 1..<i {
        bc[i][j] = bc[i - 1][j - 1] + bc[i - 1][j]
      }
    }
  }

  return bc[n][k]
}
```

The algorithm itself is quite simple: the first loop fills in the 1s at the outer edges of the triangle. The other loops calculate each number in the triangle by adding up the two numbers from the previous row.
算法本身非常简单：第一个循环填充三角形外边缘的1s。 其他循环通过将前一行中的两个数字相加来计算三角形中的每个数字。

Now you can calculate `C(66, 33)` without any problems:
现在你可以毫无问题地计算 `C(66, 33)`：

```swift
binomialCoefficient(66, choose: 33)   // prints a very large number
```

You may wonder what the point is in calculating these permutations and combinations, but many algorithm problems are really combinatorics problems in disguise. Often you may need to look at all possible combinations of your data to see which one gives the right solution. If that means you need to search through `n!` potential solutions, you may want to consider a different approach -- as you've seen, these numbers become huge very quickly!
您可能想知道计算这些排列和组合的重点是什么，但许多算法问题实际上是伪装的组合问题。通常，您可能需要查看数据的所有可能组合，以查看哪个组合能够提供正确的解决方案。如果这意味着您需要搜索 `n!` 潜在的解决方案，您可能需要考虑一种不同的方法 - 正如您所见，这些数字变得非常快！

## References
## 参考

Wirth's and Sedgewick's permutation algorithms and the code for counting permutations and combinations are based on the Algorithm Alley column from Dr.Dobb's Magazine, June 1993. The dynamic programming binomial coefficient algorithm is from The Algorithm Design Manual by Skiena.
Wirth和Sedgewick的排列算法以及计数排列和组合的代码基于Dr.Dobb杂志1993年6月的算法Alley专栏。动态编程二项系数算法来自Skiena的算法设计手册。

*Written for Swift Algorithm Club by Matthijs Hollemans and [Kanstantsin Linou](https://github.com/nuts23)*

*作者：Matthijs Hollemans，[Kanstantsin Linou](https://github.com/nuts23)*  
*翻译：[Andy Ron](https://github.com/andyRon)* 
