//
//  MosaikMixin.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/10/10.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

protocol MosaikMixin: GameMixin {
}

extension MosaikMixin {
    var gameDocumentBase: GameDocumentBase { return MosaikDocument.sharedInstance }
    var gameDocument: MosaikDocument { return MosaikDocument.sharedInstance }
}
