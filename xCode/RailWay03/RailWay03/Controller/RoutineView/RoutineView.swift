//
//  RoutineView.swift
//  RailWay03
//
//  Created by T2P mac mini on 28/1/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class RoutineView: NSView {
    
    private var viTimeTitleBG:NSView! = nil
    private var viTimeTitleHeaderBG:NSView! = nil
    private var viTimeTitleFootersBG:NSView! = nil
    
    private var viDetailBG:NSView! = nil
    private var viDetailHeaderBG:NSView! = nil
    private var viDetailFootersBG:NSView! = nil
    
    
    
    private var viBoxAddTime:NSView! = nil
    private var viBoxRemoveTime:NSView! = nil
    
    private var btAddTime:NSButton! = nil
    private var btRemoveTime:NSButton! = nil
    
    
    
    private var viBoxAddDetail:NSView! = nil
    private var viBoxRemoveDetail:NSView! = nil
    
    private var btAddDetail:NSButton! = nil
    private var btRemoveDetail:NSButton! = nil
    
    private var btCloseWindow:NSButton! = nil
    
    
    var viTimeList:TimeTableListView! = nil
    var viDetailList:TimeTableDetailListView! = nil
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setup()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        setup()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    func setup(){
        let h:CGFloat = self.frame.height - 16
        
        let headerY:CGFloat = h - 25
        
        let collectionH:CGFloat = h - 50
        
        if(viTimeTitleBG == nil){
            viTimeTitleBG = NSView(frame: NSRect(x: 8, y: 8, width: 200, height: h))
            
            viTimeTitleBG.wantsLayer = true
            viTimeTitleBG.layer?.backgroundColor = NSColor.clear.cgColor
            viTimeTitleBG.layer?.borderWidth = 1
            viTimeTitleBG.layer?.borderColor = NSColor.app_space_blue.cgColor
            viTimeTitleBG.layer?.cornerRadius = 5
            
            
            self.addSubview(viTimeTitleBG)
            
        }
        
        if(viDetailBG == nil){
            viDetailBG = NSView(frame: NSRect(x: 216, y: 8, width: 576, height: h))
            
            viDetailBG.wantsLayer = true
            viDetailBG.layer?.backgroundColor = NSColor.clear.cgColor
            viDetailBG.layer?.borderWidth = 1
            viDetailBG.layer?.borderColor = NSColor.app_space_blue.cgColor
            viDetailBG.layer?.cornerRadius = 5
            
            
            self.addSubview(viDetailBG)
        }
        
        
        if(viTimeTitleHeaderBG == nil){
            viTimeTitleHeaderBG = NSView(frame: NSRect(x: 0, y: headerY, width: 200, height: 25))
            
            viTimeTitleHeaderBG.wantsLayer = true
            viTimeTitleHeaderBG.layer?.backgroundColor = NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
            viTimeTitleHeaderBG.layer?.borderWidth = 1
            viTimeTitleHeaderBG.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            
            
            viTimeTitleBG.addSubview(viTimeTitleHeaderBG)
            
            
            let blStation:NSTextField = NSTextField(frame: NSRect(x: 0, y: 4.5, width: 200, height: 16))
            blStation.textColor = .app_space_blue
            blStation.stringValue = "Route Name"
            blStation.isEditable = false
            blStation.isBezeled = false
            blStation.drawsBackground = false
            blStation.alignment = .center
            
            blStation.wantsLayer = true
            blStation.backgroundColor = .clear
            viTimeTitleHeaderBG.addSubview(blStation)
            
            
        }
        
        
        if(viDetailHeaderBG == nil){
            viDetailHeaderBG = NSView(frame: NSRect(x: 0, y: headerY, width: 576, height: 25))
            
            viDetailHeaderBG.wantsLayer = true
            viDetailHeaderBG.layer?.backgroundColor = NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
            viDetailHeaderBG.layer?.borderWidth = 1
            viDetailHeaderBG.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            
            
            viDetailBG.addSubview(viDetailHeaderBG)
            
            
            
            let blStation:NSTextField = NSTextField(frame: NSRect(x: 50, y: 4.5, width: 302, height: 16))
            blStation.textColor = .app_space_blue
            blStation.stringValue = "Station"
            blStation.isEditable = false
            blStation.isBezeled = false
            blStation.drawsBackground = false
            
            blStation.wantsLayer = true
            blStation.backgroundColor = .clear
            viDetailHeaderBG.addSubview(blStation)
            
            
            
            
            
            let lbDewell:NSTextField = NSTextField(frame: NSRect(x: 310, y: 4.5, width: 58, height: 16))
            lbDewell.textColor = .app_space_blue
            lbDewell.stringValue = "Dwell time"
            lbDewell.isEditable = false
            lbDewell.isBezeled = false
            lbDewell.drawsBackground = false
            lbDewell.wantsLayer = true
            lbDewell.backgroundColor = .clear
            viDetailHeaderBG.addSubview(lbDewell)
            
            
            let lbDuration:NSTextField = NSTextField(frame: NSRect(x: 368, y: 4.5, width: 58, height: 16))
            lbDuration.textColor = .app_space_blue
            lbDuration.stringValue = "Duration"
            lbDuration.isEditable = false
            lbDuration.isBezeled = false
            lbDuration.drawsBackground = false
            lbDuration.wantsLayer = true
            lbDuration.backgroundColor = .clear
            viDetailHeaderBG.addSubview(lbDuration)
            
            
            
            let lbNextStation:NSTextField = NSTextField(frame: NSRect(x: 426, y: 4.5, width: 100, height: 16))
            lbNextStation.alignment = .center
            lbNextStation.textColor = .app_space_blue
            lbNextStation.stringValue = "End Station"
            lbNextStation.isEditable = false
            lbNextStation.isBezeled = false
            lbNextStation.drawsBackground = false
            lbNextStation.wantsLayer = true
            lbNextStation.backgroundColor = .clear
            viDetailHeaderBG.addSubview(lbNextStation)
            
        }
        
        
        if(viTimeTitleFootersBG == nil){
            viTimeTitleFootersBG = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 25))
            
            viTimeTitleFootersBG.wantsLayer = true
            viTimeTitleFootersBG.layer?.backgroundColor = NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
            viTimeTitleFootersBG.layer?.borderWidth = 1
            viTimeTitleFootersBG.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            
            
            viTimeTitleBG.addSubview(viTimeTitleFootersBG)
        }
        
        
        if(viDetailFootersBG == nil){
            viDetailFootersBG = NSView(frame: NSRect(x: 0, y: 0, width: 576, height: 25))
            
            viDetailFootersBG.wantsLayer = true
            viDetailFootersBG.layer?.backgroundColor = NSColor.app_space_blue.withAlphaComponent(0.1).cgColor
            viDetailFootersBG.layer?.borderWidth = 1
            viDetailFootersBG.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            
            
            viDetailBG.addSubview(viDetailFootersBG)
        }
        
        
        
        
        
        ////------------
        if(viBoxAddTime == nil){
            viBoxAddTime = NSView(frame: NSRect(x: 0, y: 0, width: 25, height: 25))
            viBoxAddTime.wantsLayer = true
            viBoxAddTime.layer?.backgroundColor = NSColor.clear.cgColor
            viBoxAddTime.layer?.borderWidth = 1
            viBoxAddTime.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            viTimeTitleFootersBG.addSubview(viBoxAddTime)
        }
        
        if(viBoxRemoveTime == nil){
            viBoxRemoveTime = NSView(frame: NSRect(x: 24, y: 0, width: 25, height: 25))
            viBoxRemoveTime.wantsLayer = true
            viBoxRemoveTime.layer?.backgroundColor = NSColor.clear.cgColor
            viBoxRemoveTime.layer?.borderWidth = 1
            viBoxRemoveTime.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            viTimeTitleFootersBG.addSubview(viBoxRemoveTime)
        }
        
        
        if(btAddTime == nil){
            if let image:NSImage = NSImage(named: NSImage.Name("baseline_add_white_18pt")){
                btAddTime = NSButton(image: image, target: self, action: #selector(tapOnAddTime))
                btAddTime.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                (self.btAddTime.cell as! NSButtonCell).isBordered = false
                (self.btAddTime.cell as! NSButtonCell).backgroundColor = NSColor.clear
                viBoxAddTime.addSubview(btAddTime)
            }
        }
        
        
        if(btRemoveTime == nil){
            if let image:NSImage = NSImage(named: NSImage.Name("baseline_remove_white_18pt")){
                btRemoveTime = NSButton(image: image, target: self, action: #selector(tapOnRemoveTime))
                btRemoveTime.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                
                
                (self.btRemoveTime.cell as! NSButtonCell).isBordered = false
                (self.btRemoveTime.cell as! NSButtonCell).backgroundColor = NSColor.clear
                viBoxRemoveTime.addSubview(btRemoveTime)
            }
        }
        
        ////------------Detail
        
        if(viBoxAddDetail == nil){
            viBoxAddDetail = NSView(frame: NSRect(x: 0, y: 0, width: 25, height: 25))
            viBoxAddDetail.wantsLayer = true
            viBoxAddDetail.layer?.backgroundColor = NSColor.clear.cgColor
            viBoxAddDetail.layer?.borderWidth = 1
            viBoxAddDetail.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            viDetailFootersBG.addSubview(viBoxAddDetail)
        }
        
        if(viBoxRemoveDetail == nil){
            viBoxRemoveDetail = NSView(frame: NSRect(x: 24, y: 0, width: 25, height: 25))
            viBoxRemoveDetail.wantsLayer = true
            viBoxRemoveDetail.layer?.backgroundColor = NSColor.clear.cgColor
            viBoxRemoveDetail.layer?.borderWidth = 1
            viBoxRemoveDetail.layer?.borderColor = NSColor.app_space_blue.cgColor
            
            viDetailFootersBG.addSubview(viBoxRemoveDetail)
        }
        
        
        if(btAddDetail == nil){
            if let image:NSImage = NSImage(named: NSImage.Name("baseline_add_white_18pt")){
                btAddDetail = NSButton(image: image, target: self, action: #selector(tapOnAddDetail))
                btAddDetail.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                (self.btAddDetail.cell as! NSButtonCell).isBordered = false
                (self.btAddDetail.cell as! NSButtonCell).backgroundColor = NSColor.clear
                viBoxAddDetail.addSubview(btAddDetail)
            }
        }
        
        
        if(btRemoveDetail == nil){
            if let image:NSImage = NSImage(named: NSImage.Name("baseline_remove_white_18pt")){
                btRemoveDetail = NSButton(image: image, target: self, action: #selector(tapOnRemoveDetail))
                btRemoveDetail.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                
                
                (self.btRemoveDetail.cell as! NSButtonCell).isBordered = false
                (self.btRemoveDetail.cell as! NSButtonCell).backgroundColor = NSColor.clear
                viBoxRemoveDetail.addSubview(btRemoveDetail)
            }
        }
        
        
        
        
        
        ///------  time list
        
        if(viTimeList == nil){
            viTimeList = TimeTableListView(frame: NSRect(x: 0, y: 25, width: 200, height: collectionH))
            viTimeTitleBG.addSubview(viTimeList)
            viTimeList.delegate = self
        }
        
        viTimeList.setup()
        
        ///------  TimeTableDetailListView
        
        
        if(viDetailList == nil){
            viDetailList = TimeTableDetailListView(frame: NSRect(x: 0, y: 25, width: 576, height: collectionH))
            viDetailBG.addSubview(viDetailList)
            viDetailList.delegate = self
        }
        viDetailList.setup()
        //-------
        
        
        
        if(btCloseWindow == nil){
            if let image:NSImage = NSImage(named: NSImage.Name("close")){
                btCloseWindow = NSButton(image: image, target: self, action: #selector(tapOnCloseWindow))
                btCloseWindow.frame = CGRect(x: self.frame.width - 25, y: self.frame.height - 25, width: 25, height: 25)
                
                
                (self.btCloseWindow.cell as! NSButtonCell).isBordered = false
                (self.btCloseWindow.cell as! NSButtonCell).backgroundColor = NSColor.clear
                self.addSubview(btCloseWindow)
            }
        }
        
        self.wantsLayer = true
        //self.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        
    }
    
    
    
    
    func removeAllSubView(){
        
        if(self.viTimeList != nil){
            self.viTimeList.delegate = nil
            self.viTimeList.removeFromSuperview()
            self.viTimeList = nil
        }
        
        
        
        if(self.btAddDetail != nil){
            self.btAddDetail.removeFromSuperview()
            self.btAddDetail = nil
            
        }
        
        if(self.btRemoveDetail != nil){
            self.btRemoveDetail.removeFromSuperview()
            self.btRemoveDetail = nil
            
        }
        
        
        if(self.btAddTime != nil){
            self.btAddTime.removeFromSuperview()
            self.btAddTime = nil
            
        }
        
        if(self.btRemoveTime != nil){
            self.btRemoveTime.removeFromSuperview()
            self.btRemoveTime = nil
            
        }
        
        if(self.viBoxAddDetail != nil){
            self.viBoxAddDetail.removeFromSuperview()
            self.viBoxAddDetail = nil
            
        }
        
        if(self.viBoxRemoveDetail != nil){
            self.viBoxRemoveDetail.removeFromSuperview()
            self.viBoxRemoveDetail = nil
            
        }
        
        if(self.viBoxRemoveTime != nil){
            self.viBoxRemoveTime.removeFromSuperview()
            self.viBoxRemoveTime = nil
            
        }
        
        if(self.viBoxAddTime != nil){
            self.viBoxAddTime.removeFromSuperview()
            self.viBoxAddTime = nil
            
        }
        
        
        
        if(self.viTimeTitleFootersBG != nil){
            self.viTimeTitleFootersBG.removeFromSuperview()
            self.viTimeTitleFootersBG = nil
            
        }
        
        if(self.viDetailFootersBG != nil){
            self.viDetailFootersBG.removeFromSuperview()
            self.viDetailFootersBG = nil
            
        }
        
        
        if(self.viTimeTitleHeaderBG != nil){
            self.viTimeTitleHeaderBG.removeFromSuperview()
            self.viTimeTitleHeaderBG = nil
            
        }
        
        if(self.viDetailHeaderBG != nil){
            self.viDetailHeaderBG.removeFromSuperview()
            self.viDetailHeaderBG = nil
            
        }
        
        
        if(self.viTimeTitleBG != nil){
            self.viTimeTitleBG.removeFromSuperview()
            self.viTimeTitleBG = nil
            
        }
        
        if(self.viDetailBG != nil){
            self.viDetailBG.removeFromSuperview()
            self.viDetailBG = nil
            
        }
    }
    
    //mark - Action
    
    @objc func tapOnCloseWindow(sender:NSButton){
        print("tapOnCloseWindow")
        if let ms = ShareData.shared.masterVC{
            ms.setupDisplayToMode(dMode: .hideToolBar)
        }
    }
    
    
    
    @objc func tapOnAddTime(sender:NSButton){
        print("tapOnAddTime")
        self.viTimeList.model.addNewTimeTable()
        
        self.viTimeList.model.selectAtTimeTableIndex = self.viTimeList.model.arTimeTable.count - 1
        self.viTimeList.myCollection.reloadData()
        
        self.viTimeList.clickOnCellAtIndex(index: self.viTimeList.model.selectAtTimeTableIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let lastIndex = self.viTimeList.model.getLastIndex()
            
            self.viTimeList.myCollection.scrollToItems(at: [lastIndex], scrollPosition: .centeredVertically)
        }
        
        
        
        
    }
    
    @objc func tapOnRemoveTime(sender:NSButton){
        
        let answer = dialogOKCancel(question: "Delete the routine plan?", text: "Are you sure you would like to delete the select routine plan?")
        
        if(answer){
            self.viTimeList.model.removeSelectItem()
            self.viTimeList.myCollection.reloadData()
            self.viDetailList.arDetail = [TimeTableDetailDataModel]()
            self.viDetailList.myCollection.reloadData()
            
            self.viDetailList.selectPath(index: -1)
        }
        
        print("tapOnRemoveTime")
    }
    
    
    
    @objc func tapOnAddDetail(sender:NSButton){
        print("tapOnAddDetail")
        
   
            
        if((self.viTimeList.model.selectAtTimeTableIndex >= 0) && (self.viTimeList.model.selectAtTimeTableIndex < self.viTimeList.model.arTimeTable.count)){
            
            self.viTimeList.model.addNewDetail()
            
            if let time = self.viTimeList.model.getSelectTimeTable(){
                self.viDetailList.arDetail = time.arDetails
            }else{
                self.viDetailList.arDetail = [TimeTableDetailDataModel]()
            }
            
            self.viDetailList.myCollection.reloadData()
            
            
            
        }
        
    }
    
    @objc func tapOnRemoveDetail(sender:NSButton){
        print("tapOnRemoveDetail")
        
        if((self.viTimeList.model.selectAtTimeTableIndex >= 0) && (self.viTimeList.model.selectAtTimeTableIndex < self.viTimeList.model.arTimeTable.count)){
            
            self.viTimeList.model.removeLastDetail()
            
            if let time = self.viTimeList.model.getSelectTimeTable(){
                self.viDetailList.arDetail = time.arDetails
            }else{
                self.viDetailList.arDetail = [TimeTableDetailDataModel]()
            }
            
            self.viDetailList.myCollection.reloadData()
            
            self.viDetailList.selectPath(index: -1)
        }
    }
}



//mark - TimeTableListViewDelegate

extension RoutineView:TimeTableListViewDelegate{
    func selectTimeTableAt(item: TimeTableDataModel?) {
        
        viDetailList.myCollection.reloadData()
        viDetailList.myCollection.isSelectable = false
        viDetailList.removeCollection()
        
        
        
        if let tb = item{
            self.viDetailList.selectAt = -1
            self.viDetailList.selectPath(index: -1)
            self.viDetailList.arDetail = tb.arDetails
           
            
        }else{
            self.viDetailList.arDetail = [TimeTableDetailDataModel]()
            
        }
        
        viDetailList.setup()
        self.viDetailList.myCollection.reloadData()
        self.viDetailList.myCollection.isSelectable = true
       
        
        
    }
    
    
    
    func duplicateData(index: NSInteger) {
        
        self.viTimeList.model.copyTimeTable(index: index)
        self.viTimeList.myCollection.reloadData()
        
        
    }
    
    func removeData(index: NSInteger) {
        let answer = dialogOKCancel(question: "Delete the routine plan?", text: "Are you sure you would like to delete this routine plan?")
        
        if(answer){
            self.viTimeList.model.removeTimetableAt(index: index)
            self.viTimeList.myCollection.reloadData()
            self.viDetailList.arDetail = [TimeTableDetailDataModel]()
            self.viDetailList.myCollection.reloadData()
            
            self.viDetailList.selectPath(index: -1)
            
        }
    }
}


//mark - TimeTableListViewDelegate

extension RoutineView:TimeTableDetailListViewDelegate{
    func selectTimeTableDetailAt(index:NSInteger){
        
    }
    
    func arriveDateChange(tag:NSInteger, arrive:Date){
        self.viTimeList.model.updateArriveTimeToTimedetail(timeDetailIndex: tag, timeArrive: arrive)
        
        self.reloadDataWithoutIndex(index: tag)
    }
    func dewellTimeChange(tag: NSInteger, dewell: NSInteger) {
        self.viTimeList.model.updateDewellTime(timeDetailIndex: tag, dewellTime: dewell)
        
        self.reloadDataWithoutIndex(index: tag)
    }
    
    func durationTimeChange(tag: NSInteger, duration: NSInteger) {
        
        self.viTimeList.model.updateDurationTime(timeDetailIndex: tag, duration: duration)
        
        self.reloadDataWithoutIndex(index: tag)
    }
    
    func selectStation(tag: NSInteger, station: TileCellDataModel) {
        
    
        self.viTimeList.model.setPathToDetail(tag: tag, station: station)
        
        self.reloadDataWithoutIndex(index: tag)
        
        self.viDetailList.selectPath(index: tag)
    }
    
    
    func reloadDataWithoutIndex(index:NSInteger){
        
        
        
        var arIndex:Set<IndexPath> = Set<IndexPath>()
        for i in 0..<self.viDetailList.arDetail.count{
            if(index != i){
                let newIndex:IndexPath = IndexPath(item: i, section: 0)
                arIndex.insert(newIndex)
            }
            
        }
        self.viDetailList.myCollection.reloadItems(at: arIndex)
        
        
        let id:IndexPath = IndexPath(item: index, section: 0)
        self.viDetailList.reloadDewellTimeDisplayAt(indexPath: id)
    }
}
