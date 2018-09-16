# Array2D
# 二维数组

In C and Objective-C, you can write the following line,
在C和Objective-C中，您可以编写下面代码，

	int cookies[9][7];
	
to make a 9x7 grid of cookies. This creates a two-dimensional array of 63 elements. To find the cookie at column 3 and row 6, you can write:
制作9x7网格的cookies。 这将创建一个包含63个元素的二维数组。 要在第3列和第6行找到cookie，您可以写：

	myCookie = cookies[3][6];
	
This statement is not acceptable in Swift. To create a multi-dimensional array in Swift, you can write:
这段代码在Swift中不能成立的。 要在Swift中创建一个多维数组，您可以编写：

```swift
var cookies = [[Int]]()
for _ in 1...9 {
  var row = [Int]()
  for _ in 1...7 {
    row.append(0)
  }
  cookies.append(row)
}
```

Then, to find a cookie, you can write:
然后，要查找cookie，您可以写：

```swift
let myCookie = cookies[3][6]
```

You can also create the array in a single line of code:
您还可以在一行代码中创建数组：

```swift
var cookies = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 9)
```

This looks complicated, but you can simplify it with a helper function:
这看起来很复杂，但您可以使用辅助函数简化它：

```swift
func dim<T>(_ count: Int, _ value: T) -> [T] {
  return [T](repeating: value, count: count)
}
```

Then, you can create the array:
然后，你可以这样创建数组：

```swift
var cookies = dim(9, dim(7, 0))
```

Swift infers that the datatype of the array must be `Int` because you specified `0` as the default value of the array elements. To use a string instead, you can write:
Swift推断数组的数据类型必须是`Int`，因为您指定了`0`作为数组元素的默认值。 要使用字符串数组，您可以编写：

```swift
var cookies = dim(9, dim(7, "yum"))
```

The `dim()` function makes it easy to go into even more dimensions:
`dim()`函数可以更容易地进入更多维度：

```swift
var threeDimensions = dim(2, dim(3, dim(4, 0)))
```

The downside of using multi-dimensional arrays or multiple nested arrays in this way is to lose track of what dimension represents what.
以这种方式使用多维数组或多个嵌套数组的缺点是无法跟踪什么维度代表什么。

Instead, you can create your own type that acts like a 2-D array which is more convenient to use:
相反，您可以创建自己的类型，其作用类似于二维数组，使用起来更方便：

```swift
public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  fileprivate var array: [T]
  
  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(repeating: initialValue, count: rows*columns)
  }
  
  public subscript(column: Int, row: Int) -> T {
    get {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      return array[row*columns + column]
    }
    set {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      array[row*columns + column] = newValue
    }
  }
}
```

`Array2D` is a generic type, so it can hold any kind of object, not just numbers.
`Array2D`是一个泛型，因此能够支持所有类型对象，而不是只能是数字

To create an instance of `Array2D`, you can write:
创建`Array2D`示例代码：

```swift
var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
```

By using the `subscript` function, you can retrieve an object from the array:
通过使用下标函数，您可以从数组中检索一个对象：

```swift
let myCookie = cookies[column, row]
```

Or, you can change it:

```swift
cookies[column, row] = newCookie
```

Internally, `Array2D` uses a single one-dimensional array to store the data. The index of an object in that array is given by `(row x numberOfColumns) + column`, but as a user of `Array2D`, you only need to think in terms of "column" and "row", and the details will be done by `Array2D`. This is the advantage of wrapping primitive types into a wrapper class or struct.
在内部，`Array2D`使用单个一维数组来存储数据。 该数组中对象的索引由`(row x numberOfColumns) + column`给出，但作为`Array2D`的用户，您只需要考虑“column”和“row”，详细信息将 由`Array2D`完成。 这是将基本类型包装到包装类或结构中的优点。

*Written for Swift Algorithm Club by Matthijs Hollemans*

*作者： Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*
