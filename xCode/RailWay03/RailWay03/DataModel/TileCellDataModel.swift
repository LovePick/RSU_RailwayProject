//
//  TileCellDataModel.swift
//  RailWay03
//
//  Created by supapon pucknavin on 24/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class TileCellDataModel: NSObject {
    
    enum Status{
        case free
        case active
    }
    var mode:NSInteger = 0          //TileCell.Mode
    var stationMode:NSInteger = 0   //TileCell.StationType
    var id:String = ""
    var stationName:String = ""
    
    var i:NSInteger = 0
    var j:NSInteger = 0
    
    
    var lineLeft:Bool = false
    var lineRight:Bool = false
    var lineTop:Bool = false
    var lineBottom:Bool = false
    
    
    var message:NSInteger = 0
    
    
    let size:CGSize = CGSize(width: 64, height: 32)
    
    var toRight:Bool = true
    
    
    
    var status:Status = .free
    
    
    var bookByCarID:String = ""
    
    var junctionLight:NSInteger = 0
    
//    var arQueueCarID:[String] = [String]()
    
    override init() {
        super.init()
        
    }
    
    convenience init(fields:[String: Any]){
        
        self.init()
        
        
        self.readJson(fields: fields)
    }
    
    
    func readJson(fields:[String: Any]) {
        if let mode = fields["mode"] as? NSInteger{
            self.mode = mode
        }
        
        if let stationMode = fields["stationMode"] as? NSInteger{
            self.stationMode = stationMode
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
        
        
        if let message = fields["message"] as? NSInteger{
            self.message = message
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
    }
    
    
    
    func getDictData()->[String:Any]{
        
        var newDic:[String:Any] = [String:Any]()
        
        newDic["mode"] = self.mode
        newDic["stationMode"] = self.stationMode
        newDic["id"] = self.id
        newDic["stationName"] = self.stationName
        newDic["i"] = self.i
        newDic["j"] = self.j
        newDic["message"] = self.message
        
        newDic["lineLeft"] = self.lineLeft
        newDic["lineRight"] = self.lineRight
        newDic["lineTop"] = self.lineTop
        newDic["lineBottom"] = self.lineBottom
        
        newDic["toRight"] = self.toRight
        newDic["junctionLight"] = self.junctionLight
        
        return newDic
        
    }
    
    func getKey()->String{
        let str:String = "x\(self.i)y\(self.j)"
        return str
    }
    
    

}
// MARK: -
extension TileCellDataModel{
    
    // MARK: -
    func getMoveingPoint()->[CGPoint]{
        
        
        guard let cmode = TileCell.Mode(rawValue: self.mode) else {
            return [CGPoint]()
        }
        
        
        switch cmode {
        case .line:
            return self.pointLine()
            
        case .endLeft:
            return [CGPoint]()
            
        case .endRight:
            return [CGPoint]()
            
        case .diversionLeftNorth:
            return self.pointDiversionLeftNorth()
            
        case .diversionRightSouth:
            return self.pointDiversionRightSouth()
            
        case .diversionLeftSouth:
            return self.pointDiversionLeftSouth()
            
        case .diversionRightNorth:
            return self.pointDiversionRightNorth()
            
        case .junctionLeftNorth_N:
            return self.pointJunctionLeftNorth_N()
            
        case .junctionRightSouth_S:
            return self.pointJunctionRightSouth_S()
            
        case .junctionLeftSouth_S:
            return self.pointJunctionLeftSouth_S()
            
        case .junctionRightNorth_N:
            return self.pointJunctionRightNorth_N()
            
        case .vertical:
            return self.pointVertical()
            
        case .bridgeNorth:
            return self.pointBridgeNorth()
            
        case .bridgeSouth:
            return self.pointBridgeSouth()
            
        case .slopeLeft1:
            return self.pointSlopeLeft1()
            
        case .slopeLett2:
            return self.pointSlopeLeft2()
            
        case .slopeRight1:
            return self.pointSlopeRight1()
            
        case .slopeRight2:
            return self.pointSlopeRight2()
            
        case .junctSemiLeftNorth_N:
            return self.pointJunctSemiLeftNorth_N()
            
        case .junctSemiLeftSouth_S:
            return self.pointJunctSemiLeftSouth_S()
            
        case .junctSemiRightNorth_N:
            return self.pointJunctSemiRightNorth_N()
            
        case .junctSemiRightSouth_S:
            return self.pointJunctSemiRightSouth_S()
            
        default:
            return [CGPoint]()
            
        }
        
        
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
    
    
    
}
