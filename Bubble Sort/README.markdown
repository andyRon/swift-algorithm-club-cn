# 冒泡排序(Bubble Sort)


冒泡排序是一种排序算法，它通过重复地走过过要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来，这样做直到数组完全排序。 较小的项慢慢地“冒泡”到数组的开头。


##### Runtime:

- 平均: O(N^2)
- 最差: O(N^2)

##### 内存

- O(1)

### 实现

平均和最差运行时间表明冒泡排序是一种非常低效的算法，因此不会显示实现。 但是，掌握这个概念将有助于您理解简单排序算法的基础知识。

> 译注： [冒泡排序的动画](http://www.algomation.com/player?algorithm=5a1b2f0711aaf40400e46699)
原文没有对冒泡排序实现，处于学习的目的，我自己实现了一下：

```

func bubbleSort(_ numbers:  [Int]) -> [Int]{
    
    var nums = numbers
    let n = nums.count
    for i in 0..<n {
        for j in 0..<(n - 1 - i) {
            if nums[j] > nums[j + 1] {
                nums.swapAt(j, j + 1)
            }
        }
    }
    return nums
}

let nums = [3,42,1,5,34,20,9]
bubbleSort(nums)

```
