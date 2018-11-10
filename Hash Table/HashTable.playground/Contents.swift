

public struct HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets = [Bucket]()
    
    /// 哈希表中键值对的数目
    private(set) public var count = 0
    
    public var isEmpty: Bool { return count == 0 }
    
    /// 通过给定的空间创造哈希表
    public init(capacity: Int) {
        assert(capacity > 0)
        buckets = Array<Bucket>(repeatElement([], count: capacity))
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            if let value = newValue {
                updateValue(value, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    private func index(forKey key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    
    public func value(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for element in buckets[index] {
            if element.key == key {
                return element.value
            }
        }
        return nil
    }
    
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                let oldValue = element.value
                buckets[index][i].value = value
                return oldValue
            }
        }
        
        buckets[index].append((key: key, value: value))
        count += 1
        return nil
    }
    
    public mutating func removeValue(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                buckets[index].remove(at: i)
                count -= 1
                return element.value
            }
        }
        return nil
    }
    
    public mutating func removeAll() {
        buckets = Array<Bucket>(repeating: [], count: buckets.count)
        count = 0
    }
}

extension HashTable: CustomStringConvertible {
    
    public var description: String {
        let pairs = buckets.flatMap{ b in b.map{e in "\(e.key) = \(e.value)" }}
        return pairs.joined(separator: ", ")
    }
    
    public var debugDescription: String {
        var str = ""
        for (i, bucket) in buckets.enumerated() {
            let pairs = bucket.map{ e in "\(e.key) = \(e.value)" }
            str += "bucket \(i): " + pairs.joined(separator: ", ") + "\n"
        }
        return str
    }
}

"firstName".hashValue
abs("firstName".hashValue) % 5

"lastName".hashValue
abs("lastName".hashValue) % 5

"hobbies".hashValue
abs("hobbies".hashValue) % 5



var hashTable = HashTable<String, String>(capacity: 5)

hashTable["firstName"] = "Andy"
hashTable["lastName"] = "Ron"
hashTable["hobbies"] = "Programming Swift"

print(hashTable)
print(hashTable.debugDescription)


