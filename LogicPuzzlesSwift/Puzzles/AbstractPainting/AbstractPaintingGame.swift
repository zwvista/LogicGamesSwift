//
//  AbstractPaintingGame.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/10.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

class AbstractPaintingGame: GridGame<AbstractPaintingGameViewController> {
    static let offset = [
        Position(-1, 0),
        Position(0, 1),
        Position(1, 0),
        Position(0, -1),
    ]

    var row2hint = [Int]()
    var col2hint = [Int]()
    var areas = [[Position]]()
    var pos2area = [Position: Int]()
    var dots: GridDots!
    
    init(layout: [String], delegate: AbstractPaintingGameViewController? = nil) {
        super.init(delegate: delegate)
        
        size = Position(layout.count / 2 - 1, layout[0].length /  2 - 1)
        dots = GridDots(rows: rows + 1, cols: cols + 1)
        row2hint = Array<Int>(repeating: 0, count: rows)
        col2hint = Array<Int>(repeating: 0, count: cols)
        
        for r in 0..<rows + 1 {
            var str = layout[2 * r]
            for c in 0..<cols {
                let ch = str[2 * c + 1]
                if ch == "-" {
                    dots[r, c][1] = .line
                    dots[r, c + 1][3] = .line
                }
            }
            guard r < rows else {break}
            str = layout[2 * r + 1]
            for c in 0..<cols + 1 {
                let ch = str[2 * c]
                if ch == "|" {
                    dots[r, c][2] = .line
                    dots[r + 1, c][0] = .line
                }
            }
        }
        var rng = Set<Position>()
        let g = Graph()
        var pos2node = [Position: Node]()
        for r in 0..<rows {
            for c in 0..<cols {
                let p = Position(r, c)
                rng.insert(p)
                pos2node[p] = g.addNode(p.description)
            }
        }
        for r in 0..<rows {
            for c in 0..<cols {
                let p = Position(r, c)
                for i in 0..<4 {
                    if dots[p + ParksGame.offset2[i]][ParksGame.dirs[i]] != .line {
                        g.addEdge(pos2node[p]!, neighbor: pos2node[p + ParksGame.offset[i * 2]]!)
                    }
                }
            }
        }
        while !rng.isEmpty {
            let node = pos2node[rng.first!]!
            let nodesExplored = breadthFirstSearch(g, source: node)
            let area = rng.filter({p in nodesExplored.contains(p.description)})
            let n = areas.count
            for p in area {
                pos2area[p] = n
            }
            areas.append(area)
            rng.subtract(area)
        }
        
        for r in 0..<rows {
            let ch = layout[2 * r + 1][2 * cols + 1]
            guard case "1"..."9" = ch else {continue}
            row2hint[r] = ch.toInt!
        }
        for c in 0..<cols {
            let ch = layout[2 * rows + 1][2 * c + 1]
            guard case "1"..."9" = ch else {continue}
            col2hint[c] = ch.toInt!
        }
        
        let state = AbstractPaintingGameState(game: self)
        states.append(state)
        levelInitilized(state: state)
    }
    
    private func changeObject(move: inout AbstractPaintingGameMove, f: (inout AbstractPaintingGameState, inout AbstractPaintingGameMove) -> Bool) -> Bool {
        if canRedo {
            states.removeSubrange((stateIndex + 1)..<states.count)
            moves.removeSubrange(stateIndex..<moves.count)
        }
        // copy a state
        var state = self.state.copy()
        guard f(&state, &move) else {return false}
        
        states.append(state)
        stateIndex += 1
        moves.append(move)
        moveAdded(move: move)
        levelUpdated(from: states[stateIndex - 1], to: state)
        return true
    }
    
    func switchObject(move: inout AbstractPaintingGameMove) -> Bool {
        return changeObject(move: &move, f: {state, move in state.switchObject(move: &move)})
    }
    
    func setObject(move: inout AbstractPaintingGameMove) -> Bool {
        return changeObject(move: &move, f: {state, move in state.setObject(move: &move)})
    }
    
}