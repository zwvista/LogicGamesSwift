//
//  MinesweeperMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class MinesweeperMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { MinesweeperDocument.sharedInstance }
}

class MinesweeperOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { MinesweeperDocument.sharedInstance }
}

class MinesweeperHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { MinesweeperDocument.sharedInstance }
}
