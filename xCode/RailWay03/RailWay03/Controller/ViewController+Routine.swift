//
//  ViewController+Routine.swift
//  RailWay03
//
//  Created by T2P mac mini on 28/1/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

extension ViewController {

    func getNextTimeTable(now:TimeTableDataModel?)->[TimeTableDataModel]{
        guard let n = now else {
            return self.routineModel.arTimeTable.sorted { (item1, item2) -> Bool in
                return item1.name < item2.name
            }
        }
        
        guard let lastDetail = n.arDetails.last else {
            return self.routineModel.arTimeTable.sorted { (item1, item2) -> Bool in
                return item1.name < item2.name
            }
        }
        
        guard let lastStation = lastDetail.station else {
            return self.routineModel.arTimeTable.sorted { (item1, item2) -> Bool in
                return item1.name < item2.name
            }
        }
        
        
        var arTimeTable:[TimeTableDataModel] = [TimeTableDataModel]()
        
        
        for ttb in self.routineModel.arTimeTable{
            if let fs = ttb.arDetails.first{
                if let station = fs.station{
                    if(station.id == lastStation.id){
                        arTimeTable.append(ttb)
                    }
                }
            }
        }
        
        return arTimeTable.sorted { (item1, item2) -> Bool in
            return item1.name < item2.name
        }
    }
    
    func getTimeTableTo(now:TimeTableDataModel?)->[TimeTableDataModel]{
        guard let n = now else {
            return self.routineModel.arTimeTable
        }
        
        guard let first = n.arDetails.first else {
            return self.routineModel.arTimeTable
        }
        
        guard let firstStation = first.station else {
            return self.routineModel.arTimeTable
        }
        
        
        var arTimeTable:[TimeTableDataModel] = [TimeTableDataModel]()
        
        
        for ttb in self.routineModel.arTimeTable{
            if let ls = ttb.arDetails.last{
                if let station = ls.station{
                    if(station.id == firstStation.id){
                        arTimeTable.append(ttb)
                    }
                }
            }
        }
        
        return arTimeTable
    }
    
    
    func getTimeTableWith(ttbID:NSInteger)->TimeTableDataModel?{
        
        var ans:TimeTableDataModel? = nil
        for ttb in self.routineModel.arTimeTable{
            if(ttb.id == ttbID){
                ans = ttb
                break
            }
        }
        
        return ans
    }
}
