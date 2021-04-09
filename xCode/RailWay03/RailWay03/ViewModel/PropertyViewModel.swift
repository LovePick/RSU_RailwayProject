//
//  PropertyViewModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 22/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class PropertyViewModel: NSObject {
    

    struct SType{
        var type:TileCell.StationType
        var title:String
    }
    
    var type:SType = SType(type: .non, title: "non")
    
    
    var arChoiceType:[SType] = [SType]()
    
    
    
  
    var tfPropertyId: NSTextField!
    var tfPropertyName: NSTextField!
    var btPropertyType: NSPopUpButton!
    var tfJunctionLighr: NSTextField!

    var btFrameBottom: NSButton!
    var btFrameLeft: NSButton!
    var btFrameRight: NSButton!
    var btFrameTop: NSButton!
    
    
    var arBufferSelectCell:[TileCell]? = nil
    
    
    
    private var enable_ID:Bool = true
    private var enable_name:Bool = true
    private var enable_type:Bool = true
    private var enable_path:Bool = true
    
    
    private var allLeft:Bool = true
    private var allRight:Bool = true
    private var allTop:Bool = true
    private var allBottom:Bool = true
    
    
    override init() {
        super.init()
        
        do{
            let newItem:SType = SType(type: .non, title: "non")
            self.arChoiceType.append(newItem)
        }
        
        do{
            let newItem:SType = SType(type: .station, title: "station")
            self.arChoiceType.append(newItem)
        }
        
        do{
            let newItem:SType = SType(type: .depot, title: "depot")
            self.arChoiceType.append(newItem)
        }
        
        do{
            let newItem:SType = SType(type: .waitPoint, title: "wait point")
            self.arChoiceType.append(newItem)
        }
        
        do{
            let newItem:SType = SType(type: .junctionUp, title: "junction Up")
            self.arChoiceType.append(newItem)
        }
        do{
            let newItem:SType = SType(type: .junctionDown, title: "junction Down")
            self.arChoiceType.append(newItem)
        }
        
        
        
    }
    
    func stypeWith(type:TileCell.StationType)->SType{
        
        var newItem:SType = SType(type: .non, title: "non")
        for item in self.arChoiceType{
            if(item.type == type){
                newItem = item
            }
        }
        
        return newItem
    }
    
    
    func addListToType(button:NSPopUpButton){
        button.removeAllItems()
        
        for i in 0..<self.arChoiceType.count{
            let item = self.arChoiceType[i]
            button.addItem(withTitle: item.title)
            button.itemArray.last?.tag = i
        }
        
        button.setTitle(self.type.title)
        
    }
    
    
    func tapOnStationType(sender:NSPopUpButton){
        

        let tag = sender.indexOfSelectedItem
       
        if((tag >= 0) && (tag < self.arChoiceType.count)){
            let item = self.arChoiceType[tag]
            self.type = item
        }
        
        
        self.updateDataToCell()
    }
    
    

    func tapOnFrameLeft(){
        
        self.allLeft = !self.allLeft
        
        let color = NSColor.app_space_blue.withAlphaComponent(0.5).cgColor
        self.btFrameLeft.wantsLayer = true
        if(self.allLeft){
            self.btFrameLeft.layer?.backgroundColor = color
        }else{
            self.btFrameLeft.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        self.updateDataToCell()
    }
    func tapOnFrameRight(){
        
        self.allRight = !self.allRight
        
        let color = NSColor.app_space_blue.withAlphaComponent(0.5).cgColor
        self.btFrameRight.wantsLayer = true
        if(self.allRight){
            self.btFrameRight.layer?.backgroundColor = color
        }else{
            self.btFrameRight.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
      
        self.updateDataToCell()
    }
    func tapOnFrameTop(){
        self.allTop = !self.allTop
        
        let color = NSColor.app_space_blue.withAlphaComponent(0.5).cgColor
        self.btFrameTop.wantsLayer = true
        if(self.allTop){
            self.btFrameTop.layer?.backgroundColor = color
        }else{
            self.btFrameTop.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
       
        self.updateDataToCell()
    }
    func tapOnFrameBottom(){
        self.allBottom = !self.allBottom
        self.btFrameBottom.wantsLayer = true
        
        let color = NSColor.app_space_blue.withAlphaComponent(0.5).cgColor
        if(self.allBottom){
            self.btFrameBottom.layer?.backgroundColor = color
        }else{
            self.btFrameBottom.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        self.updateDataToCell()
    }
    
    
    func updateUI_Type(sender:NSPopUpButton){
        sender.setTitle(self.type.title)
    }
    
    
    func selectOnCell(cells:[TileCell]){
        
        self.arBufferSelectCell = cells
        
        enable_ID = true
        enable_name = true
        enable_type = true
        enable_path = true
        
        if let vc = ShareData.shared.masterVC{
            if(vc.displayMode == .non){
                enable_ID = false
                enable_name = false
                enable_type = false
                enable_path = false
            }else if(vc.displayMode == .editPath){
                enable_ID = false
                enable_name = false
                enable_type = false
                enable_path = true
            }
        }
        
        
        
        
        if(cells.count <= 0){
            enable_ID = false
            enable_name = false
            enable_type = false
            enable_path = false
            
            self.tfPropertyId.stringValue = ""
            self.tfPropertyName.stringValue = ""
            self.btPropertyType.setTitle("")
            self.tfJunctionLighr.intValue = 0
            self.tfJunctionLighr.isEnabled = false
            
        }else if(cells.count == 1){
            
            self.tfJunctionLighr.isEnabled = true
            
            if let cell = cells.first{
                self.type = stypeWith(type: cell.stationMode)
                self.tfPropertyId.stringValue = cell.id
                self.tfPropertyName.stringValue = cell.stationName
                self.tfJunctionLighr.intValue = Int32(cell.junctionLight)
                self.btPropertyType.setTitle(self.type.title)
            }
            
            
            
        }else{
            self.tfJunctionLighr.intValue = 0
            self.tfJunctionLighr.isEnabled = false
            
            enable_ID = false
            enable_name = false
            
            
            let buffType:SType = stypeWith(type: cells[0].stationMode)
            for cell in cells{
                let t = stypeWith(type: cell.stationMode)
                if(buffType.type != t.type){
                    enable_type = false
                    break
                }
            }
            
            
            self.tfPropertyId.stringValue = ""
            self.tfPropertyName.stringValue = ""
            self.btPropertyType.setTitle(buffType.title)
        }
        
        
        
        
        
        
        self.tfPropertyId.isEditable = enable_ID
        self.tfPropertyId.isEnabled = enable_ID
        
        self.tfPropertyName.isEditable = enable_name
        self.tfPropertyName.isEnabled = enable_name
        
     
        self.btPropertyType.isEnabled = enable_type
        
        
    
        
        //--
        allLeft = true
        allRight = true
        allTop = true
        allBottom = true
        
        
        for cell in cells{
            if(cell.lineLeft == false){ allLeft = false }
            if(cell.lineRight == false){ allRight = false }
            if(cell.lineTop == false){ allTop = false }
            if(cell.lineBottom == false){ allBottom = false }
            
        }
        
        let color = NSColor.app_space_blue.withAlphaComponent(0.5).cgColor
        self.btFrameLeft.wantsLayer = true
        self.btFrameRight.wantsLayer = true
        self.btFrameTop.wantsLayer = true
        self.btFrameBottom.wantsLayer = true
        
        
        if(self.allLeft){
            self.btFrameLeft.layer?.backgroundColor = color
        }else{
            self.btFrameLeft.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        if(self.allRight){
            self.btFrameRight.layer?.backgroundColor = color
        }else{
            self.btFrameRight.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        
        if(self.allTop){
            self.btFrameTop.layer?.backgroundColor = color
        }else{
            self.btFrameTop.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        if(self.allBottom){
            self.btFrameBottom.layer?.backgroundColor = color
        }else{
            self.btFrameBottom.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        
        
    }

    
    
    func updateDataToCell(){
        if let cells = self.arBufferSelectCell{
            for c in cells{
                
                if(self.enable_type){
                    c.stationMode = self.type.type
                }
                if(self.enable_ID){
                    c.id = self.tfPropertyId.stringValue
                }
                if(self.enable_name){
                    c.stationName = self.tfPropertyName.stringValue
                }
                
                
                c.lineLeft = allLeft
                c.lineRight = allRight
                c.lineTop = allTop
                c.lineBottom = allBottom
                c.junctionLight = self.tfJunctionLighr.integerValue
                
                c.updateUI()
            }
        }
    }
}
