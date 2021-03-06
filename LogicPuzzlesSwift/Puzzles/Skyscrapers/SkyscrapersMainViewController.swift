//
//  SkyscrapersMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class SkyscrapersMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { SkyscrapersDocument.sharedInstance }
}

class SkyscrapersOptionsViewController: GameOptionsViewController {
        override func getGameDocument() -> GameDocumentBase { SkyscrapersDocument.sharedInstance }
}

class SkyscrapersHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { SkyscrapersDocument.sharedInstance }
}
