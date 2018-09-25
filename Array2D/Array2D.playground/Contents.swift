

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
            // `precondition(_:_:file:line:)`函数类似`assert`，满足条件会造成程序的提前终止并抛出错误信息，详细查看[官方文档](https://developer.apple.com/documentation/swift/1540960-precondition)。
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


var cookies = Array2D(columns: 10, rows: 7, initialValue: 0)
cookies[5, 2]
cookies[5, 2] = 1587
cookies[5, 2]

//cookies[11, 2]
