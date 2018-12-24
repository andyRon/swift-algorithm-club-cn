
public class LinkedListNode<T: Comparable> {
    var value: T
    var next: LinkedListNode?
    var previous: LinkedListNode?
    
    public init(value: T) {
        self.value = value
    }
}

public class BoundedPriorityQueue<T: Comparable> {
    fileprivate typealias Node = LinkedListNode<T>
    
    private(set) public var count = 0
    fileprivate var head: Node?
    private var tail: Node?
    private var maxElements: Int
    
    public init(maxElements: Int) {
        self.maxElements = maxElements
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public func peek() -> T? {
        return head?.value
    }
    
    public func enqueue(_ value: T) {
        if let node = insert(value, after: findInsertionPoint(value)) {
            
            if node.next == nil {
                tail = node
            }
            
            count += 1
            if count > maxElements {
                removeLeastImportantElement()
            }
        }
    }
    
    private func insert(_ value: T, after: Node?) -> Node? {
        if let previous = after {
            
            if count == maxElements && previous.next == nil {
                print("Queue is full and priority of new object is too small")
                return nil
            }
            
            let node = Node(value: value)
            node.next = previous.next
            previous.next?.previous = node
            previous.next = node
            node.previous = previous
            return head
        } else {
            head = Node(value: value)
            return head
        }
    }
    
    private func findInsertionPoint(_ value: T) -> Node? {
        var node = head
        var prev: Node? = nil
        
        while let current = node, value < current.value {
            prev = node
            node = current.next
        }
        return prev
    }
    
    private func removeLeastImportantElement() {
        if let last = tail {
            tail = last.previous
            tail?.next = nil
            count -= 1
        }
    }
    
    public func dequeue() -> T? {
        if let first = head {
            count -= 1
            if count == 0 {
                head = nil
                tail = nil
            } else {
                head = first.next
                head!.previous = nil
            }
            return first.value
        } else {
            return nil
        }
    }
}

extension LinkedListNode: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}

extension BoundedPriorityQueue: CustomStringConvertible {
    public var description: String {
        var s = "<"
        var node = head
        while let current = node {
            s += "\(current), "
            node = current.next
        }
        return s + ">"
    }
}
