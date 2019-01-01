# 跳表(Skip List)

Skip List is a probablistic data-structure  with same logarithmic time bound and
efficiency  as AVL/  or  Red-Black  tree and  provides  a  clever compromise  to
efficiently support  search and update  operations and is relatively  simpler to
implement compared to other map data structures.

跳表是一个概率数据结构，具有相同的对数时间限制和作为AVL或红黑树的效率，并提供了一个聪明的妥协有效地支持搜索和更新操作，并且相对简单与其他映射数据结构相比，实现。

A skip  list *S*  consists of  series of  sorted linked  lists *{L0,  ..., Ln}*,
layered hierarchicaly and each layer *L* stores  a subset of items in layer *L0*
in incremental order.  The items in layers  *{L1, ... Ln}* are  chosen at random
based on a coin flipping function  with probability 1/2 .  For traversing, every
item in  a layer  hold references  to the node  below and  the next  node.  This
layers serve as  express lanes to the layer underneath  them, effectively making
fast O(log n) searching possible by  skipping lanes and reducing travel distance
and in worse case  searching degrades to O (n), as  expected with regular linked
list.
跳表 *S* 由一系列排序链表 *{L0, ..., Ln}* 组成，分层次的层次结构和每一层 *L* 存储图层中的项目子集 *L0* 按增量顺序。层 *{L1, ... Ln}* 中的项目是随机选择的基于硬币翻转功能，概率为1/2。为了遍历，每一个图层中的项目包含对下面节点和下一个节点的引用。这个层作为快速通道到它们下面的层，有效地制作快速O(log n) 搜索可以通过跳过车道和减少行驶距离并且在更糟糕的情况下，搜索降级为O(n)，正如预期的那样经常链接名单。

For a skip list *S*:
对于跳表 *S*

1. List *L0* contains every inserted item.
2.  For lists *{L1, ..., Ln}*, *Li*  contains a randomly generated subset of the
   items in *Li-1*
3. Height is determined by coin-flipping.

1. 链表 *L0* 包含每个插入的项目。
5. 对于列表*{L1, ..., Ln}*，*Li* 包含随机生成的子集物品*Li-1*
3. 高度由硬币翻转决定。

![Schematic view](Images/Intro.png)
Figure 1



# 搜索

Searching for  element *N* starts by  traversing from top most  layer *Ln* until *L0*.
搜索元素*N*首先从最顶层*Ln*遍历到*L0*。

Our objective  is to find an  element *K* such  that its value at  the rightmost
position of current layer, is less-than  target item and its subsequent node has
a greater-equal  value or nil (  *K.key < N.key  <= (K.next.key or nil)*  ). if
value of *K.next* is equal to *N*,  search is terminated and we return *K.next*,
otherwise drop underneath using *K.down* to the node below ( at layer Ln-1 ) and
repeat the process until *L0* where *K.down* is `nil` which indicates that level
is *L0* and item doesn't exists.

我们的目标是找到一个元素 *K*，使其在最右边的值当前层的位置，小于目标项及其后续节点大于等于或等于零 (  *K.key < N.key  <= (K.next.key or nil)*  。 如果 *K.next* 的值等于 *N*，搜索终止，我们返回 *K.next*，否则使用*K.down*下面到下面的节点（在层Ln-1）和重复该过程，直到*L0*，其中*K.down*为`nil`，表示该级别是*L0*且项目不存在。



## 例子：

![Inserting first element](Images/Search1.png)



# 插入

Inserting  element  *N*  has  a  similar process  as  searching.  It  starts  by
traversing from  top most layer *Ln*  until *L0*. We  need to keep track  of our
traversal path  using a  stack. It  helps us  to traverse  the path  upward when
coin-flipping starts, so we can insert  our new element and update references to
it.
插入元素 *N* 具有与搜索类似的过程。 它开始于从最顶层穿过*Ln*直到*L0*。 我们需要跟踪我们的情况使用堆栈的遍历路径。 它有助于我们在向上穿越路径硬币翻转开始，所以我们可以插入我们的新元素并更新引用它。

Our objective  is to find  a element  *K* such that  its value at  the rightmost
position of  layer *Ln*,  is less-than new  item and its  subsequent node  has a
greater-equal value  or nil (  *K.key  < N.key <  (K.next.key or nil)*  ). Push
element *K*  to the stack and  with element *K*,  go down using *K.down*  to the
node below  ( at layer Ln-1  ) and repeat the  process ( forward searching  ) up
until  *L0* where  *K.down* is  `nil`  which indicates  that level  is *L0*.  We
terminate the process when *K.down* is nil.
我们的目标是找到一个元素*K*，使其在最右边的值层的位置 *Ln* 小于新项，其后续节点有一个大于等于或等于 (  *K.key  < N.key <  (K.next.key or nil)*  )。 推元素*K*到堆栈并使用元素*K*，使用*K.down*向下移动到下面的节点（在层Ln-1）并重复该过程（向前搜索）直到*L0*，其中*K.down*是`nil`，表示该等级是*L0*。 我们*K.down*为零时终止进程。

At *L0*, *N* can be inserted after *K*.
在 *L0*，*N*可以在*K*之后插入。

Here is the  interesting part. We use coin flipping  function to randomly create
layers.
这是有趣的部分。 我们使用硬币翻转功能随机创建层。

When  coin flip  function returns  0,  the whole  process is  finished but  when
returns 1, there are two possibilities:
当硬币翻转功能返回0时，整个过程结束但是何时返回1，有两种可能性：

1. Stack is empty ( Level is *L0* /- *Ln* or at uninitialized stage)
2. Stack has items ( traversing upward is possible )
1. 堆栈为空（级别为*L0* / - *Ln*或未初始化阶段）
2. 堆栈有物品（可以向上移动）

In case 1:

A new layer M*  is created with a head node *NM* referencing  head node of layer
below  and *NM.next*  referencing new  element *N*.  New element  *N* referecing
element *N* at previous layer.
创建一个新的层M*，其头节点*NM*引用层的头节点下面和*NM.next*引用新元素*N*。 新元素*N* referecing元素*前一层的N*。

In case 2:

repeat until stack is empty Pop an item *F* from stack and update the references
accordingly.  *F.next* will be *K.next* and *K.next* will be *F*
重复直到堆栈为空从堆栈中弹出项目*F*并更新引用因此。 *F.next*将是*K.next*和*K.next*将是*F*
​	
when  stack  is  empty Create  a  new  layer  consisintg  of a  head  node  *NM*
referencing  head node  of layer  below  and *NM.next*  referencing new  element
*N*. New element *N* referencing element *N* at previous layer.
当stack为空时创建一个头节点的新层consisintg *NM* 引用下面层的头节点和*NM.next*引用新元素*N*。 新元素*N*在前一层引用元素*N*。
​		 



## 例子：

Inserting 13. with coin flips (0)

![Inserting first element](Images/Insert5.png)
![Inserting first element](Images/Insert6.png)
![Inserting first element](Images/insert7.png)
![Inserting first element](Images/Insert8.png)
![Inserting first element](Images/Insert9.png)



Inserting 20. with 4 times coin flips (1) 
![Inserting first element](Images/Insert9.png)
![Inserting first element](Images/Insert10.png)
![Inserting first element](Images/Insert11.png)
![Inserting first element](Images/Insert12.png)


# 删除


删除工作类似于插入过程。

TODO



# 扩展阅读

[跳跃列表在维基百科](https://en.wikipedia.org/wiki/Skip_list) 

*作者：[Mike Taghavi](https://github.com/mitghi)*    
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  