//
//  ShipControllModel.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 19/4/2564 BE.
//  Copyright © 2564 BE T2P. All rights reserved.
//

import Foundation
import Cocoa

class ShipControllModel {
    
    
    var id:String = ""
    var countOffline:NSInteger = 10
    
    var label:NSTextField? = nil
    
    
    func updateStatus(){
        
        
        guard let lb = self.label else {
            return
        }
        lb.stringValue = id
        lb.isEditable = false
        
        if(countOffline >= 10){
            lb.textColor = NSColor.app_red
        }else{
            lb.textColor = NSColor.app_space_blue
        }
    }
    
}
