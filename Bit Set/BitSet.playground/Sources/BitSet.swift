import Foundation

/*
 * 固定大小的n位序列。 位具有索引0到n-1。
 */
public struct BitSet {
    /// 对象可以使用的位的大小
    private(set) public var size: Int
    
    private let N = 64
    public typealias Word = UInt64
    fileprivate(set) public var words: [Word]
    
    private let allOnes = ~Word()
    
    public init(size: Int) {
        precondition(size > 0)
        self.size = size
        
        // 取64的倍数（round）
        let n = (size + (N-1)) / N
        words = [Word](repeating: 0, count: n)
    }
    
    private func indexOf(_ i: Int) -> (Int, Word) {
        precondition(i >= 0)
        precondition(i < size)
        let o = i / N
        let m = Word(i - o*N)
        return (o, 1 << m)
    }
    
    private func lastWordMask() -> Word {
        let diff = words.count * N - size
        if diff > 0 {
            let mask = 1 << Word(63 - diff)
            
            return (Word)(mask | (mask - 1))
        } else {
            return allOnes
        }
    }
    
    
    fileprivate mutating func clearUnuseBits() {
        words[words.count - 1] &= lastWordMask()
    }
    
    public subscript(i: Int) -> Bool {
        get { return isSet(i) }
        set { if newValue { set(i) } else { clear(i) } }
    }
    
    public mutating func set(_ i: Int) {
        let (j, m) = indexOf(i)
        words[j] |= m
    }
    
    public mutating func setAll() {
        for i in 0..<words.count {
            words[i] = allOnes
        }
        clearUnuseBits()
    }
    
    public mutating func clear(_ i: Int) {
        let (j, m) = indexOf(i)
        words[j] &= ~m
    }

    public mutating func clearAll() {
        for i in 0..<words.count {
            words[i] = 0
        }
    }
    
    public mutating func flip(_ i: Int) -> Bool {
        let (j, m) = indexOf(i)
        words[j] ^= m
        return (words[j] & m) != 0
    }
    public func isSet(_ i: Int) -> Bool {
        let (j, m) = indexOf(i)
        return (words[j] & m) != 0
    }
    
    public var cardinality: Int {
        var count = 0
        for var x in words {
            let  y = x & ~(x - 1)
            x = x ^ y
            count += 1
        }
        return count
    }
    
    public func all1() -> Bool {
        for i in 0..<words.count - 1 {
            if words[i] != allOnes { return false }
        }
        return words[words.count - 1] == lastWordMask()
    }
    
    public func any1() -> Bool {
        for x in words {
            if x != 0 { return true }
        }
        return false
    }
    
    public func all0() -> Bool {
        for x in words {
            if x != 0 { return false }
        }
        return true
    }
    
}

// MARK: - Equality

extension BitSet: Equatable {
    
}

public func == (lhs: BitSet, rhs: BitSet) -> Bool {
    return lhs.words == rhs.words
}

// MARK: - Hashing

extension BitSet: Hashable {
    
    public var hashValue: Int {
        var h = Word(1234)
        for i in stride(from: words.count, to: 0, by: -1) {
            h ^= words[i - 1] &* Word(i)
        }
        return Int((h >> 32) ^ h)
    }
}

// MARK: - Bitwise operations

extension BitSet {
    public static var allZeros: BitSet {
        return BitSet(size: 64)
    }
}

private func copyLargest(_ lhs: BitSet, _ rhs: BitSet) -> BitSet {
    return (lhs.words.count > rhs.words.count) ? lhs : rhs
}

public func & (lhs: BitSet, rhs: BitSet) -> BitSet {
    let m = max(lhs.size, rhs.size)
    var out = BitSet(size: m)
    let n = min(lhs.words.count, rhs.words.count)
    for i in 0..<n {
        out.words[i] = lhs.words[i] & rhs.words[i]
    }
    return out
}

public func | (lhs: BitSet, rhs: BitSet) -> BitSet {
    var out = copyLargest(lhs, rhs)
    let n = min(lhs.words.count, rhs.words.count)
    for i in 0..<n {
        out.words[i] = lhs.words[i] | rhs.words[i]
    }
    return out
}

public func ^ (lhs: BitSet, rhs: BitSet) -> BitSet {
    var out = copyLargest(lhs, rhs)
    let n = min(lhs.words.count, rhs.words.count)
    for i in 0..<n {
        out.words[i] = lhs.words[i] ^ rhs.words[i]
    }
    return out
}

prefix public func ~ (rhs: BitSet) -> BitSet {
    var out = BitSet(size: rhs.size)
    for i in 0..<rhs.words.count {
        out.words[i] = ~rhs.words[i]
    }
    out.clearUnuseBits()
    return out
}

// MARK: Debugging

extension UInt64 {
    
    public func bitsToString() -> String {
        var s = ""
        var n = self
        for _  in 1...64 {
            s += ((n & 1 == 1) ? "1" : "0")
            n >>= 1
        }
        return s
    }
}

extension BitSet: CustomStringConvertible {
    public var description: String {
        var s = ""
        for x in words {
            s += x.bitsToString() + " "
        }
        return s
    }
}
