//
//  CarsListViewDataModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 23/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class CarsListViewDataModel: NSObject {

    var arCars:[CarDataModel] = [CarDataModel]()
    var lastSelect:NSInteger = -1
    
    
    
    /*
    func readJson(fields:[String: Any]) {
        self.arCars.removeAll()
        if let cars = fields["cars"] as? [[String:Any]]{
            for item in cars{
                let newCar:CarDataModel = CarDataModel(fields: item)
                self.arCars.append(newCar)
            }
        }
    }
    
    
    
    func getDicData()->[String:Any]{
        var dicData:[String:Any] = [String:Any]()
        
        var arC:[[String:Any]] = [[String:Any]]()
        
        for item in arCars{
            let dicCar:[String:Any] = item.getDicData()
            arC.append(dicCar)
        }
        
        dicData["cars"] = arC
        
        return dicData
    }
    
    */
    
    
    
    func addCar(){
        let newItem:CarDataModel = CarDataModel()
        let id:NSInteger = NSInteger(Date().timeIntervalSince1970)
        newItem.id = "\(id)"
        
        let newName:String = String(format: "Car%02d", self.arCars.count)
        newItem.name = newName
        
        self.arCars.append(newItem)
    }
    
    
    func removeCar(index:NSInteger){
        
        if(self.arCars.count <= 0){
            return
        }
        
        
        if((index >= 0) && (index < self.arCars.count)){
            self.arCars.remove(at: index)
        }else{
            self.arCars.removeLast()
        }
    }
    
    
    func updateCarDetailData(){
        
        guard let ms = ShareData.shared.masterVC else {
            return
        }
        
        for car in self.arCars{
            
            if let ttb = ms.getTimeTableRoutineWith(timeTableRoutineId: car.timeTableRoutineId){
                
                let list = ttb.getTimeTableDetailListData(allRoutineData: ms.routineModel.arTimeTable)
                
                
                
                if((car.runAtRoutineIndex >= 0) && (car.runAtRoutineIndex < list.count)){
                    car.timeDetail = list[car.runAtRoutineIndex]
                }else if let first = list.first{
                    car.timeDetail = first
                }else{
                    car.timeDetail = nil
                }
                
            }
           
        }
    }
}
