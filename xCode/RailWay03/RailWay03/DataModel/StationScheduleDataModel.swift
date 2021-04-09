//
//  StationScheduleDataModel.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 27/4/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class StationScheduleDataModel: NSObject {

    var stationID:String = ""
    var carID:String = ""
    var from:String = ""
    var to:String = ""
    var depart:Date = Date()
    var arrive:Date = Date()
    
    
    func getDicData() -> [String:Any] {
        var ans:[String:Any] = [String:Any]()
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        

        ans["depart"] = dateFormat.string(from: self.depart)
        ans["arrive"] = dateFormat.string(from: self.arrive)
        
        
        
        ans["stationID"] = self.stationID
        ans["to"] = self.to
        ans["from"] = self.from
        ans["carID"] = self.carID

        return ans
    }
}
