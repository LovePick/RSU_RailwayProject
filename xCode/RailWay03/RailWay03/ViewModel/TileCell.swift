//
//  TileCell.swift
//  Glowing
//
//  Created by T2P mac mini on 23/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit



class TileCell: SKSpriteNode {
    
    enum Mode:NSInteger {
        case line = 0
        case endLeft
        case endRight
        case diversionLeftNorth
        case diversionRightSouth
        case diversionLeftSouth
        case diversionRightNorth
        case junctionLeftNorth_N
        case junctionRightSouth_S
        case junctionLeftSouth_S
        case junctionRightNorth_N
        case vertical
        case bridgeNorth
        case bridgeSouth
        case slopeLeft1
        case slopeLett2
        case slopeRight1
        case slopeRight2
        case junctSemiLeftNorth_N
        case junctSemiRightSouth_S
        case junctSemiLeftSouth_S
        case junctSemiRightNorth_N
        case non
        
        static let count:NSInteger = 23
    }
    
    
    enum StationType:NSInteger{
        case non = 0
        case station
        case depot
        case waitPoint
        case junctionUp
        case junctionDown
    }
    
    
    
    var mode:Mode = .non
    
    var stationMode:StationType = .non
    
    
    
    var id:String = ""
    var stationName:String = ""

    
    var i:NSInteger = 0
    var j:NSInteger = 0
    
    
    
    var lineLeft:Bool = false
    var lineRight:Bool = false
    var lineTop:Bool = false
    var lineBottom:Bool = false
    
    var junctionLight:NSInteger = 0
    private(set) var normalJunctionLight:NSInteger = 0
    
    
    private(set) public var highlight:Bool = false
    
    private(set) public var selected:Bool = false
    
    private(set) public var showMovingDot:Bool = false
    
    
    
    
    private let lineWidth:CGFloat = 2
    private let inputRadius:CGFloat = 3
    private var lineColor: NSColor = .white
    
    private let highlightLineWidth:CGFloat = 1
    private let highlightColor:NSColor = .darkGray
    
    private let pathEditSelectColor:NSColor = .app_space_blue
    
    
    //private var highlightNode:SKShapeNode! = nil
    
 
    
    var stationNode:SKSpriteNode! = nil
    
    
    
    private let stationLineBlueColor:NSColor = NSColor(red: (25.0/255.0), green: (116.0/255.0), blue: (210.0/255.0), alpha: 0.5)
        
    private let stationLinePinkColor:NSColor = NSColor(red: (247.0/255.0), green: (178.0/255.0), blue: (169.0/255.0), alpha: 4.0)
        //NSColor.app_orange.withAlphaComponent(0.5) //NSColor.app_space_blue.withAlphaComponent(0.5)
    
    private let junctionLineColor:NSColor = NSColor.app_space_blue
    
    private let bridgeLineColor:NSColor = NSColor(red: (255/255), green: (255/255), blue: (255/255), alpha: 0.5)
    
    
    private let frameLineColor:NSColor = NSColor(red: (255/255), green: (255/255), blue: (255/255), alpha: 0.5)
    
    
    var movingPath:CGMutablePath! = nil
    var movingPoint:[CGPoint] = [CGPoint]()
    
    
    
    private var movingItem:SKShapeNode! = nil
    
    var toRight:Bool = true
    
    
    // MARK: - init
    init(size:CGSize, fields:[String: Any]){
        
        super.init(texture: nil, color: NSColor.black, size: size)
        self.readJson(fields: fields)
        
        self.name = "cell"
        
        self.drawMode(mode: self.mode)
    }
    
    
    
    
    init(size:CGSize, mode:Mode, i:NSInteger, j:NSInteger){
        super.init(texture: nil, color: NSColor.black, size: size)
        self.i = i
        self.j = j
        self.drawMode(mode: mode)
        
        
        
        self.name = "cell"
    }
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Read write data
    func getDictData()->[String:Any]{
        
        var newDic:[String:Any] = [String:Any]()
        
        newDic["mode"] = self.mode.rawValue
        newDic["stationMode"] = self.stationMode.rawValue
        newDic["id"] = self.id
        newDic["stationName"] = self.stationName
        newDic["i"] = self.i
        newDic["j"] = self.j
        
        newDic["lineLeft"] = self.lineLeft
        newDic["lineRight"] = self.lineRight
        newDic["lineTop"] = self.lineTop
        newDic["lineBottom"] = self.lineBottom
        newDic["toRight"] = self.toRight
        newDic["junctionLight"] = self.junctionLight
        
        return newDic
        
    }
    
    func getTileDataMode() -> TileCellDataModel {
        let newModel:TileCellDataModel = TileCellDataModel()
        newModel.mode = self.mode.rawValue
        newModel.stationMode = self.stationMode.rawValue
        newModel.id = self.id
        newModel.stationName = self.stationName
        newModel.i = self.i
        newModel.j = self.j
        
        newModel.lineLeft = self.lineLeft
        newModel.lineRight = self.lineRight
        newModel.lineTop = self.lineTop
        newModel.lineBottom = self.lineBottom
        
        newModel.toRight = self.toRight
        newModel.junctionLight = self.junctionLight
        
        return newModel
    }
    
    func readJson(fields:[String: Any])  {
        
        if let mode = fields["mode"] as? NSInteger{
            if let m = Mode(rawValue: mode){
                self.mode = m
            }
        }
        
        if let stationMode = fields["stationMode"] as? NSInteger{
            if let m = StationType(rawValue: stationMode){
                self.stationMode = m
            }
        }
        
        if let str = fields["id"] as? String{
            self.id = str
        }
        
        if let str = fields["stationName"] as? String{
            self.stationName = str
        }
        
        if let i = fields["i"] as? NSInteger{
            self.i = i
        }
        
        if let j = fields["j"] as? NSInteger{
            self.j = j
        }
        
        
        if let lineLeft = fields["lineLeft"] as? Bool{
            self.lineLeft = lineLeft
        }
        
        if let lineRight = fields["lineRight"] as? Bool{
            self.lineRight = lineRight
        }
        
        if let lineTop = fields["lineTop"] as? Bool{
            self.lineTop = lineTop
        }
        
        if let lineBottom = fields["lineBottom"] as? Bool{
            self.lineBottom = lineBottom
        }
        
        if let toRight = fields["toRight"] as? Bool{
            self.toRight = toRight
        }
        
        if let junctionLight = fields["junctionLight"] as? NSInteger{
            self.junctionLight = junctionLight
        }
        
        self.normalJunctionLight = self.junctionLight
    }
    
    func readData(cellData:TileCellDataModel){
        

        if let m = Mode(rawValue: cellData.mode){
            self.mode = m
        }
        
        if let m = StationType(rawValue: cellData.stationMode){
            self.stationMode = m
        }

        self.id = cellData.id
        self.stationName = cellData.stationName
        self.i = cellData.i
        self.j = cellData.j
        
        
        self.lineLeft = cellData.lineLeft
        self.lineRight = cellData.lineRight
        self.lineTop = cellData.lineTop
        self.lineBottom = cellData.lineBottom
    
        self.toRight = cellData.toRight
        self.junctionLight = cellData.junctionLight
        self.normalJunctionLight = cellData.junctionLight
      
        
        self.drawMode(mode: self.mode)
    }
    
    func getKey()->String{
        let str:String = "x\(self.i)y\(self.j)"
        return str
    }
    
    // MARK: - Draw
    /*
    func addHighlightNode(){
        if(self.highlightNode == nil){
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
            
            self.highlightNode = SKShapeNode()
            self.highlightNode.path = path
            self.highlightNode.strokeColor = self.highlightColor
            self.highlightNode.lineWidth = self.highlightLineWidth
            self.highlightNode.isAntialiased = true
            self.highlightNode.zPosition = 10
            self.addChild(self.highlightNode)
        }
    }
    
 */
    
    
    
    func drawMode(mode:Mode){
        
     
        self.mode = mode
        self.removeAllChildren()
        //self.highlightNode = nil
        self.movingPoint.removeAll()
    
        
        if(self.stationNode != nil){
            self.stationNode.removeAllChildren()
            
        }
        self.stationNode = nil
        
        
        
        switch mode {
        case .line:
            self.setUpLine()
            break
        case .endLeft:
            self.setUpEndLeft()
            break
        case .endRight:
            self.setUpEndRight()
            break
        case .diversionLeftNorth:
            self.setUpDiversionLeftNorth()
            break
        case .diversionRightSouth:
            self.setUpDiversionRightSouth()
            break
        case .diversionLeftSouth:
            self.setUpDiversionLeftSouth()
            break
        case .diversionRightNorth:
            self.setUpDiversionRightNorth()
            break
        case .junctionLeftNorth_N:
            self.setUpJunctionLeftNorth_N()
            break
        case .junctionRightSouth_S:
            self.setUpJunctionRightSouth_S()
            break
        case .junctionLeftSouth_S:
            self.setUpJunctionLeftSouth_S()
            break
        case .junctionRightNorth_N:
            self.setUpJunctionRightNorth_N()
            break
        case .vertical:
            self.setUpVertical()
            break
        case .bridgeNorth:
            self.setUpBridgeNorth()
            break
        case .bridgeSouth:
            self.setUpBridgeSouth()
            break
        case .slopeLeft1:
            self.setUpSlopeLeft1()
            break
        case .slopeLett2:
            self.setUpSlopeLeft2()
            break
        case .slopeRight1:
            self.setUpSlopeRight1()
            break
        case .slopeRight2:
            self.setUpSlopeRight2()
            break
        case .junctSemiLeftNorth_N:
            self.setUpJunctSemiLeftNorth_N()
            break
        case .junctSemiLeftSouth_S:
            self.setUpJunctSemiLeftSouth_S()
            break
        case .junctSemiRightNorth_N:
            self.setUpJunctSemiRightNorth_N()
            break
        case .junctSemiRightSouth_S:
            self.setUpJunctSemiRightSouth_S()
            break
        default:
            break
        }
        
        
        self.updateDrawStationType()
        
        
        if(self.lineTop){
            self.setUpFrameTop()
        }
        
        if(self.lineBottom){
            self.setUpFrameBottom()
        }
        
        if(self.lineLeft){
            self.setUpFrameLeft()
        }
        
        if(self.lineRight){
            self.setUpFrameRight()
        }
        
        
        //self.addHighlightNode()
        self.highlightStage(active: self.highlight)
        
        
        self.drawJunctionLight()
        
        self.showMovingItem(show: self.showMovingDot)
    }
   
    func setJunctionToRed(){
        switch self.junctionLight {
        case 1, 2, 3:
            self.junctionLight = 4
            break
        case 5:
            self.junctionLight = 6
            break
        case 7:
            self.junctionLight = 8
            break
        default:
            break
        }
    }
    func drawJunctionLight() {
        
        let point1 = CGPoint(x: self.size.width * -0.4, y: self.size.height * 0.3)
        let point2 = CGPoint(x: self.size.width * 0.4, y: self.size.height * 0.3)
      
        
        
        if(self.junctionLight == 0){
            //None
        }else if(self.junctionLight == 1){
            // o - o
            self.junctionLight(color: .white, point: point1)
            self.junctionLight(color: .white, point: point2)
            
        }else if(self.junctionLight == 2){
            // * - o
            self.junctionLight(color: .red, point: point1)
            self.junctionLight(color: .white, point: point2)
            
        }else if(self.junctionLight == 3){
            // o - *
            self.junctionLight(color: .white, point: point1)
            self.junctionLight(color: .red, point: point2)
            
        }else if(self.junctionLight == 4){
            // * - *
            self.junctionLight(color: .red, point: point1)
            self.junctionLight(color: .red, point: point2)
            
        }else if(self.junctionLight == 5){
            // n - o
//            self.junctionLight(color: .red, point: point1)
            self.junctionLight(color: .white, point: point2)
            
        }else if(self.junctionLight == 6){
            // n - *
//            self.junctionLight(color: .red, point: point1)
            self.junctionLight(color: .red, point: point2)
            
        }else if(self.junctionLight == 7){
            // o - n
            self.junctionLight(color: .white, point: point1)
//            self.junctionLight(color: .white, point: point2)
            
        }else if(self.junctionLight == 8){
            // * - n
            self.junctionLight(color: .red, point: point1)
//            self.junctionLight(color: .red, point: point2)
            
        }
    }
    
    func junctionLight(color:NSColor, point:CGPoint){
        let shap = SKShapeNode(circleOfRadius: 5)
        shap.strokeColor = color
        shap.lineWidth = 1
        shap.isAntialiased = true
        shap.lineCap = .round
        shap.fillColor = color
        shap.position = point
        self.addChild(shap)
    }
    
    func showMovingItem(show:Bool){
        
        
        if(self.movingItem != nil){
            self.movingItem.removeAllActions()
            self.movingItem.removeAllChildren()
            self.movingItem.removeFromParent()
            self.movingItem = nil
        }
        
        if(show == true){
            
            self.movingItem = SKShapeNode(circleOfRadius: 2)
            self.movingItem.fillColor = self.lineColor
            self.addChild(self.movingItem)
            self.movingItem.zPosition = 99
            
           
            self.movingPath = self.getMovingPath(leftToRight: self.toRight)
            
            let followSquare = SKAction.follow(self.movingPath, asOffset: false, orientToPath: false, duration: 2.0)
            let acForever:SKAction = SKAction.repeatForever(followSquare)
            self.movingItem.run(acForever)
        }
    }
    
    
    func drawGlowingLineWith(path:CGMutablePath){
        //let glow: SKEffectNode = SKEffectNode()
        //let shap = SKShapeNode()
        //shap.path = path
        //shap.strokeColor = self.lineColor
        //shap.lineWidth = self.lineWidth
        //shap.isAntialiased = true
        //shap.lineCap = .round
        
        //glow.addChild(shap)
        //glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": inputRadius])
        //glow.shouldRasterize = true
        
        //self.addChild(glow)
        
        
        let shap2 = SKShapeNode()
        shap2.path = path
        shap2.strokeColor = self.lineColor
        shap2.lineWidth = self.lineWidth
        shap2.isAntialiased = true
        //shap2.lineCap = .round
        
        
        self.addChild(shap2)
    }
    
    
    func drawGlowingWhiteLineWith(path:CGMutablePath){
//        let glow: SKEffectNode = SKEffectNode()
//        let shap = SKShapeNode()
//        shap.path = path
//        shap.strokeColor = .white
//        shap.lineWidth = self.lineWidth
//        shap.isAntialiased = true
//        //shap.lineCap = .round
//
//        glow.addChild(shap)
//        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": inputRadius])
//        glow.shouldRasterize = true
//
//        self.addChild(glow)
        
        
        let shap2 = SKShapeNode()
        shap2.path = path
        shap2.strokeColor = .white
        shap2.lineWidth = self.lineWidth
        shap2.isAntialiased = true
        //shap2.lineCap = .round
        
        
        self.addChild(shap2)
    }
    
    
    
    func drawBridgeWith(path:CGMutablePath){
        
        /*
        let glow: SKEffectNode = SKEffectNode()
        let shap = SKShapeNode()
        shap.path = path
        shap.strokeColor = self.bridgeLineColor
        shap.lineWidth = 1
        shap.isAntialiased = true
        //shap.lineCap = .round
        
        glow.addChild(shap)
        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": inputRadius])
        glow.shouldRasterize = true
        
        self.addChild(glow)
        */
        
        let shap2 = SKShapeNode()
        shap2.path = path
        shap2.strokeColor = self.bridgeLineColor
        shap2.lineWidth = 1
        shap2.isAntialiased = true
        shap2.lineCap = .round
        
        
        self.addChild(shap2)
    }
    
    
    
    func drawFrameLineWith(path:CGMutablePath){
        
        let pattern : [CGFloat] = [4.0, 6.0]
        let dashed = path.copy(dashingWithPhase: 1, lengths: pattern)
        
        
        
        let shap2 = SKShapeNode()
        shap2.path = dashed
        shap2.strokeColor = self.frameLineColor
        shap2.lineWidth = 2
        shap2.isAntialiased = true
        shap2.lineCap = .round
        
        self.addChild(shap2)
    }
    
    // MARK: -
    func pointLine()->[CGPoint]{
        let w = self.size.width
        //let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        return points
    }
    func setUpLine() {
        
        let w = self.size.width
        //let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        
        
        self.movingPath = path
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: 0))
        
       self.drawGlowingLineWith(path: path)
   
      
    }
    
    func drawLine() {
        let w = self.size.width
        //let h = self.size.height
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
       self.drawGlowingLineWith(path: path)
    }

    // MARK: -
    func pointEndLeft()->[CGPoint]{
        
        let w = self.size.width
        //let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ex-4, y: 12))
        points.append(CGPoint(x: ex - 10, y: 12))
        points.append(CGPoint(x: ex - 10, y: -12))
        points.append(CGPoint(x: ex-4, y: -12))
        
        return points
    }
    func setUpEndLeft() {
        
        let w = self.size.width
        //let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ex-4, y: 12))
        path.addLine(to: CGPoint(x: ex - 10, y: 12))
        path.addLine(to: CGPoint(x: ex - 10, y: -12))
        path.addLine(to: CGPoint(x: ex-4, y: -12))
        
        self.movingPath = path
        movingPoint.append(CGPoint(x: ex-4, y: 12))
        movingPoint.append(CGPoint(x: ex - 10, y: 12))
        movingPoint.append(CGPoint(x: ex - 10, y: -12))
        movingPoint.append(CGPoint(x: ex-4, y: -12))
        
        self.drawGlowingLineWith(path: path)
        
    }
    
    
    //
    // MARK: -
    func pointEndRight()->[CGPoint]{
        let w = self.size.width
        let ox = (w / 2.0) * -1
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox+4, y: 12))
        points.append(CGPoint(x: ox + 10, y: 12))
        points.append(CGPoint(x: ox + 10, y: -12))
        points.append(CGPoint(x: ox+4, y: -12))
        
        return points
    }
    
 
    func setUpEndRight() {
        
        let w = self.size.width
        //let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox+4, y: 12))
        path.addLine(to: CGPoint(x: ox + 10, y: 12))
        path.addLine(to: CGPoint(x: ox + 10, y: -12))
        path.addLine(to: CGPoint(x: ox+4, y: -12))
        
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox+4, y: 12))
        self.movingPoint.append(CGPoint(x: ox + 10, y: 12))
        self.movingPoint.append(CGPoint(x: ox + 10, y: -12))
        self.movingPoint.append(CGPoint(x: ox+4, y: -12))
        
        
        
        self.drawGlowingLineWith(path: path)
        
    }
    
    

    // MARK: -
    func pointDiversionLeftNorth()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: (0 - quarterW), y: 0))
        points.append(CGPoint(x: 0, y: ey))
        
        return points
        
    }
    
    func setUpDiversionLeftNorth(){
        //  _/
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: (0 - quarterW), y: 0))
        path.addLine(to: CGPoint(x: 0, y: ey))
        
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: (0 - quarterW), y: 0))
        self.movingPoint.append(CGPoint(x: 0, y: ey))
        
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    // MARK: -
    func pointDiversionRightSouth()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: oy))
        points.append(CGPoint(x: quarterW, y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        
        return points
    }
    
    func setUpDiversionRightSouth(){
        //  /-
        
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: oy))
        path.addLine(to: CGPoint(x: quarterW, y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: 0, y: oy))
        self.movingPoint.append(CGPoint(x: quarterW, y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: 0))
        
        
        
        self.drawGlowingLineWith(path: path)
    }
    
    // MARK: -
    func pointDiversionLeftSouth()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: (0 - quarterW), y: 0))
        points.append(CGPoint(x: 0, y: oy))
        
        
        return points
    }
    
    func setUpDiversionLeftSouth(){
        //  -\
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: (0 - quarterW), y: 0))
        path.addLine(to: CGPoint(x: 0, y: oy))
        
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: (0 - quarterW), y: 0))
        self.movingPoint.append(CGPoint(x: 0, y: oy))
        
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    // MARK: -
    
    func pointDiversionRightNorth()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: ey))
        points.append(CGPoint(x: quarterW, y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        return points
    }
    func setUpDiversionRightNorth(){
        
        
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: ey))
        path.addLine(to: CGPoint(x: quarterW, y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: 0, y: ey))
        self.movingPoint.append(CGPoint(x: quarterW, y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: 0))
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    
    
    // MARK: -
    
    func pointJunctionLeftNorth_N()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: (0 - quarterW), y: 0))
        points.append(CGPoint(x: 0, y: ey))
        
        return points
    }
    
    func setUpJunctionLeftNorth_N(){
        //  _/
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: (0 - quarterW), y: 0))
        path.addLine(to: CGPoint(x: 0, y: ey))
        self.drawGlowingLineWith(path: path)
        self.movingPath = path
        
        
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: (0 - quarterW), y: 0))
        self.movingPoint.append(CGPoint(x: 0, y: ey))
        
        
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: ex, y: 0))
        
        
        self.drawGlowingWhiteLineWith(path: path2)
        
    }
    
    
    // MARK: -
    func pointJunctSemiLeftNorth_N()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: quarterW, y: 0))
        points.append(CGPoint(x: ex, y: ey))
        
        return points
    }
    func setUpJunctSemiLeftNorth_N(){
        //  _/
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: quarterW, y: 0))
        path.addLine(to: CGPoint(x: ex, y: ey))
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: quarterW, y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: ey))
        
        
        
        
        self.drawGlowingLineWith(path: path)
        
    }
    
    
    
    // MARK: -
    func pointJunctionRightSouth_S()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: oy))
        points.append(CGPoint(x: quarterW, y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        
        return points
    }
    
    func setUpJunctionRightSouth_S(){
        //  /-
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: oy))
        path.addLine(to: CGPoint(x: quarterW, y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        self.drawGlowingLineWith(path: path)
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: 0, y: oy))
        self.movingPoint.append(CGPoint(x: quarterW, y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: 0))
        
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: ox, y: 0))
        self.drawGlowingWhiteLineWith(path: path2)
        
    }
    
    
    
    // MARK: -
    func pointJunctSemiRightSouth_S()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: oy))
        points.append(CGPoint(x: (quarterW * -1), y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        return points
    }
    func setUpJunctSemiRightSouth_S(){
        //  /-
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: oy))
        path.addLine(to: CGPoint(x: (quarterW * -1), y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox, y: oy))
        self.movingPoint.append(CGPoint(x: (quarterW * -1), y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: 0))
        
        
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    // MARK: -
    func pointJunctionLeftSouth_S()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: (0 - quarterW), y: 0))
        points.append(CGPoint(x: 0, y: oy))
        
        return points
    }
    func setUpJunctionLeftSouth_S(){
        //  -\
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: (0 - quarterW), y: 0))
        path.addLine(to: CGPoint(x: 0, y: oy))
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: (0 - quarterW), y: 0))
        self.movingPoint.append(CGPoint(x: 0, y: oy))
        
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: ex, y: 0))
        
        self.drawGlowingLineWith(path: path)
        
        self.drawGlowingWhiteLineWith(path: path2)
    }
    
    
    // MARK: -
    func pointJunctSemiLeftSouth_S()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: 0))
        points.append(CGPoint(x: quarterW, y: 0))
        points.append(CGPoint(x: ex, y: oy))
        
        
        return points
    }
    func setUpJunctSemiLeftSouth_S(){
        //  -\
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: quarterW, y: 0))
        path.addLine(to: CGPoint(x: ex, y: oy))
        self.movingPath = path
        
        self.movingPoint.append(CGPoint(x: ox, y: 0))
        self.movingPoint.append(CGPoint(x: quarterW, y: 0))
        self.movingPoint.append(CGPoint(x: ex, y: oy))
        
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    // MARK: -
    
    func pointJunctionRightNorth_N()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: ey))
        points.append(CGPoint(x: quarterW, y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        
        return points
    }
    func setUpJunctionRightNorth_N(){
        //  /-
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: ey))
        path.addLine(to: CGPoint(x: quarterW, y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        self.movingPath = path
        
        self.movingPoint.append(contentsOf: self.pointJunctionRightNorth_N())
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: ox, y: 0))
        
        self.drawGlowingLineWith(path: path)
        self.drawGlowingWhiteLineWith(path: path2)
    }
    
    
    // MARK: -
    func pointJunctSemiRightNorth_N()->[CGPoint]{
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        
        var points:[CGPoint] = [CGPoint]()
        
        points.append(CGPoint(x: ox, y: ey))
        points.append(CGPoint(x: (quarterW * -1), y: 0))
        points.append(CGPoint(x: ex, y: 0))
        
        return points
        
    }
    
    func setUpJunctSemiRightNorth_N(){
        //  /-
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: ey))
        path.addLine(to: CGPoint(x: (quarterW * -1), y: 0))
        path.addLine(to: CGPoint(x: ex, y: 0))
        
        self.movingPath = path
        self.movingPoint.append(contentsOf: self.pointJunctSemiRightNorth_N())
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    // MARK: -
    
    func pointVertical()->[CGPoint]{
        //let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        //let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: ey))
        points.append(CGPoint(x: 0, y: oy))
        
        return points
    }
    
    func setUpVertical(){
        //  /-
     
        //let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        //let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: ey))
        path.addLine(to: CGPoint(x: 0, y: oy))
        self.movingPath = path
        self.movingPoint.append(contentsOf: self.pointVertical())
        
        
        
        self.drawGlowingLineWith(path: path)
    }
    
    
    
    // MARK: -
    func pointBridgeNorth()->[CGPoint]{
        //let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        //let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        
        points.append(CGPoint(x: 0, y: ey))
        points.append(CGPoint(x: 0, y:0))
        
        return points
    }
    
    func setUpBridgeNorth(){
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: (quarterW * -1), y: (quarterH * -1)))
        path.addLine(to: CGPoint(x: (quarterW), y: (quarterH * -1)))
        path.addLine(to: CGPoint(x: ex, y:0))
        self.drawBridgeWith(path: path)
        
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: ey))
        path2.addLine(to: CGPoint(x: 0, y:0))
        self.movingPath = path2
        self.movingPoint.append(contentsOf: self.pointBridgeNorth())
        
        
        self.drawGlowingLineWith(path: path2)
    }
    
    
    
    // MARK: -
    func pointBridgeSouth()->[CGPoint]{
        //let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        //let quarterW = (w / 4.0)
        //let quarterH = (h / 4.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: 0))
        points.append(CGPoint(x: 0, y:oy))
        
        return points
    }
    
    func setUpBridgeSouth(){
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        
        let quarterW = (w / 4.0)
        let quarterH = (h / 4.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: 0))
        path.addLine(to: CGPoint(x: (quarterW * -1), y: (quarterH)))
        path.addLine(to: CGPoint(x: (quarterW), y: (quarterH)))
        path.addLine(to: CGPoint(x: ex, y:0))
        self.drawBridgeWith(path: path)
        
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: 0, y:oy))
        self.movingPath = path2
        self.movingPoint.append(contentsOf: self.pointBridgeSouth())
        
        
        self.drawGlowingLineWith(path: path2)
    }
    
    
    
    // MARK: -
    func pointSlopeLeft1()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ox, y: ey))
        points.append(CGPoint(x: 0, y: oy))
        
        return points
    }
    
    
    func setUpSlopeLeft1() {
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox, y: ey))
        path.addLine(to: CGPoint(x: 0, y: oy))
        self.movingPath = path
        self.movingPoint.append(contentsOf: self.pointSlopeLeft1())
        self.drawGlowingLineWith(path: path)
        
        
    }
    
    
    // MARK: -
    func pointSlopeLeft2()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: 0, y: ey))
        points.append(CGPoint(x: ex, y: oy))
        
        return points
    }
    
    
    func setUpSlopeLeft2() {
        
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: ey))
        path.addLine(to: CGPoint(x: ex, y: oy))
        self.movingPath = path
        self.movingPoint.append(contentsOf: self.pointSlopeLeft2())
        self.drawGlowingLineWith(path: path)
        
        
    }
    
    
    
    // MARK: -
    func pointSlopeRight1()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        var points:[CGPoint] = [CGPoint]()
        points.append(CGPoint(x: ex, y: ey))
        points.append(CGPoint(x: 0, y: oy))
        
        return points
        
    }
    
    func setUpSlopeRight1() {
        
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ex, y: ey))
        path.addLine(to: CGPoint(x: 0, y: oy))
        self.movingPath = path
        self.movingPoint.append(contentsOf: self.pointSlopeRight1())
        self.drawGlowingLineWith(path: path)
        
        
    }
    
    
    
    // MARK: -
    func pointSlopeRight2()->[CGPoint]{
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        var points:[CGPoint] = [CGPoint]()
        
        points.append(CGPoint(x: 0, y: ey))
        points.append(CGPoint(x: ox, y: oy))
        
        return points
    }
    func setUpSlopeRight2() {
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: ey))
        path.addLine(to: CGPoint(x: ox, y: oy))
        self.movingPath = path
        self.movingPoint.append(contentsOf: self.pointSlopeRight2())
        self.drawGlowingLineWith(path: path)
        
        
    }
    
   
    // MARK: - Frame
    func setUpFrameLeft(){
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        //let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox + 1, y: ey - 1))
        path.addLine(to: CGPoint(x: ox + 1, y: oy + 1))
      
        self.drawFrameLineWith(path: path)
    }
    
    func setUpFrameRight(){
        let w = self.size.width
        let h = self.size.height
        
        //let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ex - 1, y: ey - 1))
        path.addLine(to: CGPoint(x: ex - 1, y: oy + 1))
       
        self.drawFrameLineWith(path: path)
    }
    
    func setUpFrameTop(){
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        //let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox + 1, y: ey - 1))
        path.addLine(to: CGPoint(x: ex - 1, y: ey - 1))
      
        self.drawFrameLineWith(path: path)
    }
    
    func setUpFrameBottom(){
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        //let ey = (h / 2.0)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: ox + 1, y: oy + 1))
        path.addLine(to: CGPoint(x: ex - 1, y: oy + 1))
     
        self.drawFrameLineWith(path: path)
    }
    
    // MARK: - Action
    
    func highlightStage(active:Bool){
        self.highlight = active
        
//        guard self.highlightNode != nil else {
//            return
//        }
        
        if(active){
            //self.highlightNode.alpha = 1
            self.color = self.highlightColor
        }else{
            //self.highlightNode.alpha = 0
            self.color = .black
        }
    }
    
    
    
    func selectedStage(select:Bool){
        self.selected = select
        self.showMovingDot = select
        
        if(self.selected){
            self.lineColor = .app_space_blue
            
        }else{
            self.lineColor = .white
            
        }
        
        
        self.drawMode(mode: self.mode)
    }
    
    
    
    func showMovingDot(show:Bool, lineColor:NSColor){
        self.lineColor = lineColor
        self.showMovingDot = show
        
        self.drawMode(mode: self.mode)
    }
   
    func getLineStationColor() -> NSColor {
        
        var color = self.stationLineBlueColor
        switch self.id.lowercased() {
        case "tb03",
             "tb04",
             "b15-a",
             "b15-b",
             "b09-a",
             "b09-b",
             "b11-c",
             "b11-d",
             "sc-a",
             "sc-b",
             "b14-a",
             "b14-b",
             "tb05",
             "tb06":
            
            color = self.stationLineBlueColor
            break
        default:
            color = self.stationLinePinkColor
            break
        }
        
        return color
    }
    
    func drawStation(){
        if(self.stationNode != nil){
            return
        }
        
        let stationColor = self.getLineStationColor()
        
        
        let w = self.size.width
        let h = self.size.height * 1.2
        let ox = (w / -2) + 1
        let oy = (h / -2) + 1
        let ex = (w / 2) - 1
        let ey = (h / 2) - 1
        
        let centerY = (h - self.size.height) / 2
        
        let stationSize:CGSize = CGSize(width: w, height: h)
        self.stationNode = SKSpriteNode(color: .clear, size: stationSize)
        self.addChild(self.stationNode)
        self.stationNode.position = CGPoint(x: 0, y: centerY)
        
        
        
        do{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy + 8))
            path.addLine(to: CGPoint(x: ox, y:oy + 8))
            path.addLine(to: CGPoint(x: ox, y:oy))
            
            self.drawFillStation(path: path, to: self.stationNode, color: stationColor)
        }
        
        
        do{
            let headerSpace:CGFloat = (self.size.height * 0.2) + 8
            let path = CGMutablePath()
            
            
            path.move(to: CGPoint(x: ox, y: ey - headerSpace))
            path.addLine(to: CGPoint(x: ex, y: ey - headerSpace))
            path.addLine(to: CGPoint(x: ex, y: ey))
            path.addLine(to: CGPoint(x: ox, y: ey))
            path.addLine(to: CGPoint(x: ox, y:ey - headerSpace))
            
            self.drawFillStation(path: path, to: self.stationNode, color: stationColor)
        }
        
       
        
        do{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy))
            path.addLine(to: CGPoint(x: ex, y: ey))
            path.addLine(to: CGPoint(x: ox, y:ey))
            path.addLine(to: CGPoint(x: ox, y:oy))
            
            self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
        }
        
        
        
        //Draw tag Label
        if(self.id != ""){
            let headerSpace:CGFloat = (self.size.height * 0.2) + 8
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
            lable.fontColor = .white
            lable.fontSize = 14
            lable.text = self.id
            lable.numberOfLines = 1
            lable.preferredMaxLayoutWidth = w - 8
            lable.horizontalAlignmentMode = .left
            lable.position = CGPoint(x: ox + 4, y: (ey - headerSpace) + 1)
            self.stationNode.addChild(lable)
        }
        
        
        //Draw Station name
        if(self.stationName != ""){
            
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox, y: ey))
            path.addLine(to: CGPoint(x: ox + 10, y: ey + 10))
            path.addLine(to: CGPoint(x: ox + 20, y: ey + 10))
            self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
            
            
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
            lable.fontColor = .app_space_blue
            lable.fontSize = 14
            lable.text = self.stationName
            lable.numberOfLines = 0
            lable.preferredMaxLayoutWidth = (w * 2) - 12
            lable.horizontalAlignmentMode = .left
            lable.position = CGPoint(x: ox + 24, y: ey + 2)
            self.stationNode.addChild(lable)
        }
        
    }
    
    
    func drawDepot(){
        if(self.stationNode != nil){
            return
        }
        
        let stationColor = self.getLineStationColor()
        
        let w = self.size.width
        let h = self.size.height
        let ox = (w / -2) + 1
        let oy = (h / -2) + 8
        let ex = (w / 2) - 1
        let ey = (h / 2) - 8
        
        let centerY = 0
        
        let stationSize:CGSize = CGSize(width: w, height: h)
        self.stationNode = SKSpriteNode(color: .clear, size: stationSize)
        self.addChild(self.stationNode)
        self.stationNode.position = CGPoint(x: 0, y: centerY)
        
        
        
        do{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy + 4))
            path.addLine(to: CGPoint(x: ox, y:oy + 4))
            path.addLine(to: CGPoint(x: ox, y:oy))
            
            self.drawFillStation(path: path, to: self.stationNode, color: stationColor)
        }
        
        
        do{
            let headerSpace:CGFloat = 4
            let path = CGMutablePath()
            
            
            path.move(to: CGPoint(x: ox, y: ey - headerSpace))
            path.addLine(to: CGPoint(x: ex, y: ey - headerSpace))
            path.addLine(to: CGPoint(x: ex, y: ey))
            path.addLine(to: CGPoint(x: ox, y:ey))
            path.addLine(to: CGPoint(x: ox, y:ey - headerSpace))
            
            self.drawFillStation(path: path, to: self.stationNode, color: stationColor)
        }
        
        
        
  
        
        var haveDrawLine:Bool = false
        //Draw tag Label
        if(self.id != ""){
           
            if(haveDrawLine == false){
                let path = CGMutablePath()
                path.move(to: CGPoint(x: ox, y: ey))
                path.addLine(to: CGPoint(x: ox + 10, y: ey + 10))
                path.addLine(to: CGPoint(x: ox + 20, y: ey + 10))
                self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
                
                haveDrawLine = true
            }
            
            
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
            lable.fontColor = .white
            lable.fontSize = 14
            lable.text = self.id
            lable.numberOfLines = 1
            lable.preferredMaxLayoutWidth = w - 8
            lable.horizontalAlignmentMode = .left
            lable.position = CGPoint(x: ox + 24, y: 8)
            self.stationNode.addChild(lable)
        }
        
        
        //Draw Station name
        if(self.stationName != ""){
            if(haveDrawLine == false){
                let path = CGMutablePath()
                path.move(to: CGPoint(x: ox, y: ey))
                path.addLine(to: CGPoint(x: ox + 10, y: ey + 10))
                path.addLine(to: CGPoint(x: ox + 20, y: ey + 10))
                self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
                
                haveDrawLine = true
            }
            
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 11).fontName)
            lable.fontColor = .app_space_blue4
            lable.fontSize = 11
            lable.text = self.stationName
            lable.numberOfLines = 0
            lable.preferredMaxLayoutWidth = (w * 2) - 12
            lable.horizontalAlignmentMode = .left
            lable.position = CGPoint(x: ox + 24, y: 20)
            self.stationNode.addChild(lable)
        }
        
    }
    
    func drawWaitPoint(){
        if(self.stationNode != nil){
            return
        }
        
        let stationColor = self.getLineStationColor()
        
        
        let w = self.size.width
        let h = self.size.height
        let ox = (w / -2) + 1
        let oy = (h / -2) + 8
        let ex = (w / 2) - 1
        let ey = (h / 2) - 8
        
        let centerY = 0
        
        let stationSize:CGSize = CGSize(width: w, height: h)
        self.stationNode = SKSpriteNode(color: .clear, size: stationSize)
        self.addChild(self.stationNode)
        self.stationNode.position = CGPoint(x: 0, y: centerY)
        
        
        
        do{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy))
            path.addLine(to: CGPoint(x: ex, y: oy + 4))
            path.addLine(to: CGPoint(x: ox, y:oy + 4))
            path.addLine(to: CGPoint(x: ox, y:oy))
            
            
            self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
        }
        
        
        do{
            let headerSpace:CGFloat = 4
            let path = CGMutablePath()
            
            
            path.move(to: CGPoint(x: ox, y: ey - headerSpace))
            path.addLine(to: CGPoint(x: ex, y: ey - headerSpace))
            path.addLine(to: CGPoint(x: ex, y: ey))
            path.addLine(to: CGPoint(x: ox, y:ey))
            path.addLine(to: CGPoint(x: ox, y:ey - headerSpace))
            
            self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
            
        }
        
        

        
        var haveDrawLine:Bool = false
        //Draw tag Label
        if(self.id != ""){
            
            if(haveDrawLine == false){
                let path = CGMutablePath()
                path.move(to: CGPoint(x: ox, y: ey))
                path.addLine(to: CGPoint(x: ox + 10, y: ey + 10))
                path.addLine(to: CGPoint(x: ox + 20, y: ey + 10))
                self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
                
                haveDrawLine = true
            }
            
            
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
            lable.fontColor = .white
            lable.fontSize = 14
            lable.text = self.id
            lable.numberOfLines = 1
            lable.preferredMaxLayoutWidth = w - 8
            lable.horizontalAlignmentMode = .left
            lable.position = CGPoint(x: ox + 24, y: 8)
            self.stationNode.addChild(lable)
        }
        
        
        //Draw Station name
        if(self.stationName != ""){
            if(haveDrawLine == false){
                let path = CGMutablePath()
                path.move(to: CGPoint(x: ox, y: ey))
                path.addLine(to: CGPoint(x: ox + 10, y: ey + 10))
                path.addLine(to: CGPoint(x: ox + 20, y: ey + 10))
                self.drawStationFrameLineWith(path: path, to: self.stationNode, color: stationColor)
                
                haveDrawLine = true
            }
            
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 11).fontName)
            lable.fontColor = .app_space_blue4
            lable.fontSize = 11
            lable.text = self.stationName
            lable.numberOfLines = 0
            lable.preferredMaxLayoutWidth = (w * 2) - 12
            lable.horizontalAlignmentMode = .left
            lable.position = CGPoint(x: ox + 24, y: 20)
            self.stationNode.addChild(lable)
        }
        
    }
    
    
    func drawJunctionDown(){
        if(self.stationNode != nil){
            return
        }
        
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        
        
        
        let centerY = 0
        
        let stationSize:CGSize = CGSize(width: w, height: h)
        self.stationNode = SKSpriteNode(color: .clear, size: stationSize)
        self.addChild(self.stationNode)
        self.stationNode.position = CGPoint(x: 0, y: centerY)
        
        
        
        do{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox+1, y: oy+1))
            path.addLine(to: CGPoint(x: ox+1, y: ey-1))
            path.addLine(to: CGPoint(x: ex-1, y: ey-1))
            path.addLine(to: CGPoint(x: ex-1, y: oy+1))
            path.addLine(to: CGPoint(x: ox+1, y: oy+1))
            
            self.drawGlowingDotLine(path: path, to: self.stationNode, color: self.junctionLineColor)
        }
        
        
       
        //Draw tag Label
        if(self.id != ""){
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
            lable.fontColor = .white
            lable.fontSize = 14
            lable.text = self.id
            lable.numberOfLines = 1
            lable.preferredMaxLayoutWidth = w - 8
            lable.horizontalAlignmentMode = .center
            lable.position = CGPoint(x: 0, y: ey + 4)
            self.stationNode.addChild(lable)
        }
        
   
        
    }
    
    
    func drawJunctionUp(){
        if(self.stationNode != nil){
            return
        }
        
        
        let w = self.size.width
        let h = self.size.height
        
        let ox = (w / 2.0) * -1
        let ex = (w / 2.0)
        
        let oy = (h / 2.0) * -1
        let ey = (h / 2.0)
        
        
        
        
        
        let centerY = 0
        
        let stationSize:CGSize = CGSize(width: w, height: h)
        self.stationNode = SKSpriteNode(color: .clear, size: stationSize)
        self.addChild(self.stationNode)
        self.stationNode.position = CGPoint(x: 0, y: centerY)
        
        
        
        do{
            let path = CGMutablePath()
            path.move(to: CGPoint(x: ox+1, y: oy+1))
            path.addLine(to: CGPoint(x: ox+1, y: ey-1))
            path.addLine(to: CGPoint(x: ex-1, y: ey-1))
            path.addLine(to: CGPoint(x: ex-1, y: oy+1))
            path.addLine(to: CGPoint(x: ox+1, y: oy+1))
            
            self.drawGlowingDotLine(path: path, to: self.stationNode, color: self.junctionLineColor)
        }
        
        
       
        //Draw tag Label
        if(self.id != ""){
            
            let lable:SKLabelNode = SKLabelNode(fontNamed: NSFont.boldSystemFont(ofSize: 14).fontName)
            lable.fontColor = .white
            lable.fontSize = 14
            lable.text = self.id
            lable.numberOfLines = 1
            lable.preferredMaxLayoutWidth = w - 8
            lable.horizontalAlignmentMode = .center
            lable.position = CGPoint(x: 0, y: oy - 14)
            self.stationNode.addChild(lable)
        }
        
        
    
        
    }
    
    func drawStationFrameLineWith(path:CGMutablePath, to station:SKSpriteNode, color lineColor:NSColor){
//        let glow: SKEffectNode = SKEffectNode()
//        let shap = SKShapeNode()
//        shap.path = path
//        shap.strokeColor = lineColor
//        shap.lineWidth = 1
//        shap.isAntialiased = true
//        shap.lineCap = .round
//
//        glow.addChild(shap)
//        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": inputRadius])
//        glow.shouldRasterize = true
//
//        station.addChild(glow)
        
        
        let shap2 = SKShapeNode()
        shap2.path = path
        shap2.strokeColor = lineColor
        shap2.lineWidth = 1
        shap2.isAntialiased = true
        shap2.lineCap = .round
        
        
        station.addChild(shap2)
    }
    
    func drawFillStation(path:CGMutablePath, to station:SKSpriteNode, color lineColor:NSColor) {
        let shap2 = SKShapeNode()
        shap2.path = path
        shap2.strokeColor = .clear
        shap2.fillColor = lineColor
        shap2.lineWidth = 1
        shap2.isAntialiased = true
        shap2.lineCap = .round
        shap2.lineJoin = .round
        
        station.addChild(shap2)
    }
    
    
    func drawGlowingDotLine(path:CGMutablePath, to station:SKSpriteNode, color lineColor:NSColor) {
        
        
        let pattern : [CGFloat] = [4.0, 6.0]
        let dashed = path.copy(dashingWithPhase: 1, lengths: pattern)
        
        
//        let glow: SKEffectNode = SKEffectNode()
//        let shap = SKShapeNode()
//        shap.path = dashed
//        shap.strokeColor = lineColor
//        shap.lineWidth = 1
//        shap.isAntialiased = true
//        shap.lineCap = .round
//
//        glow.addChild(shap)
//        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": inputRadius])
//        glow.shouldRasterize = true
//
//        self.addChild(glow)
        
        
        let shap2 = SKShapeNode()
        shap2.path = dashed
        shap2.strokeColor = lineColor
        shap2.lineWidth = 1
        shap2.isAntialiased = true
        shap2.lineCap = .round
        
        
        station.addChild(shap2)
    }
    
    
    func updateUI(){
        self.drawMode(mode: self.mode)
        
        self.updateDrawStationType()
        
        
    }
    
    
    func updateDrawStationType(){
        switch self.stationMode {
        case .non:
            break
        case .station:
            self.drawStation()
            break
        case .waitPoint:
            self.drawWaitPoint()
            break
        case .depot:
            
            self.drawDepot()
            break
        case .junctionUp:
            
            self.drawJunctionUp()
            break
        case .junctionDown:
            
            self.drawJunctionDown()
            break
            
        }
    }
    
    
    
    
    
    func getMovingPoint(leftToRight:Bool)->[CGPoint]{
        
        if(leftToRight == true){
            return self.movingPoint.sorted { (p1, p2) -> Bool in
                if(p1.x == p2.x){
                    return p1.y > p2.y
                }else{
                    return p1.x < p2.x
                }
            }
        }else{
            return self.movingPoint.sorted { (p1, p2) -> Bool in
                if(p1.x == p2.x){
                    return p1.y < p2.y
                }else{
                    return p1.x > p2.x
                }
            }
        }

    }
    
    func getMovingPath(leftToRight:Bool)->CGMutablePath{
        let arPoint = self.getMovingPoint(leftToRight: leftToRight)
        
        let mPath:CGMutablePath = CGMutablePath()
        for i in 0..<arPoint.count{
            let point = arPoint[i]
            if(i == 0){
                mPath.move(to: point)
            }else{
                mPath.addLine(to: point)
            }
            
        }
        
        return mPath
        
    }
}
