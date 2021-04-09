//
//  CarTrainLabelNode.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/12/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class CarTrainLabelNode: SKSpriteNode {

    enum LabelAlignmentMode{
        case left
        case right
    }
    
    var wave:SKShapeNode! = nil
    var lbName:SKLabelNode! = nil
    
    
    
    // MARK: - init
    init(){
        
        let carSize:CGSize = CGSize(width: 60, height: 10)
        
        super.init(texture: nil, color: NSColor.black, size: carSize)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.color = .clear
        
        let shape = SKShapeNode(circleOfRadius: 5)
        shape.fillColor = .app_space_blue
        shape.strokeColor = .white
        
        self.addChild(shape)
        
        
        
        wave = SKShapeNode(circleOfRadius: 5)
        wave.fillColor = .app_space_blue
        wave.strokeColor = .clear
        self.addChild(wave)
        
        //
        let acScale:SKAction = SKAction.scale(to: 3.0, duration: 2)
        let acAlpha:SKAction = SKAction.fadeOut(withDuration: 2)
        let group1:SKAction = SKAction.group([acScale, acAlpha])
        
        
        let acResetScale:SKAction = SKAction.scale(to: 1.0, duration: 0)
        let acResetColor:SKAction = SKAction.fadeIn(withDuration: 0)
        let group2:SKAction = SKAction.group([acResetScale, acResetColor])
        
        
        
        let seq:SKAction = SKAction.sequence([group1, group2])
        let replace:SKAction = SKAction.repeatForever(seq)
        
        wave.run(replace)
        //
       
        
        
        lbName = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
        lbName.fontColor = .app_orange
        
        lbName.fontSize = 14
        lbName.text = "Car002"
        lbName.numberOfLines = 1
        lbName.preferredMaxLayoutWidth = 60
        lbName.horizontalAlignmentMode = .left
        //lbName.verticalAlignmentMode = .center
        lbName.position = CGPoint(x: 6, y: 0)
       
        self.addChild(lbName)
    }
    
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setText(text:String, alignment:LabelAlignmentMode){
        
        self.lbName.text = text
        
        switch alignment {
        case .left:
            self.lbName.position = CGPoint(x: -6, y: 0)
            lbName.horizontalAlignmentMode = .right
            break
        case .right:
            self.lbName.position = CGPoint(x: 6, y: 0)
            lbName.horizontalAlignmentMode = .left
            break
        }
    }
    
}
