//
//  MinesweeperGameState.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

class MinesweeperGameState: GridGameState, MinesweeperMixin {
    // http://stackoverflow.com/questions/24094158/overriding-superclass-property-with-different-type-in-swift
    var game: MinesweeperGame {
        get {return getGame() as! MinesweeperGame}
        set {setGame(game: newValue)}
    }
    var objArray = [MinesweeperObject]()
    
    override func copy() -> MinesweeperGameState {
        let v = MinesweeperGameState(game: game)
        return setup(v: v)
    }
    func setup(v: MinesweeperGameState) -> MinesweeperGameState {
        _ = super.setup(v: v)
        v.objArray = objArray
        return v
    }
    
    required init(game: MinesweeperGame) {
        super.init(game: game)
        objArray = Array<MinesweeperObject>(repeating: .empty, count: rows * cols)
        for p in game.pos2hint.keys {
            self[p] = .hint(state: .normal)
        }
        updateIsSolved()
    }
    
    subscript(p: Position) -> MinesweeperObject {
        get {
            return self[p.row, p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> MinesweeperObject {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }
    
    func setObject(move: inout MinesweeperGameMove) -> Bool {
        let p = move.p
        let (o1, o2) = (self[p], move.obj)
        if case .hint = o1 {return false}
        guard String(describing: o1) != String(describing: o2) else {return false}
        self[p] = o2
        updateIsSolved()
        return true
    }
    
    func switchObject(move: inout MinesweeperGameMove) -> Bool {
        let markerOption = MarkerOptions(rawValue: self.markerOption)
        func f(o: MinesweeperObject) -> MinesweeperObject {
            switch o {
            case .empty:
                return markerOption == .markerFirst ? .marker : .mine
            case .mine:
                return markerOption == .markerLast ? .marker : .empty
            case .marker:
                return markerOption == .markerFirst ? .mine : .empty
            default:
                return o
            }
        }
        move.obj = f(o: self[move.p])
        return setObject(move: &move)
    }
    
    private func updateIsSolved() {
        isSolved = true
        for r in 0..<rows {
            for c in 0..<cols {
                let p = Position(r, c)
                if case .forbidden = self[p] {self[p] = .empty}
            }
        }
        for (p, n2) in game.pos2hint {
            var n1 = 0
            var rng = [Position]()
            for os in MinesweeperGame.offset {
                let p2 = p + os
                guard game.isValid(p: p2) else {continue}
                switch self[p2] {
                case .mine:
                    n1 += 1
                case .empty:
                    rng.append(p2)
                default:
                    break
                }
            }
            let s: HintState = n1 < n2 ? .normal : n1 == n2 ? .complete : .error
            self[p] = .hint(state: s)
            if s != .complete {
                isSolved = false
            } else {
                for p2 in rng {
                    self[p2] = .forbidden
                }
            }
        }
    }
}