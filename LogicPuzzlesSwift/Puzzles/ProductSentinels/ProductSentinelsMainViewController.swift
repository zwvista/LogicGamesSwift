//
//  ProductSentinelsMainViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/09/21.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import UIKit

class ProductSentinelsMainViewController: GameMainViewController {
    override func getGameDocument() -> GameDocumentBase { ProductSentinelsDocument.sharedInstance }
}

class ProductSentinelsOptionsViewController: GameOptionsViewController {
    override func getGameDocument() -> GameDocumentBase { ProductSentinelsDocument.sharedInstance }
}

class ProductSentinelsHelpViewController: GameHelpViewController {
    override func getGameDocument() -> GameDocumentBase { ProductSentinelsDocument.sharedInstance }
}
