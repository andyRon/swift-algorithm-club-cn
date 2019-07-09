# 字典树（Trie）

> This topic has been tutorialized [here](https://www.raywenderlich.com/139410/swift-algorithm-club-swift-trie-data-structure)
> 这个话题已经有个辅导[文章](https://www.raywenderlich.com/139410/swift-algorithm-club-swift-trie-data-structure)

## What is a Trie?
## 什么是字典树

A `Trie`, (also known as a prefix tree, or radix tree in some other implementations) is a special type of tree used to store associative data structures. A `Trie` for a dictionary might look like this:
`Trie`（在一些其他实现中也称为前缀树或基数树）是用于存储关联数据结构的特殊类型的树。 `Trie`作为一个字典可能如下所示：

![A Trie](images/trie.png)

Storing the English language is a primary use case for a `Trie`. Each node in the `Trie` would represent a single character of a word. A series of nodes then make up a word.
存储英语是`Trie`的主要用处。 `Trie`中的每个节点都代表一个单词的单个字符。 然后，一系列节点组成一个单词。

## Why a Trie?
## 为什么需要字典树？

Tries are very useful for certain situations. Here are some of the advantages:
字典树对某些情况非常有用。 以下是一些优点：

* Looking up values typically have a better worst-case time complexity.
* Unlike a hash map, a `Trie` does not need to worry about key collisions.
* Doesn't utilize hashing to guarantee a unique path to elements.
* `Trie` structures can be alphabetically ordered by default.

* 查找值通常具有更好的最坏情况时间复杂度。
* 与哈希映射不同，`Trie`不需要担心键冲突。
* 不使用散列来保证元素的唯一路径。
* `Trie`结构默认按字母顺序排列。

## Common Algorithms
## 常用算法

### Contains (or any general lookup method)
### 包含（或任何常规查找方法）

`Trie` structures are great for lookup operations. For `Trie` structures that model the English language, finding a particular word is a matter of a few pointer traversals:
`Trie`结构非常适合查找操作。 对于模拟英语语言的`Trie`结构，找到一个特定的单词就是几个指针遍历的问题：

```swift
func contains(word: String) -> Bool {
	guard !word.isEmpty else { return false }

	// 1
	var currentNode = root
  
	// 2
	var characters = Array(word.lowercased().characters)
	var currentIndex = 0
 
	// 3
	while currentIndex < characters.count, 
	  let child = currentNode.children[characters[currentIndex]] {

	  currentNode = child
	  currentIndex += 1
	}

	// 4
	if currentIndex == characters.count && currentNode.isTerminating {
	  return true
	} else {
	  return false
	}
}
```

The `contains` method is fairly straightforward:

1. Create a reference to the `root`. This reference will allow you to walk down a chain of nodes.
2. Keep track of the characters of the word you're trying to match.
3. Walk the pointer down the nodes.
4. `isTerminating` is a boolean flag for whether or not this node is the end of a word. If this `if` condition is satisfied, it means you are able to find the word in the `trie`.

`contains`方法相当简单：

1. 创建对`root`的引用。 此引用将允许您沿着节点链向下走。
2. 跟踪你想要匹配的单词的字符。
3. 将指针向下移动节点。
4. `isTerminating`是一个布尔标志，表示该节点是否是单词的结尾。 如果满足此`if`条件，则意味着您可以在`trie`中找到该单词。

### Insertion
### 插入

Insertion into a `Trie` requires you to walk over the nodes until you either halt on a node that must be marked as `terminating`, or reach a point where you need to add extra nodes.
插入`Trie`需要您遍历节点，直到您停止必须标记为`terminating`的节点，或者到达需要添加额外节点的点。

```swift
func insert(word: String) {
  guard !word.isEmpty else {
    return
  }

  // 1
  var currentNode = root

  // 2
  for character in word.lowercased().characters {
    // 3
    if let childNode = currentNode.children[character] {
      currentNode = childNode
    } else {
      currentNode.add(value: character)
      currentNode = currentNode.children[character]!
    }
  }
  // Word already present?
  guard !currentNode.isTerminating else {
    return
  }

  // 4
  wordCount += 1
  currentNode.isTerminating = true
}
```

1. Once again, you create a reference to the root node. You'll move this reference down a chain of nodes.
2. Begin walking through your word letter by letter
3. Sometimes, the required node to insert already exists. That is the case for two words inside the `Trie` that shares letters (i.e "Apple", "App"). If a letter already exists, you'll reuse it, and simply traverse deeper down the chain. Otherwise, you'll create a new node representing the letter.
4. Once you get to the end, you mark `isTerminating` to true to mark that specific node as the end of a word.

1. 再次，您创建对根节点的引用。 您将此引用沿着节点链移动。
2. 逐字逐句地逐字逐句
3. 有时，要插入的节点已存在。 这是`Trie`里面两个共享字母的词（即“Apple”，“App”）。如果一个字母已经存在，你将重复使用它，并简单地遍历链条。 否则，您将创建一个表示该字母的新节点。
4. 一旦结束，将`isTerminating`标记为true，将该特定节点标记为单词的结尾。

### Removal
### 删除

Removing keys from the trie is a little tricky, as there are a few more cases you'll need to take into account. Nodes in a `Trie` may be shared between different words. Consider the two words "Apple" and "App". Inside a `Trie`, the chain of nodes representing "App" is shared with "Apple". 
从字典树中删除键有点棘手，因为还有一些情况需要考虑。 `Trie`中的节点可以在不同的单词之间共享。 考虑两个词“Apple”和“App”。 在`Trie`中，代表“App”的节点链与“Apple”共享。

If you'd like to remove "Apple", you'll need to take care to leave the "App" chain in tact.
如果你想删除“Apple”，你需要注意保持“App”链。

```swift
func remove(word: String) {
  guard !word.isEmpty else {
    return
  }

  // 1
  guard let terminalNode = findTerminalNodeOf(word: word) else {
    return
  }

  // 2
  if terminalNode.isLeaf {
    deleteNodesForWordEndingWith(terminalNode: terminalNode)
  } else {
    terminalNode.isTerminating = false
  }
  wordCount -= 1
}
```

1. `findTerminalNodeOf` traverses through the Trie to find the last node that represents the `word`. If it is unable to traverse through the chain of characters, it returns `nil`.
2. `deleteNodesForWordEndingWith` traverse backwords, deleting the nodes represented by the `word`.


1. `findTerminalNodeOf`遍历字典树，找到代表`word`的最后一个节点。 如果它无法遍历字符串，则返回`nil`。
2. `deleteNodesForWordEndingWith`遍历后缀，删除`word`表示的节点。


### Time Complexity
### 时间复杂度

Let n be the length of some value in the `Trie`.
设n是`Trie`中某个值的长度。

* `contains` - 最差情况O(n)
* `insert` - O(n)
* `remove` - O(n)

### Other Notable Operations
### 其他值得注意的操作

* `count`: Returns the number of keys in the `Trie` - O(1)
* `words`: Returns a list containing all the keys in the `Trie` - O(1)
* `isEmpty`: Returns `true` if the `Trie` is empty, `false` otherwise - O(1)

* `count`：返回`Trie`中的键数 —— O(1)
* `words`：返回包含`Trie`中所有键的列表 —— O(1)
* `isEmpty`：如果`Trie`为空则返回`true`，否则返回`false` —— O(1)

扩展阅读[字典树的维基百科](https://en.wikipedia.org/wiki/Trie)

*作者：Christian Encarnacion， Kelvin Lau*  
*翻译：[Andy Ron](https://github.com/andyRon)* 
*校对：[Andy Ron](https://github.com/andyRon)* 

# Changes by Rick Zaccone

* Added comments to all methods
* Refactored the `remove` method
* Renamed some variables.  I have mixed feelings about the way Swift infers types.  It's not always apparent what type a variable will have.  To address this, I made changes such as renaming `parent` to `parentNode` to emphasize that it is a node and not the value contained within the node.
* Added a `words` property that recursively traverses the trie and constructs an array containing all of the words in the trie.
* Added a `isLeaf` property to `TrieNode` for readability.
* Implemented `count` and `isEmpty` properties for the trie.
* I tried stress testing the trie by adding 162,825 words.  The playground was very slow while adding the words and eventually crashed.  To fix this problem, I moved everything into a project and wrote `XCTest` tests that test the trie.  There are also several performance tests.  Everything passes.
