# Shuffle
# 洗牌算法

Goal: Rearrange the contents of an array.  
目标：重新排列数组的内容。


Imagine you're making a card game and you need to shuffle a deck of cards. You can represent the deck by an array of `Card` objects and shuffling the deck means to change the order of those objects in the array. (It's like the opposite of sorting.)

想象一下，你正在进行纸牌游戏，你需要洗牌。 您可以通过一组“卡片”对象来表示卡片组，并对卡片组件进行洗牌，以更改阵列中这些对象的顺序。 （这与排序相反。）

Here is a naive way to approach this in Swift:
这是在Swift中解决这个问题的一种原始的方式：

```swift
extension Array {
  public mutating func shuffle() {
    var temp = [Element]()
    while !isEmpty {
      let i = random(count)
      let obj = remove(at: i)
      temp.append(obj)
    }
    self = temp
  }
}
```

To try it out, copy the code into a playground and then do:
要试用它，将代码复制到playground然后执行：

```swift
var list = [ "a", "b", "c", "d", "e", "f", "g" ]
list.shuffle()
list.shuffle()
list.shuffle()
```

You should see three different arrangements -- or [permutations](../Combinatorics/) to use math-speak -- of the objects in the array.  
您应该看到三种不同的排列 - 或[排列](../Combinatorics/)来使用数学说话 - 数组中的对象。

This shuffle works *in place*, it modifies the contents of the original array. The algorithm works by creating a new array, `temp`, that is initially empty. Then we randomly choose an element from the original array and append it to `temp`, until the original array is empty. Finally, the temporary array is copied back into the original one.  
这个shuffle *就位*，它修改了原始数组的内容。 该算法通过创建一个最初为空的新数组`temp`来工作。 然后我们从原始数组中随机选择一个元素并将其附加到`temp`，直到原始数组为空。 最后，将临时数组复制回原始数组。

This code works just fine but it's not very efficient. Removing an element from an array is an **O(n)** operation and we perform this **n** times, making the total algorithm **O(n^2)**. We can do better!  
这段代码工作得很好，但效率不高。 从数组中删除元素是一个**O(n)**操作，我们执行** n **次，使总算法 **O(n^2)**。 我们可以做得更好！

## The Fisher-Yates / Knuth shuffle

Here is a much improved version of the shuffle algorithm:  
这是一个改进版本的洗牌算法：

```swift
extension Array {
  public mutating func shuffle() {
    for i in stride(from: count - 1, through: 1, by: -1) {
      let j = Int.random(in: 0...i)
      if i != j {
        swap(&self[i], &self[j])
      }
    }
  }
}
```

Again, this picks objects at random. In the naive version we placed those objects into a new temporary array so we could keep track of which objects were already shuffled and which still remained to be done. In this improved algorithm, however, we'll move the shuffled objects to the end of the original array. 
同样，这会随机选择对象。 在天真的版本中，我们将这些对象放入一个新的临时数组中，这样我们就可以跟踪哪些对象已经被洗牌，哪些仍然有待完成。 但是，在这个改进的算法中，我们将混洗的对象移动到原始数组的末尾。

Let's walk through the example. We have the array:
让我们来看看这个例子。 我们有数组：

  [ "a", "b", "c", "d", "e", "f", "g" ]

The loop starts at the end of the array and works its way back to the beginning. The very first random number can be any element from the entire array. Let's say it returns 2, the index of `"c"`. We swap `"c"` with `"g"` to move it to the end:
循环从数组的末尾开始，然后返回到开头。 第一个随机数可以是整个数组中的任何元素。 假设它返回2，即"c"的索引。 我们将`"c"`与`"g"`交换到最后：

  [ "a", "b", "g", "d", "e", "f" | "c" ]
               *                    *

The array now consists of two regions, indicated by the `|` bar. Everything to the right of the bar is shuffled already. 
该数组现在由两个区域组成，由`|`条表示。 酒吧右边的所有东西都已经洗牌了。

The next random number is chosen from the range 0...6, so only from the region `[ "a", "b", "g", "d", "e", "f" ]`. It will never choose `"c"` since that object is done and we'll no longer touch it.
下一个随机数是从0...6的范围中选择的，所以只能从区域`[ "a", "b", "g", "d", "e", "f" ]`中选择。它永远不会选择`"c"`，因为该对象已完成，我们将不再触摸它。

Let's say the random number generator picks 0, the index of `"a"`. Then we swap `"a"` with `"f"`, which is the last element in the unshuffled portion, and the array looks like this:
假设随机数生成器选择0，即`"a"`的索引。 然后我们将`"a"`与`"f"`交换，这是未洗过的部分中的最后一个元素，数组如下所示：

  [ "f", "b", "g", "d", "e" | "a", "c" ]
     *                         *

The next random number is somewhere in `[ "f", "b", "g", "d", "e" ]`, so let's say it is 3. We swap `"d"` with `"e"`:
下一个随机数在某个地方`[ "f", "b", "g", "d", "e" ]`，所以我们说它是3.我们将`"d"`与`"e"`交换：

  [ "f", "b", "g", "e" | "d", "a", "c" ]
                    *     *

And so on... This continues until there is only one element remaining in the left portion. For example:
等等......这一直持续到左侧部分只剩下一个元素。 例如：

  [ "b" | "e", "f", "g", "d", "a", "c" ]

There's nothing left to swap that `"b"` with, so we're done.
没有什么可以交换`"b"`了，所以我们已经完成了。

Because we only look at each array element once, this algorithm has a guaranteed running time of **O(n)**. It's as fast as you could hope to get!
因为我们只查看每个数组元素一次，所以该算法的运行时间保证为 **O(n)**。 它的速度和你希望的一样快！

## Creating a new array that is shuffled
## 创建一个被洗牌的新数组

There is a slight variation on this algorithm that is useful for when you want to create a new array instance that contains the values `0` to `n-1` in random order.
当您想要以随机顺序创建包含值`0`到`n-1`的新数组实例时，此算法略有不同。

Here is the code:

```swift
public func shuffledArray(_ n: Int) -> [Int] {
  var a = [Int](repeating: 0, count: n)
  for i in 0..<n {
    let j = Int.random(in: 0...i)
    if i != j {
      a[i] = a[j]
    }
    a[j] = i
  }
  return a
}
```

To use it:

```swift
let numbers = shuffledArray(10)
```

This returns something like `[3, 0, 9, 1, 8, 5, 2, 6, 7, 4]`. As you can see, every number between 0 and 10 is in that list, but shuffled around. Of course, when you try it for yourself the order of the numbers will be different. 
这会返回类似`[3, 0, 9, 1, 8, 5, 2, 6, 7, 4]`的内容。 正如您所看到的，0到10之间的每个数字都在该列表中，但随机摆动。 当然，当你自己尝试时，数字的顺序会有所不同。

The `shuffledArray()` function first creates a new array with `n` zeros. Then it loops `n` times and in each step adds the next number from the sequence to a random position in the array. The trick is to make sure that none of these numbers gets overwritten with the next one, so it moves the previous number out of the way first!
`shuffledArray()`函数首先创建一个带有`n`零的新数组。 然后它循环`n`次，并在每个步骤中将序列中的下一个数字添加到数组中的随机位置。 诀窍是确保这些数字都不会被下一个数字覆盖，所以它先将前一个数字移开！

The algoritm is quite clever and I suggest you walk through an example yourself, either on paper or in the playground. (Hint: Again it splits the array into two regions.)
算法很聪明，我建议你自己走一个例子，无论是在纸上还是在操场上。 （提示：再次将数组拆分为两个区域。）

## See also
## 扩展阅读

These Swift implementations are based on pseudocode from the [Wikipedia article](https://en.wikipedia.org/wiki/Fisher–Yates_shuffle).
这些Swift实现基于[Wikipedia文章](https://en.wikipedia.org/wiki/Fisher-Yates_shuffle)中的伪代码。

Mike Bostock has a [great visualization](http://bost.ocks.org/mike/shuffle/) of the shuffle algorithm.  
Mike Bostock有一个shuffle算法的[很好的可视化](http://bost.ocks.org/mike/shuffle/)。

*Written for Swift Algorithm Club by Matthijs Hollemans*  
*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  