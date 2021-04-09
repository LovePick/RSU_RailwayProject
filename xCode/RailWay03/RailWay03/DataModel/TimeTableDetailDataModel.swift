//
//  TimeTableDataModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 29/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class TimeTableDetailDataModel: NSObject {

    var index:NSInteger = -1
    
    
    
    var path:PathDataModel? = nil
    var dewell:NSInteger = 5
    
    
    var fromStation:TileCellDataModel? = nil
    var station:TileCellDataModel? = nil
    var toStation:TileCellDataModel? = nil
    
    
    var duration:NSInteger = 5
    
    
    //var arrive:Date? = Date()
    //var depart:Date? = Date()
    override init() {
        super.init()
        
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
//        if let strarrive = fields["arrive"] as? String{
//
//            if let date = dateFormat.date(from: strarrive){
//                self.arrive = date
//            }else{
//                self.arrive = nil
//            }
//
//        }
//
//        if let strdepart = fields["depart"] as? String{
//
//            if let date = dateFormat.date(from: strdepart){
//                self.depart = date
//            }else{
//                self.depart = nil
//            }
//        }
        
        
        
        if let partDic = fields["part"] as? [String:Any]{
            self.path = PathDataModel(fields: partDic)
        }
        if let partDic = fields["path"] as? [String:Any]{
            self.path = PathDataModel(fields: partDic)
        }
        
        
        if let dewell = fields["dewell"] as? NSInteger{
            self.dewell = dewell
        }
        
        
        
        if let duration = fields["duration"] as? NSInteger{
            self.duration = duration
        }
        
        if let fromStation = fields["fromStation"] as? [String:Any]{
            self.fromStation = TileCellDataModel(fields: fromStation)
        }

        if let station = fields["station"] as? [String:Any]{
            self.station = TileCellDataModel(fields: station)
        }
        
        if let toStation = fields["toStation"] as? [String:Any]{
            self.toStation = TileCellDataModel(fields: toStation)
        }
        
        
        if let index = fields["index"] as? NSInteger{
            self.index = index
        }
        
        
        
        
    }
    
    
    func getDictionary()->[String:Any]{
        var newDic:[String:Any] = [String:Any]()
        
//        let dateFormat:DateFormatter = DateFormatter()
//        dateFormat.dateFormat = "HH:mm:ss"
//        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//        if let a = self.arrive{
//            let str = dateFormat.string(from: a)
//            newDic["arrive"] = str
//        }
//
//        if let d = self.depart{
//            let str = dateFormat.string(from: d)
//            newDic["depart"] = str
//        }
        
        if let myPath = self.path{
            newDic["path"] = myPath.getDicData()
        }
        
        
        newDic["dewell"] = self.dewell
        
        newDic["duration"] = self.duration
        
        newDic["index"] = self.index
        
        
        
        if let fromStation = self.fromStation{
            newDic["fromStation"] = fromStation.getDictData()
        }
        
        if let station = self.station{
            newDic["station"] = station.getDictData()
        }
        
        if let toStation = self.toStation{
            newDic["toStation"] = toStation.getDictData()
        }
        
        

        
        
        
        return newDic
    }
    
    
    
    
    func getUseTime()->NSInteger{
        
        var dw = self.dewell
        var dt = self.duration
        
        if(dw < 0){
            dw = 0
        }
        
        if(dt < 0){
            dt = 0
        }
        return dw + dt
    }
    
}
