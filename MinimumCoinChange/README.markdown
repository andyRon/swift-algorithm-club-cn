# Minimum Coin Change
# 最小硬币变换

Minimum Coin Change problem algorithm implemented in Swift comparing dynamic programming algorithm design to traditional greedy approach.  
Swift中实现的最小硬币变换问题算法，将动态规划算法设计与传统的贪婪方法进行比较。

Written for Swift Algorithm Club by Jacopo Mangiavacchi

![Coins](eurocoins.gif)

# Introduction
# 介绍

In the traditional coin change problem you have to find all the different ways to change some given money in a particular amount of coins using a given amount of set of coins (i.e. 1 cent, 2 cents, 5 cents, 10 cents etc.).  
在传统的硬币更换问题中，您必须找到使用给定数量的硬币（即1美分，2美分，5美分，10美分等）以特定数量的硬币更改某些给定金钱的所有不同方法。

For example using Euro cents the total of 4 cents value of money can be changed in these possible ways:  
例如，使用欧元美分，可以通过以下方式更改总共4美分的货币价值：

- Four 1 cent coins
- Two 2 cent coins
- One 2 cent coin and two 1 cent coins

 - 四个1美分硬币
 - 两个2美分硬币
 - 一个2美分硬币和两个1美分硬币

The minimum coin change problem is a variation of the generic coin change problem where you need to find the best option for changing the money returning the less number of coins.  
最小的硬币变化问题是一般硬币变化问题的变化，你需要找到最好的选项来更换返还少量硬币的钱。

For example using Euro cents the best possible change for 4 cents are two 2 cent coins with a total of two coins.  
例如，使用欧元美分，4美分的最佳可能变化是两个2美分硬币，总共两个硬币。


# Greedy Solution
# 贪心解决方案

A simple approach for implementing the Minimum Coin Change algorithm in a very efficient way is to start subtracting from the input value the greater possible coin value from the given amount of set of coins available and iterate subtracting the next greater possible coin value on the resulting difference.  
以非常有效的方式实现最小硬币变换算法的一种简单方法是从输入值中减去可用硬币的给定量的硬币值，并迭代减去下一个更大的硬币值。

For example from the total of 4 Euro cents of the example above you can subtract initially 2 cents as  the other biggest coins value (from 5 cents to above) are to bigger for the current 4 Euro cent value. Once used the first 2 cents coin you iterate again with the same logic for the rest of 2 cents and select another 2 cents coin and finally return the two 2 cents coins as the best change.  
例如，从上面示例的总共4欧分，您可以减去最初的2美分，因为其他最大的硬币值（从5美分到以上）对于当前的4欧分值来说要大一些。一旦使用前2美分硬币，你再次使用相同的逻辑迭代2美分的剩余部分并选择另一个2美分硬币，最后返回两个2美分硬币作为最佳变化。

Most of the time the result for this greedy approach is optimal but for some set of coins the result will not be the optimal. 
大多数情况下，这种贪婪方法的结果是最佳的，但对于某些硬币组，结果将不是最佳的。

Indeed, if we use the a set of these three different coins set with values 1, 3 and 4 and execute this  greedy algorithm for asking the best change for the value 6 we will get one coin of 4 and two coins of 1 instead of two coins of 3.  
实际上，如果我们使用设置为值1,3和4的这三个不同硬币的一组并执行这个贪婪算法来询问值6的最佳变化，我们将得到一个4硬币和两个硬币1而不是2 硬币3。


# Dynamic Programming Solution
# 动态编程解决方案

A classic dynamic programming strategy will iterate selecting in order a possible coin from the given amount of set of coins and finding using recursive calls the minimum coin change on the difference from the passed value and the selected coin. For any interaction the algorithm select from all possible combinations the one with the less number of coins used.  
经典的动态编程策略将迭代选择从给定数量的硬币组中的可能硬币，并使用递归调用找到与传递值和所选硬币的差异的最小硬币变化。对于任何交互，算法从所有可能的组合中选择具有较少数量的硬币的组合。

The dynamic programming approach will always select the optimal change but it will require a number of steps that is at least quadratic in the goal amount to change.  
动态编程方法将始终选择最佳变化，但是需要多个步骤，这些步骤至少是要改变的目标量的二次方。

In this Swift implementation in order to optimize the overall performance we use an internal data structure for caching the result for best minimum coin change for previous values.  
在此Swift实现中，为了优化整体性能，我们使用内部数据结构来缓存结果，以便为先前的值进行最佳的最小硬币更改。

