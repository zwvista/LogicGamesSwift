//
//  BridgesGameState.swift
//  LogicGamesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

struct BridgesGameState {
    let game: BridgesGame
    var size: Position { return game.size }
    var rows: Int { return size.row }
    var cols: Int { return size.col }
    func isValid(p: Position) -> Bool {
        return game.isValid(row: p.row, col: p.col)
    }
    func isValid(row: Int, col: Int) -> Bool {
        return game.isValid(row: row, col: col)
    }
    var objArray = [BridgesObject]()
    var options: BridgesGameProgress { return BridgesDocument.sharedInstance.gameProgress }
    
    init(game: BridgesGame) {
        self.game = game
        objArray = Array<BridgesObject>(repeating: BridgesObject(), count: rows * cols)
    }
    
    subscript(p: Position) -> BridgesObject {
        get {
            return objArray[p.row * cols + p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> BridgesObject {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }
    
    mutating func switchBridges(move: BridgesGameMove) -> Bool {
        let pFrom = move.pFrom, pTo = move.pTo
        guard pFrom < pTo && (pFrom.row == pTo.row || pFrom.col == pTo.col) else {return false}
        guard case .island(let state1, var bridges1) = self[pFrom] else {return false}
        guard case .island(let state2, var bridges2) = self[pTo] else {return false}
        let n1 = pFrom.row == pTo.row ? 1 : 2;
        let n2 = (n1 + 2) % 4;
        let os = BridgesGame.offset[n1]
        var p = pFrom + os
        while p != pTo {
            switch bridges1[n1] {
            case 0:
                guard case .empty = self[p] else {return false}
                self[p] = .bridge
            case 2:
                self[p] = .empty
            default:
                break
            }
            p += os
        }
        let n = (bridges1[n1] + 1) % 3
        bridges1[n1] = n; bridges2[n2] = n
        self[pFrom] = .island(state: state1, bridges: bridges1)
        self[pTo] = .island(state: state2, bridges: bridges2)
        updateIsSolved()
        return true
    }
    
    private(set) var isSolved = false
    
    private mutating func updateIsSolved() {
        isSolved = true
        for (p, info) in game.islandsInfo {
            guard case .island(var state, let bridges) = self[p] else {continue}
            let n1 = bridges.reduce(0, +)
            let n2 = info.bridges
            state = n1 < n2 ? .normal : n1 == n2 ? .complete : .error
            if state != .complete {isSolved = false}
            self[p] = .island(state: state, bridges: bridges)
        }
    }
}