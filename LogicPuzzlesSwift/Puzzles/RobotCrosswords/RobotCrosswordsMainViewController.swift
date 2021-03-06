//
//  RobotCrosswordsMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class RobotCrosswordsMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { RobotCrosswordsDocument.sharedInstance }
}

class RobotCrosswordsOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { RobotCrosswordsDocument.sharedInstance }
}

class RobotCrosswordsHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { RobotCrosswordsDocument.sharedInstance }
}
