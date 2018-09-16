/*
 Queue
 
 队列可以保证元素存入和取出的顺序是先进先出(first-in first-out, FIFO)
 
 In this implementation, enqueuing is an O(1) operation, dequeuing is O(n).
 */

public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        // 周期性地清理无用空间
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

var q = Queue<String>()
q.array

q.enqueue("🍎")
q.enqueue("🍌")
q.enqueue("🍐")
q.enqueue("🍑")
q.array
q.count

q.dequeue()
q.array
q.count

q.dequeue()
q.array
q.count

q.enqueue("🍇")
q.array
q.count

q.front

q.isEmpty



