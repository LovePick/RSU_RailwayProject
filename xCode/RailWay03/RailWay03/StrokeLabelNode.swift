//
//  StrokeLabelNode.swift
//  RailWay03
//
//  Created by T2P mac mini on 23/12/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit



extension SKLabelNode {

   func addStroke(color:NSColor, width: CGFloat) {

        guard let labelText = self.text else { return }

        let font = NSFont(name: self.fontName!, size: self.fontSize)

        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

    let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
   }
}
