//
//  TimeTableDetailListView.swift
//  RailWay03
//
//  Created by T2P mac mini on 28/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa


@objc protocol TimeTableDetailListViewDelegate {
    @objc optional func selectTimeTableDetailAt(index:NSInteger)
    
    @objc optional func arriveDateChange(tag:NSInteger, arrive:Date)
    @objc optional func dewellTimeChange(tag:NSInteger, dewell:NSInteger)
    @objc optional func durationTimeChange(tag:NSInteger, duration:NSInteger)
    @objc optional func selectStation(tag:NSInteger, station:TileCellDataModel)
    
}


class TimeTableDetailListView: NSView {
    
    var scrollView:NSScrollView! = nil
    
    var myCollection:NSCollectionView! = nil
    
    
    let cellSize:CGSize = CGSize(width: 576, height: 40)
    
    
    
    var arDetail:[TimeTableDetailDataModel] = [TimeTableDetailDataModel]()
    
    
    var delegate:TimeTableDetailListViewDelegate? = nil
    
    
    
    var selectAt:NSInteger = -1
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
        
        if(myCollection == nil){
            
            
            
            let collectionFrame:CGRect = CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.height)
            self.myCollection = NSCollectionView(frame: collectionFrame)
            
            // 1
            let flowLayout = NSCollectionViewFlowLayout()
            flowLayout.itemSize = self.cellSize
            flowLayout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 0)
            flowLayout.minimumInteritemSpacing = 0.0
            flowLayout.minimumLineSpacing = 0.0
            flowLayout.scrollDirection = .vertical
            self.myCollection.collectionViewLayout = flowLayout
            // 2
            self.wantsLayer = true
            self.layer?.backgroundColor = .clear
            self.myCollection.wantsLayer = true
            
            
            
            
            // 3
            self.myCollection.layer?.backgroundColor = NSColor.clear.cgColor
            
            
            
            self.myCollection.delegate = self
            self.myCollection.dataSource = self
            
            self.myCollection.autoresizingMask = .none
            
            self.myCollection.enclosingScrollView?.wantsLayer = true
            self.myCollection.enclosingScrollView?.hasHorizontalScroller = false
            self.myCollection.enclosingScrollView?.hasVerticalScroller = true
            
            self.myCollection.enclosingScrollView?.backgroundColor = NSColor.clear
            self.myCollection.backgroundColors = [NSColor.clear]
            self.myCollection.enclosingScrollView?.documentView?.wantsLayer = true
            self.myCollection.enclosingScrollView?.documentView?.layer?.backgroundColor = NSColor.clear.cgColor
            self.myCollection.allowsMultipleSelection = false
            self.myCollection.allowsEmptySelection = true
            self.myCollection.isSelectable = true
            
            
            
            self.scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width , height: self.frame.height))
            self.scrollView.wantsLayer = true
            self.scrollView.layer?.backgroundColor = .clear
            scrollView.documentView = self.myCollection
            self.addSubview(scrollView)
            
            
            
            self.layer?.shadowRadius = 3
            self.layer?.shadowOffset = CGSize.zero
            self.layer?.shadowColor = NSColor.app_space_blue.cgColor
            self.layer?.shadowOpacity = 0.2
            
            
            self.myCollection.frame = collectionFrame
            
            
            
        }
        
        
        DispatchQueue.main.async {
            self.myCollection.wantsLayer = true
            
            self.myCollection.reloadData()
            
        }
    }
    
    
    
    func removeCollection(){
        
        if(self.myCollection != nil){
            self.myCollection.delegate = nil
            self.myCollection.dataSource = nil
            
            self.myCollection.removeFromSuperview()
            self.myCollection = nil
        }
        self.wantsLayer = true
    }
    
    
    
    
    func selectPath(index:NSInteger){
        
        if let mvc = ShareData.shared.masterVC{
            
            if((index >= 0) && (index < self.arDetail.count)){
                
                
                
                let showAtIndex:NSInteger = index
//                if((showAtIndex == (self.arDetail.count - 1)) && (self.arDetail.count >= 2)){
//                    showAtIndex = index - 1
//                }
                
                let detail = self.arDetail[showAtIndex]
                
                if let p = self.arDetail[showAtIndex].path{
                    
                    if let f = detail.fromStation, let t = detail.station {
                        if(f.i < t.i){
                            p.bufferRevertDirection = false
                        }else{
                            p.bufferRevertDirection = true
                        }
                    }
                    
                    
                    mvc.updateDisplayWithPath(paths: [p])
                }else{
                    mvc.updateDisplayWithPath(paths: [])
                }
                
            }else{
                mvc.updateDisplayWithPath(paths: [])
            }
        }
        
    }
    
    
    
    
    func selectCellAt(index:NSInteger){
        
        if((index >= 0) && (index < self.arDetail.count)){
            
            if(self.selectAt != index){
                
                let lastIndex:IndexPath = IndexPath(item: self.selectAt, section: 0)
                if let cell = self.myCollection.item(at: lastIndex) as? TimeTableDatailV2Cell{
                    cell.setSelectState(select: false)
                    
                    self.selectPath(index: -1)
                }
            }
            
            self.selectAt = index
            
            if((self.selectAt >= 0) && (self.selectAt < self.arDetail.count)){
                
                let selectIndex:IndexPath = IndexPath(item: self.selectAt, section: 0)
                if let cell = self.myCollection.item(at: selectIndex) as? TimeTableDatailV2Cell{
                    cell.setSelectState(select: true)
                }
            }
            
            
        }else{
            self.selectAt = -1
        }
        
        
        self.selectPath(index: self.selectAt)
    }
    
    
    
    
}



extension TimeTableDetailListView:NSCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        
        let size:CGSize = self.cellSize
        
        
        
        return size
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

//mark - NSCollectionViewDataSource, NSCollectionViewDelegate
extension TimeTableDetailListView:NSCollectionViewDataSource, NSCollectionViewDelegate{
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arDetail.count
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let cellitem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimeTableDatailV2Cell"), for: indexPath)
        guard let cell = cellitem as? TimeTableDatailV2Cell else {
            
            return cellitem
        }
        
        if((indexPath.item >= 0) && (indexPath.item < arDetail.count)){
            let item = arDetail[indexPath.item]
            
            
            
            if let mvc = ShareData.shared.masterVC{
                
                let listStation = mvc.pathListViewDataModel.getStationCanBe(cell: item.fromStation)
                
                cell.updateStationList(stations: listStation, CanEmpty: true)
                
                if((indexPath.item == 0) && (self.arDetail.count > 1) && (item.toStation != nil)){
                    let listStationF = mvc.pathListViewDataModel.getStationCanBe(cell: item.toStation)
                    
                    cell.updateStationList(stations: listStationF, CanEmpty: false)
                }
            }
            
            
            if let station = item.station{
                cell.btPath.setTitle(station.id)
            }else{
                cell.btPath.setTitle("-")
            }
            
            
            if let station = item.toStation{
                cell.lbToStation.stringValue = station.id
            }else{
                cell.lbToStation.stringValue = "-"
            }
            //cell.depart.dateValue = item.depart ?? Date()
            
            cell.tfDewell.integerValue = item.dewell
            cell.tfDuration.integerValue = item.duration
            
            if(indexPath.item <  (arDetail.count - 1)){
                cell.btPath.isEnabled = false
            }else{
                cell.btPath.isEnabled = true
            }
            
            
            if(ShareData.shared.production == false){
                if((indexPath.item == 0) && (self.arDetail.count > 1) && (item.toStation != nil)){
                    cell.btPath.isEnabled = true
                }
            }
            
            
        }
      
        
        if(indexPath.item == self.selectAt){
            cell.setSelectState(select: true)
        }else{
            cell.setSelectState(select: false)
        }
        cell.myTag = indexPath.item
        cell.tfDewell.tag = indexPath.item
        cell.tfDewell.delegate = self
        cell.tfDuration.tag = 1000 + indexPath.item
        cell.tfDuration.delegate = self
        
        //cell.arrive.tag = indexPath.item
        //cell.depart.tag = indexPath.item
        cell.btPath.tag = indexPath.item
        
        cell.arriveDateChangeCallBack = {[weak self](tag, date) in
            
            if let s = self{
                if((tag >= 0) && (tag < s.arDetail.count)){
                    //s.arDetail[tag].arrive = date
                    
                    
                    s.selectCellAt(index: tag)
                }
                
                if let de = s.delegate{
                    de.arriveDateChange?(tag: tag, arrive: date)
                }
            }
            
        }
        
        
        
        
        cell.tapOnStationCallBack = {[weak self](tag, station) in
            
            
            if let s = self{
                if((tag >= 0) && (tag < s.arDetail.count)){
                    
                    
                    if let de = s.delegate{
                        de.selectStation?(tag: tag, station: station)
                    }
                    
                }
            }
        }
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        if let selectIndex = indexPaths.first{
            print(selectIndex.item)
            self.selectCellAt(index: selectIndex.item)
            
            
            if let de = self.delegate{
                de.selectTimeTableDetailAt?(index: selectIndex.item)
            }
        }
    }

    func reloadDewellTimeDisplayAt(indexPath:IndexPath){
        
        
        
        
        let cellitem = self.myCollection.item(at: indexPath)
        guard let cell = cellitem as? TimeTableDatailV2Cell else {
            return
        }
        
        
        if((indexPath.item >= 0) && (indexPath.item < arDetail.count)){
        let item = arDetail[indexPath.item]
            
            cell.tfDewell.integerValue = item.dewell
            cell.tfDuration.integerValue = item.duration
        }
        
    }
}



// MARK: - NSTextFieldDelegate

extension TimeTableDetailListView:NSTextFieldDelegate{
    
    
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        if let txtFld = obj.object as? NSTextField {
            
            txtFld.becomeFirstResponder()
            
            if((txtFld.tag >= 0) && (txtFld.tag < self.arDetail.count)){
                
                var dewellTime:NSInteger = txtFld.integerValue
                
                if(dewellTime < 0){
                    dewellTime = 0
                }
                
                
                if let de = self.delegate{
                    
                    de.dewellTimeChange?(tag: txtFld.tag, dewell: dewellTime)
                    
                }
                
                
            }else if(txtFld.tag >= 1000){
                
                let tfIndex:NSInteger = txtFld.tag - 1000
                if((tfIndex >= 0) && (tfIndex < self.arDetail.count)){
                    
                    var duration:NSInteger = txtFld.integerValue
                    
                    if(duration < 0){
                        duration = 0
                    }
                    
                    if let de = self.delegate{
                        
                        de.durationTimeChange?(tag: tfIndex, duration: duration)
                        
                    }
                }
                
                
                
            }
            
            
            
            self.selectCellAt(index: -1)
        }
    }
    
    
    
}

