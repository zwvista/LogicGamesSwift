//
//  PairakabeMixin.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/10/10.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

protocol PairakabeMixin: GameMixin {
}

extension PairakabeMixin {
    var gameDocumentBase: GameDocumentBase { return PairakabeDocument.sharedInstance }
    var gameDocument: PairakabeDocument { return PairakabeDocument.sharedInstance }
}
