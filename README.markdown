> 注：本项目翻译自[Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club)。  
> 欢迎有兴趣学习算法和数据结构，有时间的小伙伴一起参与翻译，欢迎issue，或者直接提交pull request。  
> [说明和翻译进度](Schedule.markdown)


初次翻译时保留英文+中文，校对后去除英文。


---------------------------------------------------------------
以下是原项目的README.markdown翻译部分(译注：⏳表示还未翻译)
---------------------------------------------------------------



![Swift算法俱乐部](Images/SwiftAlgorithm-410-transp.png)

# 欢迎来到Swift算法俱乐部！

在这里，你可以找到很多流行的算法和数据结构的具体实现，使用的是大家最喜欢的新语言Swift，并对他们的工作原理配有详细的解释。

如果你是一个计算机学院的学生，为了考试想学习一下算法；又或者你是一个自学成才的程序员，想提高一下自身的理论姿势水平 —— 你真是来对地方了！

这个项目的目的是 **解释各种算法的工作方式**。所以我们主要关注代码的清晰性和可读性，而不是为了产出一个可复用的库，让读者可以直接拖进自己的工程使用。换句话说，绝大多数的代码都是可以用于实际的项目中的，不过需要你根据自己的项目需求进行一些调整。

所有的代码都是兼容 **Xcode 9** 以及 **Swift 4** 的。如果 Swift 有更新，我们也会及时跟进。


😍 **欢迎提供建议和贡献！** 😍

## 重要链接

[什么是算法和数据结构？](What%20are%20Algorithms.markdown)－ 薄饼！

[为什么要学习算法？](Why%20Algorithms.markdown)－ 还在担心这不是你的菜吗？请读一下这篇文章。

[大O表示法](Big-O%20Notation.markdown)－ 我们经常会听到这样的话：“这个算法是 **O(n)** 的”。如果你不知道这是啥意思，请读读这篇文章。

[算法设计技巧](Algorithm%20Design.markdown)－ 怎样设计自己的算法？

欢迎参与贡献 － 通过留下issue反馈，或者提交pull request。

## 从哪开始？

如果你之前没有接触过算法和数据结构，你可以从下面这些简单易懂的算法开始看起：

- [栈](Stack/)
- [队列](Queue/)
- [插入排序](Insertion%20Sort/)
- [二分搜索](Binary%20Search/) 和 [二分搜索树](Binary%20Search%20Tree/)
- [归并排序](Merge%20Sort/)
- [Boyer-Moore字符串搜索](Boyer-Moore-Horspool/)

## 算法列表

### 搜索算法

- [线性搜索](Linear%20Search/)	从数组中查找某个元素。
- [二分搜索](Binary%20Search/)	从已排序的数组中快速查找元素。
- [统计出现次数](Count%20Occurrences/)	统计某个值在数组中的出现次数。
- [查找最大／最小值](Select%20Minimum%20Maximum)	找到数组中的最大／最小值。
- [第K大元素](Kth%20Largest%20Element/)	找到数组中的第 **K** 大元素，例如中位数。
- [选取样本](Selection%20Sampling/)	随机地从集合中选取一些元素作为样本。
- [并查集](Union-Find/)	保持一些不相交的集合，帮助你快速合并它们。

### 字符串搜索算法

- [暴力字符串搜索算法](Brute-Force%20String%20Search/)	一个简单粗暴的方法。
- [Boyer-Moore算法](Boyer-Moore-Horspool/)	一种高效的字符串子串搜索算法。它不需要对被搜索的字符串中的字符进行逐一比较，而是根据一个查找表跳过其中的某些部分。
- [Knuth-Morris-Pratt(KMP)算法](Knuth-Morris-Pratt/)	一种线性时间字符串算法，它获得字符串出现的已经给定模型字符串的索引。
- [Rabin-Karp 算法]	使用哈希的快速搜索
- [最长公共子序列算法](Longest%20Common%20Subsequence/)	找到两个字符串中的最长公共子序列。
- [Z-Algorithm](Z-Algorithm/)	在String中查找模式的所有实例，并返回模式在String中开始的索引。

### 排序算法

探究排序算法的工作原理是非常有趣的，但在实际的编码中，你几乎永远也不会需要自己编写排序算法，Swift 自带的 `sort()` 函数已经非常够用了，但如果你还是好奇背后的原理，请继续阅读。

基本的排序算法：

- [插入排序](Insertion%20Sort/)
- [选择排序](Selection%20Sort/)
- [希尔排序](Shell%20Sort/)

快速的排序算法：

- [快速排序](Quicksort/)
- [归并排序](Merge%20Sort/)
- [堆排序](Heap%20Sort/)

混合排序算法：
- [内省排序](Introsort/)

特殊的排序算法

- [计数排序](Counting%20Sort/)
- [基数排序](Radix%20Sort/)
- [拓扑排序](Topological%20Sort/)

不好的排序算法（知道就行了，不要用！）：

- [冒泡排序](Bubble%20Sort/)
- [慢排序](Slow%20Sort/)

### 压缩算法

- [变动长度编码法(RLE)](Run-Length%20Encoding/)	将重复的值存储为一个单字节及其计数。
- [哈夫曼编码](Huffman%20Coding/)	将常见的元素使用更小的单位存储。

### 杂项

- [洗牌算法](Shuffle/)	随机搅乱数组中的内容。
- [梳排序](Comb%20Sort/)	冒泡排序算法的改进。
- [凸包算法](Convex%20Hull/)
- [Miller-Rabin素性检测](Miller-Rabin%20Primality%20Test/). Is the number a prime number?
- [MinimumCoinChange](MinimumCoinChange/). A showcase for dynamic programming.

### 数学算法

- [最大公约数算法(GCD)](GCD/)－特殊福利：最小公倍数算法。
- [排列组合算法](Combinatorics/)－还记得高中学过俄组合数学吗？
- [调度场算法](Shunting%20Yard/)－用于将中缀表达式转换为后缀表达式的经典算法。
- [⏳karatsuba乘法](Karatsuba%20Multiplication/). Another take on elementary multiplication.
- [⏳Haversine Distance](HaversineDistance/). Calculating the distance between 2 points from a sphere.
- [⏳Strassen's Multiplication Matrix](Strassen%20Matrix%20Multiplication/). Efficient way to handle matrix multiplication.

### 机器学习

- [k-Means 聚类算法](K-Means/)－无监督的分类器，将数据聚类为 K 个簇。
- ⏳K-近邻算法
- ⏳线性回归
- ⏳逻辑回归
- ⏳神经网络
- ⏳网页排名算法
- [⏳Naive Bayes Classifier](Naive%20Bayes%20Classifier/)


## 数据结构

对于特定的任务，数据结构的选择需要基于以下几点考量。

首先，你的数据是具有某种形态的，并且有一些必要的操作方法。如果你想基于关键字来查找对象，需要的是字典类型的数据结构；如果你的数据原生就是分层级的，就需要某种类型的树形结构；而如果你的数据是线性的，则你需要的是数据结构可能就是栈或队列等。

其次，具体的选择还与你在实际使用中最常用的操作方法有关，因为不同的数据结构都对不同的操作方法做了优化。举例来说，如果你经常需要获取集合中的某些较为重要的元素，那么使用堆或优先队列就比普通的数组要好很多。

绝大多数情况下，使用 Swift 内建的 `Array`、`Dictinary`、`Set` 就足够高效了，但某些时候，可能还是需要某些更合适的数据结构...

### 数组变体

- [二维数组](Array2D/)－固定尺寸的二维数组，可用于棋盘游戏。
- [比特集](Bit%20Set/)－**n** 位大小固定尺度的序列。
- [固定长度数组](Fixed%20Size%20Array/) - 如果你确切的知道数据的大小，使用老式的固定长度的数组会更加高效。
- [有序数组](Ordered%20Array/)－一个永远有序的数组。
- [⏳Rootish Array Stack](Rootish%20Array%20Stack/). A space and time efficient variation on Swift arrays.

### 队列

- [栈](Stack/)－后进先出！
- [队列](Queue/)－先进先出！
- [双端队列](Deque/)
- [优先队列](Priority%20Queue)－一个保持最重要的元素总是在最前面的队列。
- [有限优先队列](Bounded%20Priority%20Queue)－元素最大数受限制的优先队列。 :construction:
- [环形缓冲区](Ring%20Buffer/)－一个语义上的固定大小的环形缓冲区，实际使用的是一维序列头尾相接实现。

### 列表

- [链表](Linked%20List/)－链接起来的数据序列。包含单向和双向链表。
- [跳跃列表](Skip-List/) —— 跳过列表是一种概率数据结构，具有与AVL/或红黑树相同的对数时间限制和效率，并提供了有效支持搜索和更新操作的巧妙折衷。

### 树

- [树](Tree/)－通用目的的树形结构。
- [二叉树](Binary%20Tree/)－一种节点最多有两个孩子节点的树形结构。
- [二叉搜索树(BST)](Binary%20Search%20Tree/)－以某种方式组织自己的节点的二叉树，以求较快的查询速度。
- [AVL树](AVL%20Tree/)－一种通过旋转来维持平衡的二叉搜索树。 :construction:
- [红黑树](Red-Black%20Tree/). A self balancing binary search tree.
- [伸展树](Splay%20Tree/). A self balancing binary search tree that enables fast retrieval of recently updated elements.
- [线索二叉树](Threaded%20Binary%20Tree/). A binary tree that maintains a few extra variables for cheap and fast in-order traversals.
- [线段树](Segment%20Tree/)－能够快速地对某区间进行计算。
  - [Lazy Propagation](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Segment%20Tree/LazyPropagation)
- ⏳k-d 树
- [ST(稀疏表)算法](Sparse%20Table/). Another take on quickly computing a function over a portion of an array, but this time we'll make it even quicker!.
- [堆](Heap/)－存储在一维数组中的二叉树，所以它不需要使用指针。很适合做为优先队列使用。
- ⏳斐波那契堆
- [字典树(Trie)](Trie/). A special type of tree used to store associative data structures.
- [B 树](B-Tree/). A self-balancing search tree, in which nodes can have more than two children.
- [四分树](QuadTree/). A tree with 4 children.
- [八叉树](Octree/). A tree with 8 children.

### 哈希

- [哈希表](Hash%20Table/)－允许你通过一个关键词来存取数据。字典通常都是基于哈希表实现的。
- ⏳哈希函数

### 集合

- [布隆过滤器](Bloom%20Filter/)－一个常量内存数据结构，用于概率性的检测某个元素是否在集合中。
- [哈希集合](Hash%20Set/)－使用哈希表实现的集合。
- [多重集](Multiset/). A set where the number of times an element is added matters. (Also known as a bag.)
- [有序集](Ordered%20Set/)－很看重元素顺序的集合。

### 图

- [图](Graph/)
- [广度优先搜索(BFS)](Breadth-First%20Search/)
- [深度优先搜索(DFS)](Depth-First%20Search/)
- [最短路径算法](Shortest%20Path%20%28Unweighted%29/)－作用对象为无权值树。
- [单源最短路径算法](Single-Source%20Shortest%20Paths%20(Weighted)/)

- [最小生成树(未加权图)](Minimum%20Spanning%20Tree%20%28Unweighted%29/)－作用对象为无权值树。
- [最小生成树(加权图)](Minimum%20Spanning%20Tree/)

- [任意两点间的最短路径算法](All-Pairs%20Shortest%20Paths/)
- [⏳迪杰斯特拉算法(Dijkstra's shortest path algorithm)](Dijkstra%20Algorithm/)

## 智力题

很多程序员在面试时都会被问到一些算法性质的智力题。这里只囊括了一点比较有趣的。想了解更多的智力题（及答案），请浏览[这里](http://elementsofprogramminginterviews.com/)，还有[这里](http://www.crackingthecodinginterview.com)。

- [⏳二和问题](Two-Sum%20Problem/)
- [⏳Three-Sum/Four-Sum Problem](3Sum%20and%204Sum/)
- [⏳Fizz Buzz](Fizz%20Buzz/)
- [⏳蒙提霍尔问题](Monty%20Hall%20Problem/)
- [⏳Finding Palindromes](Palindromes/)
- [⏳Dining Philosophers](DiningPhilosophers/)
- [⏳Egg Drop Problem](Egg%20Drop%20Problem/)
- [⏳Encoding and Decoding Binary Tree](Encode%20and%20Decode%20Tree/)


## 贡献者

Swift算法俱乐部最初是由[Matthijs Hollemans](https://github.com/hollance) 创建。 

现在主要是[Vincent Ngo](https://www.raywenderlich.com/u/jomoka) 和 [Kelvin Lau](https://github.com/kelvinlauKL) 维护。

Swift算法俱乐部是来自[raywenderlich.com](https://www.raywenderlich.co)社区的[许多数算法成员](https://github.com/rwenderlich/swift-algorithm-club/graphs/contributors)的一起合作努力的成果。

## 许可(License)

所有内容均根据MIT开源许可条款获得许可。

通过在此发布或通过此论坛提交任何pull request，即表示您同意您提交或创建的所有内容（包括代码和文本）均受此许可证的约束。 Razeware，LLC和其他人将拥有许可中描述的有关此内容的所有权利。 可以在[此处](https://github.com/raywenderlich/swift-algorithm-club/blob/master/LICENSE.txt)找到许可的准确条款。

[![Build Status](https://travis-ci.org/raywenderlich/swift-algorithm-club.svg?branch=master)](https://travis-ci.org/raywenderlich/swift-algorithm-club)
