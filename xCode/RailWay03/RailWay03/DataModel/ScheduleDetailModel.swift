//
//  ScheduleDetailModel.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 12/4/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class ScheduleDetailModel {

    var depart:Date = Date()
    var arrive:Date = Date()
    var station:String = ""
    var to:String = ""
    var from:String = ""
    var car:String = ""
    
    func getDicData() -> [String:Any] {
        var ans:[String:Any] = [String:Any]()
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        

        ans["depart"] = dateFormat.string(from: self.depart)
        ans["arrive"] = dateFormat.string(from: self.arrive)
        
        
        
        ans["station"] = self.station
        ans["to"] = self.to
        ans["from"] = self.from
        ans["car"] = self.car
        
        return ans
    }
    
    
}
