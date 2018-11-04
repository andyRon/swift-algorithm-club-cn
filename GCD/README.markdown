# Greatest Common Divisor
# 最大公约数算法

The *greatest common divisor* (or Greatest Common Factor) of two numbers `a` and `b` is the largest positive integer that divides both `a` and `b` without a remainder.
两个数字`a`和`b`的*最大公约数*（或最大公因数）是将`a`和`b`分开都没有余的最大正整数。

For example, `gcd(39, 52) = 13` because 13 divides 39 (`39/13 = 3`) as well as 52 (`52/13 = 4`). But there is no larger number than 13 that divides them both.
例如，`gcd(39, 52) = 13`因为13除以39(`39/13 = 3`)以及52(`52/13 = 4`)，而且没有比13更大的数字。

You've probably had to learn about this in school at some point. :-)
在某些时候你可能不得不在学校里了解这一点。:-)

The laborious way to find the GCD of two numbers is to first figure out the factors of both numbers, then take the greatest number they have in common. The problem is that factoring numbers is quite difficult, especially when they get larger. (On the plus side, that difficulty is also what keeps your online payments secure.)
找到两个数字的GCD的费力方法是先找出两个数字的因子，然后取其共同的最大数量。 问题在于分解数字是非常困难的，特别是当它们变大时。 （从好的方面来说，这种困难也是保证您的在线支付安全的原因。）

There is a smarter way to calculate the GCD: Euclid's algorithm. The big idea here is that,
有一种更聪明的方法来计算GCD：Euclid的算法。 这里最重要的是，

	gcd(a, b) = gcd(b, a % b)

where `a % b` calculates the remainder of `a` divided by `b`.
其中`a％b`计算`a`的余数除以`b`。

Here is an implementation of this idea in Swift:
以下是Swift中这个想法的实现：

```swift
func gcd(_ a: Int, _ b: Int) -> Int {
  let r = a % b
  if r != 0 {
    return gcd(b, r)
  } else {
    return b
  }
}
```

Put it in a playground and try it out with these examples:
把它放在一个 playground 上，然后试试这些例子：

```swift
gcd(52, 39)        // 13
gcd(228, 36)       // 12
gcd(51357, 3819)   // 57
```

Let's step through the third example:
让我们逐步完成第三个例子：

	gcd(51357, 3819)

According to Euclid's rule, this is equivalent to,
根据欧几里德的规则，这相当于，

	gcd(3819, 51357 % 3819) = gcd(3819, 1710)

because the remainder of `51357 % 3819` is `1710`. If you work out this division you get `51357 = (13 * 3819) + 1710` but we only care about the remainder part.
因为`51357 ％ 3819`的剩余部分是`1710`。 如果你计算出这个部门你会得到`51357 = (13 * 3819) + 1710`但我们只关心其余部分。

So `gcd(51357, 3819)` is the same as `gcd(3819, 1710)`. That's useful because we can keep simplifying:
所以`gcd(51357, 3819)`与`gcd(3819, 1710)`相同。 这很有用，因为我们可以继续简化：

	gcd(3819, 1710) = gcd(1710, 3819 % 1710) = 
	gcd(1710, 399)  = gcd(399, 1710 % 399)   = 
	gcd(399, 114)   = gcd(114, 399 % 114)    = 
	gcd(114, 57)    = gcd(57, 114 % 57)      = 
	gcd(57, 0)

And now can't divide any further. The remainder of `114 / 57` is zero because `114 = 57 * 2` exactly. That means we've found the answer:
现在不能再进一步划分了。 `114 / 57`的余数为零，因为`114 = 57 * 2`正是如此。 这意味着我们找到了答案：

	gcd(3819, 51357) = gcd(57, 0) = 57

So in each step of Euclid's algorithm the numbers become smaller and at some point it ends when one of them becomes zero.
因此，在Euclid算法的每个步骤中，数字变得更小，并且在某个点上，当它们中的一个变为零时它结束。

By the way, it's also possible that two numbers have a GCD of 1. They are said to be *relatively prime*. This happens when there is no number that divides them both, for example:
顺便说一下，两个数字的GCD也可能为1.它们被认为是*相对素数*。 当没有数字将它们分开时会发生这种情况，例如：

```swift
gcd(841, 299)     // 1
```

Here is a slightly different implementation of Euclid's algorithm. Unlike the first version this doesn't use recursion but only a basic `while` loop.
这是Euclid算法的略微不同的实现。 与第一个版本不同，它不使用递归，而只使用基本的`while`循环。

```swift
func gcd(_ m: Int, _ n: Int) -> Int {
  var a = 0
  var b = max(m, n)
  var r = min(m, n)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}
```

The `max()` and `min()` at the top of the function make sure we always divide the larger number by the smaller one.
函数顶部的 `max()` 和 `min()` 确保我们总是将较大的数字除以较小的数字。

## Least Common Multiple
## 最不常见的多重

An idea related to the GCD is the *least common multiple* or LCM.
与GCD相关的想法是*最小公倍数*或LCM。

The least common multiple of two numbers `a` and `b` is the smallest positive integer that is a multiple of both. In other words, the LCM is evenly divisible by `a` and `b`. 
两个数字`a`和`b`的最小公倍数是最小的正整数，它是两者的倍数。 换句话说，LCM可以被`a`和`b`整除。

For example: `lcm(2, 3) = 6` because 6 can be divided by 2 and also by 3.
例如：`lcm（2, 3）= 6`因为6可以除以2而且也可以除以3。

We can calculate the LCM using Euclid's algorithm too:
我们也可以使用Euclid算法计算LCM：

	              a * b
	lcm(a, b) = ---------
	            gcd(a, b)

In code:

```swift
func lcm(_ m: Int, _ n: Int) -> Int {
  return m / gcd(m, n) * n
}
```

And to try it out in a playground:

```swift
lcm(10, 8)    // 40
```

You probably won't need to use the GCD or LCM in any real-world problems, but it's cool to play around with this ancient algorithm. It was first described by Euclid in his [Elements](http://publicdomainreview.org/collections/the-first-six-books-of-the-elements-of-euclid-1847/) around 300 BC. Rumor has it that he discovered this algorithm while he was hacking on his Commodore 64.
您可能不需要在任何实际问题中使用GCD或LCM，但是使用这种古老的算法很酷。 它首先由欧几里德在公元前300年左右的[元素](http://publicdomainreview.org/collections/the-first-six-books-of-the-elements-of-euclid-1847/)中描述。 有传言说他在攻击他的Commodore 64时发现了这个算法。

*Written for Swift Algorithm Club by Matthijs Hollemans*

*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  