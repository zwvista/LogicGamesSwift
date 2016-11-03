//
//  GameMixin.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/10/10.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

protocol GameMixin {
    var soundManager: SoundManager { get }
}

extension GameMixin {
    var soundManager: SoundManager { return SoundManager.sharedInstance }
}
