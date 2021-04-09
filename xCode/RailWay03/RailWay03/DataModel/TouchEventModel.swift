//
//  TouchEventModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class TouchEventModel: NSObject {

    enum ActionEvent{
        case non
        case moveMap
        case selectTileType
        case zoom
    }
    
    var start:CGPoint = CGPoint.zero
    var now:CGPoint = CGPoint.zero
    var end:CGPoint = CGPoint.zero
    var active:Bool = false
    
    var action:ActionEvent = .non
    
    var disPlayMode:ViewController.DisplayMode = .non

    var objectStartPoint:CGPoint = CGPoint.zero
}



