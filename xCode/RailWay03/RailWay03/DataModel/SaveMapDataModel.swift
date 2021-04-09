//
//  SaveMapDataModel.swift
//  RailWay03
//
//  Created by supapon pucknavin on 24/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class SaveMapDataModel: NSObject {

    
    
    var filePath:URL? = nil
    
    
    var mapW:NSInteger = 0
    var mapH:NSInteger = 0
    var arCell:[TileCellDataModel] = [TileCellDataModel]()
    
    var arPath:[PathDataModel] = [PathDataModel]()
    
    
    var timeTable:[TimeTableRoutineModel] = [TimeTableRoutineModel]()
    
    var routinePlan:[TimeTableDataModel] = [TimeTableDataModel]()
    
    var arCars:[CarDataModel] = [CarDataModel]()
    
    convenience init(fields:[String: Any]){
        
        self.init()
        
        
        self.readJson(fields: fields)
    }
    
    
    func readJson(fields:[String: Any]) {
        self.arCell.removeAll()
        
        if let mapData = fields["mapData"] as? [String: Any]{
            
            if let w = mapData["mapW"] as? NSInteger{
                self.mapW = w
            }
            if let h = mapData["mapH"] as? NSInteger{
                self.mapH = h
                
            }
            
            if let mapLayer = mapData["map"] as? [String: [String: Any]]{
                
                for (_, cellData) in mapLayer{
                    
                    let newCellData:TileCellDataModel = TileCellDataModel(fields: cellData)
                   
                    self.arCell.append(newCellData)
                }
            }
        }
        //---
        
        // read path
        
        self.arPath.removeAll()
        if let pathDatas = fields["pathData"] as? [String: Any]{
            
            if let paths = pathDatas["paths"] as? [[String:Any]]{
                for item in paths{
                    let newPath = PathDataModel(fields: item)
                    self.arPath.append(newPath)
                }
            }
        }
        //---
        
        
        
        // read rountine Plan
        
        self.routinePlan.removeAll()
        if let timetableData = fields["routinePlanData"] as? [String: Any]{
            
            if let times = timetableData["routinePlan"] as? [[String:Any]]{
                for item in times{
                    let newTime = TimeTableDataModel(fields: item)
                    self.routinePlan.append(newTime)
                }
            }
        }
        //---
        
        
        // read time table
        
        self.timeTable.removeAll()
        if let timetableData = fields["timeTableData"] as? [String: Any]{
            
            if let times = timetableData["timeTable"] as? [[String:Any]]{
                for item in times{
                    let newTime = TimeTableRoutineModel(fields: item)
                    newTime.updateDetailData(allRoutineData: self.routinePlan)
                    self.timeTable.append(newTime)
                }
            }
        }
        //---
        
        
        // read Car list
        self.arCars.removeAll()
        
        if let carsData = fields["carsData"] as? [String: Any]{
            
            if let cars = carsData["cars"] as? [[String:Any]]{
                for item in cars{
                    let newCar:CarDataModel = CarDataModel(fields: item)
                    self.arCars.append(newCar)
                }
            }
            
        }
        
        //---
    }
    
    func getDicData()->[String:Any]{
        
        
        var myDic:[String:Any] = [String:Any]()
        
        
        var mapData:[String:Any] = [String:Any]()
        mapData["mapW"] = self.mapW
        mapData["mapH"] = self.mapH
        
        var dicMapCell:[String:Any] = [String:Any]()
        for cell in self.arCell{
            let newDicData = cell.getDictData()
            let strKey = cell.getKey()
           
            
            dicMapCell[strKey] = newDicData
        }
        mapData["map"] = dicMapCell
        myDic["mapData"] = mapData
        
        //----
        //Path
        var arPaths:[[String:Any]] = [[String:Any]]()
        
        for item in self.arPath{
            let pathDic = item.getDicData()
            arPaths.append(pathDic)
        }
        
        var pathDic:[String:Any] = [String:Any]()
        pathDic["paths"] = arPaths
        myDic["pathData"] = pathDic
        //----
        
        //Time table
        var arTimeTable:[[String:Any]] = [[String:Any]]()
        
        for ttb in self.timeTable{
            let itemDic = ttb.getDictionary()
            arTimeTable.append(itemDic)
        }
        
        var timeDic:[String:Any] = [String:Any]()
        timeDic["timeTable"] = arTimeTable
        myDic["timeTableData"] = timeDic
        
        //----
        
        //rountine Plan
        var arRoutine:[[String:Any]] = [[String:Any]]()
        
        for rnt in self.routinePlan{
            let itemDic = rnt.getDictionary()
            arRoutine.append(itemDic)
        }
        
        var rntDic:[String:Any] = [String:Any]()
        rntDic["routinePlan"] = arRoutine
        myDic["routinePlanData"] = rntDic
        
        //----
        // read Car list
        var arC:[[String:Any]] = [[String:Any]]()
        for item in arCars{
            let dicCar:[String:Any] = item.getDicData()
            arC.append(dicCar)
        }
        
        var carListData:[String:Any] = [String:Any]()
        carListData["cars"] = arC
        myDic["carsData"] = carListData
        //----
        
        return myDic
    }
}
