//
//  CarsController.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 7/12/2563 BE.
//  Copyright © 2563 BE T2P. All rights reserved.
//

import Foundation
import Cocoa


class CarsController: NSView {
    var scrollView:NSScrollView! = nil
    
    var myCollection:NSCollectionView! = nil
    
    
    let cellSize:CGSize = CGSize(width: 200, height: 140)
    
    var model:CarsListViewDataModel = CarsListViewDataModel()
    
    
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
            
            
            
            let collectionFrame:CGRect = CGRect(x: 5, y: 5, width: self.frame.width - 10 , height: self.frame.height - 10)
            self.myCollection = NSCollectionView(frame: collectionFrame)
            
            // 1
            let flowLayout = NSCollectionViewFlowLayout()
            flowLayout.itemSize = self.cellSize
            flowLayout.sectionInset = NSEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            flowLayout.minimumInteritemSpacing = 0.0
            flowLayout.minimumLineSpacing = 0.0
            flowLayout.scrollDirection = .horizontal
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
            self.myCollection.enclosingScrollView?.hasHorizontalScroller = true
            self.myCollection.enclosingScrollView?.hasVerticalScroller = false
            
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
    
   
    
    func updateData(){
        
        DispatchQueue.main.async {
            self.myCollection.wantsLayer = true
            
            self.myCollection.reloadData()
            
        }
    }
    
    
}

extension CarsController:NSCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        
        let size:CGSize = self.cellSize
        
        
        
        return size
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}

//mark - NSCollectionViewDataSource, NSCollectionViewDelegate
extension CarsController:NSCollectionViewDataSource, NSCollectionViewDelegate{
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
     
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return model.arCars.count
 
    }
    
    
    
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CarControllerCell"), for: indexPath)
        guard let cell = item as? CarControllerCell else {
          
            return item
        }
        
        if((indexPath.item >= 0) && (indexPath.item < model.arCars.count)){
            let car = model.arCars[indexPath.item]
            cell.updateDateBy(car: car)
        }

        return cell
        
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    
        
        

        
        
        
        if let selectIndex = indexPaths.first{
            //print(selectIndex.item)
            
            //self.selectCarAt(index: selectIndex.item)
        }
        
        
        
    }
    
    
    
}

