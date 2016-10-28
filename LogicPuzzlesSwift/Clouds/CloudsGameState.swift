//
//  CloudsGameState.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

struct CloudsGameState {
    let game: CloudsGame
    var size: Position { return game.size }
    var rows: Int { return size.row }
    var cols: Int { return size.col }    
    func isValid(p: Position) -> Bool {
        return game.isValid(p: p)
    }
    func isValid(row: Int, col: Int) -> Bool {
        return game.isValid(row: row, col: col)
    }
    var objArray = [CloudsObject]()
    var row2state = [CloudsHintState]()
    var col2state = [CloudsHintState]()
    var options: CloudsGameProgress { return CloudsDocument.sharedInstance.gameProgress }
    
    init(game: CloudsGame) {
        self.game = game
        objArray = Array<CloudsObject>(repeating: CloudsObject(), count: rows * cols)
    }
    
    subscript(p: Position) -> CloudsObject {
        get {
            return objArray[p.row * cols + p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> CloudsObject {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }
    
    mutating func setObject(move: inout CloudsGameMove) -> Bool {
        let p = move.p
        guard isValid(p: p) && self[p] != move.obj else {return false}
        self[p] = move.obj
        updateIsSolved()
        return true
    }
    
    mutating func switchObject(move: inout CloudsGameMove) -> Bool {
        let markerOption = CloudsMarkerOptions(rawValue: options.markerOption)
        func f(o: CloudsObject) -> CloudsObject {
            switch o {
            case .empty:
                return markerOption == .markerBeforeCloud ? .marker : .cloud
            case .cloud:
                return markerOption == .markerAfterCloud ? .marker : .empty
            case .marker:
                return markerOption == .markerBeforeCloud ? .cloud : .empty
            }
        }
        let p = move.p
        guard isValid(p: p) else {return false}
        move.obj = f(o: self[p])
        return setObject(move: &move)
    }
    
    private(set) var isSolved = false
    
    private mutating func updateIsSolved() {
        isSolved = true
        for r in 0 ..< rows {
            var n1 = 0
            let n2 = game.row2hint[r]
            for c in 0 ..< cols {
                if self[r, c] == .cloud {n1 += 1}
            }
            row2state[r] = n1 < n2 ? .normal : n1 == n2 ? .complete : .error
            if n1 != n2 {isSolved = false}
        }
        for c in 0 ..< cols {
            var n1 = 0
            let n2 = game.col2hint[c]
            for r in 0 ..< rows {
                if self[r, c] == .cloud {n1 += 1}
            }
            col2state[c] = n1 < n2 ? .normal : n1 == n2 ? .complete : .error
            if n1 != n2 {isSolved = false}
        }
        guard isSolved else {return}
        let g = Graph()
        var pos2node = [Position: Node]()
        for r in 0 ..< rows {
            for c in 0 ..< cols {
                let p = Position(r, c)
                guard self[p] == .cloud else {continue}
                let node = g.addNode(label: p.description)
                pos2node[p] = node
            }
        }
        for (p, node) in pos2node {
            for os in CloudsGame.offset {
                let p2 = p + os
                guard let node2 = pos2node[p2] else {continue}
                g.addEdge(source: node, neighbor: node2)
            }
        }
        while pos2node.count > 0 {
            let nodesExplored = breadthFirstSearch(g, source: pos2node.values.first!)
            var r2 = 0, r1 = rows, c2 = 0, c1 = cols
            for node in nodesExplored {
                let p = pos2node.filter{$1.label == node}.first!.key
                pos2node.remove(at: pos2node.index(forKey: p)!)
                if r2 < p.row {r2 = p.row}
                if r1 > p.row {r1 = p.row}
                if c2 < p.col {c2 = p.col}
                if c1 > p.col {c1 = p.col}
            }
            let rs = r2 - r1 + 1, cs = c2 - c1 + 1;
            if !(rs >= 2 && cs >= 2 && rs * cs == nodesExplored.count) {
                isSolved = false
                return
            }
        }
    }
}