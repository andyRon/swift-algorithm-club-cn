

func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
    for (index, obj) in array.enumerated() where obj == object {
        return index
    }
    return nil
}
/*
 使用尾随闭包简写
 */
func linearSearch1<T: Equatable>(_ array: [T], _ object: T) -> Int? {
    return array.index { $0 == object }
}

linearSearch([2,5,3,12,7,8],  12)

linearSearch1([2,5,3,12,7,8],  7)
