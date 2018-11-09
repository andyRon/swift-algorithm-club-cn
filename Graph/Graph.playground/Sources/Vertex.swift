import Foundation

public struct Vertex<T>: Equatable where T: Hashable {
    
    public var data: T
    public let index: Int
    
}
