//
//  GameScene.swift
//  RailWay03
//
//  Created by T2P mac mini on 19/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    

    var zoomNode:SKSpriteNode! = nil
    var mapNode:SKSpriteNode! = nil
    
    var tileCollection:TileCollectionNode! = nil
    
    
    
    var mapPosition:CGPoint = CGPoint.zero
    var startPoint:CGPoint = CGPoint.zero
    var nowPoint:CGPoint = CGPoint.zero
    
    var mapScale:CGFloat = 1
    
    
    let model:GameModel = GameModel()
    
    
    var touchEvent:TouchEventModel = TouchEventModel()
    
    
    
    var trakingCarID:String = ""
    
    
 
    
    
    override func didMove(to view: SKView) {
        
        ShareData.shared.gamseSceme = self
        
        
        
        let w:CGFloat = model.cellSize.width * CGFloat(model.mapWidth)
        let h:CGFloat = model.cellSize.height * CGFloat(model.mapHeight)
        
        zoomNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: w, height: h))
        zoomNode.color = .clear
        zoomNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(zoomNode)
        zoomNode.position = CGPoint.zero
        
        
        mapNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: w, height: h))
        
        
        mapNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zoomNode.addChild(mapNode)
        mapNode.position = CGPoint.zero
        
        
        self.updateMapSize(width: 10, height: 10)
        
        
        /*
        //test car
        let ox:CGFloat = 32
        let oy:CGFloat = 16
   
        
        do{
            let car1:CarNode = CarNode()
            car1.zPosition = 100
            car1.position = CGPoint(x: ox + (64 * 2), y: oy)
            mapNode.addChild(car1)
            car1.setupDraw(arrowDirection: .right, animationaStyle: .fade)
        }
        
        do{
            let car1:CarTrainLabelNode = CarTrainLabelNode()
            car1.zPosition = 100
            car1.position = CGPoint(x: ox + (64 * 2), y: oy - (32 * 2))
            mapNode.addChild(car1)
        }
        
        
        do{
            let car1:CarTrainLabelNode = CarTrainLabelNode()
            car1.zPosition = 100
            car1.position = CGPoint(x: ox + (64 * -2), y: oy - (32 * 4))
            car1.setText(text: "Car003", alignment: .left)
            mapNode.addChild(car1)
        }
        */
        
        
        print(self.size)
    }
    
    
    func addTileColleltion() {

        if(self.tileCollection == nil){
            tileCollection = TileCollectionNode(size: CGSize(width: self.frame.size.width, height: 40))
            self.addChild(tileCollection)
            let cx:CGFloat = self.frame.size.width / -2
            let cy:CGFloat = self.frame.size.height / -2
            
            tileCollection.position = CGPoint(x: cx + (self.frame.size.width / 2), y: cy + 20)
            tileCollection.zPosition = 500
        }
    }
    
    
    func removeTileCollection(){
        if(self.tileCollection != nil){
            tileCollection.removeAllActions()
            tileCollection.removeAllChildren()
            tileCollection.removeFromParent()
            
            tileCollection = nil
        }
        
    }
    
    
    func updateMapSize(width:NSInteger, height:NSInteger){
        model.mapWidth = width
        model.mapHeight = height
        
        let w:CGFloat = model.cellSize.width * CGFloat(width)
        let h:CGFloat = model.cellSize.height * CGFloat(height)
        
        zoomNode.size = CGSize(width: w, height: h)
        mapNode.size = CGSize(width: w, height: h)
        model.changeMapSize(width: width, height: height, toMapNode: mapNode)
        
        zoomNode.position = CGPoint.zero
        mapNode.position = CGPoint.zero
    }
    
    
    func removeNotUseNode(remove:Bool){
        model.removeNotUseCell(remove: remove, fromNode: mapNode)
    }
    
    
    func updateCarsData(carsData:[CarDataModel]){
        model.updateCarData(carsData: carsData, mapNode: mapNode)
    }
    
    func updateJunctionLightWith(i:NSInteger, j:NSInteger, light:NSInteger){
        model.updateJunctionLightWith(i: i, j: j, light: light)
    }
    
    
    /*
    func readMapData(map:SaveMapDataModel){
        model.mapWidth = map.mapW
        model.mapHeight = map.mapH
        
        let w:CGFloat = model.cellSize.width * CGFloat(map.mapW)
        let h:CGFloat = model.cellSize.height * CGFloat(map.mapH)
        
        zoomNode.size = CGSize(width: w, height: h)
        mapNode.size = CGSize(width: w, height: h)
        model.changeMapSize(width: map.mapW, height: map.mapH, toMapNode: mapNode)
        
        zoomNode.position = CGPoint.zero
        mapNode.position = CGPoint.zero
        
        
    }*/
    
    // MARK: - Touch / Mouse Event
    func touchDown(atPoint pos : CGPoint) {
    
        if(self.trakingCarID != ""){
            return
        }
        self.touchEvent.active = true
        self.touchEvent.start = pos
        self.touchEvent.now = pos
        
        
        if(model.mapMode == .editMap){
            
            
            
            if(self.touchEvent.action == .non){
                if let cell = self.model.getCellAt(point: pos, mapNode: self.mapNode){
                    self.selectCell(cells: [cell], touchEvent: self.touchEvent)
                }else{
                    self.selectCell(cells: [], touchEvent: self.touchEvent)
                }
                
                
                
            }else if(self.touchEvent.action == .moveMap){
                self.touchEvent.objectStartPoint = self.zoomNode.position
                self.moveMap()
                
                
            }else if(self.touchEvent.action == .zoom){
                self.touchEvent.objectStartPoint = self.zoomNode.position
                self.zoomMap()
                
                
            }else if(self.touchEvent.action == .selectTileType){
                
                if(self.tileCollection == nil){ return }
                self.touchEvent.objectStartPoint = self.tileCollection.contentBG.position
                if let tile = self.tileCollection.cellAtPosition(location: pos){
                    self.model.changeSelectCellTo(type: tile)
                }
            }
        }
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.touchEvent.now = pos
        
        if(self.trakingCarID != ""){
            return
        }
        
        
        if(model.mapMode == .editMap){
            if(self.touchEvent.action == .non){
                let cells = self.model.getCellsInRect(start: self.touchEvent.start, now: pos, gameScene: self, map: self.mapNode)
                self.selectCell(cells: cells, touchEvent: self.touchEvent)
                
            }else if(self.touchEvent.action == .moveMap){
                self.moveMap()
            }else if(self.touchEvent.action == .zoom){
                self.zoomMap()
            }else if(self.touchEvent.action == .selectTileType){
                
                if(self.tileCollection == nil){ return }
                self.tileCollection.scrollCollection(touchEvent: self.touchEvent)
                
                
            }
        }
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.touchEvent.active = false
        self.touchEvent.now = pos
        self.touchEvent.end = pos
        
        

    }
    
  
    
    override func mouseDown(with event: NSEvent) {
        
        if(model.mapMode == .editMap){
            
            
            if(self.touchEvent.action == .non){
                
                
                if(self.hisTestCollection(pos: event.location(in: self))){
                    print("hisTestCollection")
                    self.touchEvent.action = .selectTileType
                    self.touchDown(atPoint: event.location(in: tileCollection))
                    
                
                    
                }else{
                    self.touchDown(atPoint: event.location(in: self.mapNode))
                }
                
                
            }else if(self.touchEvent.action == .moveMap){
                self.touchDown(atPoint: event.location(in: self))
            }else if(self.touchEvent.action == .zoom){
                if (event.clickCount >= 2) {
                    self.resetZoomLV()
                }else{
                   self.touchDown(atPoint: event.location(in: self))
                }
                
            }
        }
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        if(model.mapMode == .editMap){
            
            if(self.touchEvent.action == .non){
                self.touchMoved(toPoint: event.location(in: self.mapNode))
            }else if((self.touchEvent.action == .moveMap) || (self.touchEvent.action == .zoom)){
                self.touchMoved(toPoint: event.location(in: self))
            }else if(self.touchEvent.action == .selectTileType){
                self.touchMoved(toPoint: event.location(in: self))
            }
        }
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
        
        if(model.mapMode == .editMap){
            if(self.touchEvent.action == .non){
                self.touchUp(atPoint: event.location(in: self.mapNode))
            }else if((self.touchEvent.action == .moveMap) || (self.touchEvent.action == .zoom)){
                self.touchUp(atPoint: event.location(in: self))
            }else if(self.touchEvent.action == .selectTileType){
                self.touchEvent.action = .non
            }
        }
        
    }
    
    
    
    // MARK: - Key event
    override func keyDown(with event: NSEvent) {
   
        if event.charactersIgnoringModifiers == " "{
            
            
        }
    
        
    }
    

    // MARK: - Touch / Mouse Function
    
    func hisTestCollection(pos:CGPoint)->Bool{
        
        if(self.tileCollection == nil){
            return false
        }
        
        if(pos.y < (self.tileCollection.position.y + 20)){
            return true
        }else{
            return false
        }
    }
    
    
    

    // MARK: - render
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    
    // MARK: - Function
    func selectCell(cells:[TileCell], touchEvent:TouchEventModel){
        self.model.selectCell(cells: cells, touchEvent: touchEvent)
    }
    
    
    
    func moveMap(){
        
        let deltaX:CGFloat = self.touchEvent.now.x - self.touchEvent.start.x
        let deltaY:CGFloat = self.touchEvent.now.y - self.touchEvent.start.y
        
        let newX:CGFloat = self.touchEvent.objectStartPoint.x + deltaX
        let newY:CGFloat = self.touchEvent.objectStartPoint.y + deltaY
        
        self.zoomNode.position = CGPoint(x: newX, y: newY)
        
    }
    
    
    
    func trackCar(carID:String){
        self.trakingCarID = carID
        
        
        if(carID != ""){
            
            for carNode in self.model.arCarsNode{
                if(carNode.id == carID){
                    
                  
                    //let mapW = self.size.width
                    
                    
                    var newX:CGFloat = (self.size.width - carNode.position.x) - self.size.width
                    var newY:CGFloat = (self.size.height - carNode.position.y) - (self.size.height)
                    
                    let mapW:CGFloat = CGFloat(self.model.mapWidth) * self.model.cellSize.width
                    let mapH:CGFloat = CGFloat(self.model.mapHeight) * self.model.cellSize.height
                    
                    let maxX:CGFloat = mapW + (self.zoomNode.size.width / 2)
                    let minX:CGFloat = maxX * -1
                    
                    let maxY:CGFloat = abs(mapH - self.size.height) / 2
                    let minY:CGFloat = 0
                    
//                    print("new: \(newX), \(newY)")
//                    print("LimitY: \(minY), \(maxY)")
                    if(newX < minX){
                        newX = minX
                    }
                    if(newX > maxX){
                        newX = maxX
                    }
                    
                    if(newY < minY){
                        newY = minY
                    }
                    if(newY > maxY){
                        newY = maxY
                    }
                    
                  
                    
                    let actionMove = SKAction.move(to: CGPoint(x: newX, y: newY), duration: 0.8)
                    self.zoomNode.run(actionMove)
                    
                    
                    
                }
            }
            
        }
    }
    
    func zoomMap(){
        let deltaY:CGFloat = self.touchEvent.now.y - self.touchEvent.start.y
        
        var scale:CGFloat = (deltaY / 1200)
        
        if(scale < -0.01){
            scale = -0.01
        }else if(scale > 0.01){
            scale = 0.01
        }
        
        
        self.model.zoomScale += scale
        
        if(self.model.zoomScale < 0.25){
            self.model.zoomScale = 0.25
        }else if(self.model.zoomScale > 2){
            self.model.zoomScale = 2
        }
        
        self.mapNode.setScale(self.model.zoomScale)
        
    }
    
    func zoomInMap(){
        self.model.zoomScale += 0.05
        
        if(self.model.zoomScale < 0.25){
            self.model.zoomScale = 0.25
        }else if(self.model.zoomScale > 2){
            self.model.zoomScale = 2
        }
        
        self.mapNode.setScale(self.model.zoomScale)
    }
    
    
    func zoomOutMap(){
        self.model.zoomScale -= 0.05
        
        if(self.model.zoomScale < 0.25){
            self.model.zoomScale = 0.25
        }else if(self.model.zoomScale > 2){
            self.model.zoomScale = 2
        }
        
        self.mapNode.setScale(self.model.zoomScale)
    }
    
    func resetZoomLV(){
        self.model.zoomScale = 1
        self.mapNode.setScale(self.model.zoomScale)
    }
    
    
    func zoomToFitSize(){
//        let w = self.size.width
//        let zoomw:CGFloat = model.cellSize.width * CGFloat(model.mapWidth)
        
        
        let scale:CGFloat = 0.45
        print("scale : \(scale)")
        
        self.model.zoomScale = scale
        self.mapNode.setScale(self.model.zoomScale)
    }
    
    
    
    
}
