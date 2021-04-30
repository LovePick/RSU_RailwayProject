//
//  RealmDataRecordModel.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 22/6/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa
import RealmSwift


class RealmDataRecordModel: Object {

    @objc dynamic var time = Date()
    @objc dynamic var status = ""
    
    @objc dynamic var train_id = ""
    @objc dynamic var train_name = ""
    
    @objc dynamic var from_station_id = ""
    @objc dynamic var to_station_id = ""

    
    @objc dynamic var duration = 0.0
    
    @objc dynamic var time_table_routine_id = 0
    
    
    func setDataWith(car:CarDataModel){
        switch car.activeStatus {
        case .unknow:
            self.status = "unknow"
            break
        case .dewell:
            self.status = "dewell"
            break
        case .waitDepart:
            self.status = "waitDepart"
            break
        case .onTheWay:
            self.status = "onTheWay"
            break
        case .arrived:
            self.status = "arrived"
            break
        case .emergencyStop:
            self.status = "emergencyStop"
            break
        case .stop:
            self.status = "stop"
            break
        case .inProgress:
            self.status = "inProgress"
            break
        case .error:
            self.status = "error"
            break
        }
        
       
        self.time = Date()
        self.train_id = car.id
        self.train_name = car.name
        
        self.time_table_routine_id = car.timeTableRoutineId
        
        guard let ttb = car.timeDetail else {
            return
        }
        
        if let station = ttb.station{
            self.from_station_id = station.id
        }
        
        if let to = ttb.toStation{
            self.to_station_id = to.id
        }
        
        let timeDiff = time.timeIntervalSinceNow - car.lastUpdate.timeIntervalSinceNow
        self.duration = timeDiff
    }
    
    
    func getDicData()->[String:Any]{
        
        var newDic:[String:Any] = [String:Any]()
        newDic["time"] = self.time
        
        newDic["train_id"] = self.train_id
        newDic["train_name"] = self.train_name
        newDic["from_station_id"] = self.from_station_id
        newDic["to_station_id"] = self.to_station_id
        
        newDic["status"] = self.status
        newDic["time_table_routine_id"] = self.time_table_routine_id
        newDic["duration"] = self.duration
        
        return newDic
    }
    
    
    func getTextHeader()->String{
        return "time,train_id,train_name,from_station_id,to_station_id,status,time_table_routine_id,duration,,\n"
    }
    
    
    func getTextData(lase:Date?)->String{
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        let strData:String = dateFormat.string(from: self.time)
        
        
        var newDuration = 0.0
        
        if let lase = lase{
            newDuration = self.time.timeIntervalSinceNow - lase.timeIntervalSinceNow
        }
        let str:String = "\(strData),\(self.train_id),\(self.train_name),\(self.from_station_id),\(self.to_station_id),\(self.status),\(self.time_table_routine_id),\(newDuration),,\n"
        
        
        return str
    }
}
