# Selection Sampling
# 选取样本

Goal: Select *k* items at random from a collection of *n* items.
目标：从*n* 项目的集合中随机选择*k*项目。

Let's say you have a deck of 52 playing cards and you need to draw 10 cards at random. This algorithm lets you do that.
假设你有一副52张牌，你需要随机抽取10张牌。 这个算法可以让你达成。

Here's a very fast version:
这是一个非常快的版本：

```swift
func select<T>(from a: [T], count k: Int) -> [T] {
  var a = a
  for i in 0..<k {
    let r = random(min: i, max: a.count - 1)
    if i != r {
      swap(&a[i], &a[r])
    }
  }
  return Array(a[0..<k])
}
```

As often happens with these [kinds of algorithms](../Shuffle/), it divides the array into two regions. The first region contains the selected items; the second region is all the remaining items.
正如这些[kinds of algorithms](../Shuffle/)经常发生的那样，它将数组划分为两个区域。 第一个区域包含所选项目; 第二个区域是所有剩余的项目。

Here's an example. Let's say the array is:
一个例子。 我们说数组是：

	[ "a", "b", "c", "d", "e", "f", "g" ]
	
We want to select 3 items, so `k = 3`. In the loop, `i` is initially 0, so it points at `"a"`.
我们想选择3个项目，所以`k = 3`。 在循环中，`i`最初为0，因此它指向`"a"`。

	[ "a", "b", "c", "d", "e", "f", "g" ]
	   i

We calculate a random number between `i` and `a.count`, the size of the array. Let's say this is 4. Now we swap `"a"` with `"e"`, the element at index 4, and move `i` forward:
我们计算`i`和`a.count`之间的随机数，即数组的大小。 让我们说这是4. 现在我们将`"a"`与`"e"`交换，索引为4的元素，然后向前移动`i`：

	[ "e" | "b", "c", "d", "a", "f", "g" ]
	         i

The `|` bar shows the split between the two regions. `"e"` is the first element we've selected. Everything to the right of the bar we still need to look at.
`|`栏显示两个区域之间的分割。 `"e"`是我们选择的第一个元素。 我们仍然需要关注`|`栏右侧的所有内容。

Again, we ask for a random number between `i` and `a.count`, but because `i` has shifted, the random number can never be less than 1. So we'll never again swap `"e"` with anything.
再一次，我们要求`i`和`a.count`之间的随机数，但因为`i`已经移位，随机数永远不会小于1.所以我们再也不会交换`"e"`任何东西。

Let's say the random number is 6 and we swap `"b"` with `"g"`:
假设随机数为6，我们将`"b"`与`"g"`交换：

	[ "e" , "g" | "c", "d", "a", "f", "b" ]
	               i

One more random number to pick, let's say it is 4 again. We swap `"c"` with `"a"` to get the final selection on the left:
还有一个随机数，我们再说它是4。 我们将`"c"`与`"a"`交换为左边的最终选择：

	[ "e", "g", "a" | "d", "c", "f", "b" ]

And that's it. Easy peasy. The performance of this function is **O(k)** because as soon as we've selected *k* elements, we're done.
就是这样。 十分简单。 这个函数的性能是**O(k)**，因为只要我们选择了*k*元素，我们就完成了。

Here is an alternative algorithm, called "reservoir sampling":
这是一种替代算法，称为“水库采样”：

```swift
func reservoirSample<T>(from a: [T], count k: Int) -> [T] {
  precondition(a.count >= k)

  var result = [T]()      // 1
  for i in 0..<k {
    result.append(a[i])
  }

  for i in k..<a.count {  // 2
    let j = random(min: 0, max: i)
    if j < k {
      result[j] = a[i]
    }
  }
  return result
}
```

This works in two steps:
有两个步骤：

1. Fill the `result` array with the first `k` elements from the original array. This is called the "reservoir".
2. Randomly replace elements in the reservoir with elements from the remaining pool.
1. 使用原始数组中的第一个`k`元素填充`result`数组。 这被称为“水库”。
2. 用剩余池中的元素随机替换储层中的元素。

The performance of this algorithm is **O(n)**, so it's a little bit slower than the first algorithm. However, its big advantage is that it can be used for arrays that are too large to fit in memory, even if you don't know what the size of the array is (in Swift this might be something like a lazy generator that reads the elements from a file).
该算法的性能为 **O(n)**，因此它比第一算法慢一点。 但是，它的最大优点是它可以用于太大而无法容纳在内存中的数组，即使你不知道数组的大小是什么（在Swift中这可能类似于懒惰的生成器，它读取了来自文件的元素）。

There is one downside to the previous two algorithms: they do not keep the elements in the original order. In the input array `"a"` came before `"e"` but now it's the other way around. If that is an issue for your app, you can't use this particular method.
前两种算法有一个缺点：它们不保留原始顺序的元素。 在输入数组中，`"a"`出现在"e"之前，但现在却是另一种方式。 如果这是您的应用的问题，则无法使用此特定方法。

Here is an alternative approach that does keep the original order intact, but is a little more involved:
这是一种替代方法，可以保持原始订单的完整性，但需要更多参与：

```swift
func select<T>(from a: [T], count requested: Int) -> [T] {
  var examined = 0
  var selected = 0
  var b = [T]()
  
  while selected < requested {                          // 1
    let r = Double(arc4random()) / 0x100000000          // 2
    
    let leftToExamine = a.count - examined              // 3
    let leftToAdd = requested - selected

    if Double(leftToExamine) * r < Double(leftToAdd) {  // 4
      selected += 1
      b.append(a[examined])
    }

    examined += 1
  }
  return b
}
```

This algorithm uses probability to decide whether to include a number in the selection or not. 
该算法使用概率来决定是否在选择中包括数字。

1. The loop steps through the array from beginning to end. It keeps going until we've selected *k* items from our set of *n*. Here, *k* is called `requested` and *n* is `a.count`.

2. Calculate a random number between 0 and 1. We want `0.0 <= r < 1.0`. The higher bound is exclusive; we never want it to be exactly 1. That's why we divide the result from `arc4random()` by `0x100000000` instead of the more usual `0xffffffff`.

3. `leftToExamine` is how many items we still haven't looked at. `leftToAdd` is how many items we still need to select before we're done.

4. This is where the magic happens. Basically, we're flipping a coin. If it was heads, we add the current array element to the selection; if it was tails, we skip it.

1. 循环从头到尾逐步完成数组。 它一直持续到我们从*n*的集合中选择*k*项目。 这里，*k*被称为`requested`而*n*被称为`a.count`。

2. 计算0到1之间的随机数。我们想要`0.0 <= r <1.0`。 上限是排他性的; 我们从不希望它完全是1。这就是为什么我们将结果从`arc4random()`除以`0x100000000`而不是更常见的`0xffffffff`。
 
3. `leftToExamine`是我们还没有看过多少项。 `leftToAdd`是我们在完成之前还需要选择的项目数。

4. 这就是魔术发生的地方。 基本上，我们正在翻转一枚硬币。 如果是head，我们将当前数组元素添加到选择中; 如果它是尾巴，我们跳过它。

Interestingly enough, even though we use probability, this approach always guarantees that we end up with exactly *k* items in the output array.
有趣的是，即使我们使用概率，这种方法总是保证我们最终得到输出数组中的*k*项。

Let's walk through the same example again. The input array is:
让我们再次讨论相同的例子。 输入数组是：

	[ "a", "b", "c", "d", "e", "f", "g" ]

The loop looks at each element in turn, so we start at `"a"`. We get a random number between 0 and 1, let's say it is 0.841. The formula at `// 4` multiplies the number of items left to examine with this random number. There are still 7 elements left to examine, so the result is: 
循环依次查看每个元素，因此我们从`"a"`开始。 我们得到一个介于0和1之间的随机数，假设它是0.841。 `// 4`处的公式将要检查的项目数乘以此随机数。 还有7个元素需要检查，结果是：

	7 * 0.841 = 5.887

We compare this to 3 because we wanted to select 3 items. Since 5.887 is greater than 3, we skip `"a"` and move on to `"b"`.
我们将此与3进行比较，因为我们想要选择3个项目。 由于5.887大于3，我们跳过`"a"`并继续`"b"`。

Again, we get a random number, let's say 0.212. Now there are only 6 elements left to examine, so the formula gives:
再一次，我们得到一个随机数，比方说0.212。 现在只剩下6个要检查的元素，因此公式给出：

	6 * 0.212 = 1.272

This *is* less than 3 and we add `"b"` to the selection. This is the first item we've selected, so two left to go.
小于3，我们在选择中添加`"b"`。 这是我们选择的第一个项目，所以还剩下两个。

On to the next element, `"c"`. The random number is 0.264, giving the result:
到下一个元素，`"c"`。 随机数为0.264，得出结果：

	5 * 0.264 = 1.32

There are only 2 elements left to select, so this number must be less than 2. It is, and we also add `"c"` to the selection. The total selection is `[ "b", "c" ]`.
只剩下2个元素可供选择，因此这个数字必须小于2。它是，我们还在选择中加上`"c"`。 总选择是`["b"，"c"]`。

Only one item left to select but there are still 4 candidates to look at. Suppose the next random number is 0.718. The formula now gives:
只有一个项目可供选择，但仍有4个候选人要查看。 假设下一个随机数是0.718。 该公式现在给出：

	4 * 0.718 = 2.872

For this element to be selected the number has to be less than 1, as there is only 1 element left to be picked. It isn't, so we skip `"d"`. Only three possibilities left -- will we make it before we run out of elements?
要选择此元素，数字必须小于1，因为只剩下1个要拾取的元素。 它不是，所以我们跳过`"d"`。 只剩下三种可能性 - 我们会在耗尽元素之前制作它吗？

The random number is 0.346. The formula gives:
随机数为0.346。 该公式给出：

	3 * 0.346 = 1.038
	
Just a tiny bit too high. We skip `"e"`. Only two candidates left...
只是有点太高了。 我们跳过`"e"`。 只有两名候选人离职......

Note that now literally we're dealing with a coin toss: if the random number is less than 0.5 we select `"f"` and we're done. If it's greater than 0.5, we go on to the final element. Let's say we get 0.583:
请注意，现在字面上我们正在处理抛硬币：如果随机数小于0.5，我们选择`"f"`，我们就完成了。 如果它大于0.5，我们继续最后的元素。 假设我们得到0.583：

	2 * 0.583 = 1.166

We skip `"f"` and look at the very last element. Whatever random number we get here, it should always select `"g"` or we won't have selected enough elements and the algorithm doesn't work!
我们跳过`"f"`并查看最后一个元素。 无论我们在这里得到什么随机数，它应该总是选择`"g"`或者我们不会选择足够的元素而算法不起作用！

Let's say our final random number is 0.999 (remember, it can never be 1.0 or higher). Actually, no matter what we choose here, the formula will always give a value less than 1:
假设我们的最终随机数是0.999（记住，它永远不会是1.0或更高）。 实际上，无论我们在这里选择什么，公式总是会给出小于1的值：

	1 * 0.999 = 0.999

And so the last element will always be chosen if we didn't have a big enough selection yet. The final selection is `[ "b", "c", "g" ]`. Notice that the elements are still in their original order, because we examined the array from left to right.
因此，如果我们还没有足够大的选择，那么总是会选择最后一个元素。 最后的选择是`[“b”，“c”，“g”]`。 请注意，元素仍处于原始顺序，因为我们从左到右检查了数组。

Maybe you're not convinced yet... What if we always got 0.999 as the random value (the maximum possible), would that still select 3 items? Well, let's do the math:
也许你还不相信......如果我们总是将0.999作为随机值（最大可能值），那还能选择3项吗？ 好吧，让我们做数学：

	7 * 0.999 = 6.993     is this less than 3? no
	6 * 0.999 = 5.994     is this less than 3? no
	5 * 0.999 = 4.995     is this less than 3? no
	4 * 0.999 = 3.996     is this less than 3? no
	3 * 0.999 = 2.997     is this less than 3? YES
	2 * 0.999 = 1.998     is this less than 2? YES
	1 * 0.999 = 0.999     is this less than 1? YES

It always works! But does this mean that elements closer to the end of the array have a higher probability of being chosen than those in the beginning? Nope, all elements are equally likely to be selected. (Don't take my word for it: see the playground for a quick test that shows this in practice.)
它总是有效！ 但这是否意味着靠近数组末尾的元素比一开始的元素更有可能被选中？ 不，所有元素同样可能被选中。 （不要相信我的话：在playground 看一下快速测试，在实践中证明了这一点。）

Here's an example of how to test this algorithm:
以下是如何测试此算法的示例：

```swift
let input = [
  "there", "once", "was", "a", "man", "from", "nantucket",
  "who", "kept", "all", "of", "his", "cash", "in", "a", "bucket",
  "his", "daughter", "named", "nan",
  "ran", "off", "with", "a", "man",
  "and", "as", "for", "the", "bucket", "nan", "took", "it",
]

let output = select(from: input, count: 10)
print(output)
print(output.count)
```

The performance of this second algorithm is **O(n)** as it may require a pass through the entire input array.
第二种算法的性能是**O(n)**，因为它可能需要通过整个输入数组。

> **Note:** If `k > n/2`, then it's more efficient to do it the other way around and choose `a.count - k` items to remove.
> **注意：** 如果`k> n / 2`，那么以相反的方式执行它并选择要删除的`a.count - k`项更有效。

Based on code from Algorithm Alley, Dr. Dobb's Magazine, October 1993.
基于发表于1993年10月Dobb博士的杂志的Algorithm Alley的代码。

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*