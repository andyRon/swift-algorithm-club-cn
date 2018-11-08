# 内省排序(IntroSort)

Goal: Sort an array from low to high (or high to low).
目标：将数组从低到高（或从高到低）排序。

IntroSort is the algorithm used by swift to sort a collection. Introsort is an hybrid algorithm invented by David Musser  in 1993 with the purpose of giving a generic sorting algorithm for the C++ standard library. The classic implementation of introsort expect a recursive Quicksort with fallback to Heapsort in case the recursion depth level reached a certain max. The maximum depends on the number of elements in the collection and it is usually 2 * log(n). The reason behind this “fallback” is that if Quicksort was not able to get the solution after 2 * log(n) recursions for a branch, probably it hit its worst case and it is degrading to complexity O( n^2 ). To optimise even further this algorithm, the swift implementation introduce an extra step in each recursion where the partition is sorted using InsertionSort if the count of the partition is less than 20.
内省排序是Swift用于对集合进行排序的算法。 内省排序是David Musser在1993年发明的一种混合算法，目的是为C ++标准库提供通用的排序算法。 对于递归深度级别达到某个最大值，内省排序的经典实现期望递归Quicksort并回退到Heapsort。 最大值取决于集合中元素的数量，通常为2 * log（n）。 这种“后备”背后的原因是，如果Quicksort在分支的2 * log（n）递归之后无法得到解决方案，可能它遇到了最坏的情况，并且它降级到复杂度O（n ^ 2）。 为了进一步优化该算法，swift实现在每次递归中引入了额外的步骤，其中如果分区的计数小于20，则使用InsertionSort对分区进行排序。

The number 20 is an empiric number obtained observing the behaviour of InsertionSort with lists of this size.
数字20是一个经验数字，它使用此大小的列表观察InsertionSort的行为。

Here's an implementation in pseudocode:
伪代码的实现：

```
procedure sort(A : array):
    let maxdepth = ⌊log(length(A))⌋ × 2
    introSort(A, maxdepth)

procedure introsort(A, maxdepth):
    n ← length(A)
    if n < 20:
        insertionsort(A)
    else if maxdepth = 0:
        heapsort(A)
    else:
        p ← partition(A)  // the pivot is selected using median of 3
        introsort(A[0:p], maxdepth - 1)
        introsort(A[p+1:n], maxdepth - 1)
```

## An example
## 例子

Let's walk through the example. The array is initially:
让我们来看看这个例子。 开始数组是：

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]


For this example let's assume that `maxDepth` is **2** and that the size of the partition for the insertionSort to kick in is **5**
对于这个例子，我们假设`maxDepth`是**2**并且要插入的insertSort分区的大小是**5**

The first iteration of introsort begins by attempting to use insertionSort. The collection has 13 elements, so it tries to do heapsort instead. The condition for heapsort to occur is if `maxdepth == 0` evaluates true. Since `maxdepth` is currently **2** for the first iteration, introsort will default to quicksort.
内省排序的第一次迭代从尝试使用insertionSort开始。 该集合有13个元素，因此它尝试进行heapsort。 发生堆的条件是`maxdepth == 0`评估为真。 由于`maxdepth`在第一次迭代中目前是**2**，因此内省排序将默认为quicksort。

The `partition`  method picks the first element, the median and the last, it sorts them and uses the new median as pivot.
`partition`方法选择第一个元素，中间值和最后一个元素，它对它们进行排序并使用新的中位数作为枢轴。

    [ 10, 8, 26 ] -> [ 8, 10, 26 ]
    
Our array is now
现在数组是：

    [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]

**10** is the pivot. After the choice of the pivot, the `partition` method swaps elements to get all the elements less than pivot on the left, and all the elements more or equal than pivot on the right.
**10**是支点。 在选择了枢轴之后，`partition`方法交换元素以使所有元素在左边小于枢轴，并且所有元素大于或等于右边的枢轴。

    [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10, 27, 14, 26 ]
    
Because of the swaps, the index of of pivot is now changed and returned. The next step of introsort is to call recursively itself for the two sub arrays:
由于交换，现在更改并返回数据透视的索引。 内省排序的下一步是为两个子数组递归调用：

    less: [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10 ]
    greater: [ 27, 14, 26 ]

## maxDepth: 1, branch: less

    [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10 ]

The count of the array is still more than 5 so we don't meet yet the conditions for insertion sort to kick in. At this iteration maxDepth is decreased by one but it is still more than zero, so heapsort will not act.
数组的计数仍然超过5，所以我们还没有满足插入排序的条件。在这次迭代中，maxDepth减少了一个但仍然大于零，所以heapsort不会动作。

Just like in the previous iteration quicksort wins and the `partition` method choses a pivot and sorts the elemets less than pivot on the left and the elements more or equeal than pivot on the right.
就像在上一次迭代中一样，quicksort获胜并且`partition`方法选择一个数据透视表并对左边的元素进行排序，而对元素进行排序，元素比右边的数据更多或更有效。

    array: [ 8, 0, 3, 9, 2, 1, 5, 8, -1, 10 ]
    pivot candidates: [ 8, 1, 10] -> [ 1, 8, 10]
    pivot: 8
    before partition: [ 1, 0, 3, 9, 2, 8, 5, 8, -1, 10 ]
    after partition: [ 1, 0, 3, -1, 2, 5, 8, 8, 9, 10 ]
    
    less: [ 1, 0, 3, -1, 2, 5, 8 ]
    greater: [ 8, 9, 10 ]
    
## maxDepth: 0, branch: less

    [ 1, 0, 3, -1, 2, 5, 8 ]
    
Just like before, introsort is recursively executed for `less` and greater. This time `less`has a count more than **5** so it will not be sorted with insertion sort, but the maxDepth decreased again by 1 is now 0 and heapsort takes over sorting the array.
就像以前一样，内省排序以递减的方式执行“less”和更多。这次`less`的计数超过**5**所以它不会按插入排序排序，但maxDepth再次减少1现在为0，而heapsort接管排序数组。

    heapsort -> [ -1, 0, 1, 2, 3, 5, 8 ]
    
## maxDepth: 0, branch: greater

    [ 8, 9, 10 ]

following greater in this recursion, the count of elements is 3, which is less than 5, so this partition is sorted using insertionSort.
在此递归中，如果更大，则元素的数量为3，小于5，因此使用insertionSort对此分区进行排序。

    insertionSort -> [ 8, 9 , 10]
    

## back to maxDepth = 1, branch: greater

    [ 27, 14, 26 ]

At this point the original array has mutated to be
此时原始数组已经变为

    [ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 27, 14, 26 ]
    
now the `less` partition is sorted  and since the count of the `greater` partition is 3 it will be sorted with insertion sort  `[ 14, 26, 27 ]`
现在`less`分区被排序，因为`more`分区的计数是3，它将按插入排序`[14,26,27]`进行排序。

The array is now successfully sorted
数组被成功排序：

    [ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]


## See also
## 扩展阅读

[Introsort on Wikipedia](https://en.wikipedia.org/wiki/Introsort)
[Introsort comparison with other sorting algorithms](http://agostini.tech/2017/12/18/swift-sorting-algorithm/)
[Introsort implementation from the Swift standard library](https://github.com/apple/swift/blob/09f77ff58d250f5d62855ea359fc304f40b531df/stdlib/public/core/Sort.swift.gyb)

*Written for Swift Algorithm Club by Giuseppe Lanza*
*作者：Giuseppe Lanza*  
*翻译：[Andy Ron](https://github.com/andyRon)*