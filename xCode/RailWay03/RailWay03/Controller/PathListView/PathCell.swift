//
//  PathCell.swift
//  RailWay03
//
//  Created by T2P mac mini on 27/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class PathCell: NSCollectionViewItem {

    @IBOutlet weak var viContentBG: NSView!
    
    
    
    @IBOutlet weak var from: NSTextField!
    @IBOutlet weak var lbTo: NSTextField!
    @IBOutlet weak var to: NSTextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        viContentBG.wantsLayer = true
        
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        
        viContentBG.layer?.backgroundColor = NSColor.black.cgColor
        viContentBG.layer?.cornerRadius = 5
        viContentBG.layer?.borderWidth = 1
        viContentBG.layer?.borderColor = NSColor.app_space_blue.cgColor
        
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
}
