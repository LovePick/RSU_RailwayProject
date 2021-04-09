//
//  TimeTableRoutineCell.swift
//  RailWay03
//
//  Created by T2P mac mini on 18/2/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

@objc protocol TimeTableRoutineCellDelegate {

    func routineCellStartTimeChange(cell:TimeTableRoutineCell, time:Date)
    func routineCellSelectRountine(cell:TimeTableRoutineCell, ttb:TimeTableDataModel?)
    
    func routineCellLoopChangeValue(cell:TimeTableRoutineCell, value:NSInteger)
}



class TimeTableRoutineCell: NSCollectionViewItem {
    
    @IBOutlet weak var startTime: NSDatePicker!
    
    @IBOutlet weak var btRoutine: NSPopUpButton!
    
    @IBOutlet weak var tfLoopCount: NSTextField!
    
    @IBOutlet weak var btStepperLoopCount: NSStepper!
    
    @IBOutlet weak var lbStatus: NSTextField!
    
    @IBOutlet weak var viLine: NSView!
    
    
    var arRoutineChoice:[TimeTableDataModel] = [TimeTableDataModel]()
    
    var delegate:TimeTableRoutineCellDelegate? = nil
    
    
    var myTag:NSInteger = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        
        viLine.wantsLayer = true
        viLine.layer?.backgroundColor = NSColor.app_space_blue.cgColor
        btRoutine.removeAllItems()
        tfLoopCount.delegate = self
        
    }
    
    
    
    
    func updateRoutineChoice(choices:[TimeTableDataModel], CanEmpty empty:Bool){
        self.arRoutineChoice = choices
        
        self.btRoutine.removeAllItems()
        
        if(empty == true){
            self.btRoutine.addItem(withTitle: "-")
        }
        
        
        
        for r in choices{
            let title = r.name
            self.btRoutine.addItem(withTitle: title)
        }
        
    }
    
    func setSelectState(select:Bool) {
        
        self.view.wantsLayer = true
        
        
        if(select){
            self.view.layer?.backgroundColor = NSColor.app_space_blue2.cgColor
        }else{
            
            self.view.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    
    @IBAction func startTimeChange(_ sender: NSDatePicker) {
        guard let de = self.delegate else { return }
        
        de.routineCellStartTimeChange(cell: self, time: sender.dateValue)
        
    }
    
    
    @IBAction func routineChange(_ sender: NSPopUpButton) {
        let index = findSelectIndexWith(title: sender.title)
        
        guard let de = self.delegate else { return }
        
        if((index >= 0) && (index < self.arRoutineChoice.count)){
            de.routineCellSelectRountine(cell: self, ttb: self.arRoutineChoice[index])
        }else{
            de.routineCellSelectRountine(cell: self, ttb: nil)
        }
    }
    
    
    func findSelectIndexWith(title:String) -> Int {
        if(self.arRoutineChoice.count > 0){
            
            var ans = -1
            for i in 0..<self.arRoutineChoice.count{
                if(self.arRoutineChoice[i].name == title){
                    ans = i
                    break
                }
            }
            
            return ans
        }else{
            return -1
        }
    }
    
    @IBAction func stepperLoopChange(_ sender: NSStepper) {
        
        var value:NSInteger = NSInteger(sender.intValue)
        if(sender.intValue < 1){
            self.btRoutine.intValue = 1
            value = 1
        }
        
        self.tfLoopCount.intValue = Int32(value)
        
        
        guard let de = self.delegate else { return }
        de.routineCellLoopChangeValue(cell: self, value: value)
    }
    
    
    
    
}

extension TimeTableRoutineCell:NSTextFieldDelegate{
    
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        
        guard let txtFld = obj.object as? NSTextField else { return }
        
        
        var value:NSInteger = NSInteger(txtFld.intValue)
        if(value < 1){
            self.btRoutine.intValue = 1
            self.tfLoopCount.intValue = 1
            value = 1
        }
        
        self.tfLoopCount.intValue = Int32(value)
        
        
        guard let de = self.delegate else { return }
        de.routineCellLoopChangeValue(cell: self, value: value)
        
    }
    
    
    
}
