/*
 插入排序
 */
public func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
    var a = array
    for x in 1..<a.count {
        var y = x
        let temp = a[y]
        while y > 0 && isOrderedBefore(temp, a[y-1]) {
            a[y] = a[y-1]
            y -= 1
        }
        a[y] = temp
    }
    return a
}


let numbers = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(numbers, <)
insertionSort(numbers, >)

let strings = [ "b", "a", "d", "c", "e" ]
insertionSort(strings, <)
