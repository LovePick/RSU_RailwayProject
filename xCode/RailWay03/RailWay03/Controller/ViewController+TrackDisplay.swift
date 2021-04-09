//
//  ViewController+TrackDisplay.swift
//  RailWay03
//
//  Created by T2P mac mini on 7/1/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

extension ViewController {

    
   
    
    // MARK: - Edit Mode
    func updateCarPosition(cars:[CarDataModel]){
        if let gameScene = ShareData.shared.gamseSceme{
         
            gameScene.updateCarsData(carsData: cars)
        }
        
        self.autoUpdateCarControllDisplay()
    }
    
    func updateJunctionLight(cars:[CarDataModel]){
        guard let gameScene =  ShareData.shared.gamseSceme else {
            return
        }
        
        for car in cars{
            
            if let from = car.getFromStation(), let to = car.getNextStation() {
                
                //---
                
                
                if(from.id.lowercased() == "b01-a"){
                    if(to.id.lowercased() == "tb01"){
                        gameScene.updateJunctionLightWith(i: 41, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 41, j: 12, light: 1)
                    }
                    if(to.id.lowercased() == "tb02"){
                        gameScene.updateJunctionLightWith(i: 41, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 41, j: 12, light: 2)
                    }
                }
                
                if(from.id.lowercased() == "tb01"){
                    if(to.id.lowercased() == "b01-a"){
                        gameScene.updateJunctionLightWith(i: 41, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 41, j: 12, light: 1)
                    }
                    if(to.id.lowercased() == "b01-b"){
                        gameScene.updateJunctionLightWith(i: 41, j: 7, light: 2)
                        gameScene.updateJunctionLightWith(i: 41, j: 12, light: 1)
                    }
                }
                
                if(from.id.lowercased() == "tb02"){
                    if(to.id.lowercased() == "b01-a"){
                        gameScene.updateJunctionLightWith(i: 41, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 41, j: 12, light: 2)
                    }
                    if(to.id.lowercased() == "b01-b"){
                        gameScene.updateJunctionLightWith(i: 41, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 41, j: 12, light: 1)
                    }
                }
                //----
                
                //---
                if(from.id.lowercased() == "tb03"){
                    if(to.id.lowercased() == "b15-a"){
                        gameScene.updateJunctionLightWith(i: 21, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 21, j: 24, light: 1)
                    }
                    if(to.id.lowercased() == "b15-b"){
                        gameScene.updateJunctionLightWith(i: 21, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 21, j: 24, light: 2)
                    }
                }
                
                if(from.id.lowercased() == "b15-b"){
                    if(to.id.lowercased() == "tb03"){
                        gameScene.updateJunctionLightWith(i: 21, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 21, j: 24, light: 2)
                    }
                    if(to.id.lowercased() == "tb04"){
                        gameScene.updateJunctionLightWith(i: 21, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 21, j: 24, light: 1)
                    }
                }
                
                if(from.id.lowercased() == "tb04"){
                    if(to.id.lowercased() == "b15-a"){
                        gameScene.updateJunctionLightWith(i: 21, j: 19, light: 2)
                        gameScene.updateJunctionLightWith(i: 21, j: 24, light: 1)
                    }
                    if(to.id.lowercased() == "b15-b"){
                        gameScene.updateJunctionLightWith(i: 21, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 21, j: 24, light: 1)
                    }
                }
                //----
                //---
                if(from.id.lowercased() == "b14-a"){
                    if(to.id.lowercased() == "tb05"){
                        gameScene.updateJunctionLightWith(i: 44, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 44, j: 24, light: 1)
                    }
                    if(to.id.lowercased() == "tb06"){
                        gameScene.updateJunctionLightWith(i: 44, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 44, j: 24, light: 2)
                    }
                }
                
                if(from.id.lowercased() == "tb05"){
                    if(to.id.lowercased() == "b14-a"){
                        gameScene.updateJunctionLightWith(i: 44, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 44, j: 24, light: 1)
                    }
                    if(to.id.lowercased() == "b14-b"){
                        gameScene.updateJunctionLightWith(i: 44, j: 19, light: 2)
                        gameScene.updateJunctionLightWith(i: 44, j: 24, light: 1)
                    }
                }
                
                if(from.id.lowercased() == "tb06"){
                    if(to.id.lowercased() == "b14-a"){
                        gameScene.updateJunctionLightWith(i: 44, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 44, j: 24, light: 2)
                    }
                    if(to.id.lowercased() == "b14-b"){
                        gameScene.updateJunctionLightWith(i: 44, j: 19, light: 1)
                        gameScene.updateJunctionLightWith(i: 44, j: 24, light: 1)
                    }
                }
                //----
                
                
                //---
                if(from.id.lowercased() == "b05-a"){
                    if(to.id.lowercased() == "b11-a"){
                        gameScene.updateJunctionLightWith(i: 33, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 33, j: 19, light: 1)
                    }
                    if(to.id.lowercased() == "b11-c"){
                        gameScene.updateJunctionLightWith(i: 33, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 33, j: 19, light: 2)
                    }
                }
                
                if(from.id.lowercased() == "b09-a"){
                    if(to.id.lowercased() == "b11-c"){
                        gameScene.updateJunctionLightWith(i: 33, j: 7, light: 1)
                        gameScene.updateJunctionLightWith(i: 33, j: 19, light: 1)
                    }
                }
                
                //----
                //---
                if(from.id.lowercased() == "b11-d"){
                    if(to.id.lowercased() == "b05-b"){
                        gameScene.updateJunctionLightWith(i: 32, j: 12, light: 1)
                        gameScene.updateJunctionLightWith(i: 32, j: 24, light: 2)
                    }
                    if(to.id.lowercased() == "b09-b"){
                        gameScene.updateJunctionLightWith(i: 32, j: 12, light: 1)
                        gameScene.updateJunctionLightWith(i: 32, j: 24, light: 1)
                    }
                }
                
                if(from.id.lowercased() == "b11-b"){
                    if(to.id.lowercased() == "b05-b"){
                        gameScene.updateJunctionLightWith(i: 32, j: 12, light: 1)
                        gameScene.updateJunctionLightWith(i: 32, j: 24, light: 1)
                    }
                }
                
                //----
                
            }
        }
    }
    
    func updateDisplayWithPath(paths:[PathDataModel]){
        
        
        
        guard let gameScene = ShareData.shared.gamseSceme else { return }
        
        
        var newItem:[PathDataModel] = [PathDataModel]()
        
        if(paths.count <= 0){
            gameScene.model.deselectAllCell()
            self.lastSelectPaths.removeAll()
        }else{
            
            
            var i:NSInteger = self.lastSelectPaths.count - 1
            while i >= 0 {
                let last = self.lastSelectPaths[i]
                var remove:Bool = true
                for update in paths{
                    if(update.id == last.id){
                        remove = false
                        break
                    }
                }
                
                if(remove == true){
                    gameScene.model.deselectPath(path: last)
                    self.lastSelectPaths.remove(at: i)
                }
                i -= 1
            }
            
            
            
        
        }
        
        for pathData in paths{
            var have:Bool = false
            
            
            for ready in self.lastSelectPaths{
                if(pathData.id == ready.id){
                    have = true
                    break
                }
            }
            
            if(have == false){
                newItem.append(pathData)
            }
        }
        
      
        
        for pathData in newItem{
            self.lastSelectPaths.append(pathData)
            self.updateTileDisplay(pathData: pathData)
        }
            
            
    }
    
    
    
    
    func updateTileDisplay(pathData:PathDataModel){
        
        guard let gameScene = ShareData.shared.gamseSceme else { return }
        
        let arCellX = gameScene.model.arCell
        
        for item in pathData.setPath.values{
            
            if((item.i >= 0) && (item.i < arCellX.count)){
                let cellY = arCellX[item.i]
                
                if((item.j >= 0) && (item.j < cellY.count)){
                    let tile = arCellX[item.i][item.j]
                    if let m = TileCell.Mode(rawValue: item.mode){
                        tile.mode = m
                        
                        
                        
                        if(pathData.bufferRevertDirection == true){
                            tile.toRight = !item.toRight
                        }else{
                            tile.toRight = item.toRight
                        }
                        
                        
                      
                        
                    }
                    
                    
                    if(tile.id.lowercased() == "j01"){
                        
                    }else if(tile.id.lowercased() == "j02"){
                      
                    }else if(tile.id.lowercased() == "j03"){
                      
                    }else if(tile.id.lowercased() == "j04"){
                       
                    }else if(tile.id.lowercased() == "j05"){
                        
                    }else if(tile.id.lowercased() == "j06"){
                       
                    }else if(tile.id.lowercased() == "jpt1"){
                        
                    }else if(tile.id.lowercased() == "jpt2"){
                      
                    }else if(tile.id.lowercased() == "jbt1"){
                      
                    }else if(tile.id.lowercased() == "jbt2"){
                       
                    }else{
                        tile.junctionLight = item.junctionLight
                    }
                    
                    
                    tile.selectedStage(select: true)
                }
            }
            
        }
    }
    
 
    
    func updateDisplayToClearWithPath(paths:[PathDataModel]){
 
        for pathData in paths{
            self.updateTileDisplayClear(pathData: pathData)
        }
    
    }
    
    
    func updateTileDisplayClear(pathData:PathDataModel){
        
        guard let gameScene = ShareData.shared.gamseSceme else { return }
        
        let arCellX = gameScene.model.arCell
        
        for item in pathData.setPath.values{
            
            if((item.i >= 0) && (item.i < arCellX.count)){
                let cellY = arCellX[item.i]
                
                if((item.j >= 0) && (item.j < cellY.count)){
                    let tile = arCellX[item.i][item.j]
                    
                    tile.setJunctionToRed()
                    
                    tile.selectedStage(select: false)
                }
            }
            
        }
    }
    
    // MARK: - Display
    
    
    func addDisplayPath(path:PathDataModel){
        
        var acPath:PathDataModel? = nil
        
        for p in self.arActivePath{
            if(path.id == p.id){
                acPath = p
                break
            }
        }
        

        guard let pathActive = acPath else {
            // add new display path
            self.updateTileDisplay(pathData: path)
            
            self.arActivePath.append(path)
            return
        }
        

        self.updateTileDisplay(pathData: pathActive)
        
        
    }
    
    
    func removeDisplayPath(path:PathDataModel){
        guard let gameScene = ShareData.shared.gamseSceme else { return }
        
        let arCellX = gameScene.model.arCell
        
        for item in path.setPath.values{
            
            if((item.i >= 0) && (item.i < arCellX.count)){
                let cellY = arCellX[item.i]
                
                if((item.j >= 0) && (item.j < cellY.count)){
                    let tile = arCellX[item.i][item.j]
                    tile.junctionLight = tile.normalJunctionLight
                    tile.highlightStage(active: false)
                    tile.selectedStage(select: false)
                    
                }
            }
            
        }
        //---
        
        var count:NSInteger = self.arActivePath.count - 1
        
        while (count >= 0) {
            let item = self.arActivePath[count]
            if(item.id == path.id){
                self.arActivePath.remove(at: count)
            }
            
            count -= 1
        }
    }
    
}
