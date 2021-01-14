# 基数排序(Radix Sort)

基数排序是一种排序算法，它将整数数组作为输入，并使用排序子程序（通常是另一种有效的排序算法）来按整数基数或者它们的数字对整数进行排序。 Counting Sort和Bucket Sort通常用作Radix Sort的子程序。

## 例子

* Input Array: [170, 45, 75, 90, 802, 24, 2, 66]
* Output Array (Sorted):  [2, 24, 45, 66, 75, 90, 170, 802]

### 第一步：

此算法的第一步是定义数字，或者更确切地说是我们将用于排序的“base”或基数。
对于这个例子，我们将radix = 10，因为我们在示例中使用的整数是基数10。

### 第二步：

下一步是简单地迭代n次（其中n是输入数组中最大整数中的位数），并且在每次迭代时对当前数字执行排序子程序。

### 算法中的行动

我们来看看我们的示例输入数组。

我们数组中的最大整数是802，它有三位数（一，十，百）。 因此，我们的算法将迭代三次，同时对每个整数的数字执行一些排序算法。

* Iteration 1:  170, 90, 802, 2, 24, 45, 75, 66
* Iteration 2:  802, 2, 24, 45, 66, 170, 75, 90
* Iteration 3:  2, 24, 45, 66, 75, 90, 170, 802


## 代码

``` swift
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


```


更多查看 [基数排序的维基百科](https://en.wikipedia.org/wiki/Radix_Sort)  
[基数排序的中文维基百科](https://zh.wikipedia.org/wiki/基数排序)


*作者：Christian Encarnacion*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

----------

# 翻译后补充


基数排序对数组`[53, 3, 542, 748, 14, 214, 154, 63, 616]`的排序，示意图(来源：https://www.cnblogs.com/skywang12345/p/3603669.html) 说明：

![](image/radix_sort.jpg)
