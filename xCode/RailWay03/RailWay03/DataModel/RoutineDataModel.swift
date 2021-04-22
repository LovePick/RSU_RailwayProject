//
//  RountineDataModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 17/2/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class RoutineDataModel: NSObject {
    
    enum TimeTableStatus{
        case noData
        case loop
        case oneWay
    }
    
    
    var index:NSInteger = 0
    
    
    var timeTableID:NSInteger = 0
    var count:NSInteger = 1
    var timeTableStatus:TimeTableStatus = .noData
    var startTime:Date = Date()
    var buffStartTime:Date? = nil
    
    var strStartTime:String = ""
    
    var endTime:Date? = nil
    
    var strEndTime:String = ""
    
    override init() {
        super.init()
    
      
        if let d = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: Date()){
            self.startTime = d
            self.buffStartTime = d
            
            let dateFormat:DateFormatter = DateFormatter()
            dateFormat.dateFormat = "HH:mm:ss"
            dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            strStartTime = dateFormat.string(from: d)
        }
        
    }
    
    convenience init(fields:[String: Any]){
        
        self.init()
        
        
        self.readJson(fields: fields)
    }
    
    
    func readJson(fields:[String: Any]) {
        
//        let dateFormat:DateFormatter = DateFormatter()
//        dateFormat.dateFormat = "HH:mm:ss"
//        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//        
        
//        if let id = fields["id"] as? NSInteger{
//            self.id = id
//        }
        
        if let index = fields["index"] as? NSInteger{
            self.index = index
        }
        
        if let timeTableID = fields["timeTableID"] as? NSInteger{
            self.timeTableID = timeTableID
        }
        
        if let count = fields["count"] as? NSInteger{
            self.count = count
        }
        
        if let startAt = fields["startTime"] as? String{
            self.startTime = self.stringTimeToDateToday(str: startAt)
        }
        
        self.buffStartTime = self.startTime
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        strStartTime = dateFormat.string(from: self.startTime)
        

        if let endTimeAt = fields["endTime"] as? String{
            self.endTime = self.stringTimeToDateToday(str: endTimeAt)
            self.strEndTime = endTimeAt
        }
        
        
    }
    
    
    
    func getDictionary()->[String:Any]{
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        var newDic:[String:Any] = [String:Any] ()
//        newDic["id"] = self.id
        newDic["timeTableID"] = self.timeTableID
        newDic["count"] = self.count
        
        let start = dateFormat.string(from: self.startTime)
        newDic["startTime"] = start
        
        let end = dateFormat.string(from: self.endTime ?? self.startTime)
        newDic["endTime"] = end
        
        
        newDic["index"] = self.index
        
        return newDic
        
    }
    
    
    
    func loadTimeTableStatus(timeTables:[TimeTableDataModel]){
        
        self.timeTableStatus = .noData
        for ttb in timeTables{
            if(ttb.id == self.timeTableID){
                
                if(ttb.arDetails.count > 0){
                    self.timeTableStatus = .oneWay
                }
                
                if(ttb.arDetails.count > 1){
                    
                    guard let first = ttb.arDetails.first else { return }
                    guard let last = ttb.arDetails.last else { return }
                    
                    guard let fs = first.station else { return }
                    guard let ls = last.station else { return }
                    
                    if(fs.id == ls.id){
                        self.timeTableStatus = .loop
                    }
                }
                
                break
            }
        }
    }
    
    
    
    func getTimeTableDetailList(timeTables:[TimeTableDataModel])->[TimeTableDetailDataModel]{
        
        self.loadTimeTableStatus(timeTables: timeTables)
        
        if(self.timeTableStatus == .noData){
            return [TimeTableDetailDataModel]()
        }
        
        var timeTable:TimeTableDataModel = TimeTableDataModel()
        for ttb in timeTables{
            if(ttb.id == self.timeTableID){
                timeTable = ttb
                break
            }
        }
         
        var newArDetail:[TimeTableDetailDataModel] = [TimeTableDetailDataModel]()
        
        for _ in 0..<self.count{
            for de in timeTable.arDetails{
                let dic = de.getDictionary()
                let newDetail:TimeTableDetailDataModel = TimeTableDetailDataModel(fields: dic)
                newArDetail.append(newDetail)
            }
        }
        
        
        return newArDetail
    }
    
    
    
    func stringTimeToDateToday(str:String)->Date{
        let arTimeString = str.split(separator: ":")

        guard (arTimeString.count == 3)  else {
            return Date()
        }
        
        guard let H = Int(arTimeString[0]), let m = Int(arTimeString[1]), let s = Int(arTimeString[2]) else {
            return Date()
        }
        
        guard let date = Calendar.current.date(bySettingHour: H, minute: m, second: s, of: Date())else {
            return Date()
        }
        
        return date
        
    }
    
   
    func dateToStringTime(date:Date)->String{
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let str = dateFormat.string(from: date)
        return str
    }
    
}
