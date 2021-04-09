//
//  AleartCenter.swift
//  RailWay03
//
//  Created by T2P mac mini on 27/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa




func dialogOKCancel(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    return alert.runModal() == .alertFirstButtonReturn
}


func dialogOK(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    return alert.runModal() == .alertFirstButtonReturn
}


class AleartCenter: NSObject {
    
    

}
