//
//  CarScheduleDetailModel.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 12/4/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class CarScheduleDetailModel {

    var carID:String = ""
    var arSchedule:[ScheduleDetailModel] = [ScheduleDetailModel]()
    
    func getDicData() -> [String:Any] {
        
        var ans:[String:Any] = [String:Any]()
        
        ans["carID"] = carID
        
        var arS:[[String:Any]] = [[String:Any]]()
        
        for item in arSchedule{
            let ds = item.getDicData()
            arS.append(ds)
        }
        
        ans["schedule"] = arS
        
        return ans
    }
    
}
