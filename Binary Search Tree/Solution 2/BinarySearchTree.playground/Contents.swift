/*
 二叉搜索树(Binary Search Tree, BST)  结构体实现
 */

public enum BinarySearchTree<T: Comparable> {
    case empty
    case leaf(T)
    indirect case node(BinarySearchTree, T, BinarySearchTree)
    
    public var count: Int {
        switch self {
        case .empty:
            return 0
        case .leaf:
            return 1
        case let .node(left, _, right):
            return left.count + 1 + right.count
        }
    }
    
    public var height: Int {
        switch self {
        case .empty:
            return 0
        case .leaf:
            return 1
        case let .node(left, _, right):
            return 1 + max(left.height, right.height)
        }
    }
    
    public func insert(newValue: T) -> BinarySearchTree {
        switch self {
        case .empty:
            return .leaf(newValue)
        case .leaf(let value):
            if newValue < value {
                return .node(.leaf(newValue), value, .empty)
            } else {
                return .node(.empty, value, .leaf(newValue))
            }
        case .node(let left, let value, let right):
            if newValue < value {
                return .node(left.insert(newValue: newValue), value, right)
            } else {
                return .node(left, value, right.insert(newValue: newValue))
            }
        }
    }
    
    public func search(x: T) -> BinarySearchTree? {
        switch self {
        case .empty:
            return nil
        case .leaf(let y):
            return (x == y) ? self : nil
        case let .node(left, y, right):
            if x < y {
                return left.search(x: x)
            } else if y < x {
                return right.search(x: x)
            } else {
                return self
            }
        }
    }
    
    public func contains(x: T) -> Bool {
        return search(x: x) != nil
    }
    
    public func minimum() -> BinarySearchTree {
        var node = self
        var prev = node
        while case let .node(next, _, _) = node {
            prev = node
            node = next
        }
        if case .leaf = node {
            return node
        }
        return prev
    }
    
    public func maximum() -> BinarySearchTree {
        var node = self
        var prev = node
        while case let .node(_, _, next) = node {
            prev = node
            node = next
        }
        if case .leaf = node {
            return node
        }
        return prev
    }
}

extension BinarySearchTree: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .empty:
            return "."
        case .leaf(let value):
            return "\(value)"
        case .node(let left, let value, let right):
            return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
        }
    }
}


var tree = BinarySearchTree.leaf(7)
tree = tree.insert(newValue: 2)
tree = tree.insert(newValue: 5)
tree = tree.insert(newValue: 10)
tree = tree.insert(newValue: 9)
tree = tree.insert(newValue: 1)
print(tree)

tree.search(x: 10)
tree.search(x: 1)
tree.search(x: 11)
