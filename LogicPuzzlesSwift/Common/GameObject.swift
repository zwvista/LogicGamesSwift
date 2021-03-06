//
//  GameObject.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2016/11/08.
//  Copyright © 2016年 趙偉. All rights reserved.
//

import Foundation

enum MarkerOptions: Int {
    case noMarker, markerFirst, markerLast
    
    static let optionStrings = ["No Marker", "Marker First", "Marker Last"]
}

enum HintState {
    case normal, complete, error
}

enum AllowedObjectState {
    case normal, error
}
