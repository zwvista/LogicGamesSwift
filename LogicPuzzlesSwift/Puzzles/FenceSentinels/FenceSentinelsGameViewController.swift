//
//  FenceSentinelsGameViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/08/31.
//  Copyright (c) 2016年 趙偉. All rights reserved.
//

import UIKit
import SpriteKit

class FenceSentinelsGameViewController: GameGameViewController2<FenceSentinelsGameState, FenceSentinelsGame, FenceSentinelsDocument, FenceSentinelsGameScene> {
    override func getGameDocument() -> GameDocumentBase { FenceSentinelsDocument.sharedInstance }
    
    override func handleTap(_ sender: UITapGestureRecognizer) {
        guard !game.isSolved else {return}
        let touchLocation = sender.location(in: sender.view)
        let touchLocationInScene = scene.convertPoint(fromView: touchLocation)
        guard scene.gridNode.contains(touchLocationInScene) else {return}
        let touchLocationInGrid = scene.convert(touchLocationInScene, to: scene.gridNode)
        let (b, p, dir) = scene.gridNode.linePosition(point: touchLocationInGrid)
        guard b else {return}
        var move = FenceSentinelsGameMove(p: p, dir: dir, obj: .empty)
        if game.switchObject(move: &move) { soundManager.playSoundTap() }
    }
   
    override func newGame(level: GameLevel) -> FenceSentinelsGame {
        FenceSentinelsGame(layout: level.layout, delegate: self)
    }
}
