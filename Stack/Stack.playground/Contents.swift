/*
 Stack
 
 栈类似于数组，但是限制了存取操作的灵活性。栈只允许使用者从栈顶 **压入(push)** 元素；从栈顶 **弹出(pop)** 元素；**取得(peek)** 栈顶元素，但不弹出。

 Last-in first-out stack (LIFO)
 Push and pop are O(1) operations.
 */
public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
}
// 让Stack可以遍历
extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            return curr.pop()
        }
    }
}

// 创建一个栈
var stackOfNames = Stack(array: ["小明", "小强", "小戎", "张三", "李四"])

// 想栈顶部添加一个元素
stackOfNames.push("王麻子")
stackOfNames.push("李狗子")

print(stackOfNames.array)

// 移除栈顶部的第一个元素
stackOfNames.pop()

stackOfNames.top

stackOfNames.isEmpty

// 遍历，从顶部开始遍历
for name in stackOfNames {
    print(name)
}
