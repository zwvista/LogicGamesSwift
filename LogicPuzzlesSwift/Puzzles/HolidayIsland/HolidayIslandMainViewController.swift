//
//  HolidayIslandMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class HolidayIslandMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { HolidayIslandDocument.sharedInstance }
}

class HolidayIslandOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { HolidayIslandDocument.sharedInstance }
}

class HolidayIslandHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { HolidayIslandDocument.sharedInstance }
}
