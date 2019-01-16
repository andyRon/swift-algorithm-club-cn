

func introsort<T>(_ array: inout [T], by areInIncreasingOrder: (T, T) -> Bool) {
    
}

private func introSortImplementation<T>(for array: inout [T], range: Range<Int>, depthLimit: Int, by areInIncreasingOrder: (T, T) -> Bool) {
    
    if array.distance(from: range.lowerBound, to: range.upperBound) < 20 {
        
        insertionSort(for: &array, range: range, by: areInIncreasingOrder)
    } else if depthLimit == 0 {
        
        heapsort(for: &array, range: range, by: areInIncreasingOrder)
    } else {
        
        let partIdx = partitionIndex(for: &array, subRange: range, by: areInIncreasingOrder)
        
        introSortImplementation(for: &array, range: range.lowerBound..<partIdx, depthLimit: depthLimit &- 1, by: areInIncreasingOrder)
        introSortImplementation(for: &array, range: partIdx..<range.upperBound, depthLimit: depthLimit &- 1 , by: areInIncreasingOrder)
    }
    
}


