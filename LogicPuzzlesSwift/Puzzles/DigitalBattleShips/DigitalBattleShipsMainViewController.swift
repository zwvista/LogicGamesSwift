//
//  DigitalBattleShipsMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class DigitalBattleShipsMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { DigitalBattleShipsDocument.sharedInstance }
}

class DigitalBattleShipsOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { DigitalBattleShipsDocument.sharedInstance }
}

class DigitalBattleShipsHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { DigitalBattleShipsDocument.sharedInstance }
}
