//
//  PathEditerModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 26/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class PathEditerModel: NSObject {

    
    var lastSelect:NSInteger = -1
    var arPath:[PathDataModel] = [
        PathDataModel]()
    
    
    var bufferCellSelect:TileCellDataModel? = nil
    
    
    func swapStation() {
        if((lastSelect >= 0) && (lastSelect < arPath.count)){
            let pathData = arPath[lastSelect]
            
            let buff = pathData.from
            pathData.from = pathData.to
            pathData.to = buff
        }
    }
    
    
    func addTileToSelectPath(cells:[TileCellDataModel]){
        if((lastSelect >= 0) && (lastSelect < arPath.count)){
            
            for item in cells{
                arPath[lastSelect].addPath(path: item)
            }
            
        }
    }
    
    
    
    func removeTileFromSelectPath(cells:[TileCellDataModel]){
        if((lastSelect >= 0) && (lastSelect < arPath.count)){
            
            for item in cells{
                arPath[lastSelect].removePath(path: item)
            }
            
        }
    }
    
    
    
    func updatePathDisPlay(){
        if let gameScene = ShareData.shared.gamseSceme{
            gameScene.model.deselectAllCell()
            
            
            if((lastSelect >= 0) && (lastSelect < arPath.count)){
                let pathData = arPath[lastSelect]
                
                let arCellX = gameScene.model.arCell
                
                
                for item in pathData.setPath.values{
                    
                    if((item.i >= 0) && (item.i < arCellX.count)){
                        let cellY = arCellX[item.i]
                        
                        if((item.j >= 0) && (item.j < cellY.count)){
                            let tile = arCellX[item.i][item.j]
                            if let m = TileCell.Mode(rawValue: item.mode){
                                tile.mode = m
                                tile.toRight = item.toRight
                                
                            }
                            tile.junctionLight = item.junctionLight
                            tile.selectedStage(select: true)
                            
                        }
                    }
                    
                }

            }
            
            
        }

    }
    
    
    
    
    func getPathSelected(tile:TileCell)->TileCellDataModel?{
        
        if((lastSelect >= 0) && (lastSelect < arPath.count)){
            
            let paths = arPath[lastSelect].setPath
            
            for v in paths.values{
                if((v.i == tile.i) && (v.j == tile.j)){
                    return v
                }
            }
        }
        
        
        return nil
    }
    
    
    
    
    func isSameCell(a:TileCellDataModel, b:TileCellDataModel)->Bool{
        if((a.i == b.i) && (a.j == b.j)){
            return true
        }else{
            return false
        }
    }
    
//    func getPathStationOriginal(cellID:NSInteger)->TileCellDataModel?{
//        var station:TileCellDataModel? = nil
//        for item in self.arPath{
//            if(item.id == cellID){
//                station = item.
//            }
//        }
//        
//        return station
//    }
    
    func getStationCanBe(cell:TileCellDataModel?)->[TileCellDataModel]{
        
        var arTile:[TileCellDataModel] = [TileCellDataModel]()
        
        if let c = cell{
            for item in self.arPath{
                
                if((isSameCell(a: c, b: item.to)) || (isSameCell(a: c, b: item.from))){
                    var f:Bool = true
                    var t:Bool = true
                    for ready in arTile{
                        if((item.from.i == ready.i) && (item.from.j == ready.j)){
                            f = false
                        }
                        
                        if((item.to.i == ready.i) && (item.to.j == ready.j)){
                            t = false
                        }
                    }
                    
                    //--------
                    if(c.id.lowercased() == "tb06"){
                        if(item.to.id.lowercased() == "b14-a"){
                            t = false
                        }
                        
                        if(item.from.id.lowercased() == "b14-a"){
                            f = false
                        }
                    }
                    
                    if(c.id.lowercased() == "b14-a"){
                        if(item.to.id.lowercased() == "tb06"){
                            t = false
                        }
                        
                        if(item.from.id.lowercased() == "tb06"){
                            f = false
                        }
                    }
                    //--------
                    
                    
                    if(f){
                        arTile.append(item.from)
                    }
                    if(t){
                        arTile.append(item.to)
                    }
                }
                
            }
            
            
        }else{
            
            //All station
            for item in self.arPath{
                
                var f:Bool = true
                var t:Bool = true
                for ready in arTile{
                    if((item.from.i == ready.i) && (item.from.j == ready.j)){
                        f = false
                    }
                    
                    if((item.to.i == ready.i) && (item.to.j == ready.j)){
                        t = false
                    }
                }
                
                if(f){
                    arTile.append(item.from)
                }
                if(t){
                    arTile.append(item.to)
                }
            }
        }
        
        
        arTile = arTile.sorted { (tc1, tc2) -> Bool in
            return tc1.id < tc2.id
        }
        
        return arTile
    }
    
    
    func getPathWith(a:TileCellDataModel, b:TileCellDataModel)->[PathDataModel]{
        
        var arPathReturn:[PathDataModel] = [PathDataModel]()
        
        var isOK:Bool = false
        
        
        
        for item in self.arPath{
            
            if(isSameCell(a: item.from, b: a)){
                
                if(isSameCell(a: item.to, b: b)){
                    isOK = true
                    
                    item.bufferRevertDirection = false
                    
//                    if(a.i < b.i){
//                        item.bufferRevertDirection = false
//                    }else if(a.i > b.i){
//                        item.bufferRevertDirection = true
//                    }
                }
            }
            
            if(isSameCell(a: item.from, b: b)){
                
                if(isSameCell(a: item.to, b: a)){
                    isOK = true
                    
                    item.bufferRevertDirection = true
                    
//                    if(a.i < b.i){
//                        item.bufferRevertDirection = false
//                    }else if(a.i > b.i){
//                        item.bufferRevertDirection = true
//                    }
                }
            }
            
            if(isOK){
                arPathReturn.append(item)
            }
            
        }
        
        
        return arPathReturn
    }
}
