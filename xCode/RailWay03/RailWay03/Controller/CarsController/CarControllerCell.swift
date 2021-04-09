//
//  CarControllerCell.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 7/12/2563 BE.
//  Copyright © 2563 BE T2P. All rights reserved.
//

import Cocoa

class CarControllerCell: NSCollectionViewItem {

    @IBOutlet weak var lbName: NSTextField!
    @IBOutlet weak var lbStatus: NSTextField!
    @IBOutlet weak var lbNextStation: NSTextField!
    @IBOutlet weak var lbSpeed: NSTextField!
    @IBOutlet weak var btStepSpeed: NSStepper!
    @IBOutlet weak var btBreak: NSButton!
    @IBOutlet weak var viButtonBG: NSView!
    
    @IBOutlet weak var viLine: NSBox!
    
    
    var myCar:CarDataModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        
        
        self.view.layer?.backgroundColor = NSColor.black.cgColor
        self.view.layer?.cornerRadius = 5
        self.view.layer?.borderWidth = 1
        self.view.layer?.borderColor = NSColor.app_space_blue.cgColor
        
        if let mutableAttributedTitle = btBreak.attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: mutableAttributedTitle.length))
            btBreak.attributedTitle = mutableAttributedTitle
        }
        
        self.viLine.wantsLayer = true
        self.viLine.borderColor = NSColor.app_space_blue
        
        self.viButtonBG.wantsLayer = true
        self.viButtonBG.layer?.backgroundColor = NSColor.black.cgColor
        self.viButtonBG.layer?.cornerRadius = 5
        self.viButtonBG.layer?.borderWidth = 1
        self.viButtonBG.layer?.borderColor = NSColor.white.cgColor
        
        
        self.btStepSpeed.minValue = 0
        self.btStepSpeed.maxValue = 10
        self.btStepSpeed.increment = 1.0
    }
    
    
    func updateDateBy(car:CarDataModel){
        self.myCar = car
        self.lbName.stringValue = car.name
        
        
        
        if((car.online) || (car.inModeSimulator)){
            self.lbName.textColor = NSColor.app_space_blue
            
        }else{
            self.lbName.textColor = NSColor.app_red
        }
        
        if(car.timeDetail == nil ){
            self.lbName.textColor = NSColor.app_red
        }
        
        
        
        self.lbStatus.stringValue = car.getDisplayStatus()
        
        if(car.activeStatus == .emergencyStop){
            lbStatus.textColor = .red
        }else if(car.activeStatus == .onTheWay){
            lbStatus.textColor = .app_space_blue
        }else{
            lbStatus.textColor = .white
        }
        
        
        
        if let next = car.getNextStation(){
            lbNextStation.stringValue = "Next Station : \(next.id)"
        }else{
            lbNextStation.stringValue = "Next Station : -"
        }
        
        let speed:NSInteger = NSInteger(car.speed * 100.0)
        
        self.btStepSpeed.intValue = Int32(NSInteger(car.speed * 10.0))
        
  
        lbSpeed.stringValue = "Max Speed : \(speed)%"
        
        var stopBTTitle:String = "Stop"
        if(car.activeStatus == .emergencyStop){
            stopBTTitle = "Continue"
        }
        
        
        self.btBreak.title = stopBTTitle
        
        
        if(car.timeDetail == nil ){
            self.lbName.textColor = NSColor.app_red
            self.btBreak.title = ""
            self.btBreak.isEnabled = false
            
            self.lbStatus.stringValue = "-"
            
            lbSpeed.stringValue = "Max Speed : -"
        }else{
            self.btBreak.title = stopBTTitle
            
            self.btBreak.isEnabled = true
        }
        
        
        
        
        if let mutableAttributedTitle = btBreak.attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: mutableAttributedTitle.length))
            btBreak.attributedTitle = mutableAttributedTitle
        }
        
    }
    @IBAction func tapOnStepSpeed(_ sender: NSStepper) {
        
        print(sender.floatValue)
        if((sender.floatValue >= 0) && (sender.floatValue <= 10)){
            let value:Double = sender.doubleValue / 10.0
            //self.myCar?.setMaxSpeed(speed: value)
            
            if let car = self.myCar{
                if let mv = ShareData.shared.masterVC{
                    mv.cooldinater.setSpeedCarWith(carID: car.id, speed: value)
                }
            }
        }
        
    }
    
    @IBAction func tapOnBreak(_ sender: NSButton) {
        
        print("tapOnBreak")
        if let car = self.myCar{
            if let mv = ShareData.shared.masterVC{
                switch car.activeStatus {
                    case .emergencyStop:
                        mv.cooldinater.continueCarWith(carID: car.id)
                        break
                    default:
                        mv.cooldinater.stopCarWith(carID: car.id)
                        break
                    
                }
            }
        }
    }
    
}
