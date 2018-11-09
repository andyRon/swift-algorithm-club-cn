import Foundation

public struct Edge<T>: Equatable where T: Hashable {
    
    public let from: Vertex<T>
    public let to: Vertex<T>
    
    public let weight: Double?
    
}
