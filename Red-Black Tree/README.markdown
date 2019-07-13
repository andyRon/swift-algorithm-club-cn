# 红黑树(Red-Black Tree)

A red-black tree (RBT) is a balanced version of a [Binary Search Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree) guaranteeing that the basic operations (search, predecessor, successor, minimum, maximum, insert and delete) have a logarithmic worst case performance.
红黑树（RBT）是[二叉搜索树](https://github.com/andyRon/swift-algorithm-club-cn/tree/master/Binary%20Search%20Tree)的平衡版本，保证基本操作（搜索，前驱，后继，最小，最大，插入和删除）具有对数最坏情况的性能。

Binary search trees (BSTs) have the disadvantage that they can become unbalanced after some insert or delete operations. In the worst case, this could lead to a tree where the nodes build a linked list as shown in the following example:
二叉搜索树（BST）的缺点是它们在一些插入或删除操作之后可能变得不平衡。 在最坏的情况下，这可能会变成链表的树，如以下示例所示：

> **译注：**链表可看作是树的简单版本。

```
a
  \
   b
    \
     c
      \
       d
```
To prevent this issue, RBTs perform rebalancing operations after an insert or delete and store an additional color property at each node which can either be red or black. After each operation a RBT satisfies the following properties:
为了防止出现此问题，RBT在插入或删除后执行重新平衡操作，并在每个节点上存储额外颜色属性，可以是红色或黑色。 每次操作后，RBT都满足以下属性：

## Properties
## 性质

1. Every node is either red or black
2. The root is black
3. Every leaf (nullLeaf) is black
4. If a node is red, then both its children are black
5. For each node, all paths from the node to descendant leaves contain the same number of black nodes

1. 每个节点都是红色或黑色
2. 根节点是黑色的
3. 叶节点（nullLeaf）都是黑色的
4. 如果节点为红色，则其子节点均为黑色
5. 对于每个节点，从节点到后代叶子的所有路径都包含相同数量的黑色节点

Property 5 includes the definition of the black-height of a node x, bh(x), which is the number of black nodes on a path from this node down to a leaf not counting the node itself.
From [CLRS]
性质5包括节点x的黑色高度的定义，bh(x)，它是从该节点到不计算节点本身的叶子的路径上的黑色节点的数量。（来自 [CLRS]）

> **译注：** CLRS 是指[《算法导论》](https://book.douban.com/subject/20432061/)，CLRS是四位作者的首字母组合。

## Methods
## 方法

Nodes:
* `nodeX.getPredecessor()` Returns the inorder predecessor of nodeX
* `nodeX.getSuccessor()` Returns the inorder successor of nodeX
* `nodeX.minimum()` Returns the node with the minimum key of the subtree of nodeX
* `nodeX.maximum()` Returns the node with the maximum key of the subtree of nodeX
Tree:
* `search(input:)` Returns the node with the given key value
* `minValue()` Returns the minimum key value of the whole tree
* `maxValue()` Returns the maximum key value of the whole tree
* `insert(key:)` Inserts the key value into the tree
* `delete(key:)` Delete the node with the respective key value from the tree
* `verify()` Verifies that the given tree fulfills the red-black tree properties

The rotation, insertion and deletion algorithms are implemented based on the pseudo-code provided in [CLRS]

节点：
* `nodeX.getPredecessor()` 返回未排序的前驱节点
* `nodeX.getSuccessor()` 返回inorder的后继节点
* `nodeX.minimum()` 返回具有nodeX子树最小键的节点
* `nodeX.maximum()` 返回具有nodeX子树的最大键的节点
树：
* `search(input:)` 返回具有给定键值的节点
* `minValue()` 返回整个树的最小键值
* `maxValue()`返回整个树的最大键值
* `insert(key:)` 将键值插入树中
* `delete(key:)` 使用树中相应的键值删除节点
* `verify()` 验证给定的树是否满足红黑树属性

旋转，插入和删除算法基于[CLRS]中提供的伪代码实现

## Implementation Details
## 实现细节

For convenience, all nil-pointers to children or the parent (except the parent of the root) of a node are exchanged with a nullLeaf. This is an ordinary node object, like all other nodes in the tree, but with a black color, and in this case a nil value for its children, parent and key. Therefore, an empty tree consists of exactly one nullLeaf at the root.
为方便起见，所有指向子节点的nil指针或节点的父节点（根节点的父节点）都与nullLeaf交换。 这是一个普通的节点对象，就像树中的所有其他节点一样，但是使用黑色，在这种情况下，它的子节点是父节点和键的nil值。 因此，空树在根处只包含一个nullLeaf。

## Rotation
## 旋转

Left rotation (around x):
Assumes that x.rightChild y is not a nullLeaf, rotates around the link from x to y, makes y the new root of the subtree with x as y's left child and y's left child as x's right child, where n = a node, [n] = a subtree
左旋（围绕x）：
假设x的右子节点（x.rightChild）y不是nullLeaf，围绕从x到y的链接旋转，使y成为子树的新根节点，x为y的左子节点，y的左子节点（[B]）为x的右子节点，其中 n = a node, [n] = a subtree。

```
      |                |
      x                y
    /   \     ~>     /   \
  [A]    y          x    [C]
        / \        / \
      [B] [C]    [A] [B]
```

Right rotation (around y):
Assumes that y.leftChild x is not a nullLeaf, rotates around the link from y to x, makes x the new root of the subtree with y as x's right child and x's right child as y's left child, where n = a node, [n] = a subtree
右旋（围绕y）：
假设y的左子节点（y.leftChild）x不是nullLeaf，围绕从y到x的链接旋转，使x成为子树的新根节点，其中y为x的右子节点，x的右子节点为y的左子节点，其中 n = a node, [n] = a subtree。

```
      |                |
      x                y
    /   \     <~     /   \
  [A]    y          x    [C]
        / \        / \
      [B] [C]    [A] [B]
```
As rotation is a local operation only exchanging pointers it's runtime is O(1).
由于旋转是仅交换指针的本地操作，因此它的运行时为O(1)。

## Insertion
## 插入

We create a node with the given key and set its color to red. Then we insert it into the the tree by performing a standard insert into a BST. After this, the tree might not be a valid RBT anymore, so we fix the red-black properties by calling the insertFixup algorithm.
The only violation of the red-black properties occurs at the inserted node z and its parent. Either both are red, or the parent does not exist (so there is a violation since the root must be black).
我们用给定的键创建一个节点，并将其颜色设置为红色。 然后我们通过在BST中执行标准插入将其插入树中。 在此之后，树可能不再是有效的RBT，因此我们通过调用insertFixup算法来修复红黑属性。
唯一违反红黑属性的情况发生在插入的节点z及其父节点上。 两者都是红色，或者父级不存在（存在违规，因为根必须是黑色）。

We have three distinct cases:
**Case 1:** The uncle of z is red. If z.parent is left child, z's uncle is z.grandparent's right child. If this is the case, we recolor and move z to z.grandparent, then we check again for this new z. In the following cases, we denote a red node with (x) and a black node with {x}, p = parent, gp = grandparent and u = uncle
我们有三个不同的案例：
**案例1：** z的叔节点是红色的。 如果z.parent是左子节点，z的叔节点是z.grandparent的右子节点。 如果是这种情况，我们重新着色并将z移动到z.grandparent，然后我们再次检查这个新z。 在下面的例子中，我们用 `(x)`表示红色节点，用`{x}`表示黑色节点，`p` = 父节点，`gp` = 祖父节点，`u` = 叔节点

```
         |                   |
        {gp}               (newZ)
       /    \     ~>       /    \
    (p)     (u)         {p}     {u}
    / \     / \         / \     / \
  (z)  [C] [D] [E]    (z) [C] [D] [E]
  / \                 / \
[A] [B]             [A] [B]

```

**Case 2a:** The uncle of z is black and z is right child. Here, we move z upwards, so z's parent is the newZ and then we rotate around this newZ. After this, we have Case 2b.
**案例2a：** z的叔节点是黑色，z是右子节点。 在这里，我们将z向上移动，假设z的父级是newZ，然后我们围绕这个newZ旋转。 在此之后，我们有下面案例2b。

```
         |                   |
        {gp}                {gp}
       /    \     ~>       /    \
    (p)      {u}         (z)     {u}
    / \      / \         / \     / \
  [A]  (z)  [D] [E]  (newZ) [C] [D] [E]
       / \            / \
     [B] [C]        [A] [B]

```

**Case 2b:** The uncle of z is black and z is left child. In this case, we recolor z.parent to black and z.grandparent to red. Then we rotate around z's grandparent. Afterwards we have valid red-black tree.
**案例2b：** z的叔节点是黑色而z是左子节点。 在这种情况下，我们将z.parent重新着色为黑色，将z.grandparent重新着色为红色。 然后我们围绕z的祖父母转动。 之后我们有了有效的红黑树。

```
         |                   |
        {gp}                {p}
       /    \     ~>       /    \
    (p)      {u}         (z)    (gp)
    / \      / \         / \     / \
  (z)  [C] [D] [E]    [A] [B]  [C]  {u}
  / \                               / \
[A] [B]                           [D] [E]

```

Running time of this algorithm: 
* Only case 1 may repeat, but this only h/2 steps, where h is the height of the tree
* Case 2a -> Case 2b -> red-black tree
* Case 2b -> red-black tree
As we perform case 1 at most O(log n) times and all other cases at most once, we have O(log n) recolorings and at most 2 rotations. 
The overall runtime of insert is O(log n).
该算法的运行时间：
* 只有案例1可以重复，但这只有h/2步，其中h是树的高度
* 案例2a -> 案例2b -> 红黑树
* 案例2b -> 红黑树
由于我们在最多O(log n)次执行情况1并且所有其他情况最多执行一次，我们有O(log n)重新着色并且最多2次旋转。
插入操作的整个运行时间为O(log n)。

## Deletion
## 删除

We search for the node with the given key, and if it exists we delete it by performing a standard delete from a BST. If the deleted nodes' color was red everything is fine, otherwise red-black properties may be violated so we call the fixup procedure deleteFixup.
Violations can be that the parent and child of the deleted node x where red, so we now have two adjacent red nodes, or if we deleted the root, the root could now be red, or the black height property is violated.
We have 4 cases: We call deleteFixup on node x
**Case 1:** The sibling of x is red. The sibling is the other child of x's parent, which is not x itself. In this case, we recolor the parent of x and x.sibling then we left rotate around x's parent. In the following cases s = sibling of x, (x) = red, {x} = black, |x| = red/black.
我们使用给定key搜索节点，如果存在，我们通过从BST执行标准删除来删除它。 如果删除的节点的颜色为红色，则一切正常，否则可能会违反红黑属性，因此我们调用修复程序`deleteFixup`。
违规可能使是已删除节点x的父节点和子节点都为红色，因此我们现在有两个相邻的红色节点，或者如果我们删除了根节点，而新根节点可能是红色，或者违反了黑色高度属性。
我们有4种情况：我们在节点x上调用 `deleteFixup`
**案例1：** x的兄弟节点是红色的。 兄弟节点是x的父节点的另子节点，而不是x本身。 在这种情况下，我们重新着色x和x.sibling的父节点，然后我们围绕x的父级旋转。 在下列情况下，s = x的兄弟节点，（x）= 红色，{x} = 黑色，|x| = 红色/黑色。

```
        |                   |
       {p}                 {s}
      /    \     ~>       /    \
    {x}    (s)         (p)     [D]
    / \    / \         / \     
  [A] [B] [C] [D]    {x} [C]
                     / \  
                   [A] [B]

```

**Case 2:** The sibling of x is black and has two black children. Here, we recolor x.sibling to red, move x upwards to x.parent and check again for this newX.
**案例2：** x的兄弟节点是黑色，有两个黑色子节点。 在这里，我们将x.sibling重新着色为红色，将x向上移动到x.parent并再次检查此newX。

```
        |                    |
       |p|                 |newX|
      /    \     ~>       /     \
    {x}     {s}          {x}     (s)
    / \    /   \          / \   /   \
  [A] [B] {l}  {r}     [A] [B] {l}  {r}
          / \  / \             / \  / \
        [C][D][E][F]         [C][D][E][F]

```

**Case 3:** The sibling of x is black with one black child to the right. In this case, we recolor the sibling to red and sibling.leftChild to black, then we right rotate around the sibling. After this we have case 4.
**案例3：** x的兄弟节点是黑色，右边有一个黑色子节点。 在这种情况下，我们将兄弟重新着色为红色和sibling.leftChild为黑色，然后我们右旋转兄弟。 在此之后我们有案例4。

```
        |                    |
       |p|                  |p|
      /    \     ~>       /     \
    {x}     {s}          {x}     {l}
    / \    /   \         / \    /   \
  [A] [B] (l)  {r}     [A] [B] [C]  (s)
          / \  / \                  / \
        [C][D][E][F]               [D]{e}
                                      / \
                                    [E] [F]

```

**Case 4:** The sibling of x is black with one red child to the right. Here, we recolor the sibling to the color of x.parent and x.parent and sibling.rightChild to black. Then we left rotate around x.parent. After this operation we have a valid red-black tree. Here, ||x|| denotes that x can have either color red or black, but that this can be different to |x| color. This is important, as s gets the same color as p.
**案例4：** x的兄弟节点是黑色，右边是一个红色的孩子。 在这里，我们将兄弟重新着色为x.parent和x.parent以及sibling.rightChild的颜色为黑色。 然后我们左右旋转x.parent。 在此操作之后，我们有一个有效的红黑树。 这里，||x|| 表示x可以是红色或黑色，但这可能与|x|不同 颜色。 这很重要，因为s与p具有相同的颜色。

```
        |                        |
       ||p||                   ||s||
      /    \     ~>           /     \
    {x}     {s}              {p}     {r}
    / \    /   \            /  \     /  \
  [A] [B] |l|  (r)        {x}  |l|  [E] [F]
          / \  / \        / \  / \
        [C][D][E][F]    [A][B][C][D]

```

Running time of this algorithm:
* Only case 2 can repeat, but this only h many times, where h is the height of the tree
* Case 1 -> case 2 -> red-black tree
  Case 1 -> case 3 -> case 4 -> red-black tree
  Case 1 -> case 4 -> red-black tree
* Case 3 -> case 4 -> red-black tree
* Case 4 -> red-black tree
As we perform case 2 at most O(log n) times and all other steps at most once, we have O(log n) recolorings and at most 3 rotations.
The overall runtime of delete is O(log n).
该算法的运行时间：
* 只有情况2可以重复，但这只有很多次，其中h是树的高度
* 案例1 -> 案例2 -> 红黑树
   案例1 -> 案例3 -> 案例4 -> 红黑树
   案例1 -> 案例4 -> 红黑树
* 案例3 -> 案例4 -> 红黑树
* 案例4 -> 红黑树
由于我们在最多O(log n)次执行情况2并且所有其他步骤最多执行一次，因此我们有O(log n)重新着色并且最多3次旋转。
删除的总体运行时间是O(log n)。

## 资源：

[CLRS]  T. Cormen, C. Leiserson, R. Rivest, and C. Stein. 《算法导论》, 第三版. 2009



*作者：Ute Schiehlen， Jaap Wijnen， Ashwin Raghuraman*   
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  