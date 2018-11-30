# Miller-Rabin Primality Test
# Miller-Rabin素性检测

In 1976, Gray Miller introduced an algorithm, through his ph.d thesis[1], which determines a primality of the given number. The original algorithm was deterministic under the Extended Reimann Hypothesis, which is yet to be proven. After four years, Michael O. Rabin improved the algorithm[2] by using probabilistic approach and it no longer assumes the unproven hypothesis.

1976年，格雷米勒通过他的博士论文[1]介绍了一种算法，它确定了给定数字的素数。 原始算法在扩展Reimann假设下是确定性的，尚未得到证实。 四年后，Michael O. Rabin通过使用概率方法改进了算法[2]，并且不再假设未经证实的假设。

## Probabilistic
## 概率

The result of the test is simply a boolean. However, `true` does not implicate _the number is prime_. In fact, it means _the number is **probably** prime_. But `false` does mean _the number is composite_.  
测试结果只是一个布尔值。 但是，`true`并不意味着 _the number is prime_ 。 事实上，这意味着 _the number is **probably** prime_。 但是`false`的意思是 _the number is composite_。


In order to increase the accuracy of the test, it needs to be iterated few times. If it returns `true` in every single iteration, then we can say with confidence that _the number is pro......bably prime_.  
为了提高测试的准确性，需要迭代几次。 如果它在每一次迭代中都返回`true`，那么我们可以自信地说 _the number is pro......bably prime_。

## Algorithm
## 算法

Let `n` be the given number, and write `n-1` as `2^s·d`, where `d` is odd. And choose a random number `a` within the range from `2` to `n - 1`.  
设`n`为给定数字，并将`n-1`写为`2^s·d`，其中`d`为奇数。 并选择从`2`到`n - 1`范围内的随机数`a`。

Now make a sequence, in modulo `n`, as following:  
现在以模`n`形式创建一个序列，如下所示：

> a^d, a^(2·d), a^(4·d), ... , a^((2^(s-1))·d), a^((2^s)·d) = a^(n-1)

And we say the number `n` passes the test, _probably prime_, if 1) `a^d` is congruence to `1` in modulo `n`, or 2) `a^((2^k)·d)` is congruence to `-1` for some `k = 1, 2, ..., s-1`.  
并且我们说数字`n`通过测试， _probably prime_ ，如果1）`a^d`与modulo`n`中的`1`是一致的，或2）`a^((2^k)·d)` 对于某些 `k = 1, 2, ..., s-1`，与`-1`是一致的。

### Pseudo Code
### 伪代码

The following pseudo code is excerpted from Wikipedia[3]:  
以下伪代码摘自维基百科[3]：

![Image of Pseudocode](./Images/img_pseudo.png)

## Usage
## 使用

```swift
mrPrimalityTest(7)                      // test if 7 is prime. (default iteration = 1)
mrPrimalityTest(7, iteration: 10)       // test if 7 is prime && iterate 10 times.
```

## Reference
## 参考

1. G. L. Miller, "Riemann's Hypothesis and Tests for Primality". _J. Comput. System Sci._ 13 (1976), 300-317.
2. M. O. Rabin, "Probabilistic algorithm for testing primality". _Journal of Number Theory._ 12 (1980), 128-138.
3. Miller–Rabin primality test - Wikipedia, the free encyclopedia

_Written for Swift Algorithm Club by **Sahn Cha**, @scha00_

*作者：*Sahn Cha***  
*翻译：[Andy Ron](https://github.com/andyRon)*  

[1]: https://cs.uwaterloo.ca/research/tr/1975/CS-75-27.pdf
[2]: http://www.sciencedirect.com/science/article/pii/0022314X80900840
[3]: https://en.wikipedia.org/wiki/Miller–Rabin_primality_test
