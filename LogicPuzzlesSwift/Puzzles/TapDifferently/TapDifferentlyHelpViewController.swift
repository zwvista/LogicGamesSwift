//
//  TapDifferentlyHelpViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2017/05/14.
//  Copyright © 2017年 趙偉. All rights reserved.
//

import UIKit

class TapDifferentlyHelpViewController: GameHelpViewController {

    var gameDocument: TapDifferentlyDocument { return TapDifferentlyDocument.sharedInstance }
    override func getGameDocument() -> GameDocumentBase! { return TapDifferentlyDocument.sharedInstance }

}