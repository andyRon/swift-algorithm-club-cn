# 慢排序（Slow Sort）


目标：将数字数组从低到高（或从高到低）排序。

您将获得一系列数字，需要按正确的顺序排列。 插入排序算法【？？】的工作原理如下：

我们可以分解按升序排序n个数字的问题

1. 找到最大数字  
    1. 找到前n/2个元素的最大值  
    2. 找到剩余n/2个元素的最大值  
    3. 找到这两个最大值中的最大值  
2. 对其余的进行排序  

## 代码

这是慢速排序在Swift中的实现：

```swift
public func slowsort(_ i: Int, _ j: Int) {
    if i>=j {
        return
    }
    let m = (i+j)/2
    slowsort(i,m)
    slowsort(m+1,j)
    if numberList[j] < numberList[m] {
        let temp = numberList[j]
        numberList[j] = numberList[m]
        numberList[m] = temp
    }
    slowsort(i,j-1)
}
```

## 性能

| Case  | 性能 |
|:-------------: |:---------------:|
| 最差       |  slow |
| 最好      | 	O(n^(log(n)/(2+e))))        |
| 平均 | 	O(n^(log(n)/2))       | 

## 扩展阅读

[慢排序的详细说明](http://c2.com/cgi/wiki?SlowSort)


*作者：Lukas Schramm*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*  

(used the Insertion Sort Readme as template)
