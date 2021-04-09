//
//  CarsListView.swift
//  RailWay03
//
//  Created by T2P mac mini on 23/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

@objc protocol CarsListViewDelegate {
    @objc optional func selectCarAt(view:CarsListView, index: NSInteger)
}


class CarsListView: NSView {

    var scrollView:NSScrollView! = nil
    
    var myCollection:NSCollectionView! = nil
    
    
    let cellSize:CGSize = CGSize(width: 170, height: 79)
    
    
    
    var model:CarsListViewDataModel = CarsListViewDataModel()
    
    var delegate:CarsListViewDelegate? = nil
    
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
            
            
            
            let collectionFrame:CGRect = CGRect(x: 10, y: 10, width: self.frame.width - 20 , height: self.frame.height - 20)
            self.myCollection = NSCollectionView(frame: collectionFrame)
            
            // 1
            let flowLayout = NSCollectionViewFlowLayout()
            flowLayout.itemSize = self.cellSize
            flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
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
    
   
    
    func updateData(){
        
        DispatchQueue.main.async {
            self.myCollection.wantsLayer = true
            
            self.myCollection.reloadData()
            
        }
    }
    
    
    
    func getCarSelect()->CarDataModel?{
        if((self.model.lastSelect >= 0) && (self.model.lastSelect < self.model.arCars.count)){
            return self.model.arCars[self.model.lastSelect]
        }else{
            return nil
        }
    }
    
    
    
    
    /*
    func selectCarAt(index:NSInteger){
        
        if((self.model.lastSelect >= 0) && (self.model.lastSelect < self.model.arCars.count) && (self.model.lastSelect != index)){
            self.model.arCars[self.model.lastSelect].select = false
            
            let lastIndex:IndexPath = IndexPath(item: self.model.lastSelect, section: 0)
            self.myCollection.reloadItems(at: [lastIndex])
            
            self.model.lastSelect = -1
            
        }
        
        
        if((index >= 0) && (index < self.model.arCars.count)){
            self.model.arCars[index].select = !self.model.arCars[index].select
            
            if let de = self.delegate{
                if(self.model.arCars[index].select){
                    de.selectCarAt?(view: self, index: index)
                }else{
                    de.selectCarAt?(view: self, index: -1)
                }
            }
            
            
        }
        
        
        self.model.lastSelect = index
        let selectIndex:IndexPath = IndexPath(item: index, section: 0)
      
        if let cell:CarsCell = self.myCollection.item(at: selectIndex) as? CarsCell{
            let car = self.model.arCars[index]
            cell.setSelectState(select: car.select)
        }
        
        
    }
    */
    
    
    
    
    func addChoiceTimeTable(carIndex:NSInteger)->[String]{
        
        var choices:[String] = [String]()
        choices.append("-")
        guard let ms = ShareData.shared.masterVC else {
            return choices
        }
        
        
        let ar = ms.getAllTimeTableRoutineChoiceList(carIndex: carIndex)
        
       
        for item in ar{
            choices.append(item.name)
        }
        
        return choices
    }
    
    func getTimeTableNameWithID(ttbID:NSInteger)->String{
        guard let ms = ShareData.shared.masterVC else {
            return "-"
        }
        
        guard let ttb = ms.getTimeTableRoutineWith(timeTableRoutineId: ttbID) else {
            return "-"
        }
        
       
        return ttb.name
        
    }
}



extension CarsListView:NSCollectionViewDelegateFlowLayout{
    
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
extension CarsListView:NSCollectionViewDataSource, NSCollectionViewDelegate{
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
     
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.model.arCars.count
 
    }
    
    
    
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CarsCell"), for: indexPath)
        guard let cell = item as? CarsCell else {
          
            return item
        }
        
        
        
        if((indexPath.item >= 0) && (indexPath.item < self.model.arCars.count)){
            let car = self.model.arCars[indexPath.item]
            
            cell.setSelectState(select: car.select)
            
            cell.lbTitle.stringValue = car.name
            
            
            cell.btTimeTable.removeAllItems()
            cell.btTimeTable.addItems(withTitles: self.addChoiceTimeTable(carIndex: indexPath.item))
            let getSelect = self.getTimeTableNameWithID(ttbID: car.timeTableRoutineId)
            cell.btTimeTable.selectItem(withTitle: getSelect)
            
            if(car.online){
                cell.lbOnlineMark.isHidden = false
            }else{
                cell.lbOnlineMark.isHidden = true
            }
        }else{
            cell.setSelectState(select: false)
            cell.lbOnlineMark.isHidden = true
        }
        
        cell.lbTitle.tag = indexPath.item
        cell.lbTitle.delegate = self
        cell.myTag = indexPath.item
        cell.lbTitle.isEditable = false
        
        cell.delegate = self
        
        
        
        
        
        return cell
        
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    
        
        

        
        
        
        if let selectIndex = indexPaths.first{
            //print(selectIndex.item)
            
            //self.selectCarAt(index: selectIndex.item)
        }
        
        
        
    }
    
    
    
}



// MARK: - NSTextFieldDelegate

extension CarsListView:NSTextFieldDelegate{
    
    
    
    func controlTextDidEndEditing(_ obj: Notification) {
        if let txtFld = obj.object as? NSTextField {
            
            if((txtFld.tag >= 0) && (txtFld.tag < self.model.arCars.count)){
                self.model.arCars[txtFld.tag].name = txtFld.stringValue
               
                
                let indexPath:IndexPath = IndexPath(item: txtFld.tag, section: 0)
                if let item:CarsCell = self.myCollection.item(at: indexPath) as? CarsCell{
                    item.lbTitle.isEditable = false
                }
            }
        }
    }
    
    
    
}
// MARK: - CarsCellDelegate

extension CarsListView:CarsCellDelegate{
    
    
    
    
    func selectCarTimeTableAt(cellTag:NSInteger, timeTableIndex: NSInteger){
       
    
        guard let ms = ShareData.shared.masterVC else {
            return
        }
        
        
        
    
        if((cellTag >= 0) && (cellTag < self.model.arCars.count)){
            
            let ar = ms.getAllTimeTableRoutineChoiceList(carIndex: cellTag)
            
            let ttbIndex = timeTableIndex - 1
            if((ttbIndex >= 0) && (ttbIndex < ar.count)){
                
                let ttb = ar[ttbIndex]
                
                self.model.arCars[cellTag].timeTableRoutineId = ttb.id
                
                if let firstDetail = ttb.getTimeTableDetailListData(allRoutineData: ms.routineModel.arTimeTable).first{
                    self.model.arCars[cellTag].timeDetail = firstDetail
                }else{
                    self.model.arCars[cellTag].timeDetail = nil
                }
                
                
            }else{
                self.model.arCars[cellTag].timeTableRoutineId = -1
                self.model.arCars[cellTag].timeDetail = nil
            }
            
            self.myCollection.reloadData()
            self.selectCarCell(cellTag: cellTag)
        }
    }
    
    
    func selectCarCell(cellTag:NSInteger){
        
        
        print(cellTag)
        
      
        var lastSelect:NSInteger = -1
        for i in 0..<self.model.arCars.count{
            if(self.model.arCars[i].select == true){
                lastSelect = i
            }
            
        }
        
        
        
        if((cellTag >= 0) && (cellTag < self.model.arCars.count)){
            
            
            
            for i in 0..<self.model.arCars.count{
                if(i != cellTag){
                    self.model.arCars[i].select = false
                }
                
            }
            
            let car = self.model.arCars[cellTag]
            
            car.select = !car.select
            
          
            let newIndex:IndexPath = IndexPath(item: cellTag, section: 0)
            
            
            if let cell:CarsCell = self.myCollection.item(at: newIndex) as? CarsCell{
                cell.setSelectState(select: car.select)
                
            }
            
        }
        
        
        
        if((lastSelect >= 0) && (lastSelect != cellTag)){
            if let cell:CarsCell = self.myCollection.item(at: lastSelect) as? CarsCell{
                cell.setSelectState(select: false)
                cell.lbTitle.resignFirstResponder()
                cell.lbTitle.isEditable = false
            }
        }
        model.lastSelect = cellTag
     
        guard let de = self.delegate else {
            return
        }
        
        if((cellTag >= 0) && (cellTag < self.model.arCars.count)){
            if(self.model.arCars[cellTag].select){
                de.selectCarAt?(view: self, index: cellTag)
            }else{
                de.selectCarAt?(view: self, index: -1)
            }
        }else{
            de.selectCarAt?(view: self, index: -1)
        }
        
    }
    
}


