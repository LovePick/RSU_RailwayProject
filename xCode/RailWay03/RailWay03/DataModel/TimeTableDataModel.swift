//
//  TimeTableDataModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 29/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class TimeTableDataModel: NSObject {

    
    var id:NSInteger = 0
    var name:String = ""
    
    
    
    var arDetails:[TimeTableDetailDataModel] = [TimeTableDetailDataModel]()
    var arStationList:[TileCellDataModel] = [TileCellDataModel]()
    

    //private var startAt:Date = Date()

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
        
        
        if let id = fields["id"] as? NSInteger{
            self.id = id
        }
        
        if let name = fields["name"] as? String{
            self.name = name
        }
        
//        if let startAt = fields["startAt"] as? String{
//            if let date = dateFormat.date(from: startAt){
//                self.startAt = date
//            }else{
//                self.startAt = Date()
//            }
//        }
        
        arStationList.removeAll()
        arDetails.removeAll()
        if let arDic = fields["arDetails"] as? [[String:Any]]{
            for item in arDic{
                let newDetail:TimeTableDetailDataModel = TimeTableDetailDataModel(fields: item)
                if(newDetail.index < 0){
                    newDetail.index = arDetails.count
                }
                
                arDetails.append(newDetail)
                
                if let part = newDetail.path{
                    arStationList.append(part.from)
                    
                    
                }
                
            }
            
            
            //get last station
            if(arDic.count > 0){
                if let last = arDic.last{
                    let newDetail:TimeTableDetailDataModel = TimeTableDetailDataModel(fields: last)
                    if let part = newDetail.path{
                        arStationList.append(part.to)
                    }
                }
            }
            
            
        }
        
        
        
        
    }
    
    
    
    func getDictionary()->[String:Any]{
        
//        let dateFormat:DateFormatter = DateFormatter()
//        dateFormat.dateFormat = "HH:mm:ss"
//        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//
//
        var newDic:[String:Any] = [String:Any] ()
        
        newDic["id"] = self.id
        newDic["name"] = self.name
        
//        let start = dateFormat.string(from: self.startAt)
//        newDic["startAt"] = start
//
        
        
        
        var arDetail:[[String:Any]] = [[String:Any]]()
        
        for item in self.arDetails{
            let newDicDetail = item.getDictionary()
            arDetail.append(newDicDetail)
        }
        newDic["arDetails"] = arDetail
        
        
        return newDic
        
    }
    
    /*
    func updateStartTime(time:Date){
        //self.startAt = time
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        //let modifiedDate = calendar.date(byAdding: .second, value: dewell, to: arrive)

        var lastDuration:NSInteger = 0
        var lastDepart:Date = time
        for i in 0..<self.arDetails.count{

            self.arDetails[i].arrive = calendar.date(byAdding: .second, value: lastDuration, to: lastDepart)
            
            if let arr = self.arDetails[i].arrive, i < (self.arDetails.count - 1){
                
                self.arDetails[i].depart = calendar.date(byAdding: .second, value: self.arDetails[i].dewell, to: arr)

            }
            
            lastDuration = self.arDetails[i].duration
            
            if let dep = self.arDetails[i].depart{
                
                lastDepart = dep
                
            }
        }
    }

 */

    
    func getTimeDulation()->NSInteger{
        
        var allTime:NSInteger = 0
        
        for item in self.arDetails{
            
            allTime = allTime + item.dewell
            allTime = allTime + item.duration
            
        }
        
        return allTime
    }

}
