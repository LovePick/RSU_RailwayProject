//
//  TimeTableDetailRoutsView.swift
//  RailWay03
//
//  Created by T2P mac mini on 17/2/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

class TimeTableDetailRoutsView: NSView {
    
    
    var scrollView:NSScrollView! = nil
    
    var myCollection:NSCollectionView! = nil
    
    
    let cellSize:CGSize = CGSize(width: 576, height: 40)
    
    var arRoutine:[RoutineDataModel] = [RoutineDataModel]()
    
    var selectAt:NSInteger = -1
    
    let shareData:ShareData = ShareData.shared
    
    
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
            
            
            DispatchQueue.main.async {
                self.myCollection.wantsLayer = true
                
                self.myCollection.reloadData()
                
            }
        }
        
    }
    
    func selectPath(index:NSInteger){
        
        
        
    }
    
    
    
    func selectCellAt(index:NSInteger){
        
        if((index >= 0) && (index < self.arRoutine.count)){
            
            if(self.selectAt != index){
                
                let lastIndex:IndexPath = IndexPath(item: self.selectAt, section: 0)
                if let cell = self.myCollection.item(at: lastIndex) as? TimeTableRoutineCell{
                    cell.setSelectState(select: false)
                    
                    self.selectPath(index: -1)
                }
            }
            
            self.selectAt = index
            
            if((self.selectAt >= 0) && (self.selectAt < self.arRoutine.count)){
                
                let selectIndex:IndexPath = IndexPath(item: self.selectAt, section: 0)
                if let cell = self.myCollection.item(at: selectIndex) as? TimeTableRoutineCell{
                    cell.setSelectState(select: true)
                }
            }
            
            
        }else{
            self.selectAt = -1
        }
        
        
        self.selectPath(index: self.selectAt)
    }
    
    
    
    
}




extension TimeTableDetailRoutsView:NSCollectionViewDelegateFlowLayout{
    
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
extension TimeTableDetailRoutsView:NSCollectionViewDataSource, NSCollectionViewDelegate{
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arRoutine.count
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let cellitem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimeTableRoutineCell"), for: indexPath)
        guard let cell = cellitem as? TimeTableRoutineCell else {
            
            return cellitem
        }
        
        let routine = self.arRoutine[indexPath.item]
        
        
        cell.myTag = indexPath.item
        cell.delegate = self
        
        
        cell.startTime.minDate = nil
        
        if let buff = routine.buffStartTime{
            cell.startTime.dateValue = buff
        }else{
            cell.startTime.dateValue = routine.startTime
        }
        
    
        
        
        cell.setSelectState(select: false)
        
        guard let ms = self.shareData.masterVC else {
            
            return cell
        }
        
     
        
        var lastTTB:TimeTableDataModel? = nil
        
        if(indexPath.item > 0){
            let lastRoutine = self.arRoutine[indexPath.item - 1]
            cell.startTime.minDate = lastRoutine.endTime
            
            if let buff = routine.buffStartTime{
                cell.startTime.dateValue = buff
            }else{
                cell.startTime.dateValue = routine.startTime
            }
//            cell.startTime.dateValue = routine.startTime
            
            lastTTB = ms.getTimeTableWith(ttbID: lastRoutine.timeTableID)
        }
        
        
        
        if let lttb = lastTTB{
            let arTTB = ms.getNextTimeTable(now: lttb)
            cell.updateRoutineChoice(choices: arTTB, CanEmpty: true)
        }else{
            var arTTB = ms.getNextTimeTable(now: nil)
            
            if(self.arRoutine.count > 1){
                let nextIndex:NSInteger = indexPath.item + 1
                if(nextIndex < self.arRoutine.count){
                    let lastRoutine = self.arRoutine[nextIndex]
                    lastTTB = ms.getTimeTableWith(ttbID: lastRoutine.timeTableID)
                    if let lttb = lastTTB{
                        arTTB = ms.getTimeTableTo(now: lttb)
                    }
                }
            }
            
            if((indexPath.item == 0) || (indexPath.item == self.arRoutine.count - 1)){
                cell.updateRoutineChoice(choices: arTTB, CanEmpty: false)
            }else{
                cell.updateRoutineChoice(choices: arTTB, CanEmpty: true)
            }
            
            
        }
        
        
        var ttbName:String = "-"
        var endStation:TileCellDataModel? = nil
        
        
        
        guard let timeTable = ms.getTimeTableWith(ttbID: routine.timeTableID) else {
            
            cell.btStepperLoopCount.isEnabled = false
            cell.lbStatus.stringValue = "-"
            cell.tfLoopCount.intValue = 0
            cell.tfLoopCount.isEnabled = false
            cell.startTime.isEnabled = true
            cell.setSelectState(select: false)
            cell.btRoutine.setTitle(ttbName)
            cell.btRoutine.isEnabled = true
            
            return cell
        }
        
        ttbName = timeTable.name
        
        if let lasts = timeTable.arDetails.last{
            endStation = lasts.station
        }
        
        
        
        cell.btRoutine.setTitle(ttbName)
        cell.tfLoopCount.intValue = Int32(routine.count)
        cell.btStepperLoopCount.intValue = Int32(routine.count)
        switch routine.timeTableStatus {
        case .noData:
            cell.btStepperLoopCount.isEnabled = false
            cell.lbStatus.stringValue = "-"
            cell.tfLoopCount.intValue = 0
            cell.btRoutine.intValue = 0
            cell.tfLoopCount.isEnabled = false
            cell.startTime.isEnabled = true
            break
        case .oneWay:
            
            cell.btStepperLoopCount.isEnabled = false
            
            if let ls = endStation{
                cell.lbStatus.stringValue = ls.id
            }else{
                cell.lbStatus.stringValue = "-"
            }
            
            cell.tfLoopCount.intValue = 1
            cell.btRoutine.intValue = 1
            cell.tfLoopCount.isEnabled = false
            cell.startTime.isEnabled = true
            
            break
        case .loop:
            
            
            if let ls = endStation{
                cell.lbStatus.stringValue = ls.id
            }else{
                cell.lbStatus.stringValue = "-"
            }
            
            cell.tfLoopCount.isEditable = true
            cell.tfLoopCount.intValue = Int32(routine.count)
            cell.btRoutine.intValue = Int32(routine.count)
            cell.startTime.isEnabled = true
            cell.btStepperLoopCount.isEnabled = true
            
            
            break
        }
        
        print(indexPath.item)
        if((indexPath.item == 0) || (indexPath.item == self.arRoutine.count - 1)){
         
            cell.btRoutine.isEnabled = true
            
            if(ShareData.shared.production == true){
                if((self.arRoutine.count > 1) && (indexPath.item == 0)){
                    cell.btRoutine.isEnabled = false
                }
            }
        }else{
       
            cell.btRoutine.isEnabled = false
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        if let selectIndex = indexPaths.first{
            print(selectIndex.item)
           // self.selectCellAt(index: selectIndex.item)
            //           if let de = self.delegate{
            //               de.selectTimeTableDetailAt?(index: selectIndex.item)
            //           }
        }
    }
    
    
}



// MARK: - NSTextFieldDelegate

extension TimeTableDetailRoutsView:NSTextFieldDelegate{
    
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        
        guard let txtFld = obj.object as? NSTextField else { return }
        
        
    }
    
    
    
}


// MARK: - TimeTableRoutineCellDelegate
extension TimeTableDetailRoutsView:TimeTableRoutineCellDelegate{
    
    
    func updateTimeRelation(index:NSInteger, time:Date){
        
        guard ((index >= 0) && (index < self.arRoutine.count)) else {
            return
        }

        let strTime = self.arRoutine[index].dateToStringTime(date: time)
        self.arRoutine[index].strStartTime = strTime
        let ajTime = self.arRoutine[index].stringTimeToDateToday(str: strTime)
        
        self.arRoutine[index].startTime = ajTime
        self.arRoutine[index].buffStartTime = ajTime

        guard let ms = self.shareData.masterVC else {
            return
        }
        
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var duration:NSInteger = 0
        
        var lastStart:Date = ajTime
        
        var arCollectionIndex:[IndexPath] = [IndexPath]()
        for i in index..<self.arRoutine.count{
            let rout = self.arRoutine[i]
            if let ttb = ms.getTimeTableWith(ttbID: rout.timeTableID){
                if(i > index){
                    let newStartTime = calendar.date(byAdding: .second, value: Int(duration), to: ajTime) ?? lastStart

                    
                    self.arRoutine[i].startTime = newStartTime
                    self.arRoutine[i].buffStartTime = newStartTime
                    
                    
                    let newIndex:IndexPath = IndexPath(item: i, section: 0)
                    arCollectionIndex.append(newIndex)
                }
                //ttb.updateStartTime(time: self.arRoutine[i].startTime)
                lastStart = self.arRoutine[i].startTime
                
                var useTime = ttb.getTimeDulation() * rout.count
                if(useTime <= 0){
                    useTime = ttb.getTimeDulation()
                }
                
                self.arRoutine[i].endTime = calendar.date(byAdding: .second, value: Int(useTime), to: lastStart) ?? lastStart
                
                self.arRoutine[i].strEndTime = self.arRoutine[i].dateToStringTime(date: self.arRoutine[i].endTime!)
                
                duration = duration + useTime
            }
        }
        
        
        print("Reload collection")
        
        self.myCollection.reloadItems(at: Set(arCollectionIndex))
        
    }
    
    
    func routineCellStartTimeChange(cell:TimeTableRoutineCell, time:Date){
        
        print(time)
        guard ((cell.myTag >= 0) && (cell.myTag < self.arRoutine.count)) else {
            return
        }

        self.updateTimeRelation(index: cell.myTag, time: time)

    }
    func routineCellSelectRountine(cell:TimeTableRoutineCell, ttb:TimeTableDataModel?){
        
        guard ((cell.myTag >= 0) && (cell.myTag < self.arRoutine.count)) else {
            return
        }
        
        guard let timeTable = ttb else {
            self.arRoutine[cell.myTag].timeTableID = 0
            self.arRoutine[cell.myTag].timeTableStatus = .noData
            return
        }
        
        
        self.arRoutine[cell.myTag].timeTableID = timeTable.id
        if let ms = self.shareData.masterVC{
            let allTB = ms.getNextTimeTable(now: nil)
            self.arRoutine[cell.myTag].loadTimeTableStatus(timeTables: allTB)
        }
        
        var time = self.arRoutine[cell.myTag].startTime
        
        if let buff = self.arRoutine[cell.myTag].buffStartTime {
            time = buff
        }
        self.updateTimeRelation(index: cell.myTag, time: time)
    
    }
    
    
    func routineCellLoopChangeValue(cell:TimeTableRoutineCell, value:NSInteger){
        guard ((cell.myTag >= 0) && (cell.myTag < self.arRoutine.count)) else {
            return
        }
        
        var newValue:NSInteger = value
        if(newValue < 1){
            newValue = 1
        }
        
        print("Count : \(value)")
        self.arRoutine[cell.myTag].count = newValue
        
        
        var time = self.arRoutine[cell.myTag].startTime
        if let buff = self.arRoutine[cell.myTag].buffStartTime {
            time = buff
        }
        
        self.updateTimeRelation(index: cell.myTag, time: time)
    }
    
}
