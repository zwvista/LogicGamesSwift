//
//  MasyuGameViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/08/31.
//  Copyright (c) 2016年 趙偉. All rights reserved.
//

import UIKit
import SpriteKit

class MasyuGameViewController: GameViewController, GameDelegate, MasyuMixin {

    var scene: MasyuGameScene!
    var game: MasyuGame!
    weak var skView: SKView!
    var levelInitilizing = false

    @IBOutlet weak var lblSolved: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblMoves: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = MasyuGameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = UIColor.black
        
        // Present the scene.
        skView.presentScene(scene)
        
        lblLevel.textColor = SKColor.white
        lblMoves.textColor = SKColor.white
        
        startGame()
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        guard !game.isSolved else {return}
        let touchLocation = sender.location(in: sender.view)
        let touchLocationInScene = scene.convertPoint(fromView: touchLocation)
        guard scene.gridNode.contains(touchLocationInScene) else {return}
        let touchLocationInGrid = scene.convert(touchLocationInScene, to: scene.gridNode)
        let (b, p, orientation) = scene.gridNode.linePosition(point: touchLocationInGrid)
        guard b else {return}
        var move = MasyuGameMove(p: p, objOrientation: orientation, obj: .empty)
        if game.switchObject(move: &move) { soundManager.playSoundTap() }
    }
    
    func startGame() {
        lblLevel.text = gameDocument.selectedLevelID
        let layout = gameDocument.levels[gameDocument.selectedLevelID]!
        
        levelInitilizing = true
        defer {levelInitilizing = false}
        game = MasyuGame(layout: layout, delegate: self)
        
        // restore game state
        for case let rec as MasyuMoveProgress in gameDocument.moveProgress {
            var move = MasyuGameMove(p: Position(rec.row, rec.col), objOrientation: MasyuObjectOrientation(rawValue: rec.objOrientation)!, obj: MasyuObject(rawValue: rec.obj)!)
                _ = game.setObject(move: &move)
        }
        let moveIndex = gameDocument.levelProgress.moveIndex
        guard case 0..<game.moveCount = moveIndex else {return}
        while moveIndex != game.moveIndex {
            game.undo()
        }
    }
    
    func moveAdded(_ game: AnyObject, move: MasyuGameMove) {
        guard !levelInitilizing else {return}
        gameDocument.moveAdded(game: game, move: move)
    }
    
    func updateLabels(_ game: MasyuGame) {
        lblMoves.text = "Moves: \(game.moveIndex)(\(game.moveCount))"
        lblSolved.textColor = game.isSolved ? SKColor.white : SKColor.black
    }
    
    func levelInitilized(_ game: AnyObject, state: MasyuGameState) {
        let game = game as! MasyuGame
        updateLabels(game)
        scene.levelInitialized(game, state: state, skView: skView)
    }
    
    func levelUpdated(_ game: AnyObject, from stateFrom: MasyuGameState, to stateTo: MasyuGameState) {
        let game = game as! MasyuGame
        updateLabels(game)
        scene.levelUpdated(from: stateFrom, to: stateTo)
        guard !levelInitilizing else {return}
        gameDocument.levelUpdated(game: game)
    }
    
    func gameSolved(_ game: AnyObject) {
        if !levelInitilizing {
            soundManager.playSoundSolved()
        }
    }
    
    @IBAction func undoGame(_ sender: AnyObject) {
        game.undo()
    }
    
    @IBAction func redoGame(_ sender: AnyObject) {
        game.redo()
    }
    
    @IBAction func clearGame(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Clear", message: "Do you really want to reset the level?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(noAction)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.gameDocument.clearGame()
            self.startGame()
        }
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backToMain(_ sender: AnyObject) {
        navigationController!.popViewController(animated: true)
    }

}
