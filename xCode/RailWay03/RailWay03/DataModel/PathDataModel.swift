//
//  PathDataModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 26/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class PathDataModel: NSObject {

    var id:NSInteger = 0
    var from:TileCellDataModel! = nil
    var to:TileCellDataModel! = nil
    
    var setPath:[String:TileCellDataModel] = [String:TileCellDataModel]()
    

    var select:Bool = false
    
    let cellSize:CGSize = CGSize(width: 64, height: 32)
    
    
    var bufferRevertDirection:Bool = false
    
    
    override init() {
        super.init()
        
    }
    
    convenience init(fields:[String: Any]){
        
        self.init()
        
        
        self.readJson(fields: fields)
    }
    
    
        
        
    
    func addPath(path:TileCellDataModel){
        setPath[path.getKey()] = path
        
        self.findStationDestination()
    }
    
    func removePath(path:TileCellDataModel){
        setPath.removeValue(forKey: path.getKey())
        
        self.findStationDestination()
    }
    
    
    
    func getPathWith(fromStation:TileCellDataModel, toStation:TileCellDataModel)->[TileCellDataModel]{
        if(fromStation.i < toStation.i){
            
            if(fromStation.j < toStation.j){
                let arItem = setPath.values.sorted { (cell1, cell2) -> Bool in
                
                    if(cell1.i == cell2.i){
                        return cell1.j < cell2.j
                    }else{
                        return cell1.i < cell2.i
                    }
                    
                    
                }
                return arItem
            }else{
                let arItem = setPath.values.sorted { (cell1, cell2) -> Bool in
                
                    if(cell1.i == cell2.i){
                        return cell1.j > cell2.j
                    }else{
                        return cell1.i < cell2.i
                    }
                    
                    
                }
                return arItem
            }
            
        }else{
            if(fromStation.j < toStation.j){
                
                let arItem = setPath.values.sorted { (cell1, cell2) -> Bool in
                    
                    if(cell1.i == cell2.i){
                        return cell1.j < cell2.j
                    }else{
                        return cell1.i > cell2.i
                    }
                    
                }
                return arItem
            }else{
                let arItem = setPath.values.sorted { (cell1, cell2) -> Bool in
                    
                    if(cell1.i == cell2.i){
                        return cell1.j > cell2.j
                    }else{
                        return cell1.i > cell2.i
                    }
                    
                }
                return arItem
            }
            
            
        }
    }
    
    func getMovingPointInMap(fromStation:TileCellDataModel, toStation:TileCellDataModel, wCount:NSInteger, hCount:NSInteger)->[CGPoint]{
        
        let arCell = self.getPathWith(fromStation: fromStation, toStation: toStation)
        
        var dicPoint:[String:CGPoint] = [String:CGPoint]()
        
        
        let w:CGFloat = CGFloat(wCount) * cellSize.width
        let h:CGFloat = CGFloat(hCount) * cellSize.height
        
        
        let ox:CGFloat = w / -2
        let oy:CGFloat = h / 2
        
        
        
        for item in arCell{
            let path = item.getMoveingPoint()

            let deltaX:CGFloat = CGFloat(item.i) * cellSize.width
            let deltaY:CGFloat = (CGFloat(item.j) * cellSize.height) * -1
            
            let shipX:CGFloat = (cellSize.width / 2)
            let shipY:CGFloat = (cellSize.height / 2)
            
            for p in path{
                
                let cellX:CGFloat = shipX + p.x
                let cellY:CGFloat = shipY - p.y
                
                let wX:CGFloat = deltaX + cellX
                let wY:CGFloat = deltaY - cellY
                
                let newX:CGFloat = ox + wX
                let newY:CGFloat = oy + wY
                let keyX:NSInteger = NSInteger(newX)
                let keyY:NSInteger = NSInteger(newY)
                let key:String = "x\(keyX)y\(keyY)"
                dicPoint[key] = CGPoint(x: newX, y: newY)
            }
        }
        
        
        if(fromStation.i < toStation.i){
            
            if(fromStation.j < toStation.j){
                return dicPoint.values.sorted { (cell1, cell2) -> Bool in
                
                    if(cell1.x == cell2.x){
                        return cell1.y < cell2.y
                    }else{
                        return cell1.x < cell2.x
                    }
                }
            }else{
                return dicPoint.values.sorted { (cell1, cell2) -> Bool in
                
                    if(cell1.x == cell2.x){
                        return cell1.y > cell2.y
                    }else{
                        return cell1.x < cell2.x
                    }
                }
            }
        }else{
            if(fromStation.j < toStation.j){
                return dicPoint.values.sorted { (cell1, cell2) -> Bool in
                
                    if(cell1.x == cell2.x){
                        return cell1.y < cell2.y
                    }else{
                        return cell1.x > cell2.x
                    }
                }
            }else{
                return dicPoint.values.sorted { (cell1, cell2) -> Bool in
                
                    if(cell1.x == cell2.x){
                        return cell1.y > cell2.y
                    }else{
                        return cell1.x > cell2.x
                    }
                }
            }
        }
        
    }
    
    
    
    
    func findStationDestination() {
        self.from = nil
        self.to = nil
        
        let arItem = setPath.values.sorted { (cell1, cell2) -> Bool in
            return cell1.i < cell2.i
        }
        
        if(arItem.count > 0){
            
            for i in arItem{
                if(i.stationMode != TileCell.StationType.non.rawValue){
                    self.from = i
                    break
                }
            }
            
            for i in arItem.reversed(){
                if(i.stationMode != TileCell.StationType.non.rawValue){
                    self.to = i
                    break
                }
            }
        }
    }
    
    func getDicData()->[String:Any]{
        var dicData:[String:Any] = [String:Any]()
        
        dicData["id"] = self.id
        
        if self.from != nil{
            dicData["from"] = self.from.getDictData()
        }
        if self.to != nil{
            dicData["to"] = self.to.getDictData()
        }
        
        
        var arTile:[[String:Any]] = [[String:Any]]()
        
        for item in self.setPath.values{
            let itemDic = item.getDictData()
            arTile.append(itemDic)
        }
        
        dicData["setPath"] = arTile
        
        
        dicData["Revert"] = self.bufferRevertDirection
        
        return dicData
    }
    
    
    func readJson(fields:[String: Any]) {
        if let id = fields["id"] as? NSInteger{
            self.id = id
        }
        
        if let fromDic = fields["from"] as? [String:Any]{
            self.from = TileCellDataModel(fields: fromDic)
        }
        
        if let toDic = fields["to"] as? [String:Any]{
            self.to = TileCellDataModel(fields: toDic)
        }
        
        if let arCell = fields["setPath"] as? [[String:Any]]{
            for item in arCell{
                let newTile:TileCellDataModel = TileCellDataModel(fields: item)
                self.addPath(path: newTile)
            }
        }
        
        
        if let bufferRevertDirection = fields["Revert"] as? Bool{
            self.bufferRevertDirection = bufferRevertDirection
        }
    }
    
    
    

    
    
    
    
    func getTitle()->String{
        var str:String = ""
        
   
        if((self.from != nil) && (self.to != nil)){
            
            
            var a:String = self.from.stationName
            var b:String = self.to.stationName
            
            if(self.from.stationName == ""){
                a = self.from.id
            }
            
            if(self.to.stationName == ""){
                b = self.to.id
            }
            str = "\(a) - \(b)"
            
            
            
            
        }else if(self.from != nil){
            var a:String = self.from.stationName
            if(self.from.stationName == ""){
                a = self.from.id
            }
            str = "\(a) - "
        }else if(self.to != nil){
            var b:String = self.to.stationName
            if(self.to.stationName == ""){
                b = self.to.id
            }
            
            str = " - \(b)"
        }
        
        return str
    }
    
    
    
    
    
}
