# B树（B-Tree）

A B-Tree is a self-balancing search tree, in which nodes can have more than two children.
B-Tree是一种自平衡搜索树，其中节点可以有两个以上的子节点。

### Properties
### 性质

A B-Tree of order *n* satisfies the following properties:
 - Every node has at most *2n* keys.
 - Every node (except root) has at least *n* keys.
 - Every non-leaf node with *k* keys has *k+1* children.
 - The keys in all nodes are sorted in increasing order. 
 - The subtree between two keys *k* and *l* of a non-leaf node contains all the keys between *k* and *l*.
 - All leaves appear at the same level.

B树排序满足以下性质：
  - 每个节点最多有 *2n* 个键。
  - 每个节点（root除外）至少有 *n* 个键。
  - 每个带有 *k* 个键的非叶节点都有 *k+1* 个子节点。
  - 所有节点中的键按递增顺序排序。
  - 非叶节点的两个键 *k* 和 *l* 之间的子树包含 *k* 和 *l* 之间的所有键。
  - 所有叶节点出现在同一水平。

A second order B-Tree with keys from 1 to 20 looks like this:
带有1到20键的二阶B-Tree看起来像这样：

![A B-Tree with 20 keys.](Images/BTree20.png)

### The representation of a B-Tree node in code
### 代码中B树节点的表示

```swift
class BTreeNode<Key: Comparable, Value> {
  unowned var owner: BTree<Key, Value>
  
  fileprivate var keys = [Key]()
  var children: [BTreeNode]?
  
  ...
}
```

The main parts of a node are two arrays:
 - An array containing the keys
 - An array containing the children

节点的主要部分是两个数组属性：
  - 包含键的数组
  - 包含子项的数组

![Node.](Images/Node.png)

Nodes also have a reference to the tree they belong to.  
This is necessary because nodes have to know the order of the tree.

节点还引用了它们所属的树。
这是必要的，因为节点必须知道树的排序。

*Note: The array containing the children is an Optional, because leaf nodes don't have children.*
*注意：包含子节点的数组是可选的，因为叶节点没有子节点。*

## Searching
## 搜索

1. Searching for a key `k` begins at the root node.
2. We perform a linear search on the keys of the node, until we find a key `l` that is not less than `k`,  
   or reach the end of the array.
3. If `k == l` then we have found the key.
4. If `k < l`: 
    - If the node we are on is not a leaf, then we go to the left child of `l`, and perform the steps 3 - 5 again.
    - If we are on a leaf, then `k` is not in the tree.
5. If we have reached the end of the array:
    - If we are on a non-leaf node, then we go to the last child of the node, and perform the steps 3 - 5 again.
    - If we are on a leaf, then `k` is not in the tree.

1. 从根节点开始搜索键`k`。
2. 我们对节点的键进行线性搜索，直到找到一个不小于`k`的键`l`，或到达数组的末尾。
3. 如果`k == l`那么我们找到了键。
4. 如果`k <l`：
     - 如果我们所在的节点不是叶节点，那么我们转到`l`的左子节点，然后再次执行步骤3 - 5。
     - 如果我们在叶子节点，那么`k`不在树上。
5. 如果我们到达了数组的末尾：
     - 如果我们在非叶节点上，那么我们转到节点的最后一个子节点，然后再次执行步骤3 - 5。
     - 如果我们在叶子上，那么`k`不在树上。

### 代码


`value(for:)` method searches for the given key and if it's in the tree,  
it returns the value associated with it, else it returns `nil`.
`value(for:)`方法搜索给定的键，如果它在树中，它返回与之关联的值，否则返回`nil`。

## Insertion
## 插入

Keys can only be inserted to leaf nodes.
键只能插入叶节点。

1. Perform a search for the key `k` we want to insert.
2. If we haven't found it and we are on a leaf node, we can insert it.
 - If after the search the key `l` which we are standing on is greater than `k`:  
   We insert `k` to the position before `l`.
 - Else:  
   We insert `k` to the position after `l`.

1. 搜索我们要插入的键`k`。
2. 如果我们没有找到它并且我们在叶节点上，我们可以插入它。
  - 如果在搜索之后我们所在的键`l`大于`k`：
    我们在`l`之前插入`k`。
  - 否则：
    我们在`l`之后插入`k`。

After insertion we should check if the number of keys in the node is in the correct range.  
If there are more keys in the node than `order*2`, we need to split the node.
插入后，我们应检查节点中的键数是否在正确的范围内。如果节点中的键多于`order * 2`，我们需要拆分节点。

#### Splitting a node
#### 拆分节点

1. Move up the middle key of the node we want to split, to its parent (if it has one).  
2. If it hasn't got a parent(it is the root), then create a new root and insert to it.  
   Also add the old root as the left child of the new root.
3. Split the node into two by moving the keys (and children, if it's a non-leaf) that were after the middle key
   to a new node.  
4. Add the new node as a right child for the key that we have moved up.  

1. 将我们要拆分的节点的中间键向上移动到其父节点（如果有的话）。
2. 如果它没有父（它是根节点），则创建一个新根节点并插入它。还要将旧根节点添加为新根节点的左子节点。
3. 通过移动中间键之后的键（以及子项，如果它是非叶子）将节点拆分为两个到一个新节点。
4. 将新节点添加为我们向上移动的键的右子节点。

After splitting a node it is possible that the parent node will also contain too many keys, so we need to split it also.  
In the worst case the splitting goes up to the root (in this case the height of the tree increases).
拆分节点后，父节点可能也包含太多的键，因此我们也需要拆分它。
在最坏的情况下，分裂上升到根（在这种情况下，树的高度增加）。

An insertion to a first order tree looks like this:
对第一个顺序树的插入如下所示：

![Splitting](Images/InsertionSplit.png)

### The code

The method `insert(_:for:)` does the insertion.
After it has inserted a key, as the recursion goes up every node checks the number of keys in its child.  
if a node has too many keys, its parent calls the `split(child:atIndex:)` method on it.
方法 `insert(_:for:)` 进行插入。
插入键后，随着递归的增加，每个节点都会检查其子节点中的键数。
如果一个节点有太多的键，它的父节点就会调用 `split(child:atIndex:)` 方法。

The root node is checked by the tree itself.  
If the root has too many nodes after the insertion the tree calls the `splitRoot()` method.
根节点由树本身检查。
如果插入后根有太多节点，则树会调用`splitRoot()`方法。

## Removal
## 删除

Keys can only be removed from leaf nodes.

1. Perform a search for the key `k` we want to remove.
2. If we have found it:
   - If we are on a leaf node:  
     We can remove the key.
   - Else:  
     We overwrite `k` with its inorder predecessor `p`, then we remove `p` from the leaf node.

只能从叶节点中删除键。

1.搜索我们要删除的键`k`。
2.如果我们找到了它：
    - 如果我们在叶子节点上：
      我们可以删除键。
    - 否则：
      我们用它的前驱节点`p`覆盖`k`，然后我们从叶节点中删除`p`。

After a key have been removed from a node we should check that the node has enough keys.
If a node has fewer keys than the order of the tree, then we should move a key to it,  
or merge it with one of its siblings.
从节点中删除键后，我们应该检查节点是否有足够的键。如果一个节点的键少于树的规定，那么我们应该移动一个键，或者与其中一个兄弟节点合并。

#### Moving a key to the child
#### 将键移给子节点

If the problematic node has a nearest sibling that has more keys than the order of the tree,  
we should perform this operation on the tree, else we should merge the node with one of its siblings.
如果有问题的节点具有最近的兄弟节点，其具有比树规定的更多的键，我们应该在树上执行此操作，否则我们应该将节点与其中一个兄弟节点合并。

Let's say the child we want to fix `c1` is at index `i` in its parent node's children array.
假设我们要修复`c1`的子节点在其父节点的children数组中的索引`i`。

If the child `c2` at index `i-1` has more keys than the order of the tree:  
如果索引`i-1`中的子节点`c2`的键数多于树的规定：

1. We move the key at index `i-1` from the parent node to the child `c1`'s keys array at index `0`.
2. We move the last key from `c2` to the parent's keys array at index `i-1`.
3. (If `c1` is non-leaf) We move the last child from `c2` to `c1`'s children array at index 0.

1. 我们将索引`i-1`的键从父节点移动到索引为`0`的子节点`c1`的keys数组。
2. 我们将最后一个键从`c2`移动到索引`i-1`的父键数组。
3. （如果`c1`是非叶节点）我们将最后一个子节点从`c2`移动到`c1`的子数组，在索引0处。

Else:  

1. We move the key at index `i` from the parent node to the end of child `c1`'s keys array.
2. We move the first key from `c2` to the parent's keys array at index `i`.
3. (If `c1` isn't a leaf) We move the first child from `c2` to the end of `c1`'s children array. 

另外：
1. 我们将索引`i`的键从父节点移动到子节点`c1`的keys数组的末尾。
2. 我们将第一个键从`c2`移动到索引`i`的父keys数组。
3. （如果`c1`不是叶几点）我们将第一个子节点从`c2`移动到`c1`的children数组的末尾。

![Moving Key](Images/MovingKey.png)

#### Merging two nodes
#### 合并两个节点

Let's say we want to merge the child `c1` at index `i` in its parent's children array.
假设我们想要在父节点的子数组中将索引`i`处的子节点`c1`合并。

If `c1` has a left sibling `c2`:
如果`c1`有一个左兄弟节点`c2`：

1. We move the key from the parent at index `i-1` to the end of `c2`'s keys array.
2. We move the keys and the children(if it's a non-leaf) from `c1` to the end of `c2`'s keys and children array.
3. We remove the child at index `i-1` from the parent node.

1. 我们将密钥从索引“i-1”的父级移动到“c2”的密钥数组的末尾。
2. 我们将键和子项（如果它是非叶子）从`c1`移动到`c2`的键和子数组的末尾。
3. 我们从父节点删除索引“i-1”的子节点。

Else if `c1` only has a right sibling `c2`:
否则，如果`c1`只有一个右兄弟节点`c2`：

1. We move the key from the parent at index `i` to the beginning of `c2`'s keys array.
2. We move the keys and the children(if it's a non-leaf) from `c1` to the beginning of `c2`'s keys and children array.
3. We remove the child at index `i` from the parent node.

1. 我们将键从索引`i`的父节点移动到`c2`的keys数组的开头。
2. 我们将键和子节点（如果它是非叶节点）从`c1`移动到`c2`的keys和children数组的开头。
3. 我们从父节点删除索引`i`处的子节点。

After merging it is possible that now the parent node contains too few keys,  
so in the worst case merging also can go up to the root, in which case the height of the tree decreases.
合并后，现在父节点可能包含太少的键，所以在最坏的情况下，合并也可以到达根，在这种情况下，树的高度会降低。

![Merging Nodes](Images/MergingNodes.png)

### 代码

- `remove(_:)` method removes the given key from the tree. After a key has been deleted,  
  every node checks the number of keys in its child. If a child has less nodes than the order of the tree,
  it calls the `fix(childWithTooFewKeys:atIndex:)` method.  

- `fix(childWithTooFewKeys:atIndex:)` method decides which way to fix the child (by moving a key to it,
  or by merging it), then calls `move(keyAtIndex:to:from:at:)` or 
  `merge(child:atIndex:to:)` method according to its choice.


- `remove(_:)`方法从树中删除给定的键。 删除键后，每个节点都会检查其子节点中的键数。 如果子树中节点数少于树的规定，
   它调用`fix(childWithTooFewKeys:atIndex:)` 方法。

- `fix(childWithTooFewKeys:atIndex:)`方法可以修复子节点的方法（通过移动一个键，或者通过合并它），然后根据选择调用`move(keyAtIndex:to:from:at:)`或 `fix(childWithTooFewKeys:atIndex:)` 。

## 扩展阅读


[B树维基百科](https://en.wikipedia.org/wiki/B-tree)  
[GeeksforGeeks](http://www.geeksforgeeks.org/b-tree-set-1-introduction-2/)



*作者：Viktor Szilárd Simkó*  
*翻译：[Andy Ron](https://github.com/andyRon)*
*校对：[Andy Ron](https://github.com/andyRon)*