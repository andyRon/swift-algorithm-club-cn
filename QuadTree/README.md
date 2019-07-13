# 四叉树（QuadTree）

四叉树是一种[树](../Tree)，其中每个内部（非叶节点）节点有四个子节点。

![](Images/quadtree.png)

### 问题


考虑以下问题：您需要存储多个点（每个点是一对`X`和`Y`坐标），然后您需要回答哪些点位于某个矩形区域。一个天真的解决方案是将点存储在一个数组中，然后迭代这些点并分别检查每个点。 该解决方案花费O(n)。

### 更好的方法

四叉树最常用于通过递归地将其细分为四个区域（象限）来划分二维空间。 让我们看看如何使用四叉树来存储点数。

树中的每个节点代表一个矩形区域，并存储所有位于其区域中的有限数量（`maxPointCapacity`）点。

```swift
class QuadTreeNode {

  enum NodeType {
    case leaf
    case `internal`(children: Children)
  }

  struct Children {
    let leftTop: QuadTreeNode
    let leftBottom: QuadTreeNode
    let rightTop: QuadTreeNode
    let rightBottom: QuadTreeNode

    ...
  }

  var points: [Point] = []
  let rect: Rect
  var type: NodeType = .leaf

  static let maxPointCapacity = 3

  init(rect: Rect) {
    self.rect = rect
  }

  ...
}

```

一旦达到叶节点的限制，就会向节点添加四个子节点，它们代表节点rect的`topLeft`，`topRight`，`bottomLeft`，`bottomRight`象限;rect中的每个结果点都将传递给其中一个子节点。 因此，总是将新点添加到叶节点。


```swift
extension QuadTreeNode {

  @discardableResult
  func add(point: Point) -> Bool {

    if !rect.contains(point: point) {
      return false
    }

    switch type {
    case .internal(let children):
      // pass the point to one of the children
      for child in children {
        if child.add(point: point) {
          return true
        }
      }
      return false // should never happen
    case .leaf:
      points.append(point)
      // if the max capacity was reached, become an internal node
      if points.count == QuadTreeNode.maxPointCapacity {
        subdivide()
      }
    }
    return true
  }

  private func subdivide() {
    switch type {
    case .leaf:
      type = .internal(children: Children(parentNode: self))
    case .internal:
      preconditionFailure("Calling subdivide on an internal node")
    }
  }
}

extension Children {

  init(parentNode: QuadTreeNode) {
    leftTop = QuadTreeNode(rect: parentNode.rect.leftTopRect)
    leftBottom = QuadTreeNode(rect: parentNode.rect.leftBottomRect)
    rightTop = QuadTreeNode(rect: parentNode.rect.rightTopRect)
    rightBottom = QuadTreeNode(rect: parentNode.rect.rightBottomRect)
  }
}

```

为了找到位于给定区域中的点，我们现在可以从上到下遍历树并从节点收集合适的点。

```swift

class QuadTree {

  ...

  let root: QuadTreeNode

   public func points(inRect rect: Rect) -> [Point] {
    return root.points(inRect: rect)
  }
}

extension QuadTreeNode {
  func points(inRect rect: Rect) -> [Point] {

    // if the node's rect and the given rect don't intersect, return an empty array,
    // because there can't be any points that lie the node's (or its children's) rect and
    // in the given rect
    if !self.rect.intersects(rect: rect) {
      return []
    }

    var result: [Point] = []

    // collect the node's points that lie in the rect
    for point in points {
      if rect.contains(point: point) {
        result.append(point)
      }
    }

    switch type {
    case .leaf:
      break
    case .internal(children: let children):
      // recursively add children's points that lie in the rect
      for childNode in children {
        result.append(contentsOf: childNode.points(inRect: rect))
      }
    }

    return result
  }
}

```

在最坏的情况下，添加点和搜索仍然可以占用O(n)，因为树不以任何方式平衡。 但是，平均而言，它的运行速度明显更快（与O(log n)相当）。

### 扩展阅读

在MapView中显示大量对象 - 四叉树的一个很好的用例（[Thoughtbot Article](https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps)）

[四叉树的维基百科](https://en.wikipedia.org/wiki/Quadtree)


*作者：Timur Galimov*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  
