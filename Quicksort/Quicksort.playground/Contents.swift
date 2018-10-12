
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
