//
//  TimeTableCell.swift
//  RailWay03
//
//  Created by T2P mac mini on 28/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class TimeTableCell: NSCollectionViewItem {
    
    
    @IBOutlet weak var viContentBG: NSView!
    
    @IBOutlet weak var viLine: NSView!
    
    @IBOutlet weak var tfTitle: NSTextField!
    
    var myTag:NSInteger = 0
    
    var callBackClick:(NSInteger)->Void = {(tag) in }
    
    
    var callBackDuplicate:(NSInteger)->Void = {(tag) in }
    var callBackRemove:(NSInteger)->Void = {(tag) in }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        viContentBG.wantsLayer = true
        
        
        viLine.wantsLayer = true
        viLine.layer?.backgroundColor = NSColor.app_space_blue.cgColor
        
        
        tfTitle.wantsLayer = true
        tfTitle.layer?.backgroundColor = NSColor.clear.cgColor
        tfTitle.textColor = NSColor.white
        tfTitle.backgroundColor = .clear
        
        tfTitle.isEditable = false
        tfTitle.isEnabled = false
        
    }
    
    
    func setSelectState(select:Bool) {
        
        self.view.wantsLayer = true
        viContentBG.wantsLayer = true
        
        if(select){
            viContentBG.layer?.backgroundColor = NSColor.app_space_blue2.cgColor
        }else{
            tfTitle.isEditable = false
            tfTitle.isEnabled = false
            tfTitle.resignFirstResponder()
            viContentBG.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    
    
    //mark - mouse event
    
    override func mouseDown(with event: NSEvent) {
        
        //print(event.clickCount)
        if(event.clickCount > 1){
            tfTitle.isEditable = true
            tfTitle.isEnabled = true
            tfTitle.becomeFirstResponder()
        }else{
            tfTitle.resignFirstResponder()
            tfTitle.isEditable = false
            tfTitle.isEnabled = false
        }
        
        self.callBackClick(self.myTag)
    }
    
    
    override func rightMouseDown(with theEvent: NSEvent) {
        print("rightMouseDown \(self.myTag)")
        
        let point:NSPoint = theEvent.locationInWindow
        //ShareData.shared.masterVC?.view.convert(point, to: self.view)
        let viLocation = ShareData.shared.masterVC?.view.convert(point, to: self.view) ?? self.view.convert(point, to: self.view)
        self.createMenuPopup(Origin: viLocation)
    }
    
    
    func createMenuPopup(Origin origin:CGPoint){
        let menu:NSMenu = NSMenu()
    
        let duplicate:NSMenuItem = NSMenuItem(title: "Duplicate", action: #selector(self.popupDuplicate), keyEquivalent: "")
        duplicate.target = self
        menu.addItem(duplicate)
        
        
        let item:NSMenuItem = NSMenuItem(title: "Remove", action: #selector(self.popupDelete), keyEquivalent: "")
        item.target = self
        menu.addItem(item)
     
        
        menu.autoenablesItems = false
        menu.delegate = self
        
        
        menu.popUp(positioning: nil, at: origin, in: self.view)
    
        
    
        
    }
    
    
    @objc private func popupDelete(){
    
        print("popupDelete")
        self.callBackRemove(self.myTag)
     }
     
     @objc private func popupDuplicate(){
        print("popupDuplicate")
         self.callBackDuplicate(self.myTag)
         
     }
    
    
    
    
}


extension TimeTableCell:NSMenuDelegate{
    
    
}

