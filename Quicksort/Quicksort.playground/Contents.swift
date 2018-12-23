
import Foundation

/// 普通的快速排序，不是很高效
func quicksort<T: Comparable>(_ a: [T]) -> [T] {
    guard a.count > 1  else {
        return a
    }
    
    let pivot = a[a.count/2]
    let less = a.filter{ $0 < pivot }
    let equal = a.filter{ $0 == pivot }
    let greater = a.filter{ $0 > pivot }
    
    return quicksort(less) + equal + quicksort(greater)
}

let list = [12,3,2,34,8,-3,-23,9,10,51]
quicksort(list)


/*
 * Lomuto的分区方案
 * 返回 新数组中基准的索引
 */
func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
    let pivot = a[high]
    
    var i = low
    for j in low..<high {
        if a[j] <= pivot {
            (a[i], a[j]) = (a[j], a[i])
            i += 1
        }
    }
    
    (a[i], a[high]) = (a[high], a[i])
    return i
}

var list2 = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
let p = partitionLomuto(&list2, low: 0, high: list2.count - 1)
list2  // show the results

/*
 *Lomuto分区方案的快速排序
 */
func quicksortLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
    if low < high {
        let p = partitionLomuto(&a, low: low, high: high)
        quicksortLomuto(&a, low: low, high: p-1)
        quicksortLomuto(&a, low: p+1, high: high)
    }
}

var list3 = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
quicksortLomuto(&list3, low: 0, high: list3.count - 1)


/*
 * Hoare的分区方案
 * 返回值 不一定是新数组中基准元素的索引
 */
func partitionHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
    let pivot = a[low]
    var i = low - 1
    var j = high + 1
    
    while true {
        repeat { j -= 1 } while a[j] > pivot
        repeat { i += 1 } while a[i] < pivot
        
        if i < j {
            a.swapAt(i, j)
        } else {
            return j
        }
    }
}

var list4 = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
let p4 = partitionHoare(&list4, low: 0, high: list4.count - 1)
list4

/*
 * Hoare分区方案的快速排序
 */
func quicksortHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
    if low < high {
        let p = partitionHoare(&a, low: low, high: high)
        quicksortHoare(&a, low: low, high: p)
        quicksortHoare(&a, low: p + 1, high: high)
    }
}
quicksortHoare(&list4, low: 0, high: list4.count - 1)
list4



public func random(min: Int, max: Int) -> Int {
    assert(min < max)
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}
/*
 * 随机选择基准进行快速排序
 */
func quicksortRandom<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = random(min: low, max: high)
        (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
        
        let p = partitionLomuto(&a, low: low, high: high)
        quicksortRandom(&a, low: low, high: p - 1)
        quicksortRandom(&a, low: p + 1, high: high)
    }
}

var list5 = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
quicksortRandom(&list5, low: 0, high: list5.count - 1)
list5


/// 替代swapAt，i和j相同时不会出现错误
public func swap<T>(_ a: inout [T], _ i: Int, _ j: Int) {
    if i != j {
        a.swapAt(i, j)
    }
}

/*
 * 荷兰国旗🇳🇱分区
 */
func partitionDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
    let pivot = a[pivotIndex]
    
    var smaller = low
    var equal = low
    var larger = high
    
    while equal <= larger {
        if a[equal] < pivot {
            swap(&a, smaller, equal)
            smaller += 1
            equal += 1
        } else if a[equal] == pivot {
            equal += 1
        } else {
            swap(&a, equal, larger)
            larger -= 1
        }
    }
    return (smaller, larger)
}
var list6 = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
partitionDutchFlag(&list6, low: 0, high: list6.count - 1, pivotIndex: 10)
list6

/*
 * 荷兰国旗🇳🇱分区的快速排序
 */
func quicksortDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = random(min: low, max: high)
        let (p, q) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: pivotIndex)
        quicksortDutchFlag(&a, low: low, high: p - 1)
        quicksortDutchFlag(&a, low: q + 1, high: high)
    }
}

quicksortDutchFlag(&list6, low: 0, high: list6.count - 1)
