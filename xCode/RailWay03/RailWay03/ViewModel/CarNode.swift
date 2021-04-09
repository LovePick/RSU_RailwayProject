//
//  CarNode.swift
//  RailWay03
//
//  Created by T2P mac mini on 3/10/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit


class CarNode: SKSpriteNode {
    
    enum Direction{
        case non
        case right
        case left
    }
    
    enum AnimationStyle{
        case non
        case move
        case fade
    }
    
    
    var carColor:NSColor = .app_space_blue
    var carLineColor:NSColor = .app_space_blue2
    var labelColor:NSColor = .app_space_blue4
    
    
    
    
    var direction:Direction = .non
    
    var lastActiveStatus:NSInteger = -1
    
    
    var arrowSet:[SKShapeNode] = [SKShapeNode]()
    
    var animation:AnimationStyle = .non
    
    
    var lbName:SKLabelNode! = nil
    
    var id:String = ""
    
    
    private var frameNode:SKShapeNode! = nil
    // MARK: - init
    init(){
        
        let carSize:CGSize = CGSize(width: 60, height: 10)
        
        super.init(texture: nil, color: NSColor.black, size: carSize)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.color = .black
        
        
        self.drawFrame()
        
        self.addLabelName()
        
    }
    
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupDraw(arrowDirection:Direction, animationaStyle:AnimationStyle, changeColor:Bool){
        
        if((arrowDirection != self.direction) || (animationaStyle != self.animation) || (changeColor == true)){
            if(self.arrowSet.count > 0){
                for arrow in self.arrowSet.reversed(){
                    arrow.removeAllActions()
                    arrow.removeFromParent()
                }
            }
            
            self.arrowSet.removeAll()
            
            let arrowWidth = self.size.width / 5
            switch arrowDirection {
            case .non:
                break
            case .right:
                
                for i in 0...3{
                    let arrow = self.createArrowNode(right: true)
                    
                    arrow.position = CGPoint(x: arrowWidth * CGFloat(i), y: 0)
                    
                    let z:CGFloat = 110 - CGFloat(i)
                    arrow.zPosition = z
                    self.arrowSet.append(arrow)
                    self.addChild(arrow)
                }
                
                break
            case .left:
                
                for i in 0...3{
                    let arrow = self.createArrowNode(right: false)
                    let x = (arrowWidth * CGFloat(i)) * -1
                    arrow.position = CGPoint(x: x, y: 0)
                    
                    let z:CGFloat = 110 - CGFloat(i)
                    arrow.zPosition = z
                    
                    self.arrowSet.append(arrow)
                    self.addChild(arrow)
                }
                break
            }
            
            
            
            self.direction = arrowDirection
        }
        
        
        
        
        switch animationaStyle {
        case .non:
            
            break
        case .move:
            
            if(arrowDirection == .right){
                self.animation1(right: true)
            }else if(arrowDirection == .left){
                self.animation1(right: false)
            }
            
            break
        case .fade:
            if(arrowDirection == .right){
                self.animation2(right: true)
            }else if(arrowDirection == .left){
                self.animation2(right: false)
            }
            break
        }
        
        
        self.animation = animationaStyle
    }
    
    
    
    func drawFrame(){
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox+1, y: oy+1))
        path.addLine(to: CGPoint(x: ox+1, y: ey-1))
        path.addLine(to: CGPoint(x: ex-1, y: ey-1))
        path.addLine(to: CGPoint(x: ex-1, y: oy+1))
        path.addLine(to: CGPoint(x: ox+1, y: oy+1))
        
        
        self.frameNode = SKShapeNode()
        self.frameNode.path = path
        self.frameNode.strokeColor = .white
        self.frameNode.lineWidth = 1
        self.frameNode.isAntialiased = true
        self.frameNode.zPosition = 101
        self.addChild(self.frameNode)
    }
    
    
    
    func createArrowNode(right:Bool)->SKShapeNode{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let arrowW = w / 5
        
        let path = CGMutablePath()
        
        if(right){
            path.move(to: CGPoint(x: ox, y: oy))
            path.addLine(to: CGPoint(x: ox + arrowW, y: 0))
            path.addLine(to: CGPoint(x: ox, y: ey))
            path.addLine(to: CGPoint(x: ox + arrowW, y: ey))
            path.addLine(to: CGPoint(x: ox + (arrowW * 2), y: 0))
            path.addLine(to: CGPoint(x: ox + arrowW, y: oy))
            path.addLine(to: CGPoint(x: ox, y: oy))
        }else{
            path.move(to: CGPoint(x: ex, y: oy))
            path.addLine(to: CGPoint(x: ex - arrowW, y: 0))
            path.addLine(to: CGPoint(x: ex, y: ey))
            path.addLine(to: CGPoint(x: ex - arrowW, y: ey))
            path.addLine(to: CGPoint(x: ex - (arrowW * 2), y: 0))
            path.addLine(to: CGPoint(x: ex - arrowW, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy))
        }
        
        let arrowNode = SKShapeNode()
        arrowNode.path = path
        arrowNode.strokeColor = self.carLineColor
        arrowNode.fillColor = self.carColor
        arrowNode.lineWidth = 1
        arrowNode.isAntialiased = true
        arrowNode.zPosition = 102
        
        return arrowNode
    }
    
    
    
    
    
    
    func animation1(right:Bool){
        
        let delay:CGFloat = 0.5
        let arrowWidth = self.size.width / 5
        let arrowMove = arrowWidth / 3
        
        
        if(right){
            for i in 0...3{
                let x = arrowWidth * CGFloat(i)
                
                let waitTime:TimeInterval = TimeInterval(CGFloat(i) * delay)
                let waitTimeReset:TimeInterval = TimeInterval(CGFloat(3 - i) * delay)
                
                let acWait:SKAction = SKAction.wait(forDuration: waitTime)
                
                
                let ac1:SKAction = SKAction.moveTo(x: x + arrowMove, duration: TimeInterval(delay))
                
                let ac2:SKAction = SKAction.moveTo(x: x, duration: TimeInterval(delay*1.5))
                
                let acWaitReset:SKAction = SKAction.wait(forDuration: waitTimeReset)
                
                let seq:SKAction = SKAction.sequence([acWait, ac1, ac2, acWaitReset])
                
                let replace:SKAction = SKAction.repeatForever(seq)
                self.arrowSet[i].run(replace)
            }
        }else{
            for i in 0...3{
                let x = (arrowWidth * CGFloat(i)) * -1
                
                let waitTime:TimeInterval = TimeInterval(CGFloat(i) * delay)
                let waitTimeReset:TimeInterval = TimeInterval(CGFloat(3 - i) * delay)
                
                let acWait:SKAction = SKAction.wait(forDuration: waitTime)
                
                
                let ac1:SKAction = SKAction.moveTo(x: x - arrowMove, duration: TimeInterval(delay))
                
                let ac2:SKAction = SKAction.moveTo(x: x, duration: TimeInterval(delay*1.5))
                
                let acWaitReset:SKAction = SKAction.wait(forDuration: waitTimeReset)
                
                let seq:SKAction = SKAction.sequence([acWait, ac1, ac2, acWaitReset])
                
                let replace:SKAction = SKAction.repeatForever(seq)
                self.arrowSet[i].run(replace)
            }
        }
        
    }
    
    
    func animation2(right:Bool){
        
        let delay:CGFloat = 0.5
        //let arrowWidth = self.size.width / 5
        //let arrowMove = arrowWidth / 3
        
        
        if(right){
            for i in 0...3{
                self.arrowSet[i].alpha = 0.2
                
                let waitTime:TimeInterval = TimeInterval(CGFloat(i) * delay)
                let waitTimeReset:TimeInterval = TimeInterval(CGFloat(3 - i) * delay)
                
                let acWait:SKAction = SKAction.wait(forDuration: waitTime)
                
                
                let ac1:SKAction = SKAction.fadeAlpha(to: 1.0, duration: TimeInterval(delay))
                
                let ac2:SKAction = SKAction.fadeAlpha(to: 0.20, duration: TimeInterval(delay))
                
                let acWaitReset:SKAction = SKAction.wait(forDuration: waitTimeReset)
                
                let seq:SKAction = SKAction.sequence([acWait, ac1, ac2, acWaitReset])
                
                let replace:SKAction = SKAction.repeatForever(seq)
                self.arrowSet[i].run(replace)
            }
        }else{
            for i in 0...3{
                self.arrowSet[i].alpha = 0.2
                
                let waitTime:TimeInterval = TimeInterval(CGFloat(i) * delay)
                let waitTimeReset:TimeInterval = TimeInterval(CGFloat(3 - i) * delay)
                
                let acWait:SKAction = SKAction.wait(forDuration: waitTime)
                
                
                let ac1:SKAction = SKAction.fadeAlpha(to: 1.0, duration: TimeInterval(delay))
                
                let ac2:SKAction = SKAction.fadeAlpha(to: 0.20, duration: TimeInterval(delay))
                
                let acWaitReset:SKAction = SKAction.wait(forDuration: waitTimeReset)
                
                let seq:SKAction = SKAction.sequence([acWait, ac1, ac2, acWaitReset])
                
                let replace:SKAction = SKAction.repeatForever(seq)
                self.arrowSet[i].run(replace)
            }
        }
        
    }
    
    
    
    func addLabelName(){
        
        if(self.lbName == nil){
            self.lbName = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 11).fontName)
            self.addChild(self.lbName)
        }
      
        self.lbName.fontColor = self.labelColor
        self.lbName.fontSize = 11
        self.lbName.text = "Car00"
        self.lbName.numberOfLines = 0
        self.lbName.verticalAlignmentMode = .center
        self.lbName.horizontalAlignmentMode = .center
        self.lbName.position = CGPoint.zero
        self.lbName.zPosition = 200
    }
}
