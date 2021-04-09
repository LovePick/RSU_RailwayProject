//
//  ViewControllerModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class ViewControllerModel: NSObject {
    
    var mapSizeW:NSInteger = 0
    var mapSizeH:NSInteger = 0
    
    
    
    var bufferMapData:[String:Any]! = nil

    func updateMapSize(){
        
        if let gameScene = ShareData.shared.gamseSceme{
            
            gameScene.updateMapSize(width: mapSizeW, height: mapSizeH)
        }
    }
}
