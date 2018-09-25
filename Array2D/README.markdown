# 二维数组（Array2D）

在C和Objective-C中，您可以编写下面代码，

	int cookies[9][7];
	
制作9x7网格的cookies。 这将创建一个包含63个元素的二维数组。 要在第3列和第6行找到cookie，您可以写：

	myCookie = cookies[3][6];
	
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

然后，要查找cookie，您可以写：

```swift
let myCookie = cookies[3][6]
```

您还可以使用一行代码中创建上面的数组：

```swift
var cookies = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 9)
```

这看起来很复杂，但您可以使用辅助函数简化它：

```swift
func dim<T>(_ count: Int, _ value: T) -> [T] {
  return [T](repeating: value, count: count)
}
```
> 译注：这边的`dim`，应该是`dimension`（维度）的缩写。

然后，你可以这样创建数组：

```swift
var cookies = dim(9, dim(7, 0))
```

Swift推断数组的数据类型必须是`Int`，因为您指定了`0`作为数组元素的默认值。 要使用字符串数组，您可以编写：

```swift
var cookies = dim(9, dim(7, "yum"))
```

`dim()`函数可以更容易地创建更多维度的数组：

```swift
var threeDimensions = dim(2, dim(3, dim(4, 0)))
```

以这种方式使用多维数组或多个嵌套数组的缺点是无法跟踪什么维度代表什么。

然而，您可以创建自己的类型，其作用类似于二维数组，使用起来更方便：

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

> 译注：`precondition(_:_:file:line:)`函数类似`assert`，满足条件会造成程序的提前终止并抛出错误信息，详细查看[官方文档](https://developer.apple.com/documentation/swift/1540960-precondition)。此处有来表示当下标超过范围的提示，效果如下：
![](https://upload-images.jianshu.io/upload_images/1678135-23c580bf5f081edc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`Array2D`是一个泛型，因此能够支持所有类型对象，而不是只能是数字

创建`Array2D`示例代码：

```swift
var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
```

通过使用下标函数，您可以从数组中检索一个对象：

```swift
let myCookie = cookies[column, row]
```

或者设置对象：

```swift
cookies[column, row] = newCookie
```

在内部，`Array2D`使用单个一维数组来存储数据。 该数组中对象的索引由`(row x numberOfColumns) + column`给出，但作为`Array2D`的用户，您只需要考虑`column`和`row`，具体事件将 由`Array2D`完成。 这是将基本类型包装成包装类或结构中的优点。


*作者： Matthijs Hollemans*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
*校对：[Andy Ron](https://github.com/andyRon)*
