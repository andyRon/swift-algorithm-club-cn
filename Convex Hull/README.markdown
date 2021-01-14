# Convex Hull
# 凸包

Given a group of points on a plane. The Convex Hull algorithm calculates the shape (made up from the points itself) containing all these points. It can also be used on a collection of points of different dimensions. This implementation however covers points on a plane. It essentially calculates the lines between points which together contain all points. In comparing different solutions to this problem we can describe each algorithm in terms of it's big-O time complexity.

给出平面上的一组点。 凸包算法计算包含所有这些点的形状（由点本身组成）。 它也可以用于不同维度的点集合。 然而，该实现涵盖了平面上的点。 它实质上计算了包含所有点的点之间的线。 在比较这个问题的不同解决方案时，我们可以根据它的大O时间复杂度来描述每个算法。

There are multiple Convex Hull algorithms but this solution is called Quickhull, is comes from the work of both W. Eddy in 1977 and also separately A. Bykat in 1978, this algorithm has an expected time complexity of O(n log n), but it's worst-case time-complexity can be O(n^2) . With average conditions the algorithm has ok efficiency, but it's time-complexity can start to head become more exponential in cases of high symmetry or where there are points lying on the circumference of a circle for example.

有多个凸包算法，一个解决方案叫做Quickhull，它来自于1977年的W. Eddy和1978年的A. Bykat的工作，该算法的预期时间复杂度为O(n log n)，但是 最糟糕的情况是时间复杂度可以是O(n^2)。 在平均条件下，算法具有良好的效率，但是在高对称性的情况下或者例如在圆周上存在点的情况下，时间复杂度可以开始变得更具指数性。

## Quickhull

The quickhull algorithm works as follows:

- The algorithm takes an input of a collection of points. These points should be ordered on their x-coordinate value. 
- We first find the two points A and B with the minimum(A) and the maximum(B) x-coordinates (as these will obviously be part of the hull). 
- Use the line formed by the two points to divide the set in two subsets of points, which will be processed recursively.
- Determine the point, on one side of the line, with the maximum distance from the line. The two points found before along with this one form a triangle.
- The points lying inside of that triangle cannot be part of the convex hull and can therefore be ignored in the next steps.
- Repeat the previous two steps on the two lines formed by the triangle (not the initial line).
- Keep on doing so on until no more points are left, the recursion has come to an end and the points selected constitute the convex hull.

quickhull算法的工作原理如下：

- 算法接受点集合的输入。 这些点应按其x坐标值排序。
- 我们首先找到具有最小（A）和最大（B）x坐标的两个点A和B（因为这些将显然是船体的一部分）。
- 使用由两点组成的直线将集合分成两个点子集，这些点将以递归方式处理。
- 确定线的一侧的点与线的最大距离。 之前发现的两点与此形成一个三角形。
- 位于该三角形内部的点不能是凸包的一部分，因此可以在后续步骤中忽略。
- 在由三角形（而不是初始线）形成的两条线上重复前两步。
- 继续这样做直到没有剩下的点，递归已经结束并且所选择的点构成凸包。

Our functioni will have the following defininition:
我们的功能将具有以下定义：

`findHull(points: [CGPoint], p1: CGPoint, p2: CGPoint)`

```
findHull(S1, A, B)
findHull(S2, B, A)
```

What this function does is the following:

1. If `points` is empty we return as there are no points to the right of our line to add to our hull.
2. Draw a line from `p1` to `p2`.
3. Find the point in `points` that is furthest away from this line. (`maxPoint`)
4. Add `maxPoint` to the hull right after `p1`.
5. Draw a line (`line1`) from `p1` to `maxPoint`.
6. Draw a line (`line2`) from `maxPoint` to `p2`. (These lines now form a triangle)
7. All points within this triangle are of course not part of the hull and thus can be ignored. We check which points in `points` are to the right of `line1` these are grouped in an array `s1`.
8. All points that are to the right of `line2` are grouped in an array `s2`. Note that there are no points that are both to the right of `line1` and `line2` as then `maxPoint` wouldn't be the point furthest away from our initial line between `p1` and `p2`.
9. We call `findHull(_, _, _)` again on our new groups of points to find more hull points.

这个功能的作用如下：

1. 如果`points`为空，我们返回，因为我们的线右边没有点添加到我们的船体。
2. 从`p1`到`p2`画一条线。
3. 找到离这条线最远的“点”点。（`maxPoint`）
4. 在`p1`之后立即将`maxPoint`添加到船体。
5. 从`p1`到`maxPoint`画一条线（`line1`）。
6. 从`maxPoint`画一条线（`line2`）到'p2`。 （这些线现在形成一个三角形）
7. 此三角形内的所有点当然不是船体的一部分，因此可以忽略。 我们检查`points`中哪些点位于`line1'的右边，这些点被分组在一个数组`s1`中。
8. “line2”右边的所有点都分组在一个数组`s2`中。 注意，在'line1`和`line2`的右边没有任何点，因为`maxPoint`不会是离'p1`和`p2`之间的初始线最远的点。
9. 我们在新的点组上再次调用`findHull（_，_，_）`以找到更多的船体点。

```
findHull(s1, p1, maxPoint)
findHull(s2, maxPoint, p2)
```

This eventually leaves us with an array of points describing the convex hull.
这最终给我们留下了一系列描述凸包的点。

## See also
## 扩展阅读

[凸包的维基百科](https://en.wikipedia.org/wiki/Convex_hull_algorithms)

*Written for the Swift Algorithm Club by Jaap Wijnen.*

*作者：Jaap Wijnen*   
*翻译：[Andy Ron](https://github.com/andyRon)*  