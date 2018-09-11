//
//  KWGridGraph.swift
//  KPathFinding
//
//  Created by Vitor Kawai Sala on 28/08/18.
//

import GameplayKit

open class KWGridGraph: GKGridGraph<KWGridGraphNode> {
    private(set) var pathfind: KWDjikstraPathfind = KWDjikstraPathfind()
    
    /// Generate obstacles given an obstacle tile map.
    ///
    /// - Parameter tileMap: The tile map containing obstacles.
    open func addObstacle(fromTileMap tileMap: SKTileMapNode) {
        for y in 0..<self.gridHeight {
            for x in 0..<self.gridWidth where tileMap.haveTile(atColumn: x, row: y) {
                if let node: KWGridGraphNode = self.node(atGridPosition: vector_int2(x: Int32(x), y: Int32(y))) {
                    self.remove([node])
                }
            }
        }
    }
    
    /// Generate obstacles given an another Grid Graph
    ///
    /// - Parameter gridGraph: The **KWGridGraph** containing the obstacles
    open func addObstacle(fromGridGraph gridGraph: KWGridGraph) {
        for y in 0..<self.gridHeight {
            for x in 0..<self.gridWidth {
                let vector: vector_int2 = vector_int2(x: Int32(x), y: Int32(y))
                if gridGraph.node(atGridPosition: vector) != nil, let node = self.node(atGridPosition: vector) {
                    self.remove([node])
                }
            }
        }
    }
    
    open func addObstacle(atGridPosition point: vector_int2) {
        guard let node = self.node(atGridPosition: point) else { return }
        if self.pathfind.pathsGenerated {
            let start = Date()
            self.pathfind.updatePath(forGrid: self, removingNode: node)
            let finish = Date()
            NSLog("addObstacle time : \(finish.timeIntervalSince(start))")
        } else {
            self.remove([node])
        }
    }
    
    open func removeObstacle(atGridPosition point: vector_int2) {
        guard self.node(atGridPosition: point) == nil else { return }
        let node = KWGridGraphNode(gridPosition: point)
        self.connectToAdjacentNodes(node: node)
        if self.pathfind.pathsGenerated {
            let start = Date()
            self.pathfind.updatePaths(forGrid: self, afterInsertingNode: node)
            let finish = Date()
            NSLog("removeObstacle time : \(finish.timeIntervalSince(start))")
        }
    }
}

extension KWGridGraph {
    public func generatePaths(convergingToPoint point: vector_int2) {
        let start = Date()
        self.pathfind.generatePaths(forGrid: self, convergingToPoint: point)
        let finish = Date()
        NSLog("generatePaths time : \(finish.timeIntervalSince(start))")
    }
    
    public func findPath(from startNode: vector_int2) -> [vector_int2] {
        let start = Date()
        let path = self.pathfind.findPath(inGrid: self, from: startNode)
        let finish = Date()
        NSLog("findPath time : \(finish.timeIntervalSince(start))")
        return path
    }
    
    public func haveValidPath(from point: vector_int2) -> Bool {
        return self.pathfind.haveValidPath(inGrid: self, from: point)
    }
    
    
}

extension KWGridGraph {
    open func node(atGridPosition position: CGPoint) -> KWGridGraphNode? {
        return self.node(atGridPosition: vector_int2(x: Int32(position.x), y: Int32(position.y)))
    }
    
    open func nodeAtGridPosition(x: Int, y: Int) -> KWGridGraphNode? {
        return self.node(atGridPosition: vector_int2(x: Int32(x), y: Int32(y)))
    }
}
