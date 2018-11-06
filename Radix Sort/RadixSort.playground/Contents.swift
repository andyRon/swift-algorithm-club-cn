
import Foundation

// 不能处理负数
public func radixSort(_ array: inout [Int]) {
    let radix = 10
    var done = false
    var index: Int
    var digit = 1
    
    while !done {
        done = true
        
        var buckets: [[Int]] = []  // 我们的排序子程序是桶排序，所以让我们预定义我们的桶
        
        for _ in 1...radix {
            buckets.append([])
        }
        
        for number in array {
            index = number / digit
            buckets[index % radix].append(number)
            if done && index > 0 {
                done = false
            }
        }
        
        var i = 0
        
        for j in 0..<radix {
            let bucket = buckets[j]
            for number in bucket {
                array[i] = number
                i += 1
            }
        }
        
        digit *= radix
    }
}

// 小数组的测试
var array: [Int] = [19, 4242, 2, 9, 912, 101, 55, 67, 89, 32]
radixSort(&array)
print(array)

// 大数组的测试
var bigArray = [Int](repeating: 0, count: 1000)
var i = 0
while i < 100 {
    bigArray[i] = Int(arc4random_uniform(1000) + 1)
    i += 1
}
radixSort(&bigArray)
print(bigArray)
