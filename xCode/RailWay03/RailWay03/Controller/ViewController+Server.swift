//
//  ViewController+Server.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 1/6/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa


extension ViewController {
    
    
    @IBAction func tapOnHostSetting(_ sender: Any) {
        
        print("tapOnHostSetting");
       
        if(self.windowPreferenceController == nil){
            self.windowPreferenceController = PreferenceWindowController.loadFromNib()
        }
        
        
        self.windowPreferenceController?.showWindow(self)
        
    }
    
   
    

}
