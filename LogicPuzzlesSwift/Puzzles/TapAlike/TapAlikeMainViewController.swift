//
//  TapAlikeMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class TapAlikeMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { TapAlikeDocument.sharedInstance }
}

class TapAlikeOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { TapAlikeDocument.sharedInstance }
}

class TapAlikeHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { TapAlikeDocument.sharedInstance }
}
