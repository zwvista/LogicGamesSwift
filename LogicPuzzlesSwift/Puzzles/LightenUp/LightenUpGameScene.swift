//
//  LightenUpGameScene.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/09.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import SpriteKit

class LightenUpGameScene: GameScene<LightenUpGameState> {
    var gridNode: LightenUpGridNode {
        get {return getGridNode() as! LightenUpGridNode}
        set {setGridNode(gridNode: newValue)}
    }
    
    func addWallNumber(n: Int, s: HintState, point: CGPoint, nodeName: String) {
        addLabel(text: String(n), fontColor: s == .normal ? .black : s == .complete ? .green : .red, point: point, nodeName: nodeName)
    }
    
    override func levelInitialized(_ game: AnyObject, state: LightenUpGameState, skView: SKView) {
        let game = game as! LightenUpGame
        removeAllChildren()
        let blockSize = CGFloat(skView.bounds.size.width) / CGFloat(game.cols)
        
        // addGrid
        let offset:CGFloat = 0.5
        addGrid(gridNode: LightenUpGridNode(blockSize: blockSize, rows: game.rows, cols: game.cols), point: CGPoint(x: skView.frame.midX - blockSize * CGFloat(game.cols) / 2 - offset, y: skView.frame.midY + blockSize * CGFloat(game.rows) / 2 + offset))
        
        // addWalls
        for row in 0..<game.rows {
            for col in 0..<game.cols {
                let p = Position(row, col)
                guard case let .wall(s) = state[p].objType else {continue}
                let n = state.game.wall2Lightbulbs[p]!
                let point = gridNode.gridPosition(p: p)
                let wallNode = SKSpriteNode(color: .white, size: coloredRectSize())
                wallNode.position = point
                wallNode.name = "wall"
                gridNode.addChild(wallNode)
                guard n >= 0 else {continue}
                let nodeNameSuffix = "-\(row)-\(col)"
                let wallNumberNodeName = "wallNumber" + nodeNameSuffix
                addWallNumber(n: n, s: s, point: point, nodeName: wallNumberNodeName)
            }
        }
    }
    
    override func levelUpdated(from stateFrom: LightenUpGameState, to stateTo: LightenUpGameState) {
        for row in 0..<stateFrom.rows {
            for col in 0..<stateFrom.cols {
                let point = gridNode.gridPosition(p: Position(row, col))
                let nodeNameSuffix = "-\(row)-\(col)"
                let lightCellNodeName = "lightCell" + nodeNameSuffix
                let lightbulbNodeName = "lightbulb" + nodeNameSuffix
                let markerNodeName = "marker" + nodeNameSuffix
                let wallNumberNodeName = "wallNumber" + nodeNameSuffix
                func removeWallNumber() { removeNode(withName: wallNumberNodeName) }
                func addLightCell() {
                    let lightCellNode = SKSpriteNode(color: .yellow, size: coloredRectSize())
                    lightCellNode.position = point
                    lightCellNode.name = lightCellNodeName
                    gridNode.addChild(lightCellNode)
                }
                func removeLightCell() { removeNode(withName: lightCellNodeName) }
                func addLightbulb(s: AllowedObjectState) {
                    addImage(imageNamed: "lightbulb", color: .red, colorBlendFactor: s == .normal ? 0.0 : 0.2, point: point, nodeName: lightbulbNodeName)
                }
                func removeLightbulb() { removeNode(withName: lightbulbNodeName) }
                func addMarker() {
                    let markerNode = SKShapeNode(circleOfRadius: 5)
                    markerNode.position = point
                    markerNode.name = markerNodeName
                    markerNode.strokeColor = .white
                    markerNode.glowWidth = 1.0
                    markerNode.fillColor = .white
                    gridNode.addChild(markerNode)
                }
                func removeMarker() { removeNode(withName: markerNodeName) }
                let (x, y) = (stateFrom[row, col].lightness, stateTo[row, col].lightness)
                if x > 0 && y == 0 {
                    removeLightCell()
                } else if x == 0 && y > 0 {
                    addLightCell()
                }
                let (ot1, ot2) = (stateFrom[row, col].objType, stateTo[row, col].objType)
                guard String(describing: ot1) != String(describing: ot2) else {continue}
                switch ot1 {
                case .lightbulb:
                    removeLightbulb()
                case .marker:
                    removeMarker()
                case .wall:
                    removeWallNumber()
                default:
                    break
                }
                switch ot2 {
                case let .lightbulb(s):
                    addLightbulb(s: s)
                case .marker:
                    addMarker()
                case let .wall(s):
                    let n = stateTo.game.wall2Lightbulbs[Position(row, col)]!
                    addWallNumber(n: n, s: s, point: point, nodeName: wallNumberNodeName)
                default:
                    break
                }
            }
        }
    }
}
