//
//  PowerGridMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class PowerGridMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { PowerGridDocument.sharedInstance }
}

class PowerGridOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { PowerGridDocument.sharedInstance }
}

class PowerGridHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { PowerGridDocument.sharedInstance }
}
