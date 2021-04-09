//
//  ViewController+CarList.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/12/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa




extension ViewController:CarsListViewDelegate{
    
    // MARK: - CarsListViewDelegate
    
    func selectCarAt(view:CarsListView, index: NSInteger){
        
        
        guard let gameScene =  ShareData.shared.gamseSceme else {
            return
        }
        
        if((index >= 0) && (index < self.myCarsCollection.model.arCars.count)){
            
        
            let car = self.myCarsCollection.model.arCars[index]
            gameScene.updateCarsData(carsData: [car])
            
        }else{
            gameScene.updateCarsData(carsData: self.myCarsCollection.model.arCars)
        }
    }
    
    
    
    // MARK: - intitial car List view
    func addCarListView(){
        
        
        if myCarsCollection == nil {
            
            carListViewDataModel.updateCarDetailData()
            
            self.myCarsCollection = CarsListView(frame: NSRect(x: 5, y: 30, width: 170, height: 480))
            self.viCarsListBG.addSubview(self.myCarsCollection)
            self.myCarsCollection.model = carListViewDataModel
            self.myCarsCollection.wantsLayer = true
            self.myCarsCollection.myCollection.reloadData()
            self.myCarsCollection.delegate = self
            self.myCarsCollection.layer?.backgroundColor = NSColor.clear.cgColor
            
        }
        
        if let gameScene = ShareData.shared.gamseSceme{
            gameScene.updateCarsData(carsData: self.myCarsCollection.model.arCars)
        }
    }
    
    
    func removeCarListView(){
        if myCarsCollection != nil {
            self.myCarsCollection.isHidden = true
            self.myCarsCollection.delegate = nil
            self.myCarsCollection.removeFromSuperview()
            self.myCarsCollection = nil
        }
        
        if let gameScene = ShareData.shared.gamseSceme{
            gameScene.updateCarsData(carsData: [])
        }
    }
    
    
    func reloadCarsListView(){
        
        guard let myCarsListView = self.myCarsCollection else {
            return
        }
        
        guard let collection = myCarsListView.myCollection else {
            return
        }
        
        collection.reloadData()
    }
    
    
    // MARK: - action edit car
    
    func tapOnAddCar(){
        guard self.myCarsCollection != nil else { return }
        
        self.myCarsCollection.model.addCar()
        
        self.myCarsCollection.updateData()
    }
    
    func tapOnDeleteCar(){
        self.deleteBufferindex = -1
        for i in 0..<self.myCarsCollection.model.arCars.count{
            let item = self.myCarsCollection.model.arCars[i]
            if(item.select == true){
                self.deleteBufferindex = i
                break
            }
        }
        
       
        if((self.deleteBufferindex >= 0) && (self.deleteBufferindex < self.myCarsCollection.model.arCars.count)){
            
            let answer = dialogOKCancel(question: "Delete the car?", text: "Are you sure you would like to delete the car?")
            if(answer){
                
              
                self.myCarsCollection.model.removeCar(index: self.deleteBufferindex)
                self.myCarsCollection.updateData()
                
                if let gameScene = ShareData.shared.gamseSceme{
                    gameScene.updateCarsData(carsData: [])
                }
            }
        }
    }
    
    
    
    
    
    
   
    
  
   
}
