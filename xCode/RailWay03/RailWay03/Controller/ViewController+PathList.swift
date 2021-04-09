//
//  ViewController+PathList.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/12/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa




extension ViewController:PathListViewDelegate{
    
    // MARK: - PathListViewDelegate
    
    func selectPathAt(view:PathListView ,index: NSInteger){
        
        
        
        if((index >= 0) && (index < self.pathListViewDataModel.arPath.count)){
            self.showPathToolView(show: true)
        }else{
            self.showPathToolView(show: false)
        }
        
        self.pathListViewDataModel.updatePathDisPlay()
    }
    
    
    
    
    // MARK: - action editPath -
    
    func addNewPathItem(){
        let newItem:PathDataModel = PathDataModel()
        
        let time = NSDate().timeIntervalSince1970
        newItem.id = NSInteger(time)
        self.pathListViewDataModel.arPath.append(newItem)
        
        if let pvc = self.myPathCollection{
            pvc.updateData()
        }
    }
    
    func removePathItem(){
        
        
        self.deleteBufferindex = -1
        for i in 0..<self.pathListViewDataModel.arPath.count{
            let item = self.pathListViewDataModel.arPath[i]
            if(item.select == true){
                self.deleteBufferindex = i
                break
            }
        }
        
        
        if((self.deleteBufferindex >= 0) && (self.deleteBufferindex < self.pathListViewDataModel.arPath.count)){
            
            let answer = dialogOKCancel(question: "Delete the path?", text: "Are you sure you would like to delete the path?")
            
            if(answer){
                self.showPathToolView(show: false)
                self.pathListViewDataModel.arPath.remove(at: self.deleteBufferindex)
                self.myPathCollection.updateData()
            }
        }
    }
    
    
    func pathEventSelectCell(cells:[TileCell]){
//        self.viPathToolTextField.stringValue = ""
//        self.viPathToolTextField.isEditable = false
        
        if(cells.count != 1){
            self.swithcMoving.isEnabled = true
            self.pathListViewDataModel.bufferCellSelect = nil
            self.lbJunctionLight.isEnabled = false
        }else{
            self.lbJunctionLight.isEnabled = true
            
            if let cell = cells.first{
                if let cellData = self.pathListViewDataModel.getPathSelected(tile: cell){
//                    self.viPathToolTextField.isEditable = true
//                    self.viPathToolTextField.integerValue = cellData.message
                    self.pathListViewDataModel.bufferCellSelect = cellData
                    self.swithcMoving.isEnabled = true
                    self.lbJunctionLight.intValue = Int32(cellData.junctionLight)
                    if(cell.toRight == true){
                        self.swithcMoving.setSelected(true, forSegment: 0)
                    }else{
                        self.swithcMoving.setSelected(true, forSegment: 1)
                    }
                }else{
                    self.lbJunctionLight.intValue = Int32(cell.junctionLight)
                }
            }
        }
    }
    
    func pathEventChangeMessage(message:NSInteger){
        if(self.pathListViewDataModel.bufferCellSelect != nil){
            self.pathListViewDataModel.bufferCellSelect?.message = message
        }
    }
    
    
    
    
    
    
    // MARK: - intitial path List view
    func addPathListView(){
        if myPathCollection == nil {
            self.myPathCollection = PathListView(frame: NSRect(x: 5, y: 30, width: 120, height: 480))
            self.viCarsListBG.addSubview(self.myPathCollection)
            self.myPathCollection.model = self.pathListViewDataModel
            self.myPathCollection.wantsLayer = true
            self.myPathCollection.myCollection.reloadData()
            self.myPathCollection.delegate = self
            self.myPathCollection.layer?.backgroundColor = NSColor.clear.cgColor
            
        }
    }
    
    
    func removePathListView(){
        if myPathCollection != nil {
            self.myPathCollection.isHidden = true
            self.myPathCollection.delegate = nil
            self.myPathCollection.removeFromSuperview()
            self.myPathCollection = nil
        }
    }
    
    
    
    func showPathToolView(show:Bool){
        if(show){
            self.viPathToolBG.isHidden = false
        }else{
            self.viPathToolBG.isHidden = true
        }
        
    }
    
    @IBAction func tapOnPathToolSwap(_ sender: Any) {
        self.pathListViewDataModel.swapStation()
        if let pvc = self.myPathCollection{
            pvc.updateData()
        }
        
    }
    
    
    func autoSaveEditPath(){
        if let gameScene = ShareData.shared.gamseSceme{
            let allTiles = gameScene.model.arCell
            var arData:[TileCellDataModel] = [TileCellDataModel]()
            
            
            for tx in allTiles{
                for ty in tx{
                    
                    if(ty.selected == true){
                        let newData = ty.getTileDataMode()
                        arData.append(newData)
                    }
                    
                }
            }
            
            self.pathListViewDataModel.addTileToSelectPath(cells: arData)
        }
    }
    
    
    
    
    
    @IBAction func tapOnPathToolAdd(_ sender: Any) {
        
        if let gameScene = ShareData.shared.gamseSceme{
            
            let cells = gameScene.model.lasetSelect
            
            var arData:[TileCellDataModel] = [TileCellDataModel]()
            for item in cells{
                item.selectedStage(select: true)
                let newData = item.getTileDataMode()
                arData.append(newData)
            }
            
            self.pathListViewDataModel.addTileToSelectPath(cells: arData)
        }
        
        if let pvc = self.myPathCollection{
            pvc.updateData()
        }
    }
    
    @IBAction func tapOnPathToolRemove(_ sender: Any) {
        if let gameScene = ShareData.shared.gamseSceme{
            
            let cells = gameScene.model.lasetSelect
            
            
            var arData:[TileCellDataModel] = [TileCellDataModel]()
            
            for item in cells{
                item.selectedStage(select: false)
                let newData = item.getTileDataMode()
                arData.append(newData)
            }
            
            self.pathListViewDataModel.removeTileFromSelectPath(cells: arData)
            
        }
        
        if let pvc = self.myPathCollection{
            pvc.updateData()
        }
    }
    
    
    @IBAction func tapOnPathRunTest(_ sender: Any) {
        
        
    
    }
    
    
    @IBAction func tapOnMovingDirection(_ sender: NSSegmentedControl) {
        
       
        if let gameScene = ShareData.shared.gamseSceme{
            
            let cells = gameScene.model.lasetSelect
            
            var arData:[TileCellDataModel] = [TileCellDataModel]()
            for item in cells{
                item.selectedStage(select: true)
                
                if(sender.indexOfSelectedItem == 0){
                    item.toRight = true
                }else{
                    item.toRight = false
                }
                
                let newData = item.getTileDataMode()
                if(sender.indexOfSelectedItem == 0){
                    newData.toRight = true
                }else{
                    newData.toRight = false
                }
                arData.append(newData)
            }
            
            self.pathListViewDataModel.addTileToSelectPath(cells: arData)
            
            self.pathListViewDataModel.updatePathDisPlay()
        }
        
        if let pvc = self.myPathCollection{
            pvc.updateData()
        }
        
    }
    
    
    
    
}

