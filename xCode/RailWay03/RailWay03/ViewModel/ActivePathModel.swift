//
//  ActivePathModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 7/10/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ActivePathModel: NSObject {
    
    var movingPath:CGMutablePath! = nil

    var shapNode:SKShapeNode! = nil
    
 
    
    convenience init(path:[CGPoint]){
        self.init()
        
        self.movingPath = CGMutablePath()
        
       
        for i in 0..<path.count{
            let p = path[i]
            if(i == 0){
                self.movingPath.move(to: p)
            }else{
                self.movingPath.addLine(to: p)
            }
        }
    }
}
