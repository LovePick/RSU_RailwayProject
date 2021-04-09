//
//  PathListView.swift
//  RailWay03
//
//  Created by T2P mac mini on 27/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

@objc protocol PathListViewDelegate {
    @objc optional func selectPathAt(view:PathListView ,index: NSInteger)
}

class PathListView: NSView {
    
    
    var scrollView:NSScrollView! = nil
    
    var myCollection:NSCollectionView! = nil
    
    
    let cellSize:CGSize = CGSize(width: 120, height: 80)
    
    
    
    var model:PathEditerModel = PathEditerModel()
    
    var delegate:PathListViewDelegate? = nil
    

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

extension PathListView:NSCollectionViewDelegateFlowLayout{
    
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
extension PathListView:NSCollectionViewDataSource, NSCollectionViewDelegate{
    
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.model.arPath.count
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PathCell"), for: indexPath)
        guard let cell = item as? PathCell else {
            
            return item
        }
        
        
        
        if((indexPath.item >= 0) && (indexPath.item < self.model.arPath.count)){
            let path = self.model.arPath[indexPath.item]
            
            cell.setSelectState(select: path.select)
            
            
            if(path.from == nil){
                cell.from.stringValue = "Please setup"
            }else{
                
                if(path.from.stationName != ""){
                    cell.from.stringValue = path.from.stationName
                }else{
                    cell.from.stringValue = path.from.id
                }
                
            }
            
            if(path.to == nil){
                cell.to.stringValue = "Please setup"
            }else{
                if(path.to.stationName != ""){
                    cell.to.stringValue = path.to.stationName
                }else{
                    cell.to.stringValue = path.to.id
                }
         
            }
            
            
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        
        
        
        
        
        
        if let selectIndex = indexPaths.first{
        
            
            if((self.model.lastSelect >= 0) && (self.model.lastSelect < self.model.arPath.count) && (self.model.lastSelect != selectIndex.item)){
                self.model.arPath[self.model.lastSelect].select = false
                
                let lastIndex:IndexPath = IndexPath(item: self.model.lastSelect, section: 0)
                self.myCollection.reloadItems(at: [lastIndex])
                
                self.model.lastSelect = -1
                
            }
            
            
            if((selectIndex.item >= 0) && (selectIndex.item < self.model.arPath.count)){
                self.model.arPath[selectIndex.item].select = !self.model.arPath[selectIndex.item].select
                
                if let de = self.delegate{
                    if(self.model.arPath[selectIndex.item].select){
                        self.model.lastSelect = selectIndex.item
                        de.selectPathAt?(view: self, index: selectIndex.item)
                    }else{
                        self.model.lastSelect = -1
                        de.selectPathAt?(view: self, index: -1)
                    }
                }
                
                
            }
            self.myCollection.reloadItems(at: [selectIndex])
            
            
        }
        
        
        
    }
    
}

