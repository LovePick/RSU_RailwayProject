//
//  ViewController+CarControll.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 9/5/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

extension ViewController {

    
    
    func addCarControllerView(){
        guard self.myCarControllView == nil else { return }
        
        
        let size = self.viCarControll.bounds.size
        
        self.myCarControllView = CarsController(frame: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        self.viCarControll.addSubview(self.myCarControllView!)
        self.viCarControll.wantsLayer = true
        
        self.myCarControllView!.model.arCars = self.activeCars
        self.myCarControllView!.myCollection.reloadData()
        
    }
    
    func removeCarsControllView(){
        guard self.myCarControllView != nil else { return }
        
        self.myCarControllView?.removeFromSuperview()
        self.myCarControllView = nil
        
    }
    func showCarControllView(show:Bool){
        
        viCarControll.wantsLayer = true
        
        
        
        if(show){
            self.viControllStatus.isHidden = true
            self.addCarControllerView()
            viCarControll.isHidden = false
            
            self.viStopCarBG.isHidden = false
            self.btStopCar.isEnabled = true
        }else{
            viCarControll.isHidden = true
            self.viControllStatus.isHidden = true
            self.removeCarsControllView()
            
            self.viStopCarBG.isHidden = true
            self.btStopCar.isEnabled = false
        }
        
        
        self.cooldinater.trackCarID = ""
    }
    
    
    
    
    func updateCarsControl(arCars:[CarDataModel]){
        guard self.myCarControllView != nil else { return }
        
        self.myCarControllView!.model.arCars = arCars.sorted(by: { (c1, c2) -> Bool in
            return c1.id < c2.id
        })
        
        
        self.myCarControllView!.myCollection.reloadData()
       
        
    }
    
    func updateDisplayCallControll(car:CarDataModel?){
        if let car = car{
//            self.btCarControllStop.isEnabled = true
//            self.lbCarControllName.stringValue = car.name
//            self.lbCarControllID.stringValue = car.id
            
            /*
             case unknow = 0 // ไม่ทราบสถาณะ
             case dewell     //จอดรับผู้โดยสาร
             case waitDepart //รอออกรถ
             case onTheWay   //กำลังเดินทาง
             case arrived    //ถึงที่หมาย
             case emergencyStop  //หยุดรถฉุกเฉิน
             case stop       //รถหยุดวิ่ง / ไม่ทำงาน / จบการทำงาน
             case inProgress // อยู่ระหว่างประมวลผล
             case error
             */
            
            var status:String = "Status:"
            var stopBTTitle:String = "Stop"
           
            switch car.activeStatus {
            case .unknow:
                status = "Status: Unknow"
 
                if((car.progressStatus == .waitActive) || (car.progressStatus == .active)){
                    status = "Status: Waiting"
                }
                break
            case .dewell:
                status = "Status: Dewell"
                
                if((car.progressStatus == .waitActive)){
                    status = "Status: Waiting"
                }
                
                break
            case .onTheWay:
                status = "Status: On the way"
                break
            case .arrived:
                status = "Status: Arrived"
                break
            case .emergencyStop:
                status = "Status: Emergency Stop"
                stopBTTitle = "Continue"
                break
            case .inProgress:
                status = "Status: In Progress"
                break
            case .stop:
                status = "Status: Stop/Terminate"
                break
            case .error:
                status = "Status: Error"
                break
            default:
                break
            }
            
            
            
        }else{
      
        }
    }
    
    
    func autoUpdateCarControllDisplay(){
//        if((self.btCarControllStop.tag >= 0) && (self.btCarControllStop.tag < self.carListViewDataModel.arCars.count)){
//            
//            let car = self.carListViewDataModel.arCars[self.btCarControllStop.tag]
//            self.updateDisplayCallControll(car: car)
//        }else{
//            self.cooldinater.trackCarID = ""
//            self.updateDisplayCallControll(car: nil)
//        }
    }
    
    @IBAction func selectCarControllTrank(_ sender: NSButton) {
        
      
        if((sender.tag >= 0) && (sender.tag < self.carListViewDataModel.arCars.count)){
            let car = self.carListViewDataModel.arCars[sender.tag]
//
//            if(self.btCarControllTrackCar.state == .on){
//                self.cooldinater.trackCarID = car.id
//            }else{
//              self.cooldinater.trackCarID = ""
//            }
        }
    }
    
    @IBAction func clickOnCarcontrollStop(_ sender: NSButton) {
        
        if((sender.tag >= 0) && (sender.tag < self.carListViewDataModel.arCars.count)){
            let car = self.carListViewDataModel.arCars[sender.tag]
            
            var stopBTTitle:String = "Stop"
            
            
            switch car.activeStatus {
                case .emergencyStop:
                    self.cooldinater.continueCarWith(carID: car.id)
                    break
                default:
                    self.cooldinater.stopCarWith(carID: car.id)
                    stopBTTitle = "Continue"
                    break
                
            }
        
            
        }
    }
}
