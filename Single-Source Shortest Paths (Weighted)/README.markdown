# 单源最短路径算法（Single-Source Shortest Paths）

The Single-Source shortest path problem finds the shortest paths from a given source vertex to all other vertices in a directed weighted graph. Many variations exist on the problem, specifying whether or not edges may have negative values, whether cycles exist, or whether a path between a specific pair of vertices.
单源最短路径问题是找到从定向加权图中的给定源顶点到所有其他顶点的最短路径。该问题存在许多变化，指定边是否可能具有负值，是否存在循环，或者是否是特定顶点对之间的路径。

## Bellman-Ford
## Bellman-Ford算法

The Bellman-Ford shortest paths algorithm finds the shortest paths to all vertices from a given source vertex `s` in a directed graph that may contain negative edge weights. It iterates over all edges for each other vertex in the graph, applying a relaxation to the current state of known shortest path weights. The intuition here is that a path will not contain more vertices than are present in the graph, so performing a pass over all edges `|V|-1` number of times is sufficient to compare all possible paths. 
Bellman-Ford最短路径算法在可能包含负边权重的有向图中找到来自给定源顶点`s`的所有顶点的最短路径。它迭代图中每个其他顶点的所有边，对已知最短路径权重的当前状态应用松弛。这里的直觉是路径不会包含比图中存在的更多的顶点，因此在所有边上执行传递`| V | -1`次数足以比较所有可能的路径。

At each step, a value is stored for each vertex `v`, which is the weight of the current known shortest path `s`~>`v`. This value remains 0 for the source vertex itself, and all others are initially `∞`. Then, they are "relaxed" by applying the following test to each edge `e = (u, v)` (where `u` is a source vertex and `v` is a destination vertex for the directed edge):
在每个步骤中，为每个顶点`v`存储一个值，该值是当前已知的最短路径`s`~>`v`的权重。 源顶点本身的值保持为0，其他所有值最初都是`∞`。 然后，通过对每个边缘应用以下测试来“松弛”`e =(u, v)`（其中`u`是源顶点，`v`是有向边的目标顶点）：

	if weights[v] > weights[u] + e.weight {
		weights[v] = weights[u] + e.weight
	}

Bellman-Ford in essence only computes the lengths of the shortest paths, but can optionally maintain a structure that memoizes the predecessor of each vertex on its shortest path from the source vertex.  Then the paths themselves can be reconstructed by recursing through this structure from a destination vertex to the source vertex. This is maintained by simply adding the statement
Bellman-Ford算法本质上只计算最短路径的长度，但可以选择性地维护一个结构，该结构在源极顶点的最短路径上记忆每个顶点的前任。然后，可以通过从目标顶点到源顶点递归通过该结构来重构路径本身。只需添加语句即可维护

	predecessors[v] = u
	
inside of the `if` statement's body above.
在上面`if`语句的主体里面。

### Example
### 例子

For the following weighted directed graph:

<img src="img/example_graph.png" width="200px" />

let's compute the shortest paths from vertex `s`. First, we prepare our `weights` and `predecessors` structures thusly:
让我们从顶点`s`计算最短路径。 首先，我们准备我们的`weight`和`predecessors`结构：

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = 1` |
| `weights[t] = ∞` | `predecessors[t] = ø` |
| `weights[x] = ∞` | `predecessors[x] = ø` |
| `weights[y] = ∞` | `predecessors[y] = ø` |
| `weights[z] = ∞` | `predecessors[z] = ø` |

Here are their states after each relaxation iteration (each iteration is a pass over all edges, and there are 4 iterations total for this graph):
以下是每次松弛迭代后的状态（每次迭代都是遍历所有边，并且此图总共有4次迭代）：

###### Iteration 1:
###### 迭代 1:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 6` | `predecessors[t] = s` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = 2` | `predecessors[z] = t` |

###### Iteration 2:
###### 迭代 2:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 2` | `predecessors[t] = x` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = 2` | `predecessors[z] = t` |

###### Iteration 3:
###### 迭代 3:


| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 2` | `predecessors[t] = x` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = -2` | `predecessors[z] = t` |

###### Iteration 4:
###### 迭代 4:

| weights | predecessors |
| ------------- |:-------------:|
| `weights[s] = 0` | `predecessors[s] = s` |
| `weights[t] = 2` | `predecessors[t] = x` |
| `weights[x] = 4` | `predecessors[x] = y` |
| `weights[y] = 7` | `predecessors[y] = s` |
| `weights[z] = -2` | `predecessors[z] = t` |

#### Negative weight cycles
#### 负权重循环

An additional useful property of the solution structure is that it can answer whether or not a negative weight cycle exists in the graph and is reachable from the source vertex. A negative weight cycle is a cycle whose sum of edge weights is negative. This means that shortest paths are not well defined in the graph from the specified source, because you can decrease the weight of a path by reentering the cycle, pushing the path's weight towards `-∞`. After fully relaxing the paths, simply running a check over each edge `e = (u, v)` to see if the weight of the shortest path to `v` is greater than the path to `u`, plus the edge weight itself, signals that the edge has a negative weight and would decrease the shortest path's weight further. Since we know we've already performed the relaxations enough times according to the intuition stated above, we can safely assume this further decrease of weight will continue infinitely.
解决方案结构的另一个有用属性是它可以回答图中是否存在负权重循环并且可以从源顶点到达。负权重周期是边权重之和为负的周期。这意味着在指定源的图形中没有很好地定义最短路径，因为您可以通过重新进入循环来减小路径的权重，将路径的权重推向`-∞`。在完全放松路径之后，只需检查每条边`e =(u, v)`，看看到`v`的最短路径的权重是否大于到`u`的路径，再加上边权重本身 ，表示边缘具有负重量并且将进一步减小最短路径的重量。由于我们已经知道我们已经根据上述直觉进行了足够的松弛，我们可以安全地假设这种进一步减轻的重量会无限地持续下去。

##### 例子

For this example, we try to compute the shortest paths from `a`:
对于这个例子，我们尝试从`a`计算最短路径：

<img src="img/negative_cycle_example.png" width="200px" />

The cycle `a`->`t`->`s`->`a` has a total edge weight of -9, therefore shortest paths for `a`\~>`t` and `a`~>`s` are not well-defined. `a`~>`b` is also not well-defined because `b`->`t`->`s` is also a negative weight cycle.

This is confirmed after running the relaxation loop, and checking all the edges as mentioned above. For this graph, we would have after relaxation:

他循环`a`->`t`->`s`->`a`的总边权重为-9，因此`a`\~>`t`和`a`\~>`s`的最短路径 没有明确的定义。 `a`\~>`b`也没有明确定义，因为`b`->`t`->`s`也是负权重循环。

在运行松弛循环并检查如上所述的所有边缘之后确认这一点。 对于此图表，我们将放松后：

| weights |
| ------------- |
| `weights[a] = -5` |
| `weights[b] = -5` |
| `weights[s] = -18` |
| `weights[t] = -3` |

One of the edge checks we would perform afterwards would be the following:
我们之后将执行的边缘检查之一将是以下内容：

	e = (s, a)
	e.weight = 4
	weight[a] > weight[s] + e.weight => -5 > -18 + 4 => -5 > -14 => true
	
Because this check is true, we know the graph has a negative weight cycle reachable from `a`.
因为这个检查是正确的，我们知道图形具有从`a`可到达的负重量周期。

#### Complexity
#### 复杂性

The relaxation step requires constant time (`O(1)`) as it simply performs comparisons. That step is performed once per edge (`Θ(|E|)`), and the edges are iterated over `|V|-1` times. This would mean a total complexity of `Θ(|V||E|)`, but there is an optimization we can make: if the outer loop executes and no changes are made to the recorded weights, we can safely terminate the relaxation phase, which means it may execute in `O(|V|)` steps instead of `Θ(|V|)` steps (that is, the best case for any size graph is actually a constant number of iterations; the worst case is still iterating `|V|-1` times).
松弛步骤需要恒定的时间（`O(1)`），因为它只是执行比较。 该步骤每边执行一次（`Θ(|E|)`），并且边缘在`|V|-1`次上迭代。 这意味着`Θ(|V||E|)`的总复杂度，但我们可以进行优化：如果外循环执行并且没有对记录的权重进行任何更改，我们可以安全地终止放松阶段 ，这意味着它可以在`O(|V|)`步骤而不是`Θ(|V|)`步骤中执行（也就是说，任何大小图的最佳情况实际上是迭代的常数;最坏的情况是 仍在迭代`|V|-1`次）。

The check for negative weight cycles at the end is `O(|E|)` if we return once we find a hit. To find all negative weight cycles reachable from the source vertex, we'd have to iterate `Θ(|E|)` times (we currently do not attempt to report the cycles, we simply return a `nil` result if such a cycle is present).
如果我们在找到命中后返回，那么最后检查负重量循环是`O(|E|)`。 为了找到从源顶点可到达的所有负权重周期，我们必须迭代`Θ(|E|)`次（我们目前不尝试报告周期，如果这样一个周期，我们只返回一个`nil`结果 存在）。

The total running time of Bellman-Ford is therefore `O(|V||E|)`.
因此，Bellman-Ford的总运行时间为`O(|V||E|)`。

## TODO

- Dijkstra's algorithm for computing SSSP on a directed non-negative weighted graph
- Dijkstra在有向非负加权图上计算SSSP的算法

# References
# 参考

- Chapter 24 of Introduction to Algorithms, Third Edition by Cormen, Leiserson, Rivest and Stein [https://mitpress.mit.edu/books/introduction-algorithms](https://mitpress.mit.edu/books/introduction-algorithms)
- Wikipedia: [Bellman–Ford algorithm](https://en.wikipedia.org/wiki/Bellman–Ford_algorithm)

- Cormen，Leiserson，Rivest和Stein的第三版算法导论第24章[https://mitpress.mit.edu/books/introduction-algorithms](https://mitpress.mit.edu/books/introduction-algorithms)
- 维基百科：[Bellman-Ford算法]（https://en.wikipedia.org/wiki/Bellman-Ford_algorithm）

*Written for Swift Algorithm Club by [Andrew McKnight](https://github.com/armcknight)*

*作者：[Andrew McKnight](https://github.com/armcknight)*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  