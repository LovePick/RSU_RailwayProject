//
//  GameModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 19/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit


class GameModel: NSObject {

    enum DisPlayMode {
        case editMap
    }
    
    var mapWidth:NSInteger = 0
    var mapHeight:NSInteger = 0
    
    let cellSize:CGSize = CGSize(width: 64, height: 32)
    
    
    var arCell:[[TileCell]] = [[TileCell]]()
    
    
    var lasetSelect:[TileCell] = [TileCell]()
    
    
    var mapMode:DisPlayMode = .editMap
    
    var arCarsNode:[CarNode] = [CarNode]()
    
    var zoomScale:CGFloat = 1.0
    
    //var activePath:[ActivePathModel] = [ActivePathModel]()
    
    override init() {
        super.init()
        
    }
    
    
    func changeMapSize(width:NSInteger, height:NSInteger, toMapNode:SKSpriteNode){
        
        print("changeMapSize")
        let w:CGFloat = CGFloat(width) * cellSize.width
        let h:CGFloat = CGFloat(height) * cellSize.height
        
        
        let ox:CGFloat = w / -2
        let oy:CGFloat = h / 2
        
    
        if(arCell.count > 0){
            
            //Remove X
            if(arCell.count >=  width){
                
                var i:NSInteger = arCell.count
                
                while(i > width){
                    let indexX:NSInteger = i - 1
                    
                    let arY:[TileCell] = arCell[indexX]
                    var j:NSInteger = arY.count
                    while(j > 0){
                        let indexY:NSInteger = j - 1
                        let tile = arY[indexY]
                        tile.removeAllActions()
                        tile.removeAllChildren()
                        tile.removeFromParent()
                        arCell[indexX].remove(at: indexY)
                        
                        print("Remove: \(indexX),\(indexY)")
                        //
                        j -= 1
                    }
                    arCell.remove(at: indexX)
                    ///
                    i -= 1
                }
            }
            
            
            
            //Remove Y
            for i in 0..<arCell.count {
                let arY:[TileCell] = arCell[i]
                var j:NSInteger = arY.count
                while(j > height){
                    let indexY:NSInteger = j - 1
                    let tile = arY[indexY]
                    tile.removeAllActions()
                    tile.removeAllChildren()
                    tile.removeFromParent()
                    arCell[i].remove(at: indexY)
                    print("Remove: \(i),\(indexY)")
                    //
                    j -= 1
                }
            }
            
        }
        //end Remove
        
        
        
        
        
        for i in 0..<width{
           
            
            if(i < self.arCell.count){
                
            }else{
                let ar:[TileCell] = [TileCell]()
                self.arCell.append(ar)
            }
            
           
            for j in 0..<height{
                
                if(j >= self.arCell[i].count){
                    let cell1:TileCell = TileCell(size: cellSize, mode: .non, i: i, j:j)
                    cell1.i = i
                    cell1.j = j
                    self.arCell[i].append(cell1)
                    toMapNode.addChild(cell1)
                    
                    let x:CGFloat = ox + ((CGFloat(i) * cellSize.width) + (cellSize.width / 2))
                    let y:CGFloat = oy - ((CGFloat(j) * cellSize.height) + (cellSize.height / 2))
                    
                    
                    cell1.position = CGPoint(x: x, y: y)
                }else{
                    let x:CGFloat = ox + ((CGFloat(i) * cellSize.width) + (cellSize.width / 2))
                    let y:CGFloat = oy - ((CGFloat(j) * cellSize.height) + (cellSize.height / 2))
                    
                    self.arCell[i][j].i = i
                    self.arCell[i][j].j = j
                    
                    self.arCell[i][j].position = CGPoint(x: x, y: y)
                }
                
                print("changeMapSize Update :\(self.arCell[i][j].i),\(self.arCell[i][j].j)")
               
            }
            
        }
    }
    
    
    
    func removeNotUseCell(remove:Bool, fromNode:SKSpriteNode){
        for arX in self.arCell{
            
            for cell in arX{
                if((cell.mode == .non) && (!cell.lineLeft) && (!cell.lineRight) && (!cell.lineTop) && (!cell.lineBottom) && (cell.stationMode == .non)){
         
                    
                    if(remove){
                        if let _ = cell.parent{
                            cell.removeFromParent()
                        }
                    }else{
                        if let _ = cell.parent{
                            
                        }else{
                            
                            fromNode.addChild(cell)
                            cell.zPosition = -2
 
                        }
                    }
                    
                    
                }else{
   
                }
            }
        }
    }
    
    
    
    
    func updateMapData(arData:[TileCellDataModel], width:NSInteger, height:NSInteger, toMapNode:SKSpriteNode){
        self.deselectAllCell()
        
        self.changeMapSize(width: width, height: height, toMapNode: toMapNode)
        
        for item in arData{
            
            if((item.i >= 0) && (item.i < self.arCell.count)){
                
                let arY = self.arCell[item.i]
                
                if((item.j >= 0) && (item.j < arY.count)){
                    
                    
                 
                    arY[item.j].readData(cellData: item)
                }
            }
            
        }
    }
    
    func getCellAt(point:CGPoint, mapNode:SKSpriteNode)->TileCell?{
        
        let hw:CGFloat = self.cellSize.width / 2.0
        let hh:CGFloat = self.cellSize.height / 2.0
        
        var selectCell:TileCell? = nil
        for xcell in self.arCell{
            for yCell in xcell{
                let center = yCell.position
                
                let ox:CGFloat = center.x - hw
                let ex:CGFloat = center.x + hw
                let oy:CGFloat = center.y - hh
                let ey:CGFloat = center.y + hh
                
                
                if((point.x > ox) && (point.x < ex) && (point.y > oy) && (point.y < ey)){
                    selectCell = yCell
                    break
                }
                
                if(selectCell != nil){
                    break
                }
            }
        }
        
        /*
        let hitNodes = mapNode.nodes(at: point).filter{$0.name == "cell"}
        guard let hitNode = hitNodes.first else { return nil }
        guard let cellNode = hitNode as? TileCell else { return nil}
        
        print("\(cellNode.i), \(cellNode.j)")
 */
        return selectCell
    }
    
    func getCellsInRect(start:CGPoint, now:CGPoint, gameScene:SKScene, map:SKSpriteNode)->[TileCell]{
       
        
        var startPoint:CGPoint = start
        var endPoint:CGPoint = now
        
        if(start.x >= now.x){
            startPoint.x = now.x
            endPoint.x = start.x
        }
        
        if(start.y >= now.y){
            startPoint.y = now.y
            endPoint.y = start.y
        }
        
        let width:CGFloat = endPoint.x - startPoint.x
        let heigth:CGFloat = endPoint.y - startPoint.y
        
        var arCell:[TileCell] = [TileCell]()
        
        let rect:CGRect = CGRect(x: startPoint.x, y: startPoint.y, width: width, height: heigth)
        for arY in self.arCell{
            for cell in arY{
                if(self.hitTest(cell: cell, rect: rect)){
                    arCell.append(cell)
                }
            }
        }
        
        
        
        return arCell
        
    }
    
    
    func hitTest(cell:TileCell, rect:CGRect)->Bool{
        
        
        let hw:CGFloat = self.cellSize.width / 2.0
        let hh:CGFloat = self.cellSize.height / 2.0
        
        
        var hit:Bool = false
        
        var arPoint:[CGPoint] = [CGPoint]()
        
        arPoint.append(cell.position)
        arPoint.append(CGPoint(x: cell.position.x - hw, y: cell.position.y - hh))
        arPoint.append(CGPoint(x: cell.position.x - hw, y: cell.position.y + hh))
        arPoint.append(CGPoint(x: cell.position.x + hw, y: cell.position.y - hh))
        arPoint.append(CGPoint(x: cell.position.x + hw, y: cell.position.y - hh))
        
        let sX:CGFloat = rect.origin.x
        let sY:CGFloat = rect.origin.y
        
        let endX:CGFloat = rect.origin.x + rect.size.width
        let endY:CGFloat = rect.origin.y + rect.size.height
        
        for p in arPoint{
            if((p.x >= sX) && (p.x < endX)){
                if((p.y >= sY) && (p.y < endY)){
                    hit = true
                }
            }
        }
        
        if(hit == false){
            let cellOX:CGFloat = cell.position.x - hw
            let cellEX:CGFloat = cell.position.x + hw
            let cellOY:CGFloat = cell.position.y - hh
            let cellEY:CGFloat = cell.position.y + hh
            
            if((rect.origin.x > cellOX) && (rect.origin.x < cellEX)){
                if((rect.origin.y > cellOY) && (rect.origin.y < cellEY)){
                    hit = true
                }
            }
            
            if((endX > cellOX) && (endX < cellEX)){
                if((rect.origin.y > cellOY) && (rect.origin.y < cellEY)){
                    hit = true
                }
            }
            
            if((rect.origin.x > cellOX) && (rect.origin.x < cellEX)){
                if((endY > cellOY) && (endY < cellEY)){
                    hit = true
                }
            }
            
            if((endX > cellOX) && (endX < cellEX)){
                if((endY > cellOY) && (endY < cellEY)){
                    hit = true
                }
            }
            
            
            if((sY > cellOY) && (endY < cellEY)){
                if((sX < cellOX) && (endX > cellEX)){
                    hit = true
                }
            }
            
            if((sX > cellOX) && (endX < cellEX)){
                if((sY < cellOY) && (endY > cellEY)){
                    hit = true
                }
            }
            
            
        }
        
    
        
        
        return hit
    }
    
    func deselectAllCell(){
        for arY in self.arCell{
            for cell in arY{
                cell.highlightStage(active: false)
                cell.junctionLight = cell.normalJunctionLight
                cell.selectedStage(select: false)
            }
        }
        
        
        self.lasetSelect = []
    }
    
    
    func deselectPath(path:PathDataModel){
        for (_, cell) in path.setPath{
            
            if(cell.i < self.arCell.count){
                let arY = self.arCell[cell.i]
                
                if(cell.j < arY.count){
                    let tile = arY[cell.j]
                    tile.highlightStage(active: false)
                    tile.selectedStage(select: false)
                }
            }
          
        }
    }
    
    
    func selectCell(cells:[TileCell], touchEvent:TouchEventModel){
        for arY in self.arCell{
            for cell in arY{
                cell.highlightStage(active: false)
            }
        }
        
        for cell in cells{
            cell.highlightStage(active: true)
        }
        
        
        self.lasetSelect = cells
        
        if let mvc = ShareData.shared.masterVC{
            mvc.selectOnCells(cells: cells)
        }
    }
    
    
    
    func changeSelectCellTo(type:TileCell){
        
        if let mvc = ShareData.shared.masterVC{
            
            if((mvc.displayMode == .editMap) || (mvc.displayMode == .editPath)){
                if(self.lasetSelect.count > 0){
                    for item in self.lasetSelect{
                        
                        if(type.mode == .non){
                            item.stationName = ""
                            item.id = ""
                            item.stationMode = .non
                        }
                        
                        item.drawMode(mode: type.mode)
                        
                    }
                    mvc.autoSaveEditPath()
                }
            }
        }
        
        
        
        
        
        
    }
   
    
    
    
    
    
    
    /*
    func drawPathMoving(path:[PathDataModel], toMapNode:SKSpriteNode){
        
        
        
        
        
    }
    */
    
    func updateJunctionLightWith(i:NSInteger, j:NSInteger, light:NSInteger){
        if let tile = self.getTileCellWith(i: i, j: j){
            
//            if(tile.junctionLight == light){
//                return
//            }
            
            tile.junctionLight = light
            
            if(light == 1){
                
                tile.removeAllChildren()
                tile.movingPoint.removeAll()
                if(tile.stationNode != nil){
                    tile.stationNode.removeAllChildren()
                    
                }
                tile.drawLine()
            }
            tile.drawJunctionLight()
        }
    }
    
    func updateCarData(carsData:[CarDataModel], mapNode:SKSpriteNode){
        
        
        guard carsData.count > 0 else {
            var i:NSInteger = self.arCarsNode.count - 1
            while i >= 0 {
                let carNode = self.arCarsNode[i]
                carNode.removeAllActions()
                carNode.removeAllChildren()
                carNode.removeFromParent()
                self.arCarsNode.remove(at: i)
                i -= 1
            }
            return
        }
        
        
        //---
        
        var k:NSInteger = self.arCarsNode.count - 1
        while k >= 0 {
            var have:Bool = false
            let carNode = self.arCarsNode[k]
            
            for car in carsData{
                if((car.id == carNode.id) && (car.timeDetail != nil)){
                    have = true
                    self.updateCarWith(carData: car, carNodeIndex: k)
                }
            }
            
            if(have == false){
                self.arCarsNode[k].removeAllActions()
                self.arCarsNode[k].removeAllChildren()
                self.arCarsNode[k].removeFromParent()
                self.arCarsNode.remove(at: k)
            }
            
            k -= 1
        }
        
        //---
        for car in carsData{
            
            var have:Bool = false
            var i:NSInteger = self.arCarsNode.count - 1
            
            while i >= 0 {
                let carNode = self.arCarsNode[i]
                
                if(car.id == carNode.id){
                    have = true
                }
                
                i -= 1
            }
            
            // don't have, need create new
            if((have == false)  && (car.timeDetail != nil)){
                let newNode:CarNode = CarNode()
                newNode.id = car.id
                mapNode.addChild(newNode)
                self.arCarsNode.append(newNode)
                
                let last = self.arCarsNode.count - 1
                self.updateCarWith(carData: car, carNodeIndex: last)
            }
            
            
        }
        
    }
    
    
    
    
    func updateCarWith(carData:CarDataModel, carNodeIndex:NSInteger){
        let carNode = self.arCarsNode[carNodeIndex]
        
        
        var changColor:Bool = false
        
        if(carNode.lastActiveStatus != carData.activeStatus.rawValue){
            changColor = true
        }
        carNode.lastActiveStatus = carData.activeStatus.rawValue

        
        switch carData.activeStatus {
        case .emergencyStop, .error:
            carNode.carColor = .app_red
            carNode.carLineColor = .app_red2
            break
        case .unknow, .inProgress:
            carNode.carColor = .app_orange
            carNode.carLineColor = .app_orange2
            break
        default:
            carNode.carColor = .app_space_blue
            carNode.carLineColor = .app_space_blue2
            carNode.labelColor = .app_space_blue4
            break
        }
        
        
        
        carNode.lbName.text = carData.name
       
        
        var cell:TileCell? = nil
        
        switch carData.position {
        case .atStation:
            
            if let detail = carData.timeDetail{
                if let data = detail.station{
                    cell = getTileCellWith(cellData: data)
                }
            }
            
            
            break
        case .onTheWay:
            
            guard let timeDetail = carData.timeDetail else { return }
            guard let from = timeDetail.station else { return }
            guard let to = timeDetail.toStation else { return }
            guard let part = timeDetail.path else { return }
            let arPart = part.getPathWith(fromStation: from, toStation: to)
            
            guard arPart.count > 0 else { return }
            
            if(carData.simulatorProgressFinish == 0){
                carData.simulatorProgressFinish = 1
                carData.simulatorProgressCount = 0
            }
            let diff = carData.simulatorProgressCount / carData.simulatorProgressFinish
            
            let indexd:Double = Double(arPart.count) * diff //0.5
            var index:NSInteger = NSInteger(round(indexd))
            if(index >= arPart.count){
                index = arPart.count - 1
            }
            
            let cellData = arPart[index]
            cell = getTileCellWith(cellData: cellData)
            
            break
        case .arrive:
        
            if let detail = carData.timeDetail{
                if let data = detail.toStation{
                    cell = getTileCellWith(cellData: data)
                }
            }
            
            
            break
        
        }
        
        
        guard let cellTile =  cell else { return }
        
        
        
        
        carNode.zPosition = 102
        
        
        guard let timeDetail = carData.timeDetail else {
            carNode.setupDraw(arrowDirection: .non, animationaStyle: .fade, changeColor: changColor)
            carNode.position = cellTile.position
            
            return
        }
        
        if let st = timeDetail.station, let to = timeDetail.toStation{
            
            var carPosition:CGPoint = cellTile.position
            
            
            if carData.position == .onTheWay, cellTile.mode == .vertical{
                
                let y = cellTile.position.y + (cellTile.size.height / 2.0)
                carPosition = CGPoint(x: cellTile.position.x, y: y)
                
            }
            
            
            if(st.i < to.i){
                carNode.setupDraw(arrowDirection: .right, animationaStyle: .fade, changeColor: changColor)
                
                if carData.position == .onTheWay, cellTile.mode != .vertical{
                    let x = cellTile.position.x - (cellTile.size.width / 2.0)
                    carPosition = CGPoint(x: x, y: cellTile.position.y)
                }
                
            }else{
                carNode.setupDraw(arrowDirection: .left, animationaStyle: .fade, changeColor: changColor)
                
                if carData.position == .onTheWay, cellTile.mode != .vertical{
                    let x = cellTile.position.x + (cellTile.size.width / 2.0)
                    carPosition = CGPoint(x: x, y: cellTile.position.y)
                }
                
            }
            
            
            if((cellTile.mode != .vertical) && (cellTile.mode != .line)){
                carPosition = cellTile.position
             
            }
            
            
            
            
            carNode.position = carPosition
        }else{
            carNode.setupDraw(arrowDirection: .non, animationaStyle: .fade, changeColor: changColor)
            carNode.position = cellTile.position
        }
        
        
    }
    
    
    func getTileCellWith(cellData:TileCellDataModel)->TileCell?{
        guard cellData.i < self.arCell.count else { return nil }
        let arX = self.arCell[cellData.i]
        
        guard cellData.j < arX.count else { return nil }
        
        return arX[cellData.j]
    }
    
    func getTileCellWith(i:NSInteger, j:NSInteger)->TileCell?{
        guard i < self.arCell.count else { return nil }
        let arX = self.arCell[i]
        
        guard j < arX.count else { return nil }
        
        return arX[j]
    }
}
