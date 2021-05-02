//
//  ViewController.swift
//  RailWay03
//
//  Created by T2P mac mini on 19/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {
    
    
    enum textFieldID:NSInteger{
        case non = 0
        case propertyId
        case propertyName
        case propertyType
        case pathMessage
        case junctionLight
        case mapSizeW = 201
        case mapSizeH = 202
    }
    
    
    enum DisplayMode:NSInteger{
        case non = 0
        case hideToolBar
        case editMap
        case editPath
        case editTimeTable
        case editRoutine
        case editCars
    }
    
    
    
    
    @IBOutlet var skView: GameView!
    
    
    var displayMode:DisplayMode = .non
    
    
    // MARK: - Window menu
    
    
    
    // MARK: - tool bar
    @IBOutlet weak var viToolbarBG: NSView!
    
    @IBOutlet weak var tfMapSizeW: NSTextField!
    @IBOutlet weak var stepMapSizeW: NSStepper!
    
    @IBOutlet weak var tfMapSizeH: NSTextField!
    @IBOutlet weak var stepMapSizeH: NSStepper!
    
    @IBOutlet weak var btdefault: NSButton!
    @IBOutlet weak var btMoveMap: NSButton!
    @IBOutlet weak var btZoom: NSButton!
    
    
    
    // MARK: - property
    
    @IBOutlet weak var tfPropertyId: NSTextField!
    @IBOutlet weak var tfPropertyName: NSTextField!
    @IBOutlet weak var btPropertyType: NSPopUpButton!
    
    @IBOutlet weak var btFrameBottom: NSButton!
    @IBOutlet weak var btFrameLeft: NSButton!
    @IBOutlet weak var btFrameRight: NSButton!
    @IBOutlet weak var btFrameTop: NSButton!
    
    
    
    let propertyModel:PropertyViewModel = PropertyViewModel()
    
    
    
    // MARK: - car list BG
    @IBOutlet weak var viCarsListBG: NSView!
    @IBOutlet weak var carListMenuBG: NSView!
    @IBOutlet weak var btCarAdd: NSButton!
    @IBOutlet weak var btCarRemove: NSButton!
    
    @IBOutlet weak var carVerticalLine: NSView!
    @IBOutlet weak var carHorizonLine: NSView!
    @IBOutlet weak var carListHeaderBG: NSView!
    @IBOutlet weak var carListLineHeader: NSView!
    @IBOutlet weak var carListLabelHeader: NSTextField!
    
    
    @IBOutlet weak var lbJunctionLight: NSTextField!
    
    
    
    
    // MARK: - car list
    var myCarsCollection:CarsListView! = nil
    var carListViewDataModel:CarsListViewDataModel = CarsListViewDataModel()
    

    // MARK: - path list
    var myPathCollection:PathListView! = nil
    var pathListViewDataModel:PathEditerModel = PathEditerModel()
    
    var deleteBufferindex:NSInteger = -1
    
    @IBOutlet weak var viPathToolBG: NSView!
    @IBOutlet weak var viPathToolLine1: NSView!
    @IBOutlet weak var viPathToolLine2: NSView!
    
    
    @IBOutlet weak var btPathToolSwap: NSButton!
    @IBOutlet weak var btPathToolAdd: NSButton!
    @IBOutlet weak var btPathToolRemove: NSButton!
//    @IBOutlet weak var viPathToolLine3: NSView!
//    @IBOutlet weak var viPathToolTextField: NSTextField!
//    
//    
//    @IBOutlet weak var viPathToolLine4: NSView!
//    @IBOutlet weak var btPathToolTest: NSButton!
    
    
    @IBOutlet weak var lbMovingTitle: NSLayoutConstraint!
    @IBOutlet weak var swithcMoving: NSSegmentedControl!

    
    // MARK: - Time table
    @IBOutlet weak var viTimeTableBG: NSView!
   
    
    
    @IBOutlet weak var viControlDisplayStatus: NSView!
    @IBOutlet weak var lbControlDisplayStatus: NSTextField!
    
    
    
    
    var myTimeTableView:TimeTableView! = nil
    var timeTableModel:TimeTableRoutineViewModel = TimeTableRoutineViewModel()
    

    // MARK: - Routine
    var myRoutineView:RoutineView! = nil
    var routineModel:TimeTableViewModel = TimeTableViewModel()
    
    
    // MARK: - window menu
    var savePath:URL? = nil

    
    // MARK: - Display
    var arActivePath:[PathDataModel] = [PathDataModel]()
    var lastSelectPaths:[PathDataModel] = [PathDataModel]()
    
    // MARK: - Controller
    var trainControllerRuning:Bool = false
    
    var myCarControllView:CarsController? = nil
    var activeCars:[CarDataModel] = [CarDataModel]()
    
    // MARK: - Car controll
    
    @IBOutlet weak var viCarControll: NSView!
   
    
    //Zoom in zoom out
    @IBOutlet weak var viZoomMapBG: NSView!
    @IBOutlet weak var btZoomIn: NSButton!
    @IBOutlet weak var btZoomOut: NSButton!
    
    
    //Stop car
    @IBOutlet weak var viStopCarBG: NSView!
    @IBOutlet weak var btStopCar: NSButton!
    
    
    @IBOutlet weak var viControllStatus: NSView!
    @IBOutlet weak var lbC01: NSTextField!
    @IBOutlet weak var lbC02: NSTextField!
    @IBOutlet weak var lbC03: NSTextField!
    @IBOutlet weak var lbC04: NSTextField!
    @IBOutlet weak var lbC05: NSTextField!
    @IBOutlet weak var lbC06: NSTextField!
    @IBOutlet weak var lbC07: NSTextField!
    @IBOutlet weak var lbC08: NSTextField!
    @IBOutlet weak var lbC09: NSTextField!
    @IBOutlet weak var lbC10: NSTextField!
    @IBOutlet weak var lbC11: NSTextField!
    @IBOutlet weak var lbC12: NSTextField!
    @IBOutlet weak var lbC13: NSTextField!
    @IBOutlet weak var lbC14: NSTextField!
    
    
    
    
    var windowPreferenceController:PreferenceWindowController? = nil
    
    
    
    
    var model:ViewControllerModel = ViewControllerModel()
    
    
    let cooldinater:Coordinater = Coordinater.shared
    
    
    
    var enableOpenMapMenu:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShareData.shared.masterVC = self
        
        self.tfPropertyId.tag = textFieldID.propertyId.rawValue
        self.tfPropertyId.delegate = self
        self.tfPropertyName.tag = textFieldID.propertyName.rawValue
        self.tfPropertyName.delegate = self
        
        
        
        propertyModel.tfPropertyId = self.tfPropertyId
        propertyModel.tfJunctionLighr = self.lbJunctionLight
        propertyModel.tfPropertyName = self.tfPropertyName
        propertyModel.btPropertyType = self.btPropertyType
        
        propertyModel.btFrameBottom = self.btFrameBottom
        propertyModel.btFrameLeft = self.btFrameLeft
        propertyModel.btFrameRight = self.btFrameRight
        propertyModel.btFrameTop = self.btFrameTop
        
        
        
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill

                // Present the scene
                view.presentScene(scene)
                
                if let gc = scene as? GameScene{
                    ShareData.shared.gamseSceme = gc
                }
              
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        
        self.view.wantsLayer = true
        viToolbarBG.wantsLayer = true
        viToolbarBG.layer?.zPosition = 100
        viToolbarBG.layer?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        

        self.tfMapSizeW.delegate = self
        self.tfMapSizeH.delegate = self
        
        self.tfMapSizeW.isEditable = false
        self.tfMapSizeH.isEditable = false
        
        if let gameScene = ShareData.shared.gamseSceme{
            self.tfMapSizeW.integerValue = gameScene.model.mapWidth
            self.tfMapSizeH.integerValue = gameScene.model.mapHeight
            self.stepMapSizeW.integerValue = gameScene.model.mapWidth
            self.stepMapSizeH.integerValue = gameScene.model.mapHeight
            
            self.model.mapSizeW = gameScene.model.mapWidth
            self.model.mapSizeH = gameScene.model.mapHeight
        }
        
        
        
        self.propertyModel.addListToType(button: self.btPropertyType)
        
        
        
        ////- edit car
        
        
        viCarsListBG.wantsLayer = true
        viCarsListBG.layer?.zPosition = 100
        viCarsListBG.layer?.backgroundColor = NSColor(deviceWhite: 0, alpha: 0.9).cgColor//NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
        viCarsListBG.layer?.borderWidth = 1
        viCarsListBG.layer?.borderColor = NSColor.app_space_blue.cgColor
        viCarsListBG.layer?.cornerRadius = 5
        
        
        
        
        
        self.carListMenuBG.wantsLayer = true
        self.carListMenuBG.layer?.borderColor = NSColor.clear.cgColor
        
        self.btCarAdd.wantsLayer = true
        self.btCarRemove.wantsLayer = true
        self.carHorizonLine.wantsLayer = true
        self.carVerticalLine.wantsLayer = true
        self.carListHeaderBG.wantsLayer = true
        self.carListLineHeader.wantsLayer = true
        self.carListLabelHeader.wantsLayer = true
        
        self.viControlDisplayStatus.wantsLayer = true
        self.viControlDisplayStatus.isHidden = true
        
        self.viControllStatus.wantsLayer = true
        self.viControllStatus.isHidden = false
        
        self.carHorizonLine.layer?.backgroundColor = NSColor.app_space_blue.cgColor
        self.carVerticalLine.layer?.backgroundColor = NSColor.app_space_blue.cgColor
        
        self.carListLineHeader.layer?.backgroundColor = NSColor.app_space_blue.cgColor
        self.carListLabelHeader.textColor = NSColor.app_space_blue
        
        
        
        
        
 

        ///-----------
        
        
        (self.btCarAdd.cell as! NSButtonCell).isBordered = false
        (self.btCarAdd.cell as! NSButtonCell).backgroundColor = NSColor.clear
        //self.btCarAdd.layer?.cornerRadius = 5
        
        
        
        (self.btCarRemove.cell as! NSButtonCell).isBordered = false
        (self.btCarRemove.cell as! NSButtonCell).backgroundColor = NSColor.clear
        //self.btCarRemove.layer?.cornerRadius = 5
        
       
        ////- end car
        
        
        
        
        
        self.viPathToolBG.wantsLayer = true
        self.viPathToolBG.layer?.zPosition = 100
        self.viPathToolBG.layer?.backgroundColor = NSColor(deviceWhite: 0, alpha: 0.9).cgColor//NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
        self.viPathToolBG.layer?.borderWidth = 1
        self.viPathToolBG.layer?.borderColor = NSColor.app_space_blue.cgColor
        self.viPathToolBG.layer?.cornerRadius = 5
        
        
        self.btPathToolSwap.wantsLayer = true
        self.btPathToolAdd.wantsLayer = true
        self.btPathToolRemove.wantsLayer = true
//        self.btPathToolTest.wantsLayer = true
        self.viPathToolLine1.wantsLayer = true
        self.viPathToolLine2.wantsLayer = true
//        self.viPathToolLine3.wantsLayer = true
//        self.viPathToolLine4.wantsLayer = true
//        self.viPathToolTextField.wantsLayer = true
//        self.viPathToolTextField.tag = textFieldID.pathMessage.rawValue
        
        
        
        (self.btPathToolSwap.cell as! NSButtonCell).isBordered = false
        (self.btPathToolSwap.cell as! NSButtonCell).backgroundColor = NSColor.clear
        
        (self.btPathToolAdd.cell as! NSButtonCell).isBordered = false
        (self.btPathToolAdd.cell as! NSButtonCell).backgroundColor = NSColor.clear
        
        (self.btPathToolRemove.cell as! NSButtonCell).isBordered = false
        (self.btPathToolRemove.cell as! NSButtonCell).backgroundColor = NSColor.clear
        
//        (self.btPathToolTest.cell as! NSButtonCell).isBordered = false
//        (self.btPathToolTest.cell as! NSButtonCell).backgroundColor = NSColor.clear
        
        
        self.viPathToolLine1.layer?.backgroundColor = NSColor.app_space_blue.cgColor
        self.viPathToolLine2.layer?.backgroundColor = NSColor.app_space_blue.cgColor
//        self.viPathToolLine3.layer?.backgroundColor = NSColor.app_space_blue.cgColor
//        self.viPathToolLine4.layer?.backgroundColor = NSColor.app_space_blue.cgColor
//        self.viPathToolTextField.layer?.backgroundColor = NSColor.clear.cgColor
//        self.viPathToolTextField.backgroundColor = .clear
//        self.viPathToolTextField.textColor = NSColor.app_space_blue
        
        
        
        
        
        
        //Time Table
        self.viTimeTableBG.wantsLayer = true
        self.viTimeTableBG.layer?.zPosition = 100
        self.viTimeTableBG.layer?.backgroundColor = NSColor(deviceWhite: 0, alpha: 0.9).cgColor//NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
        self.viTimeTableBG.layer?.borderWidth = 1
        self.viTimeTableBG.layer?.borderColor = NSColor.app_space_blue.cgColor
        self.viTimeTableBG.layer?.cornerRadius = 5
        
        
        
        
        //Car controll
        self.viCarControll.wantsLayer = true
        self.viCarControll.layer?.zPosition = 100
        self.viCarControll.layer?.backgroundColor = NSColor(deviceWhite: 0, alpha: 0.9).cgColor
        self.viCarControll.layer?.borderWidth = 1
        self.viCarControll.layer?.borderColor = NSColor.app_space_blue.cgColor
        self.viCarControll.layer?.cornerRadius = 5
        
        
  
        
        if let defaultMapURL = self.getDefaultMapDataPath(){
            self.enableOpenMapMenu = false
            self.openSaveMapWith(filePathUrl: defaultMapURL)
        }else{
            self.enableOpenMapMenu = true
        }
        

        self.setupDisplayToMode(dMode: .hideToolBar)

        self.showCarControllView(show: false)
        
        
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.windowServices.isHidden = true
        appDelegate.windowMenuPreference.isHidden = true
        
        
        self.lbJunctionLight.tag = textFieldID.junctionLight.rawValue
        self.lbJunctionLight.delegate = self
        
        
        self.setupEmergencyBreagButton()
        
        
        self.cooldinater.registerShipControll()
    }
    
    
    
    override func viewDidAppear() {
        
        cooldinater.connectServer()
        cooldinater.initControlShipLabel()
    }
    
    // MARK: - Action
    
    
    
    @IBAction func stepWChange(_ sender: NSStepper) {
        self.tfMapSizeW.integerValue = sender.integerValue
        self.changeMapSize()
    }
    
    @IBAction func stepHChange(_ sender: NSStepper) {
        self.tfMapSizeH.integerValue = sender.integerValue
        self.changeMapSize()
    }
    
    
    func changeMapSize(){
        self.model.mapSizeW = self.tfMapSizeW.integerValue
        self.model.mapSizeH = self.tfMapSizeH.integerValue
        self.model.updateMapSize()
    }
    
    @IBAction func tapOnZoomInMap(_ sender: Any) {
        
        if let gameScene = ShareData.shared.gamseSceme{
            gameScene.zoomInMap()
        }
        
    }
    
    @IBAction func tapOnZoomOutMap(_ sender: Any) {
        
        if let gameScene = ShareData.shared.gamseSceme{
            gameScene.zoomOutMap()
        }
        
    }
    
    
    @IBAction func tapOnMoveMap(_ sender: Any) {
        
        if let gameScene = ShareData.shared.gamseSceme{
            
            
            if(gameScene.touchEvent.action != .moveMap){
                gameScene.touchEvent.action = .moveMap
            }else{
                gameScene.touchEvent.action = .non
            }
            
            self.setUpIconToMode(mode: gameScene.touchEvent.action)
        }
    }
    
    
    @IBAction func tapOnDefault(_ sender: Any) {
        if let gameScene = ShareData.shared.gamseSceme{
            
            
            if((gameScene.touchEvent.action == .non) || (gameScene.touchEvent.action == .selectTileType)){
                
            }else{
                gameScene.touchEvent.action = .non
            }
            
            self.setUpIconToMode(mode: gameScene.touchEvent.action)
        }
    }
    
    
    @IBAction func tapOnZoom(_ sender: Any) {
        if let gameScene = ShareData.shared.gamseSceme{
            
            if(gameScene.touchEvent.action != .zoom){
                gameScene.touchEvent.action = .zoom
            }else{
                gameScene.touchEvent.action = .non
            }
            
            self.setUpIconToMode(mode: gameScene.touchEvent.action)
        }
    }
    
    
    
    @IBAction func tapOnFrameBottom(_ sender: Any) {
        self.propertyModel.tapOnFrameBottom()
    }
    
    @IBAction func tapOnFrameLeft(_ sender: Any) {
        self.propertyModel.tapOnFrameLeft()
    }
    
    @IBAction func tapOnFrameRight(_ sender: Any) {
        self.propertyModel.tapOnFrameRight()
    }
    
    @IBAction func tapOnFrameTop(_ sender: Any) {
        self.propertyModel.tapOnFrameTop()
    }
    
   
    
    @IBAction func tapOnCloseCarListView(_ sender: Any) {
        self.setupDisplayToMode(dMode: .editTimeTable)
    }
    
    
    // MARK: - setup display
    func setupDisplayToMode(dMode:DisplayMode){
        self.displayMode = dMode
        
        
        switch dMode {
        case .non:
            
            self.loadBufferMap()
            self.setDisPlayModeNon()
            self.showCarControllView(show: false)
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.backgroundColor = .black
            }
            
            break;
        case .hideToolBar:
            self.loadBufferMap()
            self.setDisPlayModeHideToolBar()
            self.showCarControllView(show: false)
            
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: true)
                gameScene.backgroundColor = .black
            }
            
            break;
        case .editMap:
            self.loadBufferMap()
            self.setDisPlayModeEditMap()
            self.showCarControllView(show: false)
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: false)
                gameScene.backgroundColor = .app_BackgroundEdit
            }
            
            
            break
        case .editPath:
            self.model.bufferMapData = self.getMapdataDic()
            self.setDisplayModeEditPath()
            self.showCarControllView(show: false)
            
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: false)
                gameScene.backgroundColor = .app_BackgroundEdit
            }
            break
        case .editTimeTable:
            self.loadBufferMap()
            self.model.bufferMapData = self.getMapdataDic()
            self.setDisplayModeEditTimeTable()
            self.showCarControllView(show: false)
            
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: true)
                gameScene.backgroundColor = .black
            }
            break
        case .editRoutine:
            
            self.loadBufferMap()
            self.model.bufferMapData = self.getMapdataDic()
            self.setDisplayModeEditRoutine()
            self.showCarControllView(show: false)
            
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: true)
                gameScene.backgroundColor = .black
            }
            break
        case .editCars:
            self.loadBufferMap()
            //self.setDisPlayModeHideToolBar()
            self.tapOnMoveMap(self.btMoveMap as Any)
            self.setDisplayModeCars()
            self.showCarControllView(show: false)
            
            
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: true)
                gameScene.backgroundColor = .black
            }
            
            
            
            break
        }
        
        
        
        self.hideMenuProduction()
    }
    
    
    func loadBufferMap(){
        if(model.bufferMapData != nil){
            self.loadOnlyMapDataWith(dic: model.bufferMapData)
            model.bufferMapData = nil
        }
    }
    
    func setDisPlayModeHideToolBar(){
        
        self.showPathToolView(show: false)
        self.removeCarListView()
        self.removePathListView()
     
        self.stepMapSizeH.isEnabled = false
        self.stepMapSizeW.isEnabled = false
        
        self.tfPropertyId.isEnabled = false
        self.tfPropertyName.isEnabled = false
        self.btPropertyType.isEnabled = false
        
        
        self.viToolbarBG.isHidden = true
        self.viCarsListBG.isHidden = true
        
        self.removeRoutineView()
        self.removeTimetableView()
        self.viTimeTableBG.isHidden = true
        
        self.btFrameBottom.isEnabled = false
        self.btFrameTop.isEnabled = false
        self.btFrameRight.isEnabled = false
        self.btFrameLeft.isEnabled = false
        
        if let gScene = ShareData.shared.gamseSceme{
            gScene.model.deselectAllCell()
            gScene.touchEvent.action = .moveMap
            gScene.touchEvent.disPlayMode = .hideToolBar
            gScene.removeTileCollection()
        }
    }
    
    
    func setDisplayModeCars(){
        self.showPathToolView(show: false)
        
        self.removePathListView()
        
        self.addCarListView()
        
        self.removeRoutineView()
        self.addTimeTableView()
        
        self.btCarAdd.isHidden = true
        self.btCarRemove.isHidden = true
        self.carHorizonLine.isHidden = true
        
        
        
        self.viTimeTableBG.isHidden = false
        
        self.stepMapSizeH.isEnabled = false
        self.stepMapSizeW.isEnabled = false
        
        self.tfPropertyId.isEnabled = false
        self.tfPropertyName.isEnabled = false
        self.btPropertyType.isEnabled = false
        
        if(ShareData.shared.production){
            self.viToolbarBG.isHidden = true
        }else{
            self.viToolbarBG.isHidden = false
        }
        
        self.viCarsListBG.isHidden = false
        
        
        self.btdefault.isEnabled = false
        self.btZoom.isEnabled =  true
        self.btMoveMap.isEnabled = true
        
        
        self.btFrameBottom.isEnabled = false
        self.btFrameTop.isEnabled = false
        self.btFrameRight.isEnabled = false
        self.btFrameLeft.isEnabled = false
        
        
        self.swithcMoving.isEnabled = false
        
        self.carListLabelHeader.stringValue = "Cars"
        if let gScene = ShareData.shared.gamseSceme{
            gScene.touchEvent.action = .moveMap
            gScene.touchEvent.disPlayMode = .non
            gScene.removeTileCollection()
        }
    }
    func setDisPlayModeNon(){
        self.showPathToolView(show: false)
        self.removeCarListView()
        self.removePathListView()
        
       
        self.stepMapSizeH.isEnabled = false
        self.stepMapSizeW.isEnabled = false
        
        self.tfPropertyId.isEnabled = false
        self.tfPropertyName.isEnabled = false
        self.btPropertyType.isEnabled = false
        
        if(ShareData.shared.production){
            self.viToolbarBG.isHidden = true
        }else{
            self.viToolbarBG.isHidden = false
        }
        self.viCarsListBG.isHidden = true
        
        self.removeRoutineView()
        self.removeTimetableView()
        self.viTimeTableBG.isHidden = true
        
        
        self.btdefault.isEnabled = true
        self.btZoom.isEnabled =  true
        self.btMoveMap.isEnabled = true
        
        
        self.btFrameBottom.isEnabled = false
        self.btFrameTop.isEnabled = false
        self.btFrameRight.isEnabled = false
        self.btFrameLeft.isEnabled = false
        
        self.swithcMoving.isEnabled = false
        
        if let gScene = ShareData.shared.gamseSceme{
            gScene.touchEvent.action = .non
            gScene.touchEvent.disPlayMode = .non
            gScene.removeTileCollection()
        }
    }
    
    func setDisPlayModeEditMap(){
        self.showPathToolView(show: false)
        self.removeCarListView()
        self.removePathListView()
       
        
        self.stepMapSizeH.isEnabled = true
        self.stepMapSizeW.isEnabled = true
        
        self.tfPropertyId.isEnabled = true
        self.tfPropertyName.isEnabled = true
        self.btPropertyType.isEnabled = true
        
        if(ShareData.shared.production){
            self.viToolbarBG.isHidden = true
        }else{
            self.viToolbarBG.isHidden = false
        }
        self.viCarsListBG.isHidden = true
        
        self.removeRoutineView()
        self.removeTimetableView()
        self.viTimeTableBG.isHidden = true
        
        
        self.btdefault.isEnabled = true
        self.btZoom.isEnabled =  true
        self.btMoveMap.isEnabled = true
        
        
        self.btFrameBottom.isEnabled = true
        self.btFrameTop.isEnabled = true
        self.btFrameRight.isEnabled = true
        self.btFrameLeft.isEnabled = true
        
        self.swithcMoving.isEnabled = false
        
        if let gScene = ShareData.shared.gamseSceme{
            
            gScene.touchEvent.disPlayMode = .editMap
            gScene.addTileColleltion()
        }
    }
    
    
    
    func setDisplayModeEditPath(){
        self.removeCarListView()
        
        self.addPathListView()
        
      
        
        self.stepMapSizeH.isEnabled = false
        self.stepMapSizeW.isEnabled = false
        
        self.tfPropertyId.isEnabled = false
        self.tfPropertyName.isEnabled = false
        self.btPropertyType.isEnabled = false
        
        if(ShareData.shared.production){
            self.viToolbarBG.isHidden = true
        }else{
            self.viToolbarBG.isHidden = false
        }
        self.viCarsListBG.isHidden = false
        
        
        self.removeRoutineView()
        self.removeTimetableView()
        self.viTimeTableBG.isHidden = true
        
        
        self.btdefault.isEnabled = true
        self.btZoom.isEnabled =  true
        self.btMoveMap.isEnabled = true
        
        
        self.btFrameBottom.isEnabled = false
        self.btFrameTop.isEnabled = false
        self.btFrameRight.isEnabled = false
        self.btFrameLeft.isEnabled = false
        
        
        self.swithcMoving.isEnabled = false
        
        self.carListLabelHeader.stringValue = "Edit Path"
        if let gScene = ShareData.shared.gamseSceme{
            
            gScene.touchEvent.disPlayMode = .editMap
            gScene.addTileColleltion()
        }
    }
    
    
    func setDisplayModeEditTimeTable(){
        self.removeRoutineView()
        
        
        self.showPathToolView(show: false)
        self.addTimeTableView()
        self.removeCarListView()
        self.removePathListView()
        
        
      
        
        self.stepMapSizeH.isEnabled = false
        self.stepMapSizeW.isEnabled = false
        
        self.tfPropertyId.isEnabled = false
        self.tfPropertyName.isEnabled = false
        self.btPropertyType.isEnabled = false
        
        if(ShareData.shared.production){
            self.viToolbarBG.isHidden = true
        }else{
            self.viToolbarBG.isHidden = false
        }
        self.viCarsListBG.isHidden = true
        
        self.viTimeTableBG.isHidden = false
        
        
        self.btdefault.isEnabled = true
        self.btZoom.isEnabled =  true
        self.btMoveMap.isEnabled = true
        
        
        self.btFrameBottom.isEnabled = false
        self.btFrameTop.isEnabled = false
        self.btFrameRight.isEnabled = false
        self.btFrameLeft.isEnabled = false
        
        self.swithcMoving.isEnabled = false
        
        if let gScene = ShareData.shared.gamseSceme{
            
            gScene.touchEvent.disPlayMode = .non
            gScene.removeTileCollection()
        }
    }
    
    func setDisplayModeEditRoutine(){
        self.removeTimetableView()
        
        self.showPathToolView(show: false)
        self.addRoutineView()
        self.removeCarListView()
        self.removePathListView()
        
     
        
        self.stepMapSizeH.isEnabled = false
        self.stepMapSizeW.isEnabled = false
        
        self.tfPropertyId.isEnabled = false
        self.tfPropertyName.isEnabled = false
        self.btPropertyType.isEnabled = false
        
        if(ShareData.shared.production){
            self.viToolbarBG.isHidden = true
        }else{
            self.viToolbarBG.isHidden = false
        }
        self.viCarsListBG.isHidden = true
        
        self.viTimeTableBG.isHidden = false
        
        
        self.btdefault.isEnabled = true
        self.btZoom.isEnabled =  true
        self.btMoveMap.isEnabled = true
        
        
        self.btFrameBottom.isEnabled = false
        self.btFrameTop.isEnabled = false
        self.btFrameRight.isEnabled = false
        self.btFrameLeft.isEnabled = false
        
        self.swithcMoving.isEnabled = false
        
        if let gScene = ShareData.shared.gamseSceme{
            
            gScene.touchEvent.disPlayMode = .non
            gScene.removeTileCollection()
        }
    }
    
    
    func setUpIconToMode(mode:TouchEventModel.ActionEvent){
        
        switch mode {
        case .non:
            
            changeCursor(mode: .mdefault)
            
            self.setIconToDefault(enable: true)
            self.setIconToMoveMap(enable: false)
            self.setIconToZoom(enable: false)
            
            
            
            break
        case .moveMap:
            changeCursor(mode: .openHand)
            
            self.setIconToDefault(enable: false)
            self.setIconToMoveMap(enable: true)
            self.setIconToZoom(enable: false)
            break
        case .selectTileType:
            changeCursor(mode: .mdefault)
            
            self.setIconToDefault(enable: true)
            self.setIconToMoveMap(enable: false)
            self.setIconToZoom(enable: false)
            
            break
        case .zoom:
            changeCursor(mode: .zoomin)
            
            self.setIconToDefault(enable: false)
            self.setIconToMoveMap(enable: false)
            self.setIconToZoom(enable: true)
            
            break
        }
    }
    
    
    func setIconToDefault(enable:Bool){
        if(enable){
            (self.btdefault.cell as! NSButtonCell).isBordered = false
            (self.btdefault.cell as! NSButtonCell).backgroundColor = .lightGray
            self.btdefault.layer?.cornerRadius = 5
            self.btdefault.image = NSImage(named: NSImage.Name("mdefault"))
        }else{
            self.btdefault.layer?.cornerRadius = 0
            (self.btdefault.cell as! NSButtonCell).isBordered = true
            (self.btdefault.cell as! NSButtonCell).backgroundColor = .clear
            self.btdefault.image = NSImage(named: NSImage.Name("mdefault"))
        }
    }
    
    
    func setIconToMoveMap(enable:Bool){
        if(enable){
            (self.btMoveMap.cell as! NSButtonCell).isBordered = false
            (self.btMoveMap.cell as! NSButtonCell).backgroundColor = .lightGray
            self.btMoveMap.layer?.cornerRadius = 5
            self.btMoveMap.image = NSImage(named: NSImage.Name("baseline_pan_tool_white_18pt"))
        }else{
            self.btMoveMap.layer?.cornerRadius = 0
            (self.btMoveMap.cell as! NSButtonCell).isBordered = true
            (self.btMoveMap.cell as! NSButtonCell).backgroundColor = .clear
            self.btMoveMap.image = NSImage(named: NSImage.Name("baseline_pan_tool_black_18pt"))
        }
    }
    
    func setIconToZoom(enable:Bool){
        if(enable){
            (self.btZoom.cell as! NSButtonCell).isBordered = false
            (self.btZoom.cell as! NSButtonCell).backgroundColor = .lightGray
            self.btZoom.layer?.cornerRadius = 5
            self.btZoom.image = NSImage(named: NSImage.Name("zoom-in"))
        }else{
            self.btZoom.layer?.cornerRadius = 0
            (self.btZoom.cell as! NSButtonCell).isBordered = true
            (self.btZoom.cell as! NSButtonCell).backgroundColor = .clear
            self.btZoom.image = NSImage(named: NSImage.Name("zoom-in"))
        }
    }
    
    
    func changeCursor(mode:GameView.CursorsType) {
        
        skView.cursorType = mode
        NSCursor.pointingHand.set()
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - action property
    
    @IBAction func tapOnPropertyAddPath(_ sender: Any) {
    }
    
    @IBAction func tapOnPropertyType(_ sender: NSPopUpButton) {
        
        self.propertyModel.tapOnStationType(sender: sender)
    }
    
    
    func selectOnCells(cells:[TileCell]){
        self.propertyModel.selectOnCell(cells:cells)
        
        switch self.displayMode {
        case .non:
            break;
        case .hideToolBar:
            break;
        case .editMap:
            
            break
        case .editPath:
            self.pathEventSelectCell(cells: cells)
            break
        case .editTimeTable:
            break
        case .editRoutine:
            break
        case .editCars:
            break
        }
    }
    
    
    // MARK: - action cars
    @IBAction func tapOnAddCar(_ sender: Any) {
        
        switch self.displayMode {
        case .non:
            break;
        case .hideToolBar:
            break;
        case .editMap:
            break
        case .editPath:
            
            self.addNewPathItem()
            break
        case .editTimeTable:
            break
        case .editRoutine:
            break
        case .editCars:
            self.tapOnAddCar()
            break
        }
        
    }
    
    
    @IBAction func tapOnRemoveCar(_ sender: Any) {
        switch self.displayMode {
        case .non:
            break;
        case .hideToolBar:
            break;
        case .editMap:
            break
        case .editPath:
            self.removePathItem()
            break
        case .editTimeTable:
            break
        case .editRoutine:
            break
        case .editCars:
            self.tapOnDeleteCar()
            break
        }
    }
    
    
    
    
    // MARK: - Routine
    func addRoutineView(){
        
        if(self.myRoutineView == nil){
            self.myRoutineView = RoutineView(frame: NSRect(x: 0, y: 0, width: 800, height: 320))
            self.viTimeTableBG.addSubview(self.myRoutineView)
            
            
            self.myRoutineView.viTimeList.model = self.routineModel
            self.myRoutineView.viTimeList.myCollection.reloadData()
      
        }
    }
    
    func removeRoutineView(){
        if(self.myRoutineView != nil){
            
            self.myRoutineView.removeAllSubView()
            
            self.myRoutineView.removeFromSuperview()
            self.myRoutineView = nil
        }
    }
    
    
    // MARK: - Time Table
    
    func addTimeTableView(){
        
        if(self.myTimeTableView == nil){
            self.myTimeTableView = TimeTableView(frame: NSRect(x: 0, y: 0, width: 800, height: 320))
       
            self.viTimeTableBG.addSubview(self.myTimeTableView)
           
            
            
            self.myTimeTableView.viTimeList.model = self.timeTableModel
            self.myTimeTableView.viTimeList.myCollection.reloadData()
        }
    }
    
    func removeTimetableView(){
        if(self.myTimeTableView != nil){
            
            self.myTimeTableView.removeAllSubView()
            
            self.myTimeTableView.removeFromSuperview()
            self.myTimeTableView = nil
        }
    }
    
    
    
    
    
    // MARK: - window toolbar menu
    
    
    func hideMenuProduction(){
    
        if(ShareData.shared.production == true){
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.windowEdit_EditMap.isEnabled = false
            appDelegate.windowEdit_EditMap.isHidden = true
            appDelegate.windowEdit_OpenToolBar.isHidden = true
            appDelegate.windowEdit_HideToolBar.isHidden = false
            
            appDelegate.windowMenuPreference.isHidden = true
            appDelegate.windowHostSetting.isHidden = true
            
            if(self.enableOpenMapMenu){
                appDelegate.windowMap.isHidden = false
                appDelegate.windowMap_Open.isHidden = false
                appDelegate.windowMap_Save.isHidden = false
            }else{
                appDelegate.windowMap.isHidden = true
                appDelegate.windowMap_Open.isHidden = true
                appDelegate.windowMap_Save.isHidden = true
            }
            appDelegate.windowEdit_EditMap.isHidden = true
            appDelegate.windowEdit_EditPath.isHidden = true
            
            
            self.showPathToolView(show: false)
//            self.setDisPlayModeHideToolBar()
        }
    }
    @IBAction func windowOpenMap(_ sender:NSMenu){
        
        // 1
        guard let window = view.window else { return }
        
        // 2
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["rmap"]
        
        // 3
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                // 4
                guard let filePath = panel.url else {
                    return
                }
                
                print(filePath)
                self.savePath = filePath
                self.openSaveMapWith(filePathUrl: filePath)
                
                
            }
        }
    }
    
    
    func getDefaultMapDataPath()->URL?{
      
        let urlPath = Bundle.main.url(forResource: "defaultMap", withExtension: "rmap")
        
        return urlPath
    }
    
    func getHelpPath()->URL?{
      
        let urlPath = Bundle.main.url(forResource: "Usermanual_TH", withExtension: "pdf")
        
        return urlPath
    }
    
    
    
    func openSaveMapWith(filePathUrl:URL){
        do {
            let contents = try Data(contentsOf: filePathUrl)
            //print(contents)
            
            
            if let gameScene = ShareData.shared.gamseSceme{
                gameScene.removeNotUseNode(remove: false)
                gameScene.backgroundColor = .app_BackgroundEdit
            }
            self.setDisPlayModeHideToolBar()
            self.readSaveData(contents: contents)
            
            self.setDisPlayModeHideToolBar()
            
        } catch {
            // contents could not be loaded
        }
    }
    
    @IBAction func windowSaveMap(_ sender:NSMenu){
        
        print("windowSaveMap")
        
        
        
        if(model.bufferMapData != nil){
            self.loadOnlyMapDataWith(dic: model.bufferMapData)
        }
        // init save data
        //---
        
        let saveDataDic:[String:Any] = self.getMapdataDic()
        
        print(saveDataDic)
        
        
        let json = try! JSONSerialization.data(withJSONObject: saveDataDic, options: .prettyPrinted)
        
        // guard let strJson:String = String(data: json, encoding: .utf8) else { return }
        
        
        // 1
        guard let window = view.window else { return }
        // 2
        let panel = NSSavePanel()
        
        // 3
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
        
        if(self.savePath != nil){
            //panel.directoryURL = self.savePath
            
            let fileDirectory = self.savePath!.deletingLastPathComponent()
            
            panel.directoryURL = fileDirectory
            
        }
        
        var firename:String = "map.rmap"
        if let laseName = self.savePath{
            let str:String = laseName.absoluteString
            
            let arSTR = str.components(separatedBy: "/")
            if let la = arSTR.last{
                firename = la
            }
        }
        
        panel.nameFieldStringValue = firename
        panel.allowedFileTypes = ["rmap"]
        panel.canCreateDirectories = true
        // panel.showsHiddenFiles = true
        
        
        
        
        // 3
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK {
                // 4
                guard let filePath = panel.url else {
                    return
                }
                print(filePath)
                
                self.savePath = filePath
                do {
                    try json.write(to: filePath)
                }catch {/* error handling here */
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
    }
    
    
    
    func updateTileIDToAllData(){
        
        if let gScene = ShareData.shared.gamseSceme{
            for arx in gScene.model.arCell{
                for cell in arx {
                    
                    for paths in self.pathListViewDataModel.arPath{
                        for pc in paths.setPath.values{
                            
                            if((cell.i == pc.i) && (cell.j == pc.j)){
                                pc.id = cell.id
                                pc.stationName = cell.stationName
                                
                                paths.addPath(path: pc)
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    //Routine Plan
                    for ttb in self.routineModel.arTimeTable{
                        for tb in ttb.arDetails{
                            if let path = tb.path{
                                for pc in path.setPath.values{
                                    
                                    if((cell.i == pc.i) && (cell.j == pc.j)){
                                        pc.id = cell.id
                                        pc.stationName = cell.stationName
                                        
                                        path.addPath(path: pc)
                                    }
                                }
                            }
                            
                            ///------------
                            if((cell.i == tb.station?.i) && (cell.j == tb.station?.j)){
                                tb.station?.id = cell.id
                                tb.station?.stationName = cell.stationName
                                
                            }
                            ///------------
                            if((cell.i == tb.fromStation?.i) && (cell.j == tb.fromStation?.j)){
                                tb.fromStation?.id = cell.id
                                tb.fromStation?.stationName = cell.stationName
                                
                            }
                            ///------------
                            if((cell.i == tb.toStation?.i) && (cell.j == tb.toStation?.j)){
                                tb.toStation?.id = cell.id
                                tb.toStation?.stationName = cell.stationName
                                
                            }
                            ///------------
                        }
                    }
                    
                }
                
            }
            
        }
    }
    
    
    func getMapdataDic()->[String:Any]{
        
        
        let newSaveData:SaveMapDataModel = SaveMapDataModel()
        newSaveData.mapH = self.model.mapSizeH
        newSaveData.mapW = self.model.mapSizeW
        
        
        if let gScene = ShareData.shared.gamseSceme{
            
            for arx in gScene.model.arCell{
                for cell in arx {
                    
                    let tileDic = cell.getTileDataMode()
                    newSaveData.arCell.append(tileDic)
                    
                }
                
            }
        }
        //--
        self.updateTileIDToAllData()
        //---
        newSaveData.arPath = self.pathListViewDataModel.arPath
        
        newSaveData.timeTable = self.timeTableModel.arRoutine
        newSaveData.routinePlan = self.routineModel.arTimeTable
        
        newSaveData.arCars = self.carListViewDataModel.arCars
        
        
        
        return newSaveData.getDicData()
    }
    
    
    func loadOnlyMapDataWith(dic:[String:Any]) {
        
        let newMap:SaveMapDataModel = SaveMapDataModel(fields: dic)
        //Read map tile data
        if let gScene = ShareData.shared.gamseSceme {
            if let mapNode = gScene.mapNode{
                gScene.model.updateMapData(arData: newMap.arCell, width: newMap.mapW, height: newMap.mapH, toMapNode: mapNode)
            }
        }
        
    }
    
    
    
    func loadSaveAllDataDataWith(dic:[String:Any]) {
        
        self.model.bufferMapData = nil
        
        let newMap:SaveMapDataModel = SaveMapDataModel(fields: dic)
        
        self.model.mapSizeW = newMap.mapW
        self.model.mapSizeH = newMap.mapH
        
        
        self.stepMapSizeW.integerValue = newMap.mapW
        self.stepMapSizeH.integerValue = newMap.mapH
        
        print("map size >>")
        print("\(self.stepMapSizeW.integerValue), \(self.stepMapSizeH.integerValue)")
        
        
        //Read map tile data
        if let gScene = ShareData.shared.gamseSceme {
            if let mapNode = gScene.mapNode{
                gScene.model.updateMapData(arData: newMap.arCell, width: newMap.mapW, height: newMap.mapH, toMapNode: mapNode)
            }
            
            gScene.zoomToFitSize()
        }
        
        
        
        
        
        //ReadPath
        self.pathListViewDataModel.lastSelect = -1
        self.pathListViewDataModel.bufferCellSelect = nil
        self.pathListViewDataModel.arPath = newMap.arPath
        
        //read time table
        self.timeTableModel.arRoutine = newMap.timeTable
        
        //read routine table
        self.routineModel.arTimeTable = newMap.routinePlan
        
        //read Cars list
        self.carListViewDataModel.arCars = newMap.arCars
        
        
        
        
        //update display
        self.tfMapSizeH.integerValue = newMap.mapH
        self.tfMapSizeW.integerValue = newMap.mapW
        
        
        
        
    }
    
    
    
    func readSaveData(contents:Data){
        do{
            let reData:[String:Any]? = try JSONSerialization.jsonObject(with: contents, options: []) as? [String:Any]
            
            
            if let reData = reData{
                
                
                print(reData)
                self.loadSaveAllDataDataWith(dic: reData)
                
                
                
            }else{
                // contents could not be loaded
                
            }
        }catch{
            // contents could not be loaded
        }
    }
    
    @IBAction func windowEditShowToolBar(_ sender:NSMenu){
        self.setupDisplayToMode(dMode: .non)
    }
    @IBAction func windowEditHideToolBar(_ sender:NSMenu){
        self.setupDisplayToMode(dMode: .hideToolBar)
    }
    
    @IBAction func windowEditMap(_ sender:NSMenu){
        self.setupDisplayToMode(dMode: .editMap)
    }
    
    @IBAction func windowEditPath(_ sender:NSMenu){
        self.setupDisplayToMode(dMode: .editPath)
    }
    
    @IBAction func windowEditTimeTable(_ sender:NSMenu){
        self.setupDisplayToMode(dMode: .editTimeTable)
        
    }
    
    
    @IBAction func windowEditRoutine(_ sender:NSMenu){
        
        self.setupDisplayToMode(dMode: .editRoutine)
    }
    
    
    
    @IBAction func windowEditCar(_ sender:NSMenu){
        
        print("windowEditCar")
        self.setupDisplayToMode(dMode: .editCars)
    }
    
    
    
    @IBAction func windowRunSimulator(_ sender:NSMenu){
        
        print("windowRunControll")
        self.startRunWithSimulator()
    }
    
    
    func startRunWithSimulator() {
        
        DatabaseService.shared.clearAllData()
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
        
        if(self.trainControllerRuning == false){
            
            if(self.runController(mode: .simulator)){
                self.trainControllerRuning = true
                
                self.showCarsMenu(show: true)
                self.selectControllCatMenuOpen(sender: nil)
                self.lbControlDisplayStatus.stringValue = "Simmulator"
                self.viControlDisplayStatus.isHidden = false
                
                
                appDelegate.windowMap.isEnabled = false
                appDelegate.windowEdit.isEnabled = false
                
                appDelegate.windowControllerRunHardware.isEnabled = false
                appDelegate.windowControllerRunHardware.isHidden = true
                appDelegate.windowControllerRunSimulator.isEnabled = false
                appDelegate.windowControllerRunSimulator.isHidden = true
                
                
                appDelegate.windowControllerPauseContinute.isEnabled = true
                appDelegate.windowControllerPauseContinute.isHidden = false
                appDelegate.windowControllerReset.isEnabled = true
                appDelegate.windowControllerReset.isHidden = false
                
                appDelegate.windowOpenLog.isEnabled = false
                appDelegate.windowOpenLog.isHidden = true
                
                
                appDelegate.windowControllerPauseContinute.title = "System Emergency Break"
                
                self.btStopCar.title = "System Emergency Break"
                
                self.setDisPlayModeHideToolBar()
            }
            
            return
        }
        
    }
    
    
    @IBAction func windowRunHardware(_ sender:NSMenu){
        
        DatabaseService.shared.clearAllData()
        
        
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
        
        if(self.trainControllerRuning == false){
            
            if(self.runController(mode: .controll)){
                self.trainControllerRuning = true
                
                self.showCarsMenu(show: true)
                self.selectControllCatMenuOpen(sender: nil)
                self.lbControlDisplayStatus.stringValue = "Hardware"
                self.viControlDisplayStatus.isHidden = false
                
                
                appDelegate.windowMap.isEnabled = false
                appDelegate.windowEdit.isEnabled = false
                
                appDelegate.windowControllerRunHardware.isEnabled = false
                appDelegate.windowControllerRunHardware.isHidden = true
                appDelegate.windowControllerRunSimulator.isEnabled = false
                appDelegate.windowControllerRunSimulator.isHidden = true
                appDelegate.windowControllerPauseContinute.isEnabled = true
                appDelegate.windowControllerPauseContinute.isHidden = false
                appDelegate.windowControllerReset.isEnabled = true
                appDelegate.windowControllerReset.isHidden = false
                
                appDelegate.windowOpenLog.isEnabled = false
                appDelegate.windowOpenLog.isHidden = true
                
                
                appDelegate.windowControllerPauseContinute.title = "System Emergency Break"
                self.btStopCar.title = "System Emergency Break"
                
                self.setDisPlayModeHideToolBar()
            }
            
            return
        }
        
        
        
  
        
  
    }
    
    @IBAction func windowPauseRun(_ sender:NSMenu){
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
        
    
        
        if(cooldinater.controllStatus == .runing){
            
            cooldinater.stopAll()
            cooldinater.pauseTimer()
            appDelegate.windowControllerPauseContinute.title = "Continue"
            
            self.btStopCar.title = "Continue"
        }else{
            cooldinater.continueSimulator()
            appDelegate.windowControllerPauseContinute.title = "System Emergency Break"
            
            self.btStopCar.title = "System Emergency Break"
        }
    }
    
    @IBAction func windowResetRun(_ sender:NSMenu){
        
        
        cooldinater.stopAll()
        self.resetController()
        
    }
    
    @IBAction func windowOpenLogLocation(_ sender:NSMenu){
        
        // 1
        guard let window = view.window else { return }
        DatabaseService.shared.openDataBase(window: window)
    }
    
    
    
    @IBAction func windowOpenHelpPDF(_ sender:NSMenu){
        
        guard let url = self.getHelpPath() else { return }
        
        
        NSWorkspace.shared.open([url],
                                withAppBundleIdentifier:"com.apple.Safari",
                                options: [],
                                additionalEventParamDescriptor: nil,
                                launchIdentifiers: nil)
    }
    
    
    
    func runController(mode:Coordinater.Mode)->Bool{
        
        
        
        for car in self.carListViewDataModel.arCars{
            car.resetRunTime()
        }
        
        cooldinater.runSimulator(cars: self.carListViewDataModel.arCars, inMode: mode)
        return true
    }
    
    
    
    func resetController(){
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
       
        cooldinater.resetSimulater()
        
        self.showCarsMenu(show: false)
        self.viControlDisplayStatus.isHidden = true
        
        appDelegate.windowMap.isEnabled = true
        appDelegate.windowEdit.isEnabled = true
        appDelegate.windowControllerRunHardware.isEnabled = true
        appDelegate.windowControllerRunSimulator.isEnabled = true
        appDelegate.windowControllerPauseContinute.isEnabled = false
        appDelegate.windowControllerReset.isEnabled = false
        
        appDelegate.windowControllerRunHardware.isHidden = false
        appDelegate.windowControllerRunSimulator.isHidden = false
        appDelegate.windowControllerPauseContinute.isHidden = true
        appDelegate.windowControllerReset.isHidden = true
        
        appDelegate.windowOpenLog.isEnabled = true
        appDelegate.windowOpenLog.isHidden = false
        
        
        appDelegate.windowControllerPauseContinute.title = "System Emergency Break"
        self.btStopCar.title = "System Emergency Break"
        
        
        self.trainControllerRuning = false
    }
    
    
    
    @IBAction func windowCarsMenu(_ sender:NSMenu){
        
      
        
    }
    
    
    func showCarsMenu(show:Bool){
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
        
        if(show){
            
            if let menu = appDelegate.windowCarsListMenu{
                menu.removeAllItems()
                
                //NSMenuItem(title: "Duplicate", action: #selector(self.popupDuplicate), keyEquivalent: "")
                
//                for i in 0..<self.carListViewDataModel.arCars.count{
//                    let car = self.carListViewDataModel.arCars[i]
//                    let newMenuItem:NSMenuItem = NSMenuItem(title: car.name, action:  #selector(self.selectControllCatMenu), keyEquivalent: "")
//                    newMenuItem.tag = i
//
//                    menu.addItem(newMenuItem)
//                }
//
//
//                let line:NSMenuItem = NSMenuItem.separator()
//                menu.addItem(line)
                
                
                let btClose:NSMenuItem = NSMenuItem(title: "Open", action:  #selector(self.selectControllCatMenuOpen), keyEquivalent: "")
                
                menu.addItem(btClose)
            }
            

            
            
            
            appDelegate.windowCarsControllMenu.isEnabled = true
            appDelegate.windowCarsControllMenu.isHidden = false
          
            
            
        }else{
       
            
           appDelegate.windowCarsListMenu.removeAllItems()
            
            appDelegate.windowCarsControllMenu.isEnabled = false
            appDelegate.windowCarsControllMenu.isHidden = true
            showCarControllView(show: false)
        }
    }
    
    
    
    @objc private func selectControllCatMenu(sender:NSMenuItem){
        print("selectControllCatMenu \(sender.tag)")
        
        
        if((sender.tag >= 0) && (sender.tag < self.carListViewDataModel.arCars.count)){
            let car = self.carListViewDataModel.arCars[sender.tag]
            
            self.showCarControllView(show: true)
        }else{
            self.showCarControllView(show: false)
        }
        
  
    }
    
    
    @objc private func selectControllCatMenuOpen(sender:NSMenuItem?){
        self.showCarControllView(show: true)
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        if let menu = appDelegate.windowCarsListMenu{
            menu.removeAllItems()
            let btClose:NSMenuItem = NSMenuItem(title: "Close", action:  #selector(self.selectControllCatMenuClose), keyEquivalent: "")
            menu.addItem(btClose)
        }
    }
    
    @objc private func selectControllCatMenuClose(sender:NSMenuItem){
        self.showCarControllView(show: false)
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        if let menu = appDelegate.windowCarsListMenu{
            menu.removeAllItems()
            let btClose:NSMenuItem = NSMenuItem(title: "Open", action:  #selector(self.selectControllCatMenuOpen), keyEquivalent: "")
            menu.addItem(btClose)
        }
    }
    
    
    @IBAction func tapOnStopCar(_ sender: Any) {
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        
       
    
        var stopBTTitle:String = "System Emergency Break"
        
        if(cooldinater.controllStatus == .runing){
            
            cooldinater.stopAll()
//            coordinate.pauseTimer()
            
            cooldinater.controllStatus = .emercencyBreak
            appDelegate.windowControllerPauseContinute.title = "Continue"
            
            stopBTTitle = "Continue"
        }else{
            cooldinater.continueSimulator()
            appDelegate.windowControllerPauseContinute.title = "System Emergency Break"
            
        }
        
        
        
        

        self.btStopCar.title = stopBTTitle
        if let mutableAttributedTitle = btStopCar.attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: mutableAttributedTitle.length))
            btStopCar.attributedTitle = mutableAttributedTitle
        }
        
    }
    
    
    func setDisplayEmergenct() {
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.windowControllerPauseContinute.title = "Continue"
        
        let stopBTTitle = "Continue"
        self.btStopCar.title = stopBTTitle
        if let mutableAttributedTitle = btStopCar.attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: mutableAttributedTitle.length))
            btStopCar.attributedTitle = mutableAttributedTitle
        }
    }
    
    func setupEmergencyBreagButton(){
        
        self.viStopCarBG.wantsLayer = true
        self.viStopCarBG.layer?.cornerRadius = 5
        self.viStopCarBG.layer?.borderWidth = 1
        self.viStopCarBG.layer?.borderColor = NSColor.app_red.cgColor
        self.viStopCarBG.layer?.backgroundColor = NSColor.app_red1.cgColor
        
        let stopBTTitle:String = "System Emergency Break"

        self.btStopCar.title = stopBTTitle
        if let mutableAttributedTitle = btStopCar.attributedTitle.mutableCopy() as? NSMutableAttributedString {
            mutableAttributedTitle.addAttribute(.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: mutableAttributedTitle.length))
            btStopCar.attributedTitle = mutableAttributedTitle
        }
        
    }
    
    
    // MARK: - Function Helper
    func getAllTimeTableRoutineChoiceList(carIndex:NSInteger) -> [TimeTableRoutineModel] {
        //self.timeTableModel.arRoutine
        
        var choices:[TimeTableRoutineModel] = [TimeTableRoutineModel]()
        
        
        
        
        for i in 0..<self.timeTableModel.arRoutine.count{
            
            let ttb = self.timeTableModel.arRoutine[i]
            var have:Bool = false
           
            for j in 0..<self.carListViewDataModel.arCars.count{
                let car = self.carListViewDataModel.arCars[j]
                if(carIndex != j){
                    if(car.timeTableRoutineId == ttb.id){
                        have = true
                        break
                    }
                }
            }
            
            if(have == false){
                choices.append(ttb)
            }
            
        }
        
        
        return choices
        
    }
    
    func getTimeTableRoutineWith(timeTableRoutineId:NSInteger)->TimeTableRoutineModel?{
        var ans:TimeTableRoutineModel? = nil
        
        for item in self.timeTableModel.arRoutine{
            if(item.id == timeTableRoutineId){
                ans = item
                break
            }
        }
        
        return ans
    }
    

    
    
    
}

// MARK: - NSTextFieldDelegate

extension ViewController:NSTextFieldDelegate{
    
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        if let txtFld = obj.object as? NSTextField {
            
            
            switch txtFld.tag {
            case 201:
                
                self.tfMapSizeW.integerValue = txtFld.integerValue
                self.stepMapSizeW.integerValue = txtFld.integerValue
                
                self.changeMapSize()
                break
            case 202:
                self.tfMapSizeH.integerValue = txtFld.integerValue
                self.stepMapSizeH.integerValue = txtFld.integerValue
                
                self.changeMapSize()
                break
                
            case textFieldID.propertyId.rawValue, textFieldID.propertyName.rawValue:
                self.propertyModel.updateDataToCell()
                break
                
            case textFieldID.pathMessage.rawValue:
                
                self.pathEventChangeMessage(message: txtFld.integerValue)
                
                break
            case textFieldID.junctionLight.rawValue:
                
                    
                if(self.displayMode == .editMap){
                    self.propertyModel.updateDataToCell()
                }else if(self.displayMode == .editPath){
                    if(self.pathListViewDataModel.bufferCellSelect != nil){
                        self.pathListViewDataModel.bufferCellSelect?.junctionLight = self.lbJunctionLight.integerValue
                    }
                    
                    self.pathListViewDataModel.updatePathDisPlay()
                }
                
                break
            default:
                break
            }
        }
    }
    
    
    
}






