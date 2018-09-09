# Insertion Sort
# 插入排序

Goal: Sort an array from low to high (or high to low).
目标：把数组从低到高（或从高到低）排序

You are given an array of numbers and need to put them in the right order. The insertion sort algorithm works as follows:
您将获得一系列数字，需要按正确的顺序排列。插入排序算法的工作原理如下

- Put the numbers on a pile. This pile is unsorted.
- Pick a number from the pile. It doesn't really matter which one you pick, but it's easiest to pick from the top of the pile. 
- Insert this number into a new array. 
- Pick the next number from the unsorted pile and also insert that into the new array. It either goes before or after the first number you picked, so that now these two numbers are sorted.
- Again, pick the next number from the pile and insert it into the array in the proper sorted position.
- Keep doing this until there are no more numbers on the pile. You end up with an empty pile and an array that is sorted.
- 把数字放在一个堆里。 这个堆是未排序的。
- 从堆中挑选一个数字。 你选择哪一个并不重要，但最容易从堆顶挑选。
- 把这个数插入一个新的数组。
- 从未排序堆中再选择一个数字，并将其插入之前的数组中。 它要么在第一个数字之前或之后，所以现在这两个数字被排序。
- 再次，从堆中选择下一个数字，并将其插入到数组中的正确排序位置。
- 继续这样做，直到堆上没有数字。 最终得到一个空堆和一个排序的数组。


That's why this is called an "insertion" sort, because you take a number from the pile and insert it in the array in its proper sorted position. 
这就是为什么这被称为“插入”排序，因为你从堆中取一个数字并将其插入数组中的正确排序位置。

## An example
## 一个例子

Let's say the numbers to sort are `[ 8, 3, 5, 4, 6 ]`. This is our unsorted pile.
假设这边有需要排序的一些数字  `[ 8, 3, 5, 4, 6 ]`。

Pick the first number, `8`, and insert it into the new array. There is nothing in that array yet, so that's easy. The sorted array is now `[ 8 ]` and the pile is `[ 3, 5, 4, 6 ]`.
选择第一个数字“8”，然后将其插入新数组中。 新数组是空的，所以插入很容易。 排序的数组现在是`[8]`，堆是`[3,5,4,6]`。

Pick the next number from the pile, `3`, and insert it into the sorted array. It should go before the `8`, so the sorted array is now `[ 3, 8 ]` and the pile is reduced to `[ 5, 4, 6 ]`.
从堆中选择下一个数字“3”，然后将其插入到已排序的数组中。 `3`应该在`8`之前，所以排序的数组现在是`[3,8]`，并且堆被缩减为`[5,4,6]`。

Pick the next number from the pile, `5`, and insert it into the sorted array. It goes in between the `3` and `8`. The sorted array is `[ 3, 5, 8 ]` and the pile is `[ 4, 6 ]`.
从堆中选择下一个数字“5”，然后将其插入到已排序的数组中。 `5`介于“3”和“8”之间。 排序的数组是`[3,5,8]`，堆是`[4,6]`。

Repeat this process until the pile is empty.
重复上面的过程直到堆为空。

## In-place sort
## 原地排序

The above explanation makes it seem like you need two arrays: one for the unsorted pile and one that contains the numbers in sorted order.
上面的解释使你看起来需要两个数组：一个用于存放未排序的堆，另一个用于存放按次序排好的数字。

But you can perform the insertion sort *in-place*, without having to create a separate array. You just keep track of which part of the array is sorted already and which part is the unsorted pile.
但您可以执行*原地*插入排序，而无需创建单独的数组。 您只需跟踪数组的哪个部分已经排序，哪个部分是未排序。

Initially, the array is `[ 8, 3, 5, 4, 6 ]`. The `|` bar shows where the sorted portion ends and the pile begins:
最初，数组是`[8,3,5,4,6]`。 `|`栏显示已排序部分的结束位置和堆的开始位置：

	[| 8, 3, 5, 4, 6 ]

This shows that the sorted portion is empty and the pile starts at `8`.
这表明排序的部分是空的，堆开始于'8'。

After processing the first number, we have:
处理完第一步后，我们有：

	[ 8 | 3, 5, 4, 6 ]

The sorted portion is `[ 8 ]` and the pile is `[ 3, 5, 4, 6 ]`. The `|` bar has shifted one position to the right.
排好序的部分是`[8]`，未排序的堆是`[ 3, 5, 4, 6 ]`。`|`条向右移动了一个位置。

This is how the content of the array changes during the sort:
这是排序期间数组内容的变化方式：

	[| 8, 3, 5, 4, 6 ]
	[ 8 | 3, 5, 4, 6 ]
	[ 3, 8 | 5, 4, 6 ]
	[ 3, 5, 8 | 4, 6 ]
	[ 3, 4, 5, 8 | 6 ]
	[ 3, 4, 5, 6, 8 |]

In each step, the `|` bar moves up one position. As you can see, the beginning of the array up to the `|` is always sorted. The pile shrinks by one and the sorted portion grows by one, until the pile is empty and there are no more unsorted numbers left.
每一步，`|`条向右移动一个位置。 如您所见，数组的开头到`|`总是排好序的。堆缩小一位置，排序部分增加一位置，直到堆变为空的，没有更多未排序的数字为止。

## How to insert
## 怎么插入

At each step you pick the top-most number from the unsorted pile and insert it into the sorted portion of the array. You must put that number in the proper place so that the beginning of the array remains sorted. How does that work?
每一步，您从未排序堆中选择最顶部的数字，并将其插入到数组的已排序部分。 您必须将该数字放在适当的位置，以便数组的从头开始保持排序。 这是如何运作的？

Let's say we've already done the first few elements and the array looks like this:
假设我们已经完成了前几个元素，并且数组看起来像这样：

	[ 3, 5, 8 | 4, 6 ]

The next number to sort is `4`. We need to insert that into the sorted portion `[ 3, 5, 8 ]` somewhere. 
要排序的下一个数字是`4`。 我们需要将它插入到已经排好序的`[3,5,8]`中。

Here's one way to do this: Look at the previous element, `8`. 
这是实现此目的的一种方法：查看前一个元素`8`。

	[ 3, 5, 8, 4 | 6 ]
	        ^
	        
Is this greater than `4`? Yes it is, so the `4` should come before the `8`. We swap these two numbers to get:
前一个元素比`4`大吗？ 是的，所以`4`应该在`8`之前。 我们交换这两个数字得到：

	[ 3, 5, 4, 8 | 6 ]
	        <-->
	       swapped

We're not done yet. The new previous element, `5`, is also greater than `4`. We also swap these two numbers:
还没有完成。 新的前一个元素`5`也大于`4`。 我们还交换了这两个数字：

	[ 3, 4, 5, 8 | 6 ]
	     <-->
	    swapped

Again, look at the previous element. Is `3` greater than `4`? No, it is not. That means we're done with number `4`. The beginning of the array is sorted again.
再看一下前面的元素。 “3”大于“4”吗？ 不它不是。 这意味着我们完成了数字'4'。 数组的开头再次排序。

This was a description of the inner loop of the insertion sort algorithm, which you'll see in the next section. It inserts the number from the top of the pile into the sorted portion by swapping numbers.
这是对插入排序算法的内部循环的描述，您将在下一节中看到。 它通过交换数字将数字从堆的顶部插入到已排序的部分。

## The code
## 代码

Here is an implementation of insertion sort in Swift:
这是插入排序的Swift实现：

```swift
func insertionSort(_ array: [Int]) -> [Int] {
    var a = array			 // 1
    for x in 1..<a.count {		 // 2
        var y = x
        while y > 0 && a[y] < a[y - 1] { // 3
            a.swapAt(y - 1, y)
            y -= 1
        }
    }
    return a
}


```

Put this code in a playground and test it like so:
将代码放在Playground上测试：

```swift
let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(list)
```

Here is how the code works.

1. Make a copy of the array. This is necessary because we cannot modify the contents of the `array` parameter directly. Like Swift's own `sort()`, the `insertionSort()` function will return a sorted *copy* of the original array.

2. There are two loops inside this function. The outer loop looks at each of the elements in the array in turn; this is what picks the top-most number from the pile. The variable `x` is the index of where the sorted portion ends and the pile begins (the position of the `|` bar). Remember, at any given moment the beginning of the array -- from index 0 up to `x` -- is always sorted. The rest, from index `x` until the last element, is the unsorted pile.

3. The inner loop looks at the element at position `x`. This is the number at the top of the pile, and it may be smaller than any of the previous elements. The inner loop steps backwards through the sorted array; every time it finds a previous number that is larger, it swaps them. When the inner loop completes, the beginning of the array is sorted again, and the sorted portion has grown by one element.

> **Note:** The outer loop starts at index 1, not 0. Moving the very first element from the pile to the sorted portion doesn't actually change anything, so we might as well skip it. 

下面就说说代码是如何工作的。

1. 先创建一个数组的拷贝。因为我们不能直接修改参数`array`中的内容，所以这是非常必要的。`insertionSort()` 会返回一个原始数组的拷贝，就像Swift自己的`sort()` 方法一样。

2. 在函数里有两个循环，外层的循环依次查找数组中的每一个元素；这就是从数字堆中取最上面的数字的过程。变量`x`是有序部分结束和堆开始的索引（也就是 | 符号的位置）。要记住的是，在任何时候，从`9`到`x`的位置数组都是有序的，剩下的则是无序的。

3. 内存循环则查找`x` 位置的元素。这就是堆顶的元素，它有可能比前面的所有元素都小。内存循环从有序数组的后面开始往前找。每次找到一个比它的元素，就交换它们的位置，直到内层循环结束，数组的前面部分依然是有序的，有序的元素也增加了一个。

> **注意：** 外层循环是从 1 开始，而不是0。从堆顶将第一个元素移动到有序数组没有任何意义，所以我们跳过这一步。

## No more swaps
## 不需要交换

The above version of insertion sort works fine, but it can be made a tiny bit faster by removing the call to `swap()`. 
上面的插入排序算法可以很好的完成任务，但是也可以移除对 `swap()` 的调用来让它更快。

You've seen that we swap numbers to move the next element into its sorted position:
通过交换两个数字来让下一个元素移动到合适的位置的

	[ 3, 5, 8, 4 | 6 ]
	        <-->
            swap
	        
	[ 3, 5, 4, 8 | 6 ]
         <-->
	     swap

Instead of swapping with each of the previous elements, we can just shift all those elements one position to the right, and then copy the new number into the right position.
可以通过将前面的元素往右挪一个位置来代替元素的交换，然后将新的数字放到正确的位置。

	[ 3, 5, 8, 4 | 6 ]   remember 4
	           *
	
	[ 3, 5, 8, 8 | 6 ]   shift 8 to the right
	        --->
	        
	[ 3, 5, 5, 8 | 6 ]   shift 5 to the right
	     --->
	     
	[ 3, 4, 5, 8 | 6 ]   copy 4 into place
	     *

In code that looks like this:
代码里是这样的：

```swift
func insertionSort(_ array: [Int]) -> [Int] {
  var a = array
  for x in 1..<a.count {
    var y = x
    let temp = a[y]
    while y > 0 && temp < a[y - 1] {
      a[y] = a[y - 1]                // 1
      y -= 1
    }
    a[y] = temp                      // 2
  }
  return a
}
```

The line at `//1` is what shifts up the previous elements by one position. At the end of the inner loop, `y` is the destination index for the new number in the sorted portion, and the line at `//2` copies this number into place.  
`//1` 这行代码就是将前一个元素往右移动一个位置，在内层循环结束的时候， `y` 就是新数字在有序数组中的位置， `//2` 这行代码就是将数字拷贝到正确的地方。


## Making it generic
## 泛型化

It would be nice to sort other things than just numbers. We can make the datatype of the array generic and use a user-supplied function (or closure) to perform the less-than comparison. This only requires two changes to the code.
如果能排序除了数字之外的东西就更好了。我们可以使数组的数据类型泛型化，然后使用一个用户提供的函数（或闭包）来执行比较操作。这仅仅只要改变两个地方。

The function signature becomes:
函数变成这样了：

```swift
func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
```

The array has type `[T]` where `T` is the placeholder type for the generics. Now `insertionSort()` will accept any kind of array, whether it contains numbers, strings, or something else.

The new parameter `isOrderedBefore: (T, T) -> Bool` is a function that takes two `T` objects and returns true if the first object comes before the second, and false if the second object should come before the first. This is exactly what Swift's built-in `sort()` function does.

数组有一个类型 `[T]`，`[T]` 是泛型化的一个占位类型。现在 `insertionSort()` 可以接收任何类型的数组，不管它是包含数字、字符串或者别的什么东西。

新的参数 `isOrderedBefore: (T, T) -> Bool` 是一个接收两个 `T` 对象然后返回一个 `Bool` 值的方法，如果第一个对象大于第二个，那么返回 `true`，反之则返回 `false`。这与 Swift 内置的 `sort()` 方法是一样的。

The only other change is in the inner loop, which now becomes:
另外一个变化就是内层循环，现在应该是这样的：


```swift
      while y > 0 && isOrderedBefore(temp, a[y - 1]) {
```

Instead of writing `temp < a[y - 1]`, we call the `isOrderedBefore()` function. It does the exact same thing, except we can now compare any kind of object, not just numbers.
`temp < a[y - 1]`被 `isOrderedBefore()` 替代，不仅可以比较数字，还可以比较各种对象了。

To test this in a playground, do:
在Playground中测试:

```swift
let numbers = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(numbers, <)
insertionSort(numbers, >)
```

The `<` and `>` determine the sort order, low-to-high and high-to-low, respectively.
`<` 和 `>` 决定排序的顺序，分别代表低到高和高到低。

Of course, you can also sort other things such as strings,
当然，我们也可以排布像字符串一样的数据：

```swift
let strings = [ "b", "a", "d", "c", "e" ]
insertionSort(strings, <)
```

or even more complex objects:
也可以是更复杂的对象：

```swift
let objects = [ obj1, obj2, obj3, ... ]
insertionSort(objects) { $0.priority < $1.priority }
```

The closure tells `insertionSort()` to sort on the `priority` property of the objects.
闭包告诉 `insertionSort()` 方法用 `priority` 属性来进行排序。


Insertion sort is a *stable* sort. A sort is stable when elements that have identical sort keys remain in the same relative order after sorting. This is not important for simple values such as numbers or strings, but it is important when sorting more complex objects. In the example above, if two objects have the same `priority`, regardless of the values of their other properties, those two objects don't get swapped around.
插入排序是一个 *稳定* 的排序算法。当元素相同时，排序后依然保持排序之前的相对顺序，那么这个排序算法就是 *稳定* 的。对于像数字或者字符串这样的简单类型来说，这不是很重要，但是对于复杂的对象来说，这就很重要了。如果两个对象有相同的 `priority`， 不管它们其他的属性如何，这两个对象都不会交换位置。

## Performance
## 性能

Insertion sort is really fast if the array is already sorted. That sounds obvious, but this is not true for all search algorithms. In practice, a lot of data will already be largely -- if not entirely -- sorted and insertion sort works quite well in that case.
如果数组是已经排好序的话，插入排序是非常快速的。这听起来好像很明显，但是不是所有的搜索算法都是这样的。在实际中，有很多数据（大部分，可能不是全部）是已经排序好的，插入排序在这种情况下就是一个非常好的选择。

The worst-case and average case performance of insertion sort is **O(n^2)**. That's because there are two nested loops in this function. Other sort algorithms, such as quicksort and merge sort, have **O(n log n)** performance, which is faster on large inputs.
插入排序的最差和平均表现是 **O( n^2 )**。这是因为在函数里有两个嵌套的循环。其他如快速排序和归并排序的表现则是 **O(n log n)**，在有大量输入的时候会更快。

Insertion sort is actually very fast for sorting small arrays. Some standard libraries have sort functions that switch from a quicksort to insertion sort when the partition size is 10 or less.
插入排序在对小数组进行排序的时候实际是非常快的。一些标准库在数据量小于或者等于10的时候会从快速排序切换到插入排序。

I did a quick test comparing our `insertionSort()` with Swift's built-in `sort()`. On arrays of about 100 items or so, the difference in speed is tiny. However, as your input becomes larger, **O(n^2)** quickly starts to perform a lot worse than **O(n log n)** and insertion sort just can't keep up.
我们做了一个速度测试来对比我们的 `insertionSort()` 和 Swift 内置的 `sort()`。在大概有 100 个元素的数组中，速度上的差异非常小。然后，如果输入一个非常大的数据量， **O(n^2)** 马上就比 **O(n log n)** 表现的糟糕多了，插入排序远远比不上。

## See also
## 扩展阅读

[Insertion sort on Wikipedia](https://en.wikipedia.org/wiki/Insertion_sort)
[插入排序的维基百科](https://en.wikipedia.org/wiki/Insertion_sort)

*Written for Swift Algorithm Club by Matthijs Hollemans*
*作者：Matthijs Hollemans*   
*翻译：[Andy Ron](https://github.com/andyRon)*
