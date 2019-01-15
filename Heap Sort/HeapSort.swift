/// Heap 见 https://github.com/andyRon/swift-algorithm-club-cn/blob/master/Heap/Heap.swift
extension Heap {
    public mutating func sort() -> [T] {
        for i in stride(from: (nodes.count - 1), through: 1, by: -1) {
            nodes.swaptAt(0, i)
            shiftDown(from: 0, until: i)
        }
        return nodes
    }
}

public func heapsort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
    let reverseOrder = {i1, i2 in sort(i2, i1) }
    var h = Heap(array: a, sort: reverseOrder)
    return h.sort()
}
