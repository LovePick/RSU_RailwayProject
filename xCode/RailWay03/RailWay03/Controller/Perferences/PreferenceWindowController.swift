//
//  PreferenceWindowController.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 1/6/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController {

    
    
    
    
    class func loadFromNib() -> PreferenceWindowController{
        
        let storyboard = NSStoryboard(name: "Preferences", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "PreferenceWindowController") as! PreferenceWindowController
        
        return vc
    }
    
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        
        
    }

}
