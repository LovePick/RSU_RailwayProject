//
//  ShareData.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class ShareData: NSObject {

    static let shared = ShareData()
    
    let cellSize:CGSize = CGSize(width: 64, height: 32)
    
    
    
    var gamseSceme:GameScene? = nil
   
    var masterVC:ViewController? = nil
    
    
    var production:Bool = false
   
    
    /*
    func saveMapData(dic:[String:Any]){
        
        let defaults = UserDefaults.standard
        defaults.set(dic, forKey: "savemapdata")
        defaults.synchronize()
    }
    
    func loadSaveMapData()->[String:Any]{
        
        let defaults = UserDefaults.standard
        let load:[String:Any]? = defaults.value(forKey: "savemapdata") as? [String:Any]
        
        if let load = load{
            return load
        }else{
            return [String:Any]()
        }
    }*/
}
