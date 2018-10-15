# k-Means Clustering
# k均值聚类

Goal: Partition data into two or more clusters.
目标：将数据分区为两个或更多集群。

The idea behind k-Means Clustering is to take a bunch of data and determine if there are any natural clusters (groups of related objects) within the data.
k-Means Clustering背后的想法是获取一堆数据并确定数据中是否存在任何自然聚类（相关对象组）。

The k-Means algorithm is a so-called *unsupervised* learning algorithm. We don't know in advance what patterns exist in the data -- it has no formal classification to it -- but we would like to see if we can divide the data into groups somehow.
k-Means算法是所谓的*无监督*学习算法。 我们事先并不知道数据中存在哪些模式 - 它没有正式的分类 - 但我们希望看看我们是否可以以某种方式将数据分组。

For example, you can use k-Means to find what are the 3 most prominent colors in an image by telling it to group pixels into 3 clusters based on their color value. Or you can use it to group related news articles together, without deciding beforehand what categories to use. The algorithm will automatically figure out what the best groups are.
例如，您可以使用k-Means通过告诉它根据颜色值将像素分组为3个聚类来查找图像中3种最突出的颜色。 或者您可以使用它将相关新闻文章组合在一起，而无需事先决定使用哪些类别。 该算法将自动确定最佳组是什么。

The "k" in k-Means is a number. The algorithm assumes that there are **k** centers within the data that the various data elements are scattered around. The data that is closest to these so-called **centroids** become classified or grouped together.
k-Means中的“k”是一个数字。 该算法假设数据中存在**k**中心，各种数据元素分散在各处。 最接近这些所谓的**质心**的数据被分类或组合在一起。

k-Means doesn't tell you what the classifier is for each particular data group. After dividing news articles into groups, it doesn't say that group 1 is about science, group 2 is about celebrities, group 3 is about the upcoming election, etc. You only know that related news stories are now together, but not necessarily what that relationship signifies. k-Means only assists in trying to find what clusters potentially exist.
k-Means不会告诉您每个特定数据组的分类器是什么。 将新闻文章分成小组后，并不是说第一组是关于科学，第二组是关于名人，第三组是关于即将到来的选举等等。你只知道相关的新闻报道现在在一起，但不一定是什么 这种关系意味着。 k-Means仅帮助尝试查找可能存在的集群。

## The algorithm
## 算法

The k-Means algorithm is really quite simple at its core.
k-Means算法的核心非常简单。

First, we choose **k** random data points to be the initial centroids. Then, we repeat the following two steps until we've found our clusters:
首先，我们选择**k**随机数据点作为初始质心。 然后，我们重复以下两个步骤，直到找到我们的集群：

1. For each data point, find which centroid it is closest to. We assign each point to its nearest centroid.
2. Update the centroid to the mean (i.e. the average) of its nearest data points. We move the centroid so that it really sits in the center of the cluster.

1. 对于每个数据点，找到它最接近的质心。 我们将每个点分配到最近的质心。
2. 将质心更新为其最近数据点的平均值（即平均值）。 我们移动质心，使其真正位于群集的中心。

We need to repeat this multiple times because moving the centroid changes which data points belong to it. This goes back and forth for a bit until everything stabilizes. That's when we reach "convergence", i.e. when the centroids no longer move around.
我们需要多次重复此操作，因为移动质心会更改哪些数据点属于它。 这种情况来回徘徊，直到一切都稳定下来。 那是当我们达到“收敛”时，即当质心不再移动时。

A few of the parameters that are required for k-Means:
k-Means所需的一些参数：

- **k**: This is the number of centroids to attempt to locate. If you want to group news articles, this is the number of groups to look for.
- **convergence distance**: If all the centroids move less than this distance after a particular update step, we're done.
- **distance function**: This calculates how far data points are from the centroids, to find which centroid they are closest to. There are a number of distance functions that can be used, but most commonly the Euclidean distance function is adequate (you know, Pythagoras). But often that can lead to convergence not being reached in higher dimensionally.

- **k**：这是尝试定位的质心数。 如果要对新闻文章进行分组，则这是要查找的组的数量。
- **收敛距离**：如果所有质心在特定更新步骤后移动的距离小于此距离，我们就完成了。
- **距离函数**：计算数据点与质心的距离，以找出它们最接近的质心。有许多距离函数可以使用，但最常见的欧几里德距离函数是足够的（你知道，毕达哥拉斯）。 但通常这会导致在更高维度上达不到收敛。

Let's look at an example.

#### Good clusters

This first example shows k-Means finding all three clusters. In all these examples the circles represent the data points and the stars represent the centroids.
第一个例子显示k-Means找到所有三个聚类。 在所有这些例子中，圆圈代表数据点，星星代表质心。

In the first iteration, we choose three data points at random and put our centroids on top of them. Then in each subsequent iteration, we figure out which data points are closest to these centroids, and move the centroids to the average position of those data points. This repeats until we reach equilibrium and the centroids stop moving.
在第一次迭代中，我们随机选择三个数据点并将我们的质心放在它们之上。 然后在每个后续迭代中，我们确定哪些数据点最接近这些质心，并将质心移动到这些数据点的平均位置。 这一直重复，直到我们达到平衡并且质心停止移动。

![Good Clustering](Images/k_means_good.png)

The selection of initial centroids was fortuitous! We found the lower left cluster (indicated by red) and did pretty good on the center and upper left clusters.
初始质心的选择是偶然的！ 我们发现左下方的簇（用红色表示）并且在中心和左上方的簇中表现相当不错。

> **Note:** These examples are contrived to show the exact nature of k-Means and finding clusters. The clusters in these examples are very easily identified by human eyes: we see there is one in the lower left corner, one in the upper right corner, and maybe one in the middle. In practice, however, data may have many dimensions and may be impossible to visualize. In such cases, k-Means is much better at this job than  human eyes!
> **注意：**这些例子旨在显示k-Means和发现聚类的确切性质。 这些例子中的星团很容易被人眼识别出来：我们看到左下角有一个，右上角有一个，中间可能有一个。 然而，在实践中，数据可能具有许多维度并且可能无法可视化。 在这种情况下，k-Means在这项工作上要比人眼好得多！

#### Bad clustering

The next two examples highlight the unpredictability of k-Means and how it does not always find the best clustering.
接下来的两个例子突出了k-Means的不可预测性以及它如何不总能找到最佳聚类。

![Bad Clustering 1](Images/k_means_bad1.png)

As you can see in this example, the initial centroids were all a little too close to one another, and the blue one didn't quite get to a good place. By adjusting the convergence distance we should be able to improve the fit of our centroids to the data.
正如你在这个例子中看到的那样，初始质心彼此之间的距离太近了，而蓝色的质心并没有达到一个好的位置。 通过调整收敛距离，我们应该能够改善质心与数据的拟合。

![Bad Clustering 1](Images/k_means_bad2.png)

In this example, the blue cluster never really could separate from the red cluster and as such sort of got stuck down there.
在这个例子中，蓝色集群永远不会真正从红色集群中分离出来，因此就会陷入困境。

#### Improving bad clustering 
#### 改善糟糕的群集

In these examples of "bad" clustering, the algorithm got stuck in a local optimum. It does find clusters but they're not the best way to divide up the data. To increase your chances of success, you can run the algorithm several times, each time with different points as the initial centroids. You choose the clustering that gives the best results.
在这些“坏”聚类的例子中，算法陷入局部最优。它确实找到了集群，但它们不是分割数据的最佳方式。为了增加成功的机会，您可以多次运行算法，每次使用不同的点作为初始质心。 您可以选择可获得最佳结果的群集。

To calculate how "good" the clustering is, you find the distance of each data point to its cluster, and add up all these distances. The lower this number, the better! That means each cluster is really in the center of a group of data points, and all clusters are roughly the same size and are spaced evenly apart.
要计算聚类的“好”程度，您可以找到每个数据点到其聚类的距离，并将所有这些距离相加。这个数字越低越好！这意味着每个群集实际上位于一组数据点的中心，并且所有群集大小大致相同并且均匀分布。

## The code
## 代码

This is what the algorithm could look like in Swift. The `points` array contains the input data as `Vector` objects. The output is an array of `Vector` objects representing the clusters that were found.
这就是Swift中算法的样子。 `points`数组包含输入数据作为`Vector`对象。 输出是一个“Vector”对象数组，表示找到的簇。

```swift
func kMeans(numCenters: Int, convergeDistance: Double, points: [Vector]) -> [Vector] {
 
  // Randomly take k objects from the input data to make the initial centroids.
  var centers = reservoirSample(points, k: numCenters)

  // This loop repeats until we've reached convergence, i.e. when the centroids
  // have moved less than convergeDistance since the last iteration.
  var centerMoveDist = 0.0
  repeat {
    // In each iteration of the loop, we move the centroids to a new position.
    // The newCenters array contains those new positions.
    let zeros = [Double](count: points[0].length, repeatedValue: 0)
    var newCenters = [Vector](count: numCenters, repeatedValue: Vector(zeros))

    // We keep track of how many data points belong to each centroid, so we
    // can calculate the average later.
    var counts = [Double](count: numCenters, repeatedValue: 0)

    // For each data point, find the centroid that it is closest to. We also 
    // add up the data points that belong to that centroid, in order to compute
    // that average.
    for p in points {
      let c = indexOfNearestCenter(p, centers: centers)
      newCenters[c] += p
      counts[c] += 1
    }
    
    // Take the average of all the data points that belong to each centroid.
    // This moves the centroid to a new position.
    for idx in 0..<numCenters {
      newCenters[idx] /= counts[idx]
    }

    // Find out how far each centroid moved since the last iteration. If it's
    // only a small distance, then we're done.
    centerMoveDist = 0.0
    for idx in 0..<numCenters {
      centerMoveDist += centers[idx].distanceTo(newCenters[idx])
    }
    
    centers = newCenters
  } while centerMoveDist > convergeDistance

  return centers
}
```

> **Note:** The code in [KMeans.swift](KMeans.swift) is slightly more advanced than the above listing. It also assigns labels to the clusters and has a few other tricks up its sleeve. Check it out!
> **注意：** [KMeans.swift](KMeans.swift)中的代码略高于上面的列表。 它还为集群分配标签，还有其他一些技巧。 看看这个！

## Performance
## 性能

k-Means is classified as an NP-Hard type of problem. That means it's almost impossible to find the optimal solution. The selection of the initial centroids has a big effect on how the resulting clusters may end up. Finding an exact solution is not likely -- even in 2 dimensional space.
k-Means被归类为NP-Hard类型的问题。 这意味着找到最佳解决方案几乎是不可能的。 初始质心的选择对最终聚类的最终结果有很大影响。 找不到精确的解决方案 - 即使在二维空间中也是如此。

As seen from the steps above the complexity really isn't that bad -- it is often considered to be on the order of **O(kndi)**, where **k** is the number of centroids, **n** is the number of **d**-dimensional vectors, and **i** is the number of iterations for convergence.
从上面的步骤可以看出，复杂性确实并不差 - 它通常被认为是 **O(kndi)** 的顺序，其中**k**是质心的数量，**n**是**d**维向量的数量，**i**是收敛的迭代次数。

The amount of data has a linear effect on the running time of k-Means, but tuning how far you want the centroids to converge can have a big impact how many iterations will be done. As a general rule, **k** should be relatively small compared to the number of vectors.
数据量对k-Means的运行时间具有线性影响，但调整质心收敛的程度会对完成多少次迭代产生很大影响。 作为一般规则，与矢量的数量相比，**k**应该相对较小。

Often times as more data is added certain points may lie in the boundary between two centroids and as such those centroids would continue to bounce back and forth and the convergence distance would need to be tuned to prevent that.
通常，当添加更多数据时，某些点可能位于两个质心之间的边界中，因此这些质心将继续来回反弹，并且需要调整会聚距离以防止这种情况。

## See Also
## 扩展阅读

[K-Means Clustering 的维基百科](https://en.wikipedia.org/wiki/K-means_clustering)

*Written by John Gill and Matthijs Hollemans*
*作者：Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*