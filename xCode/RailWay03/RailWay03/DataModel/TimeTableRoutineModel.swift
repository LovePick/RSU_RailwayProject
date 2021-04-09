//
//  TimeTableRoutineModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 17/2/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class TimeTableRoutineModel: NSObject {

    var id:NSInteger = 0
    var name:String = ""
    
    var arRoutine:[RoutineDataModel] = [RoutineDataModel]()
    
    
    override init() {
        super.init()
        
    }
    
    convenience init(fields:[String: Any]){
        
        self.init()
        
        
        self.readJson(fields: fields)
    }
    
    
    func readJson(fields:[String: Any]) {
        
   
        
        if let id = fields["id"] as? NSInteger{
            self.id = id
        }
        
        if let name = fields["name"] as? String{
            self.name = name
        }

        
        self.arRoutine.removeAll()
        if let routineList = fields["routineList"] as? [[String:Any]]{
            var arR:[RoutineDataModel] = [RoutineDataModel]()
            
            for item in routineList{
                let routine:RoutineDataModel = RoutineDataModel(fields: item)
                arR.append(routine)
            }
            
            self.arRoutine = arR.sorted(by: { (r1, r2) -> Bool in
                return r1.index < r2.index
            })
        }
        
        
        
        
    }
    
    
    
    func getDictionary()->[String:Any]{
        
   
        var newDic:[String:Any] = [String:Any] ()
        
        newDic["id"] = self.id
        newDic["name"] = self.name
        
        var arR:[[String:Any]] = [[String:Any]]()
        for item in self.arRoutine {
            let dic = item.getDictionary()
            arR.append(dic)
        }
        newDic["routineList"] = arR
        
        
        
        return newDic
        
    }
    
    
    
    
    func updateDetailData(allRoutineData:[TimeTableDataModel]){
    
        for routine in self.arRoutine{
            routine.loadTimeTableStatus(timeTables: allRoutineData)
        }
    }
    
    
    func updateTimeRelation(startTime:Date){
        
        let index:NSInteger = 0

        self.arRoutine[index].startTime = startTime

        let shareData:ShareData = ShareData.shared
        guard let ms = shareData.masterVC else {
            return
        }
        
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var duration:NSInteger = 0
        
        var lastStart:Date = startTime
        
        var arCollectionIndex:[IndexPath] = [IndexPath]()
        for i in index..<self.arRoutine.count{
            let rout = self.arRoutine[i]
            if let ttb = ms.getTimeTableWith(ttbID: rout.timeTableID){
                if(i > index){
                    let newStartTime = calendar.date(byAdding: .second, value: Int(duration), to: startTime) ?? lastStart

                    self.arRoutine[i].startTime = newStartTime
                   
                    let newIndex:IndexPath = IndexPath(item: i, section: 0)
                    arCollectionIndex.append(newIndex)
                }
                //ttb.updateStartTime(time: self.arRoutine[i].startTime)
                lastStart = self.arRoutine[i].startTime
                
                var useTime = ttb.getTimeDulation() * rout.count
                if(useTime <= 0){
                    useTime = ttb.getTimeDulation()
                }
                
                self.arRoutine[i].endTime = calendar.date(byAdding: .second, value: Int(useTime), to: lastStart) ?? lastStart
                
          
                
                duration = duration + useTime
            }
        }
        
    }
    
    
    
    func getTimeTableDetailListData(allRoutineData:[TimeTableDataModel])->[TimeTableDetailDataModel]{
        
        var arDetail:[TimeTableDetailDataModel] = [TimeTableDetailDataModel]()
        
        for routine in self.arRoutine{
            
            let arDe:[TimeTableDetailDataModel] = routine.getTimeTableDetailList(timeTables: allRoutineData)
            for de in arDe{
                arDetail.append(de)
            }
            
        }
        
        return arDetail
    }
}
