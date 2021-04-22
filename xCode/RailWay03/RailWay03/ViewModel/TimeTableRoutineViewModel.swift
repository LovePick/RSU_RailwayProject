//
//  TimeTableRoutineViewModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 17/2/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class TimeTableRoutineViewModel: NSObject {

    var arRoutine:[TimeTableRoutineModel] = [TimeTableRoutineModel]()
    var selectAtIndex:NSInteger = -1
    
    
    
    func sortByName() {
        arRoutine = arRoutine.sorted(by: { (item1, item2) -> Bool in
            return item1.name.lowercased() < item2.name.lowercased()
        })
        
   
       
    }
    
    func addNewTimeTable(){
        let newItem:TimeTableRoutineModel = TimeTableRoutineModel()
        let id:NSInteger = NSInteger(Date().timeIntervalSince1970)
        newItem.id = id
        newItem.name = "New TimeTable..."
        
        self.arRoutine.append(newItem)
    }
    
    
    func getLastIndex()->IndexPath{
        
        if(self.arRoutine.count > 0){
            let newIndex:IndexPath = IndexPath(item: self.arRoutine.count - 1, section: 0)
            return newIndex
        }
        
        return IndexPath(item: 0, section: 0)
    }
    
    
    
    func copyTimeTable(index:NSInteger){
        if((index >= 0) && (index < self.arRoutine.count)){
            
            let item = self.arRoutine[index]
            
            let deicData = item.getDictionary()
            
            let newItem = TimeTableRoutineModel(fields: deicData)
            let id:NSInteger = NSInteger(Date().timeIntervalSince1970)
            newItem.id = id
            newItem.name = "\(id)"
            
            let shareData:ShareData = ShareData.shared
            guard let ms = shareData.masterVC else {
                return
            }
            
            let allRout = ms.routineModel
            
            newItem.updateDetailData(allRoutineData: allRout.arTimeTable)
            
//            if let startItem = item.arRoutine.first{
//                let start = startItem.startTime
//                newItem.updateTimeRelation(startTime: start)
//            }
            
            for i in 0..<item.arRoutine.count{
                let et = item.arRoutine[i]
                if(i < newItem.arRoutine.count){
                    newItem.arRoutine[i].timeTableStatus = et.timeTableStatus
                    newItem.arRoutine[i].startTime = et.startTime
                    newItem.arRoutine[i].endTime = et.endTime
                    newItem.arRoutine[i].buffStartTime = et.buffStartTime
                    newItem.arRoutine[i].strStartTime = et.strStartTime
                }
            }
            
            self.arRoutine.append(newItem)
        }
    }
    
    
    
    
    func removeSelectItem(){
        if((selectAtIndex >= 0) && (selectAtIndex < self.arRoutine.count)){
            
            self.arRoutine.remove(at: self.selectAtIndex)
            
            self.selectAtIndex = -1
        }
    }
    
    
    func removeTimetableAt(index:NSInteger){
        if((index >= 0) && (index < self.arRoutine.count)){
            
            self.arRoutine.remove(at: index)
            self.selectAtIndex = -1
            
        }
    }
    
    
    func removeLastDetail(){
        if((selectAtIndex >= 0) && (selectAtIndex < self.arRoutine.count)){
            
            if(self.arRoutine[self.selectAtIndex].arRoutine.count > 0){
                self.arRoutine[self.selectAtIndex].arRoutine.removeLast()
            }
        }
    }
    
    
    func removeDetailAt(index:NSInteger){
        if((selectAtIndex >= 0) && (selectAtIndex < self.arRoutine.count)){
            
            if(self.arRoutine[self.selectAtIndex].arRoutine.count > index){
                
                var i:NSInteger = self.arRoutine[self.selectAtIndex].arRoutine.count - 1
                while(i >= index){
                    self.arRoutine[self.selectAtIndex].arRoutine.removeLast()
                    i -= 1
                }
            }
            
        }
    }
    
    
    func addNewDetail(){
        
        if((selectAtIndex >= 0) && (selectAtIndex < self.arRoutine.count)){
            
            var needSetting:Bool = false
            if(self.arRoutine[self.selectAtIndex].arRoutine.count > 0){
                if let lastItem = self.arRoutine[self.selectAtIndex].arRoutine.last{
  
                    if(lastItem.timeTableStatus == .noData){
                        needSetting = true
                    }
                }
            }
            
            
            if(needSetting){
                self.showNeedSetup()
                
            }else{
                let newDetail:RoutineDataModel = RoutineDataModel()

                newDetail.index = self.arRoutine[self.selectAtIndex].arRoutine.count
                
                let count = self.arRoutine[self.selectAtIndex].arRoutine.count
                if(count > 1){
                    let lastItem = self.arRoutine[self.selectAtIndex].arRoutine[count - 1]
                    newDetail.startTime = lastItem.endTime ?? lastItem.startTime
                    newDetail.buffStartTime = newDetail.startTime
                    newDetail.strStartTime = newDetail.dateToStringTime(date:newDetail.startTime)
                    
                }
                
                
                self.arRoutine[self.selectAtIndex].arRoutine.append(newDetail)
            }
            
        }
    }
    
    
    
    
    
    
    
    func showNeedSetup() {
        let answer = dialogOKCancel(question: "Please setting up detail", text: "Please setting up detail before create newone.")
        
        if(answer){
           
        }
    }
    
    
    
    func getSelectTimeTable()->TimeTableRoutineModel?{
        if((self.selectAtIndex >= 0) && (self.selectAtIndex < self.arRoutine.count)){
            return self.arRoutine[self.selectAtIndex]
        }else{
            return nil
        }
    }
    
    
    func getTimeTableWith(timeTableID:NSInteger)->TimeTableRoutineModel?{
        
        var ans:TimeTableRoutineModel! = nil
        
        for item in self.arRoutine{
            if(item.id == timeTableID){
                ans = item
                break
            }
        }
        
        
        return ans
    }
}
