//
//  AppDelegate.swift
//  RailWay03
//
//  Created by T2P mac mini on 19/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    @IBOutlet weak var windowMenuPreference: NSMenuItem!
    @IBOutlet weak var windowServices: NSMenuItem!
    
    @IBOutlet weak var windowHostSetting: NSMenuItem!
    
    
    
    @IBOutlet weak var windowMap: NSMenuItem!
    @IBOutlet weak var windowMap_Open: NSMenuItem!
    @IBOutlet weak var windowMap_Save: NSMenuItem!
    
    
    @IBOutlet weak var windowEdit: NSMenuItem!
    @IBOutlet weak var windowEdit_OpenToolBar: NSMenuItem!
    @IBOutlet weak var windowEdit_HideToolBar: NSMenuItem!
    @IBOutlet weak var windowEdit_EditMap: NSMenuItem!
    @IBOutlet weak var windowEdit_EditPath: NSMenuItem!
    @IBOutlet weak var windowEdit_TimeTable: NSMenuItem!
    @IBOutlet weak var windowEdit_Car: NSMenuItem!
    
    
    
    @IBOutlet weak var windowControll: NSMenuItem!
    @IBOutlet weak var windowControllerRunSimulator: NSMenuItem!
    @IBOutlet weak var windowControllerRunHardware: NSMenuItem!
    
    @IBOutlet weak var windowControllerPauseContinute: NSMenuItem!
    @IBOutlet weak var windowControllerReset: NSMenuItem!
    
    @IBOutlet weak var windowOpenLog: NSMenuItem!
    
    
    
    @IBOutlet weak var windowCarsControllMenu: NSMenuItem!
    @IBOutlet weak var windowCarsListMenu: NSMenu!
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let coordinate = Coordinater.shared
        coordinate.stopCheckStatusTimmer()
        coordinate.stopAll()
        coordinate.pauseTimer()
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
