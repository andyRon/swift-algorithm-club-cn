
func minimum<T: Comparable>(_ array: [T]) -> T? {
    guard var minimum = array.first else {
        return nil
    }
    
    for element in array.dropFirst() {
        minimum = element < minimum ? element : minimum
    }
    return minimum
}

func maximum<T: Comparable>(_ array: [T]) -> T? {
    guard var maximum = array.first else {
        return nil
    }
    
    for element in array.dropFirst() {
        maximum = element > maximum ? element : maximum
    }
    return maximum
}

let array = [3,2, 56, 1, 123, 45, -1, 5]
minimum(array)
maximum(array)
// Swift自带的方法
array.max()
array.min()

func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
    guard var minimum = array.first else {
        return nil
    }
    var maximum = minimum
    
    let start = array.count % 2
    for i in stride(from: start, to: array.count, by: 2) {
        let pair = (array[i], array[i+1])
        
        if pair.0 > pair.1 {
            if pair.0 > maximum {
                maximum = pair.0
            }
            if pair.1 < minimum {
                minimum = pair.1
            }
        } else {
            if pair.1 > maximum {
                maximum = pair.1
            }
            if pair.0 < minimum {
                minimum = pair.0
            }
        }
    }
    return (minimum, maximum)
}

minimumMaximum(array)
