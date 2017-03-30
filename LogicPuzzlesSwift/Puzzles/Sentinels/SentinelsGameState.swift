//
//  SentinelsGameState.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/19.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

class SentinelsGameState: GridGameState, SentinelsMixin {
    // http://stackoverflow.com/questions/24094158/overriding-superclass-property-with-different-type-in-swift
    var game: SentinelsGame {
        get {return getGame() as! SentinelsGame}
        set {setGame(game: newValue)}
    }
    var objArray = [SentinelsObject]()
    
    override func copy() -> SentinelsGameState {
        let v = SentinelsGameState(game: game)
        return setup(v: v)
    }
    func setup(v: SentinelsGameState) -> SentinelsGameState {
        _ = super.setup(v: v)
        v.objArray = objArray
        return v
    }
    
    required init(game: SentinelsGame) {
        super.init(game: game)
        objArray = Array<SentinelsObject>(repeating: .empty, count: rows * cols)
        updateIsSolved()
    }
    
    subscript(p: Position) -> SentinelsObject {
        get {
            return self[p.row, p.col]
        }
        set(newValue) {
            self[p.row, p.col] = newValue
        }
    }
    subscript(row: Int, col: Int) -> SentinelsObject {
        get {
            return objArray[row * cols + col]
        }
        set(newValue) {
            objArray[row * cols + col] = newValue
        }
    }
    
    func setObject(move: inout SentinelsGameMove) -> Bool {
        let p = move.p
        let (o1, o2) = (self[p], move.obj)
        if case .hint = o1 {return false}
        // guard case .hint != o1 else {return false} // syntax error
        // guard !(.hint ~= o1) else {return false} // syntax error
        guard String(describing: o1) != String(describing: o2) else {return false}
        self[p] = o2
        updateIsSolved()
        return true
    }
    
    func switchObject(move: inout SentinelsGameMove) -> Bool {
        let markerOption = MarkerOptions(rawValue: self.markerOption)
        func f(o: SentinelsObject) -> SentinelsObject {
            switch o {
            case .empty:
                return markerOption == .markerFirst ? .marker : .tower(state: .normal)
            case .tower:
                return markerOption == .markerLast ? .marker : .empty
            case .marker:
                return markerOption == .markerFirst ? .tower(state: .normal) : .empty
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
                switch self[p] {
                case .forbidden:
                    self[p] = .empty
                case .tower:
                    self[p] = .tower(state: .normal)
                default:
                    break
                }
            }
        }
        for r in 0..<rows {
            for c in 0..<cols {
                let p = Position(r, c)
                func hasTowerNeighbor() -> Bool {
                    for os in SentinelsGame.offset {
                        let p2 = p + os
                        guard isValid(p: p2) else {continue}
                        if case .tower = self[p2] {return true}
                    }
                    return false
                }
                switch self[p] {
                case let .tower(state):
                    self[p] = .tower(state: state == .normal && !hasTowerNeighbor() ? .normal : .error)
                case .forbidden:
                    break
                default:
                    guard allowedObjectsOnly && hasTowerNeighbor() else {continue}
                    self[p] = .forbidden
                }
            }
        }
        for (p, n2) in game.pos2hint {
            var nums = [0, 0, 0, 0]
            var rng = [Position]()
            next:
            for i in 0..<4 {
                let os = SentinelsGame.offset[i]
                var p2 = p + os
                while game.isValid(p: p2) {
                    switch self[p2] {
                    case .tower:
                        continue next
                    case .empty:
                        rng.append(p2)
                    default:
                        break
                    }
                    nums[i] += 1
                    p2 += os
                }
            }
            let n1 = nums[0] + nums[1] + nums[2] + nums[3] + 1
            let s: HintState = n1 > n2 ? .normal : n1 == n2 ? .complete : .error
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
