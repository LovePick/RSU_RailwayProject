//
//  CarDataModel.swift
//  RailWay03
//
//  Created by T2P mac mini on 23/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa

class CarDataModel: NSObject {
    
    enum CarPosition:NSInteger{
        case atStation = 0
        case onTheWay
        case arrive
    }
    
    
    enum ActiveStatus:NSInteger{
        case unknow = 0 // ไม่ทราบสถาณะ
        case dewell     //จอดรับผู้โดยสาร
        case waitDepart //รอออกรถ
        case onTheWay   //กำลังเดินทาง
        case arrived    //ถึงที่หมาย
        case emergencyStop  //หยุดรถฉุกเฉิน
        case stop       //รถหยุดวิ่ง / ไม่ทำงาน / จบการทำงาน
        case inProgress // อยู่ระหว่างประมวลผล
        case error
    }
    
    enum CarStatus:NSInteger{
        case unknow = 0
        case normal
        case delay
        case faster
    }
    
    enum ProgressStatus{
        case non
        case waitActive
        case active
        case done
        case end
    }
    
    var id:String = ""
    var name:String = ""
    var timeTableRoutineId:NSInteger = -1
    
    
    
    
    
    var select:Bool = false
    var position:CarPosition = .atStation
    var timeDetail:TimeTableDetailDataModel? = nil
    
    /*
     var from:TileCellDataModel? = nil
     var to:TileCellDataModel? = nil
     */
    
    var runAtRoutineIndex:NSInteger = 0
    
    var countRoutStep:NSInteger = 0
    
    var runArDetailIndex:NSInteger = 0
    
    
    
    var activeStatus:ActiveStatus = .unknow
    var lastActiveStatus:ActiveStatus = .unknow
    
    var progressStatus:ProgressStatus = .non
    
    var simulatorProgressFinish:Double = 0
    var simulatorProgressCount:Double = 0
    var simulatorProgressPerStep:Double = 0
    
    var inModeSimulator:Bool = true
    
    
    var priority:Double = 0
    
    
    var buffTimeToActive:Date? = nil
    
    
    var dataBaseLastStatus:ActiveStatus = .unknow
    
    var online:Bool = false
    var lastUpdate:Date = Date()
    
    var speed:Double = 0.50
    
    
    var maxSpeed:Double = 0.50
    
    
    
    override init() {
        super.init()
        
    }
    
    convenience init(fields:[String: Any]){
        
        self.init()
        
        
        self.readJson(fields: fields)
    }
    
    
    func readJson(fields:[String: Any]) {
        if let id = fields["id"] as? String{
            self.id = id
        }
        
        
        if let name = fields["name"] as? String{
            self.name = name
        }
        
        if let timeTableId = fields["timeTableId"] as? NSInteger{
            self.timeTableRoutineId = timeTableId
        }
        
        
    }
    
    
    
    func getDicData()->[String:Any]{
        var dicData:[String:Any] = [String:Any]()
        
        dicData["id"] = self.id
        dicData["name"] = self.name
        dicData["timeTableId"] = self.timeTableRoutineId
        
        return dicData
    }
    
    
    
    func getFromStation()->TileCellDataModel?{
        if let detail = self.timeDetail{
            if let from = detail.station{
                return from
            }
        }
        return nil
    }
    
    func getNextStation()->TileCellDataModel?{
        if let detail = self.timeDetail{
      
            if let to = detail.toStation{
                return to
            }
        }
        
        return nil
    }
    
    
    func broadcastData()->[String:Any]{
        var dicData:[String:Any] = [String:Any]()
        dicData["id"] = self.id
        dicData["name"] = self.name
        
        
        var direcTion:NSInteger = 0
        
        var f:TileCellDataModel? = nil
        var t:TileCellDataModel? = nil
        var line:String = "pink"
        
        
        if let detail = self.timeDetail{
            if let from = detail.station{
                dicData["from"] = from.id
                f = from
                t = from
                line = self.getLineWith(stationID: from.id)
               
            }
            
            if let to = detail.toStation{
                dicData["to"] = to.id
                t = to
                
            
            }
            
        }
        
        var pos:NSInteger = 0
        switch self.position {
        case .atStation:
            pos = 0
            break
        case .onTheWay:
            pos = 1
            break
        case .arrive:
            pos = 2
            break
            
        }
        dicData["position"] = pos
        dicData["status"] = self.activeStatus.rawValue
        
        
        if(self.speed > 1.0){
            self.speed = 1.0
        }
        if(self.speed < 0){
            self.speed = 0
        }
        
        dicData["speed"] = self.speed
        
        
        
        if let f = f, let t = t{
            if(f.i > t.i){
                direcTion = 1
            }
        }
        dicData["direction"] = direcTion
        
        
        
        dicData["line"] = line
        
        
        
        return dicData
    }
    
    
    func getLineWith(stationID:String)->String{
        var ans:String = "pink"
        switch stationID.lowercased() {
        case "TB03".lowercased(),
             "TB04".lowercased(),
             "B15-A".lowercased(),
             "B15-B".lowercased(),
             //"B12-A".lowercased(),
             //"B12-B".lowercased(),
             "B9-A".lowercased(),
             "B9-B".lowercased(),
             "B11-C".lowercased(),
             "B11-D".lowercased(),
             "SC-A".lowercased(),
             "SC-B".lowercased(),
             "B14-A".lowercased(),
             "B14-B".lowercased(),
             "TB05".lowercased(),
             "TB06".lowercased():
            
            ans = "blue"
            break
        default:
            break
        }
        
        return ans
    }
    
    
    // MARK: - priority
    func updatePriority(time:Date){
        if(self.activeStatus == .emergencyStop){
            return
        }
        
        if(self.activeStatus == .error){
            return
        }
        
        if(self.progressStatus == .end){
            return
        }
        
        guard let ms = ShareData.shared.masterVC else {
            self.progressStatus = .non
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        guard let ttbRout = ms.getTimeTableRoutineWith(timeTableRoutineId: self.timeTableRoutineId) else {
            self.progressStatus = .non
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        
        guard ((self.runAtRoutineIndex >= 0) && (self.runAtRoutineIndex < ttbRout.arRoutine.count)) else {
            self.progressStatus = .end
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        let routine = ttbRout.arRoutine[self.runAtRoutineIndex]
        
 
        self.buffTimeToActive = routine.startTime
//        print("\(routine.startTime) - \(time)")
        
        let timeDiff = routine.startTime.timeIntervalSince1970 - time.timeIntervalSince1970
        
        self.priority = Double(timeDiff)
        
        print("Car: \(self.name),  Priority:\(self.priority)")
        
        print("\(routine.startTime) - \(time)")
    }
    
    
    // MARK: - updateStep
    func updateStep(time:Date){
        
        
        
        if(self.dataBaseLastStatus != self.activeStatus){
            
            
            
            
            let newItem:RealmDataRecordModel = RealmDataRecordModel()
            newItem.setDataWith(car: self)
            DatabaseService.shared.addLogToDataBase(data: newItem)
            
            self.dataBaseLastStatus = self.activeStatus
            
            self.lastUpdate = Date()
        }

        
        
        if(self.activeStatus == .emergencyStop){
            return
        }
        
        if(self.activeStatus == .error){
            return
        }
        
        if(self.progressStatus == .end){
            return
        }
        
        guard let ms = ShareData.shared.masterVC else {
            self.progressStatus = .non
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        guard let ttbRout = ms.getTimeTableRoutineWith(timeTableRoutineId: self.timeTableRoutineId) else {
            self.progressStatus = .non
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        
        guard ((self.runAtRoutineIndex >= 0) && (self.runAtRoutineIndex < ttbRout.arRoutine.count)) else {
            self.progressStatus = .end
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        let routine = ttbRout.arRoutine[self.runAtRoutineIndex]
        
        
        if(self.countRoutStep < 0){
            self.countRoutStep = 0
        }
        
        
        if(self.runArDetailIndex < 0){
            self.runArDetailIndex = 0
        }
        
        
        
        
        
        guard let ttb = ms.getTimeTableWith(ttbID: routine.timeTableID) else {
            self.progressStatus = .end
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        guard self.runArDetailIndex < ttb.arDetails.count else {
            self.progressStatus = .end
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        self.timeDetail = ttb.arDetails[self.runArDetailIndex]
        
        
        guard let ttbDetail = self.timeDetail else {
            self.progressStatus = .end
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        
        
        guard let usePath = ttbDetail.path else {
            self.progressStatus = .end
            self.simulatorProgressFinish = 0
            self.simulatorProgressCount = 0
            self.simulatorProgressPerStep = 0
            self.activeStatus = .unknow
            self.priority = 0
            return
        }
        
        
        
        let timeDiff = routine.startTime.timeIntervalSince1970 - time.timeIntervalSince1970
        self.priority = Double(timeDiff)
        if(timeDiff <= 0){
            // need update
            
            
            
            let coordinator = Coordinater.shared
            
            
            
            
            
            
            // MARK: - non
            if(self.progressStatus == .non){
                self.progressStatus = .waitActive
                self.position = .atStation
                self.activeStatus = .inProgress
                self.runArDetailIndex = 0
            }
            
            
            // MARK: - waitActive
            if(self.progressStatus == .waitActive){
                
                if(self.activeStatus == .inProgress){
                    self.activeStatus = self.lastActiveStatus
                }
                
                
                self.position = .atStation
                
                var arCellNeedTouse:[TileCellDataModel] = [TileCellDataModel]()
                
                var allFree:Bool = true
                for (_, cellNeedToUse) in usePath.setPath{
                    arCellNeedTouse.append(cellNeedToUse)
                }
                
                
                let arBookingCell = coordinator.getCellBooking()
                
                for cellNeed in arCellNeedTouse{
                    for readyUser in arBookingCell{
                        
                        
                        
                        if(isCellEqual(cell1: cellNeed, cell2: readyUser)){
                            
                            
                            
                            if((readyUser.bookByCarID != self.id) && (readyUser.bookByCarID != "")){
                                allFree = false
                            }
                            
                            if(allFree == false){
                                break
                            }
                        }
                    }
                    
                    if(allFree == false){
                        break
                    }
                }
                
                // check Queue
                if(allFree == true){
                    var ready = false
                    for item in coordinator.arQueue{
                        if(item.id == self.id){
                            ready = true
                            break
                        }
                    }
                    
                    if(ready == false){
                        coordinator.addQueue(car: self)
                        allFree = false
                    }
                }
        
                
                
                print("All Free : \(allFree)")
                if(allFree == true){
                    
                    print("\(self.name) Add Path")
                    if let carStation = ttbDetail.station{
                        coordinator.addBookingCell(cell: carStation, byCar: self)
                    }
                    
                    coordinator.addBookingPath(path: usePath, byCar: self)
                    coordinator.removeQueue(carID: self.id)
                    
                    self.progressStatus = .active
                    self.activeStatus = .dewell
                    self.position = .atStation
                    
                    self.simulatorProgressFinish = Double(ttbDetail.dewell)
                    self.simulatorProgressCount = 0
                    self.simulatorProgressPerStep = coordinator.waitTimeToReRun
                    
                    //print("Booking")
                }else{
                    //print("Wait")
                    coordinator.addQueue(car: self)
                }
                
                return
                
            }
            
            
            // MARK: - active
            if(self.progressStatus == .active){
                
                if(self.activeStatus == .inProgress){
                    self.activeStatus = self.lastActiveStatus
                }
                
                
                if(self.activeStatus == .dewell){
                    if(simulatorProgressCount >= simulatorProgressFinish){
                        self.activeStatus = .waitDepart
                        
                    }
                    simulatorProgressCount += simulatorProgressPerStep
                }
                
                
                if(self.activeStatus == .waitDepart){
                    self.simulatorProgressFinish = Double(ttbDetail.duration)
                    self.simulatorProgressCount = 0
                    self.simulatorProgressPerStep = coordinator.waitTimeToReRun
                    
                    self.position = .atStation
                    self.activeStatus = .onTheWay
                    
                    
                }
                
                
                if(self.activeStatus == .onTheWay){
                    self.position = .onTheWay
                    
                    if(self.speed < self.maxSpeed){
                        self.speed += 0.05
                    }
                    
                    if(self.inModeSimulator == true){
                        if(simulatorProgressCount >= simulatorProgressFinish){
                            self.activeStatus = .arrived
                        }
                        simulatorProgressCount += (simulatorProgressPerStep * self.speed)
                        if(simulatorProgressCount < simulatorProgressPerStep){
                            simulatorProgressCount = simulatorProgressPerStep
                        }
                    }else{
                        
                        simulatorProgressCount += simulatorProgressPerStep
                        if(simulatorProgressCount >= simulatorProgressFinish){
                            simulatorProgressCount = simulatorProgressFinish - simulatorProgressPerStep
                        }
                        
                    }
                    
                }
                
                
                
                if(self.activeStatus == .arrived){
                    self.position = .arrive
                    self.progressStatus = .done
                    
                }
                
                return
            }
            
            
            // MARK: - done
            if(self.progressStatus == .done){
                if(self.activeStatus == .inProgress){
                    self.activeStatus = self.lastActiveStatus
                }
                
                
                self.activeStatus = .dewell
                
                coordinator.removeBookingPath(path: usePath)
                coordinator.removeBookingBy(carID: self.id)
                if let carStation = ttbDetail.toStation{
                    
                    coordinator.addBookingCell(cell: carStation, byCar: self)
                    
                }
                
                self.runArDetailIndex += 1
                
                
                
                
                //Check step
                if(self.runArDetailIndex < (ttb.arDetails.count - 1)){
                    
                    self.position = .arrive
                    self.activeStatus = .dewell
                    self.progressStatus = .waitActive
                }else{
                    
                    
                    
                    self.runArDetailIndex = 0
                    self.countRoutStep += 1
                    
                    if(self.countRoutStep < routine.count){
                        self.progressStatus = .waitActive
                        self.activeStatus = .waitDepart
                        if let ttb = ms.getTimeTableWith(ttbID: routine.timeTableID){
                            
                            self.timeDetail = ttb.arDetails[self.runArDetailIndex]
                            self.position = .atStation
                            self.activeStatus = .dewell
                            
                            
                        }
                        
                    }else{
                        self.countRoutStep = 0
                        self.runAtRoutineIndex += 1
                        if(runAtRoutineIndex < ttbRout.arRoutine.count){
                            self.progressStatus = .waitActive
                            self.activeStatus = .waitDepart
                            
                            let routine = ttbRout.arRoutine[self.runAtRoutineIndex]
                            if let ttb = ms.getTimeTableWith(ttbID: routine.timeTableID){
                                
                                self.timeDetail = ttb.arDetails[self.runArDetailIndex]
                                self.position = .atStation
                                self.activeStatus = .dewell
                            }
                            
                            //self.timeDetail = ttb.arDetails[self.runArDetailIndex]
                            
                            
                            
                        }else{
                            self.progressStatus = .end
                            self.activeStatus = .stop
                        }
                    }
                }
                
                
            }
            
            
            
            
        }else{
            //wait
            self.progressStatus = .non
            self.activeStatus = .unknow
            self.priority = 0
        }
        
    }
    
    
    func isCellEqual(cell1:TileCellDataModel, cell2:TileCellDataModel)->Bool{
        var ans:Bool = false
        
        if((cell1.i == cell2.i) && (cell1.j == cell2.j)){
            ans = true
        }
        
        return ans
    }
    
    
    
    func resetRunTime(){
        self.position = .atStation
        self.runAtRoutineIndex = 0
        self.countRoutStep = 0
        self.runArDetailIndex = 0
        self.activeStatus = .unknow
        self.lastActiveStatus = .unknow
        self.progressStatus = .non
        self.simulatorProgressFinish = 0
        self.simulatorProgressCount = 0
        self.simulatorProgressPerStep = 0
        self.priority = 0
        self.online = false
    }
    
    
    func getDisplayStatus()->String{
        
        switch self.activeStatus {
        case .dewell:
            return "Dewell"
            
        case .waitDepart:
            return "Depart"
            
        case .onTheWay:
            return "On the way"
            
        case .arrived:
            return "Arrived"
            
        case .emergencyStop:
            return "Emergency Stop"
            
        case .stop:
            return "Stop"
            
        default:
            return "-"
            
        }
    }
    
    func setMaxSpeed(speed:Double) {
        self.maxSpeed = speed
        self.speed = speed
    }
}
