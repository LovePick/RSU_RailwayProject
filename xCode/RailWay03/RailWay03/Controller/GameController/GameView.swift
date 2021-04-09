//
//  GameView.swift
//  RailWay03
//
//  Created by T2P mac mini on 20/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit


class GameView: SKView {

    enum CursorsType:String{
        case mdefault = "mdefault"
        case openHand = "openHand"
        case closeHand = "closeHand"
        case option = "option"
        case pointer = "pointer"
        case screenshot = "screenshot"
        case type = "type"
        case zoomin = "zoom-in"
        case zoomout = "zoom-out"
        case panBlack = "baseline_pan_tool_black_18pt"
        case panWhite = "baseline_pan_tool_white_18pt"
    }
    
    
    var cursorType:CursorsType = .mdefault
    
  
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    override func resetCursorRects() {
        
        self.discardCursorRects()
        
        /*
        if let tragetImage = NSImage(named: NSImage.Name(cursor.rawValue)){

            print(cursor.rawValue)
            
            var point:CGPoint = CGPoint(x: tragetImage.size.width/2, y: tragetImage.size.height/2)
            if((cursor == .mdefault) || (cursor == .option)){
                
                point = CGPoint(x: 0, y: tragetImage.size.height)
         
                self.addCursorRect(self.frame, cursor: NSCursor.arrow)
            }
          
            self.wantsLayer = true
            let newcursor = NSCursor(image: tragetImage, hotSpot: point)
            addCursorRect(self.frame, cursor: newcursor)
            
          
        }*/
        
        
        switch self.cursorType {
        case .mdefault:
            self.addCursorRect(self.frame, cursor: NSCursor.arrow)
            break
        case .openHand:
            self.addCursorRect(self.frame, cursor: NSCursor.openHand)
            break
        case .closeHand:
            self.addCursorRect(self.frame, cursor: NSCursor.closedHand)
            break
        case .zoomin:
            if let tragetImage = NSImage(named: NSImage.Name(self.cursorType.rawValue)){
                
                let point:CGPoint = CGPoint(x: tragetImage.size.width/2, y: tragetImage.size.height/2)
                self.wantsLayer = true
                let newcursor = NSCursor(image: tragetImage, hotSpot: point)
                self.addCursorRect(self.frame, cursor: newcursor)
                
            }
            break
        default:
            self.addCursorRect(self.frame, cursor: NSCursor.arrow)
            break
        }
        
        
        
        
        
    }
    
    
    
}
