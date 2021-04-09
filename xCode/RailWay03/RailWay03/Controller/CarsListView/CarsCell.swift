//
//  CarsCell.swift
//  RailWay03
//
//  Created by T2P mac mini on 23/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

@objc protocol CarsCellDelegate {
    @objc func selectCarTimeTableAt(cellTag:NSInteger, timeTableIndex: NSInteger)
    @objc func selectCarCell(cellTag:NSInteger)
}

class CarsCell: NSCollectionViewItem {

    
    @IBOutlet weak var viContentBG: NSView!
    @IBOutlet weak var lbTitle: NSTextField!
    
    @IBOutlet weak var btTimeTable: NSPopUpButton!
    
    @IBOutlet weak var lbOnlineMark: NSTextField!
    
    var myTag:NSInteger = 0

    
    var delegate:CarsCellDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.wantsLayer = true
        viContentBG.wantsLayer = true
        self.lbOnlineMark.wantsLayer = true
        self.lbOnlineMark.textColor = .app_space_blue
        
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        
        viContentBG.layer?.backgroundColor = NSColor.black.cgColor
        viContentBG.layer?.cornerRadius = 5
        viContentBG.layer?.borderWidth = 1
        viContentBG.layer?.borderColor = NSColor.app_space_blue.cgColor
        
        
        lbTitle.textColor = NSColor.app_space_blue
        
        lbTitle.isEditable = false
        lbTitle.isSelectable = false
       
        
    }
    
    func setSelectState(select:Bool) {
        
        self.view.wantsLayer = true
        viContentBG.wantsLayer = true
        
        if(select){
            viContentBG.layer?.backgroundColor = NSColor.app_space_blue2.cgColor
        }else{
            viContentBG.layer?.backgroundColor = NSColor.black.cgColor
        }
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        //print("mouseDown : \(myTag)")
        
        if (event.clickCount > 1) {
            
            self.lbTitle.isEditable = true
            self.lbTitle.becomeFirstResponder()
        }else{
            
            self.lbTitle.resignFirstResponder()
            self.lbTitle.isEditable = false
        }
        
        
        guard let de = self.delegate else {
            return
        }
        
        
        de.selectCarCell(cellTag: self.myTag)
      
        
    }
    
    @IBAction func selectTimeTable(_ sender: NSPopUpButton) {
        
        
        guard let de = self.delegate else {
            return
        }
        
        de.selectCarTimeTableAt(cellTag: self.myTag, timeTableIndex: sender.indexOfSelectedItem)
    }
    
    
    
    
    
}
