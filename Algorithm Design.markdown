# Algorithm design techniques
# 算法设计技巧

What to do when you're faced with a new problem and you need to find an algorithm for it.
当你遇到新问题的时候，需要寻找新的算法。

### Is it similar to another problem?
### 是否有类似的其它问题？

If you can frame your problem in terms of another, more general problem, then you might be able to use an existing algorithm. Why reinvent the wheel?
如果您可以根据另一个更普遍的问题来构建解决需要解决问题，那么您可以使用现有算法。 为什么重新发明轮子？

One thing I like about [The Algorithm Design Manual](http://www.algorist.com) by Steven Skiena is that it includes a catalog of problems and solutions you can try. (See also his [algorithm repository](http://www3.cs.stonybrook.edu/~algorith/).)
我喜欢Steven Skiena的[算法设计手册](http://www.algorist.com)，它包含了一系列可以尝试的问题和解决方案。(另见Steven Skiena的[算法库](http://www3.cs.stonybrook.edu/~algorith/))

### It's OK to start with brute force
### 从蛮力开始是可以的

Naive, brute force solutions are often too slow for practical use but they're a good starting point. By writing the brute force solution, you learn to understand what the problem is really all about.
天真的蛮力解决方案通常对实际使用而言太慢，但它们是一个很好的起点。 通过编写蛮力解决方案，您将学习如何理解问题的真正含义。

Once you have a brute force implementation you can use that to verify that any improvements you come up with are correct. 
一旦你有一个暴力实施，你可以使用它来验证你提出的任何改进是正确的。

And if you only work with small datasets, then a brute force approach may actually be good enough on its own. Don't fall into the trap of premature optimization!
如果您只使用小型数据集，那么蛮力方法实际上可能足够好。 不要陷入过早优化的陷阱！

### Divide and conquer
### 分而治之

>"When you change the way you look at things, the things you look at change."</br>
>Max Planck, Quantum theorist and Nobel Prize Winner
> “当你改变你看待事物的方式时，你看到的东西会发生变化。”  
>  ———— 马克斯·普朗克，量子物理学家和诺贝尔奖获得者

Divide and conquer is a way of dealing with a large problem by breaking it down into bits and pieces and working your way up towards the solution.
分而治之是一种处理大问题的方法，将其分解成碎片并逐步向解决方案迈进。

Instead of seeing the whole problem as a single, huge and complex task you divide the problem in relatively smaller problems that are easier to understand and deal with.
不是将整个问题看作一个单一，庞大而复杂的任务，而是将问题分成相对较小的问题，这样问题更容易理解和处理。

You solve smaller problems and aggregate the solution until you are left with the solution only. At each step the problem at hand shrinks and the solution gets mature until you have the final correct solution.
您可以解决较小的问题并聚合解决方案，直到您只使用解决方案。 在每个步骤中，手头的问题都会缩小，解决方案会变得成熟，直到您拥有最终正确的解决方案。

Solving the smaller task and applying the same solution repetitively ( or often times recursively) to other chunks give you the result in less time.
解决较小的任务并重复地（或经常递归地）将相同的解决方案应用于其他块，从而在更短的时间内获得结果。
