//
//  DatabaseService.swift
//  RailWay03
//
//  Created by Supapon Pucknavin on 22/5/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa
import RealmSwift

class BufferLastUpdate {
    var name:String = ""
    var time:Date? = nil
    
    init(_name:String, _time:Date?) {
        self.name = _name
        self.time = _time
    }
}
class DatabaseService {

    
    static let shared = DatabaseService()
    
    
    var realm:Realm? = nil
    init() {
        
        
        if let url = Realm.Configuration.defaultConfiguration.fileURL{
            do{
                try FileManager.default.removeItem(at: url)
            }catch{
                print(error.localizedDescription)
            }
        }
        
        
        
        do{
            self.realm = try Realm()
          
        }catch{
            print(error.localizedDescription)
        }
        
        
        
        
        self.clearAllData()
    }
    
  
    func clearAllData() {
        guard let rm = self.realm else {
            return
        }
        
        do{
            rm.beginWrite()
            rm.deleteAll()
            try rm.commitWrite()
        }catch{
            print(error.localizedDescription)
        }
    }
   
    
    func addLogToDataBase(data:RealmDataRecordModel) {
        
        guard let rm = self.realm else {
            return
        }
        
        do{
            rm.beginWrite()
            rm.add(data)
            try rm.commitWrite()
            
            let results = rm.objects(RealmDataRecordModel.self)
            print("Count: \(results.count)")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func openDataBase(window:NSWindow) {

        
        
        var arBufferLastUpdate:[BufferLastUpdate] = [BufferLastUpdate]()
        
        
        guard let realm = self.realm else { return }
        
        let myRecord = realm.objects(RealmDataRecordModel.self).sorted(byKeyPath: "time")
        
        print("=======")
//        print("Count : \(myRecord.count)")
        
        
        var strData:String = ""
        
        
        if(myRecord.count > 0){
            
            strData = "\(myRecord[0].getTextHeader())"
            
            var buffItem:BufferLastUpdate? = nil
            for row in myRecord{
                
                //----
                var have = false
                if(arBufferLastUpdate.count > 0){
                    for b in arBufferLastUpdate{
                        if b.name.lowercased() == row.train_name.lowercased() {
                            have = true
                            buffItem = b
                            break
                        }
                    }
                }
                
                if(have == false){
                    let newItem = BufferLastUpdate(_name: row.train_name, _time: row.time)
                    
                    arBufferLastUpdate.append(newItem)
                    buffItem = newItem
                }
                //----
                
                
                strData = "\(strData)\(row.getTextData(lase: buffItem?.time))"
                
                
                if let buffItem = buffItem{
                    buffItem.time = row.time
                }
            }
           
        }
        
        
        
        if let data = strData.data(using: .utf8){
            self.saveDataCSVToDisk(data: data, window: window)
        }
        
        
        print("=======")
        
//        if let relmPath = realm.configuration.fileURL {
//            self.showInFinder(url: relmPath)
//        }
    }
    
    
    func showInFinder(url: URL?){
        guard let url = url else { return }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    
    
    func saveDataCSVToDisk(data:Data, window:NSWindow){
        // 1
//        guard let window = view.window else { return }
        // 2
        let panel = NSSavePanel()
        
        // 3
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
    
        
        let firename:String = "record.csv"
      
        
        panel.nameFieldStringValue = firename
        panel.allowedFileTypes = ["csv"]
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
                
               
                do {
                    try data.write(to: filePath)
                }catch {/* error handling here */
                    print(error.localizedDescription)
                }
            }
        }
    }
}
