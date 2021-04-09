//
//  TimaTableViewModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 29/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class TimeTableViewModel: NSObject {

    var arTimeTable:[TimeTableDataModel] = [TimeTableDataModel]()
    
    
    var selectAtTimeTableIndex:NSInteger = -1
    
    
    func readSaveJson(fields:[String: Any]) {
        
        arTimeTable.removeAll()
        
        var buffArray:[TimeTableDataModel] = [TimeTableDataModel]()
        
        if let timeTables = fields["timeTables"] as? [[String: Any]]{
            
            for item in timeTables{
                let newTTB:TimeTableDataModel = TimeTableDataModel(fields: item)
                buffArray.append(newTTB)
            }
        }
        
        arTimeTable = buffArray.sorted(by: { (item1, item2) -> Bool in
            return item1.name < item2.name
        })
        
    }
    
    func getSortByName() -> [TimeTableDataModel] {
        sortByName()
        
        return arTimeTable
    }
    
    func sortByName() {
        arTimeTable = arTimeTable.sorted(by: { (item1, item2) -> Bool in
            return item1.name.lowercased() < item2.name.lowercased()
        })
        
    }
    
    
    func addNewTimeTable(){
        let newItem:TimeTableDataModel = TimeTableDataModel()
        let id:NSInteger = NSInteger(Date().timeIntervalSince1970)
        newItem.id = id
        newItem.name = "Route/Station"
        
        self.arTimeTable.append(newItem)
    }
    
    
    func getLastIndex()->IndexPath{
        
        if(self.arTimeTable.count > 0){
            let newIndex:IndexPath = IndexPath(item: self.arTimeTable.count - 1, section: 0)
            return newIndex
        }
        
        return IndexPath(item: 0, section: 0)
    }
    
    func copyTimeTable(index:NSInteger){
        if((index >= 0) && (index < self.arTimeTable.count)){
            
            let item = self.arTimeTable[index]
            
            let deicData = item.getDictionary()
            
            let newItem = TimeTableDataModel(fields: deicData)
            let id:NSInteger = NSInteger(Date().timeIntervalSince1970)
            newItem.id = id
            newItem.name = "\(id)"
            
            
            self.arTimeTable.append(newItem)
        }
    }
    
    /*
    func setStartTime(time:Date){
        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            self.arTimeTable[self.selectAtTimeTableIndex].updateStartTime(time: time)
        }
    }*/
    
    
    func removeSelectItem(){
        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            
            self.arTimeTable.remove(at: self.selectAtTimeTableIndex)
            
            self.selectAtTimeTableIndex = -1
        }
    }
    
    
    func removeTimetableAt(index:NSInteger){
        if((index >= 0) && (index < self.arTimeTable.count)){
            
            self.arTimeTable.remove(at: index)
            
            self.selectAtTimeTableIndex = -1
            
        }
    }
    
    
    func removeLastDetail(){
        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            
            if(self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count > 0){
                self.arTimeTable[self.selectAtTimeTableIndex].arDetails.removeLast()
            }
        }
    }
    
    
    func removeDetailAt(index:NSInteger){
        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            
            if(self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count > index){
                
                var i:NSInteger = self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count - 1
                while(i >= index){
                    self.arTimeTable[self.selectAtTimeTableIndex].arDetails.removeLast()
                    i -= 1
                }
            }
            
            
        }
    }
    
    func addNewDetail(){
        
        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            
            var needSetting:Bool = false
            if(self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count > 0){
                if let lastItem = self.arTimeTable[self.selectAtTimeTableIndex].arDetails.last{




                    if(lastItem.station == nil){
                        needSetting = true
                    }
                }
            }
            
            
            if(needSetting){
                self.showNeedSetup()
                
            }else{
                let newDetail:TimeTableDetailDataModel = TimeTableDetailDataModel()
                if(self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count > 0){
                    if let lastItem = self.arTimeTable[self.selectAtTimeTableIndex].arDetails.last{
                        newDetail.fromStation = lastItem.station
                        
//                        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//                        if let depart = lastItem.depart{
//                            let modifiedDate = calendar.date(byAdding: .second, value: 5, to: depart)
//                            newDetail.arrive = modifiedDate
//                        }
                        
                    }
                }
                
                newDetail.index = self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count
                self.arTimeTable[self.selectAtTimeTableIndex].arDetails.append(newDetail)
            }
            
        }
    }
    
    
    
    
    
    
    func setPathToDetail(tag: NSInteger, station: TileCellDataModel){
        
        var newTag:NSInteger = tag
        var newStation:TileCellDataModel = station
        
        if((newTag == 0) && (self.arTimeTable[selectAtTimeTableIndex].arDetails.count > 1) ){
            self.arTimeTable[selectAtTimeTableIndex].arDetails[0].station = newStation
            newTag = 1
            
            if let ttb = self.getSelectTimeTable(){
                if let nextStation = ttb.arDetails[newTag].station{
                    newStation = nextStation
                }
                
            }
            
        }
        

        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            

            if(newTag == 0){
                if(self.arTimeTable.count > 0){
                    if(self.arTimeTable[selectAtTimeTableIndex].arDetails.count > 0){
                        self.arTimeTable[selectAtTimeTableIndex].arDetails[0].station = newStation
                    }
                }
                
            }else if(newTag > 0){
                
                if(self.arTimeTable.count > 0){
                    if(self.arTimeTable[selectAtTimeTableIndex].arDetails.count > 1){
                        if let ttb = self.getSelectTimeTable(){
                            
                            
                            
                            //clear last cell data
                            if(newTag == self.arTimeTable.count - 1){
                                ttb.arDetails[newTag].toStation = nil
                                ttb.arDetails[newTag].path = nil
                            }
                            
                            
                            
                            //remove relation cell
                            //self.removeDetailAt(index: newTag + 1)
                            

                            // update path to last cell
                            let bIndex:NSInteger = newTag - 1
                            
                            if let bStation = ttb.arDetails[bIndex].station{
                                
                                ttb.arDetails[bIndex].toStation = newStation
                                ttb.arDetails[newTag].fromStation = bStation
                                ttb.arDetails[newTag].station = newStation
                                
                                
                                
                                if let msv = ShareData.shared.masterVC{
                                    let pathData = msv.pathListViewDataModel
                                    
                                    let paths = pathData.getPathWith(a: bStation, b: newStation)
                                    if let first = paths.first{
                                        self.updatePathAt(index: bIndex, path: first)
                                        self.updatePathAt(index: newTag, path: first)
                                    }
                                }
                                
                                
                                
                            }
                        }
                        
                        
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    func getSelectTimeTable()->TimeTableDataModel?{
        if((self.selectAtTimeTableIndex >= 0) && (self.selectAtTimeTableIndex < self.arTimeTable.count)){
            return self.arTimeTable[self.selectAtTimeTableIndex]
        }else{
            return nil
        }
    }
    
    
    
    func updatePathAt(index:NSInteger, path:PathDataModel){
        if((selectAtTimeTableIndex >= 0) && (selectAtTimeTableIndex < self.arTimeTable.count)){
            if((index >= 0) && (index < self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count)){
                self.arTimeTable[self.selectAtTimeTableIndex].arDetails[index].path = path
            }
        }
        
    }
    
    func showNeedSetup() {
        let answer = dialogOKCancel(question: "Please setting up detail", text: "Please setting up detail before create newone.")
        
        if(answer){
           
        }
    }
    
    
    
    
    func getTimeTableWith(timeTableID:NSInteger)->TimeTableDataModel?{
        
        var ans:TimeTableDataModel! = nil
        
        for item in self.arTimeTable{
            if(item.id == timeTableID){
                ans = item
                break
            }
        }
        
        
        return ans
    }
    
    
    
    
    
    func updateDewellTime(timeDetailIndex:NSInteger, dewellTime:NSInteger){
        guard self.selectAtTimeTableIndex >= 0 else { return }
        guard self.selectAtTimeTableIndex < self.arTimeTable.count else { return }
        
        guard timeDetailIndex >= 0 else { return }
        guard timeDetailIndex < self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count else { return }
        
        
        
        
        
        var dewell:NSInteger = dewellTime
        if(dewell < 0){
            dewell = 0
        }
        self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].dewell = dewell
        
        
//        guard let arrive = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].arrive else { return }
        
//        if(dewell > 0){
//
//            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//            let modifiedDate = calendar.date(byAdding: .second, value: dewell, to: arrive)
//            self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].depart = modifiedDate
//            print("depart => \(modifiedDate!)")
//        }else{
//            self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].depart = arrive
//
//            print("depart => arrive")
//        }
        
        
        //-------------
        //update all relation
        
        //self.updateAllrelationDetailFigDuration()
        
    }
    
    
    func updateDurationTime(timeDetailIndex:NSInteger, duration:NSInteger){
        guard self.selectAtTimeTableIndex >= 0 else { return }
        guard self.selectAtTimeTableIndex < self.arTimeTable.count else { return }
        
        guard timeDetailIndex >= 0 else { return }
        guard timeDetailIndex < self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count else { return }
        
        
        var dur:NSInteger = duration
        if(dur < 0){
            dur = 0
        }
        
        
        self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].duration = dur
        
        //-------------
        //update all relation
        
        //self.updateAllrelationDetailFigDuration()
    }
    
    func updateArriveTimeToTimedetail(timeDetailIndex:NSInteger, timeArrive:Date){
        guard self.selectAtTimeTableIndex >= 0 else { return }
        guard self.selectAtTimeTableIndex < self.arTimeTable.count else { return }
        
        guard timeDetailIndex >= 0 else { return }
        guard timeDetailIndex < self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count else { return }
        
        
//        self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].arrive = timeArrive
        
     
//        let dewell = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].dewell
//        
//        print("======")
//        if(dewell > 0){
//            
//            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//            let modifiedDate = calendar.date(byAdding: .second, value: dewell, to: timeArrive)
//            self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].depart = modifiedDate
//
//            print("depart => \(modifiedDate!)")
//        }else{
//            self.arTimeTable[self.selectAtTimeTableIndex].arDetails[timeDetailIndex].depart = timeArrive
//            
//            print("depart => \(timeArrive)")
//        }
        
        //-------------
        //update all relation
        
        self.updateAllrelationDetailFigTime()
    }
    
    
    
    func updateAllrelationDetailFigTime(){
        guard self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count > 1 else { return }
        

        var lastDetail = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[0]
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        for i in 1..<self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count{
            
            let item = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[i]
            
            
            
//            if let arrive = item.arrive, let lastDepart = lastDetail.depart{
//
//                lastDetail.duration = NSInteger(arrive.timeIntervalSince1970 - lastDepart.timeIntervalSince1970)
//                if(lastDetail.duration < 0){
//                    lastDetail.duration = 0
//                }
//
//                if(arrive.timeIntervalSince1970 < lastDepart.timeIntervalSince1970){
//
//                    let modifiedDate = calendar.date(byAdding: .second, value: lastDetail.duration, to: lastDepart)
//                    item.arrive = modifiedDate
//
//                    let dewell = item.dewell
//                    if dewell >= 0 , let modi = modifiedDate{
//                        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//                        let modifiedDate2 = calendar.date(byAdding: .second, value: dewell, to: modi)
//                        item.depart = modifiedDate2
//                    }else{
//                        item.dewell = 0
//                        item.depart = modifiedDate
//                    }
//
//                }
//
//            }

            
            lastDetail = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[i]
            
        }
    }
    
    
    /*
    func updateAllrelationDetailFigDuration(){
        guard self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count > 1 else { return }
        

        var lastDetail = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[0]
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        for i in 1..<self.arTimeTable[self.selectAtTimeTableIndex].arDetails.count{
            
            let item = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[i]
            
            if(lastDetail.duration < 0){
                
                lastDetail.duration = 0
                
            }

            
//            if let lastDepart = lastDetail.depart{
//
//                let modifiedDate = calendar.date(byAdding: .second, value: lastDetail.duration, to: lastDepart)
//                item.arrive = modifiedDate
//
//                let dewell = item.dewell
//                if dewell >= 0 , let modi = modifiedDate{
//                    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//                    let modifiedDate2 = calendar.date(byAdding: .second, value: dewell, to: modi)
//                    item.depart = modifiedDate2
//                }else{
//                    item.dewell = 0
//                    item.depart = modifiedDate
//                }
//
//            }
            
            
            lastDetail = self.arTimeTable[self.selectAtTimeTableIndex].arDetails[i]
            
        }
    }
 */
}
