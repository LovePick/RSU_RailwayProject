//
//  TileCollectionNode.swift
//  RailWay03
//
//  Created by T2P mac mini on 21/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class TileCollectionNode: SKCropNode {

    let cellSize:CGSize = CGSize(width: 64, height: 32)
    
    var mark:SKSpriteNode! = nil
    var contentBG:SKSpriteNode! = nil
    
    
    
    var arTileType:[TileCell]! = [TileCell]()
    
    var copSize:CGSize = CGSize.zero
    private var highlightNode:SKShapeNode! = nil
    init(size:CGSize){
        super.init()
        
        copSize = size
   
        
        self.name = "collection"
        
        mark = SKSpriteNode(color: .black, size: size)
        self.maskNode = mark
       
        let contentW:CGFloat = (cellSize.width + 10) * CGFloat(TileCell.Mode.count)
        let contentSize:CGSize = CGSize(width: contentW, height: size.height)
        contentBG = SKSpriteNode(color: .black, size: contentSize)
        
        let ox:CGFloat = contentW / -2
        for i in 0..<TileCell.Mode.count{
            let newCell:TileCell = TileCell(size: cellSize, mode: .non, i: 0, j:0)
            arTileType.append(newCell)
            newCell.name = "cell"
            
            newCell.highlightStage(active: true)
            contentBG.addChild(newCell)
            let newX:CGFloat = ox + ((CGFloat(i + 1) * (cellSize.width + 10)) - ((cellSize.width + 10) / 2))
            newCell.position = CGPoint(x: newX, y: 0)
            
           
        }
        
        arTileType[0].drawMode(mode: .non)
        arTileType[1].drawMode(mode: .line)
        arTileType[2].drawMode(mode: .endLeft)
        arTileType[3].drawMode(mode: .endRight)
        arTileType[4].drawMode(mode: .diversionLeftNorth)
        arTileType[5].drawMode(mode: .diversionRightSouth)
        arTileType[6].drawMode(mode: .diversionLeftSouth)
        arTileType[7].drawMode(mode: .diversionRightNorth)
        arTileType[8].drawMode(mode: .junctionLeftNorth_N)
        arTileType[9].drawMode(mode: .junctionRightSouth_S)
        arTileType[10].drawMode(mode: .junctionLeftSouth_S)
        arTileType[11].drawMode(mode: .junctionRightNorth_N)
        arTileType[12].drawMode(mode: .vertical)
        arTileType[13].drawMode(mode: .bridgeNorth)
        arTileType[14].drawMode(mode: .bridgeSouth)
        arTileType[15].drawMode(mode: .slopeLeft1)
        arTileType[16].drawMode(mode: .slopeLett2)
        arTileType[17].drawMode(mode: .slopeRight1)
        arTileType[18].drawMode(mode: .slopeRight2)
        arTileType[19].drawMode(mode: .junctSemiLeftSouth_S)
        arTileType[20].drawMode(mode: .junctSemiLeftNorth_N)
        arTileType[21].drawMode(mode: .junctSemiRightSouth_S)
        arTileType[22].drawMode(mode: .junctSemiRightNorth_N)
        
        self.addChild(contentBG)
        
        let dw:CGFloat = contentSize.width - size.width
        contentBG.position = CGPoint(x: (dw/2), y: 0)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func cellAtPosition(location:CGPoint)->TileCell?{
        
        let hitNodes = nodes(at: location).filter{$0.name == "cell"}
        guard let hitNode = hitNodes.first else { return nil }
        guard let ansNode = hitNode as? TileCell else { return nil }
        
        return ansNode
        
    }
    
    
    func scrollCollection(touchEvent:TouchEventModel){
        
        let dx:CGFloat = touchEvent.now.x - touchEvent.start.x
        
        
        var newX = touchEvent.objectStartPoint.x + dx
        
        let dw:CGFloat = contentBG.size.width - copSize.width
        let limitPos:CGFloat = dw / 2
        let limitNeg:CGFloat = dw / -2
        
        if(newX > limitPos){
            newX = limitPos
        }else if(newX < limitNeg){
            newX = limitNeg
        }
        
        self.contentBG.position = CGPoint(x: newX, y: 0)
    }
    
}
