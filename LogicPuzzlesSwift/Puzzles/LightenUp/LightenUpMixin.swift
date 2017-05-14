//
//  LightenUpMixin.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/10/10.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

protocol LightenUpMixin: GameMixin {
}

extension LightenUpMixin {
    var gameDocumentBase: GameDocumentBase { return LightenUpDocument.sharedInstance }
    var gameDocument: LightenUpDocument { return LightenUpDocument.sharedInstance }
}
