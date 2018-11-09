import Foundation

private class EdgeList<T> where T: Hashable {
    
    var vertex: Vertex<T>
    var edges: [Edge<T>]?
    
    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    
    func addEdge(_ edge: Edge<T>) {
        edges?.append(edge)
    }
}

open class AdjacencyListGraph<T>: AbstractGraph<T> where T: Hashable {
    
    fileprivate var adjacencyList: [EdgeList<T>] = []
    
    public required init() {
        super.init()
    }
    
    public required init(fromGraph graph: AbstractGraph<T>) {
        super.init(fromGraph: graph)
    }
    
    open override var vertices: [Vertex<T>] {
        var vertices = [Vertex<T>]()
        for edgeList in adjacencyList {
            vertices.append(edgeList.vertex)
        }
        return vertices
    }
    
    open override var edges: [Edge<T>] {
        var allEdges = Set<Edge<T>>()
        for edgeList in adjacencyList {
            guard let edges = edgeList.edges else {
                continue
            }
            
            for edge in edges {
                allEdges.insert(edge)
            }
        }
        return Array(allEdges)
    }
    
    
}
