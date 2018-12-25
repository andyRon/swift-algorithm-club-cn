/**
 * 固定长度数组
 */
struct FixedSizeArray<T> {
    /// 数组最大存储元素数量
    private var maxSize: Int
    private var defaultValue: T
    private var array: [T]
    /// 数组当前包含的元素数量
    private(set) var count = 0
    
    init(maxSize: Int, defaultValue: T) {
        self.maxSize = maxSize
        self.defaultValue = defaultValue
        self.array = [T](repeating: defaultValue, count: maxSize)
    }
    
    subscript(index: Int) -> T {
        assert(index >= 0)
        assert(index < count)
        return array[index]
    }
    
    mutating func append(_ newElement: T) {
        assert(count < maxSize)
        array[count] = newElement
        count += 1
    }
    
    mutating func removeAt(index: Int) -> T {
        assert(index >= 0)
        assert(index < count)
        count -= 1
        let result = array[index]
        array[index] = array[count]
        array[count] = defaultValue
        return result
    }
    
    mutating func removeAll() {
        for i in 0..<count {
            array[i] = defaultValue
        }
        count = 0
    }
    
}

var a = FixedSizeArray(maxSize: 10, defaultValue: 0)
