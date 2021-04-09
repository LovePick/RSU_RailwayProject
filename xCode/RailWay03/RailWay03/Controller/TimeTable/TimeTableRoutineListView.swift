//
//  TimeTableRoutineListView.swift
//  RailWay03
//
//  Created by T2P mac mini on 17/2/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa

@objc protocol TimeTableRoutineListViewDelegate {
    @objc optional func routineListViewSelectTimeTableAt(item:TimeTableRoutineModel?)
    
    func routineListViewDuplicateData(index:NSInteger)
    func routineListViewRemoveData(index:NSInteger)
}

class TimeTableRoutineListView: NSView {

    
    
    var scrollView:NSScrollView! = nil
     
     var myCollection:NSCollectionView! = nil
     
     
     let cellSize:CGSize = CGSize(width: 200, height: 40)
     
     
     
     var model:TimeTableRoutineViewModel = TimeTableRoutineViewModel()
     
     
     var delegate:TimeTableRoutineListViewDelegate? = nil
     
    
     
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
           
           self.model.sortByName()
            self.myCollection.wantsLayer = true
            
            self.myCollection.reloadData()
            
        }
         
     }
    
}


extension TimeTableRoutineListView:NSCollectionViewDelegateFlowLayout{
    
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
extension TimeTableRoutineListView:NSCollectionViewDataSource, NSCollectionViewDelegate{
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.arRoutine.count
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TimeTableCell"), for: indexPath)
        
    
        guard let cell = item as? TimeTableCell else {
            
            return item
        }
        
        if((indexPath.item >= 0) && (indexPath.item < model.arRoutine.count)){
            
            let item = model.arRoutine[indexPath.item]
            
            cell.tfTitle.stringValue = item.name
            cell.tfTitle.tag = indexPath.item
            if(indexPath.item == model.selectAtIndex){
                cell.setSelectState(select: true)
            }else{
                cell.setSelectState(select: false)
            }
        }
      
        cell.tfTitle.delegate = self
        
        cell.myTag = indexPath.item
        cell.callBackClick = {[weak self](tag) in self?.clickOnCellAtIndex(index: tag)}
        
        cell.callBackDuplicate = {[weak self](tag) in
            if let de = self?.delegate{
                de.routineListViewDuplicateData(index: tag)
                
            }
            
        }
        cell.callBackRemove = {[weak self](tag) in
            if let de = self?.delegate{
                de.routineListViewRemoveData(index: tag)
                
            }
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        if let selectIndex = indexPaths.first{
            
            self.clickOnCellAtIndex(index: selectIndex.item)
        }

    }
    
    
    
    
    func clickOnCellAtIndex(index:NSInteger){
        
        if((self.model.selectAtIndex >= 0) && (self.model.selectAtIndex < self.model.arRoutine.count) && (self.model.selectAtIndex != index)){
            
            let lastIndex:IndexPath = IndexPath(item: self.model.selectAtIndex, section: 0)
            if let cell = self.myCollection.item(at: lastIndex) as? TimeTableCell{
                cell.setSelectState(select: false)
            }
        }
        
        
        
        self.model.selectAtIndex = index
        
        let newIndex:IndexPath = IndexPath(item: index, section: 0)
        if let cell = self.myCollection.item(at: newIndex) as? TimeTableCell{
            cell.setSelectState(select: true)
        }
        
        //-----------------------
        
        if let de = self.delegate{
            if((index >= 0) && (index < self.model.arRoutine.count)){
                let item = self.model.arRoutine[index]
                
                de.routineListViewSelectTimeTableAt?(item: item)
            }else{
                de.routineListViewSelectTimeTableAt?(item: nil)
            }
        }
    }
    
}

// MARK: - NSTextFieldDelegate

extension TimeTableRoutineListView:NSTextFieldDelegate{
    
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        if let txtFld = obj.object as? NSTextField {
            
            if((txtFld.tag >= 0) && (txtFld.tag < self.model.arRoutine.count)){
                
             
                self.model.arRoutine[txtFld.tag].name = txtFld.stringValue
            }
        }
    }
    
    
    
}
