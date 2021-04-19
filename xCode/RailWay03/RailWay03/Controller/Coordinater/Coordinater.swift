//
//  Coordinater.swift
//  RailWay03
//
//  Created by T2P mac mini on 8/1/2563 BE.
//  Copyright © 2563 T2P. All rights reserved.
//

import Cocoa


@objc protocol CoordinaterDelegate {
    @objc optional func activePathData(path:PathDataModel)
    @objc optional func activeCarData(car:CarDataModel)
}



class Coordinater: NSObject {
    
    
    enum Mode{
        case simulator
        case controll
    }
    
    enum ControllStatus{
        case ideal
        case runing
        case stop
        case emercencyBreak
    }
    static let shared = Coordinater()
    
    var delegate:CoordinaterDelegate? = nil
    
    
    let waitTimeToReRun:Double = 1
    
    
    var simulatorCars:[String:CarDataModel] = [String:CarDataModel]()
    
    
    var bookingPath:[PathDataModel] = [PathDataModel]()
    
    var bookingCell:[TileCellDataModel] = [TileCellDataModel]()
    
    //var arTimeTable:[TimeTableDataModel]? = nil
    
    
    var timer:Timer! = nil
    var timeIntervalCount:TimeInterval = 0
    
    
    var mode:Mode = .simulator
    var controllStatus:ControllStatus = .ideal
    
    var myService:Service = Service()
    var myDataBase:DatabaseService = DatabaseService.shared
    
    
    var trackCarID:String = ""
    
    var arQueue:[CarDataModel] = [CarDataModel]()

    var arShipControll:[ShipControllModel] = [ShipControllModel]()
    
    
    private var countUpdateActiveCar:NSInteger = 0
    
    private var countController:NSInteger = 0
    override init() {
        super.init()
        
        myService.delegate = self
        self.registerShipControll()
    }
    
    
    func connectServer() {
        myService.conntecServer()
    }
    func startSystem()->Bool{
        
        
        return true
    }
    
    
    
    func runSimulator(cars:[CarDataModel], inMode:Mode){
        
        //update car data
        self.mode = inMode
        for car in cars{
            
            if(self.mode == .controll){
                car.inModeSimulator = false
            }else{
                car.inModeSimulator = true
            }
            self.simulatorCars[car.id] = car
        }
        
        if let ms = ShareData.shared.masterVC{
            ms.activeCars = cars.sorted(by: { (c1, c2) -> Bool in
                return c1.id < c2.id
            })
        }
        
        self.startTimer()
        
    }
    
    
    func registerShipControll() {
        if(arShipControll.count == 0){
            arShipControll.append(self.createShipControll(id: "CT01_01"))
            arShipControll.append(self.createShipControll(id: "CT01_02"))
            arShipControll.append(self.createShipControll(id: "CT02_01"))
            arShipControll.append(self.createShipControll(id: "CT02_02"))
            arShipControll.append(self.createShipControll(id: "CT03_01"))
            arShipControll.append(self.createShipControll(id: "CT03_02"))
            arShipControll.append(self.createShipControll(id: "CT03_03"))
            arShipControll.append(self.createShipControll(id: "CT04_01"))
            arShipControll.append(self.createShipControll(id: "CT04_02"))
            arShipControll.append(self.createShipControll(id: "CT05_01"))
            arShipControll.append(self.createShipControll(id: "CT05_02"))
            arShipControll.append(self.createShipControll(id: "CT06_01"))
            arShipControll.append(self.createShipControll(id: "CT06_02"))
        }
    }
    
    func createShipControll(id:String) -> ShipControllModel{
        let newitem = ShipControllModel()
     
        newitem.id = id
        return newitem
    }
    
    func startTimer(){
        self.controllStatus = .runing
        
        if(self.timer != nil){
            return
        }
        
        self.timeIntervalCount = 0
        self.adjutTimeToNow()
        
    
        self.timer = Timer.scheduledTimer(timeInterval: waitTimeToReRun, target: self, selector: #selector(myLoop), userInfo: nil, repeats: true)
    }
    
    
    func continueSimulator() {
        
        
        
        for (_, c) in self.simulatorCars{
            c.activeStatus = .inProgress
            if(c.lastActiveStatus == .inProgress){
                c.lastActiveStatus = .onTheWay
            }
        }
        
        self.controllStatus = .runing
        
        if(self.timer == nil){
            self.timer = Timer.scheduledTimer(timeInterval: waitTimeToReRun, target: self, selector: #selector(myLoop), userInfo: nil, repeats: true)
        }
        
    }
    func pauseTimer(){
        self.controllStatus = .stop
        
        if(self.timer == nil){
            return
        }
        
        if(self.timer.isValid){
            self.timer.invalidate()
        }
        self.timer = nil
        
    }
    
    func resetSimulater(){
        self.controllStatus = .ideal
        self.trackCarID = ""
        if(self.timer != nil){
            if(self.timer.isValid){
                self.timer.invalidate()
            }
        }
        
        self.timer = nil
        
        for item in self.bookingCell{
            item.bookByCarID = ""
        }
        
        
        self.simulatorCars.removeAll()
        self.bookingPath.removeAll()
        self.arQueue.removeAll()
        
        self.myLoop()
    }
    
    func stopAll(){

        for (_, c) in self.simulatorCars{
            
            if(c.activeStatus != .emergencyStop){
                
                if(c.activeStatus != .inProgress){
                    c.lastActiveStatus = c.activeStatus
                }else{
                    c.lastActiveStatus = .onTheWay
                }
                
                
                c.activeStatus = .emergencyStop
            }
        }

        self.myService.sendStopAllMessage()
        self.myLoop()
    }
    
    @objc func myLoop(){
        
        self.timeIntervalCount += self.waitTimeToReRun
        let now:Date = Date()//.addingTimeInterval(10)
        
        
        guard let mvc = ShareData.shared.masterVC else { return }
        
        
        
        
        
        var arCar0:[CarDataModel] = [CarDataModel]()
        for (_, car) in self.simulatorCars{
            car.updatePriority(time: now)
            arCar0.append(car)
        }
        arCar0 = arCar0.sorted(by: { (car1, car2) -> Bool in
            return car1.priority < car2.priority
        })
        
        var arCarDic:[[String:Any]] = [[String:Any]]()
        
       
        
        var arCar:[CarDataModel] = [CarDataModel]()
        if(self.arQueue.count > 0){
            for item in self.arQueue{
                arCar.append(item)
            }
        }
        
        for item in arCar0{
            var ready = false
            
            if(self.arQueue.count > 0){
                for q in self.arQueue{
                    if(item.id == q.id){
                        ready = true
                        break
                    }
                }
            }
            
            if(ready == false){
                arCar.append(item)
            }
        }
        
        
        
        for car in arCar{
            car.updateStep(time: now)
            let bcDic:[String:Any] = car.broadcastData()
            arCarDic.append(bcDic)
        }
        
        
        mvc.updateCarPosition(cars: arCar)
        mvc.updateCarsControl(arCars: arCar)
        
        
        mvc.updateDisplayWithPath(paths: self.bookingPath)
        
        
        var carsDic:[String:Any] = [String:Any]()
        carsDic["cars"] = arCarDic
        
        self.broadcastCars(cars: carsDic)
        
        
        
        if let gameScene = ShareData.shared.gamseSceme{
            gameScene.trackCar(carID: self.trackCarID)
        }
        
        
        
        if(countUpdateActiveCar > 5){
            countUpdateActiveCar = 0
            self.registerCars(carName: "")
        }
        
        countUpdateActiveCar += 1
    }
    
    
    
    
    
    func getCellBooking()->[TileCellDataModel]{
        
        
        return self.bookingCell
    }
    
    func addBookingPath(path:PathDataModel, byCar:CarDataModel){
        self.bookingPath.append(path)
        
        
        for (_, cell) in path.setPath{
           
            cell.bookByCarID = byCar.id
            self.bookingCell.append(cell)
        }
        
        
        
        //Update light
        guard let mvc = ShareData.shared.masterVC else { return }
        var arCar:[CarDataModel] = [CarDataModel]()
        arCar.append(byCar)
       
        mvc.updateJunctionLight(cars: arCar)
    }
    
    
    
    func addQueue(car:CarDataModel){
        var ready = false
        
        for item in self.arQueue{
            if(item.id == car.id){
                ready = true
                break
            }
        }
        
        if(ready == false){
            self.arQueue.append(car)
        }
        
    }
    
    func removeQueue(carID:String) {
        
        
        for i in (0..<self.arQueue.count).reversed(){
            let item = self.arQueue[i]
            if(item.id == carID){
                self.arQueue.remove(at: i)
            }
        }
    }
    
    
    
    func removeBookingPath(path:PathDataModel){
        
        var i:NSInteger = self.bookingPath.count - 1
        while i >= 0 {
            let item = self.bookingPath[i]
            if(item.id == path.id){
                
                self.bookingPath.remove(at: i)
                
            }
            i -= 1
        }
        
        
        //---------
        
        //remove cell
        for (_, cell) in path.setPath{
            self.removeBookingCell(cell: cell)
        }
        // end remove cell
        
        guard let mvc = ShareData.shared.masterVC else { return }
        mvc.updateDisplayToClearWithPath(paths: [path])
    }
    
    func removeBookingBy(carID:String){
       var i:NSInteger = self.bookingCell.count - 1
       while i >= 0 {
           let item = self.bookingCell[i]
           if(item.bookByCarID == carID){
                item.bookByCarID = ""
               self.bookingCell.remove(at: i)
               
           }
           i -= 1
       }

    }
    
    
    
    func addBookingCell(cell:TileCellDataModel, byCar:CarDataModel){
        
        let item = cell
        item.bookByCarID = byCar.id
        self.bookingCell.append(item)
    }
    
    func removeBookingCell(cell:TileCellDataModel){
        
        var j:NSInteger = self.bookingCell.count - 1
        while j >= 0 {
            let readyCell = self.bookingCell[j]
            if(readyCell.id == cell.id){
                
                readyCell.bookByCarID = ""
                self.bookingCell.remove(at: j)
            }
            
            j -= 1
        }
    }
    
    func adjutTimeToNow(){
        let now:Date = Date().addingTimeInterval(5)
        
        //        let dateFormat:DateFormatter = DateFormatter()
        //        dateFormat.dateFormat = "HH:mm:ss"
        //        dateFormat.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        var startTime:Date! = nil
        guard let ms = ShareData.shared.masterVC else { return }
        
        
        for ttbr in ms.timeTableModel.arRoutine{
            let arR = ttbr.arRoutine
            for r in arR{
                
                if(startTime == nil){
                    startTime = r.startTime
                }
                
                // find Start time
                if(r.startTime.timeIntervalSince1970 < startTime.timeIntervalSince1970){
                    startTime = r.startTime
                }
            }
        }
        
        guard startTime != nil else {
            return
        }
        
        var diff = now.timeIntervalSince1970 - startTime.timeIntervalSince1970
        
        diff = diff + 5
        
        
        for ttbr in ms.timeTableModel.arRoutine{
            let arR = ttbr.arRoutine
            for r in arR{
                
                let oldTime = r.startTime
                
                if(r.buffStartTime == nil){
                    r.buffStartTime = r.startTime
                }
                 
                
                r.startTime = oldTime.addingTimeInterval(diff)
                
            }
        }
        
        
    }
    
    
    func getStationScheduleWhit(stationID:String)->[ScheduleDetailModel]{
        var arSchedule:[ScheduleDetailModel] = [ScheduleDetailModel]()
        
        
        
        guard let ms = ShareData.shared.masterVC else {
            return arSchedule
        }
    
        
        for car in ms.carListViewDataModel.arCars{
        
            let carSc = self.getScheduleWhit(car: car)
            for scd in carSc.arSchedule{
                if(scd.station == stationID){
                    arSchedule.append(scd)
                }
            }
        }
        
        return arSchedule
    }
    
    func getCarScheduleWhit(carID:String)->CarScheduleDetailModel?{
        
        
        guard let ms = ShareData.shared.masterVC else {
            return nil
        }
        
        
        
        var car:CarDataModel? = nil
        
        for c in ms.carListViewDataModel.arCars{
            if c.id == carID{
                car = c
                break
            }
        }
        
        
        guard let acar = car else {
            return nil
        }
        
        
        return self.getScheduleWhit(car: acar)
        
    }
    
    func getScheduleWhit(car:CarDataModel)->CarScheduleDetailModel{
        
        
        let newCarSchedule:CarScheduleDetailModel = CarScheduleDetailModel()
        newCarSchedule.carID = car.id
        
        
        
        guard let ms = ShareData.shared.masterVC else {
            return newCarSchedule
        }
        
        
        
        guard let ttbRoutine = ms.getTimeTableRoutineWith(timeTableRoutineId: car.timeTableRoutineId) else { return  newCarSchedule }
        
        
        
        
        for rout in ttbRoutine.arRoutine{
            var buffStart:Date = rout.startTime
            
            for _ in 0..<rout.count{
                if let ttb = ms.getTimeTableWith(ttbID: rout.timeTableID){
                    
                    for detail in ttb.arDetails{
                        
                        let newItem:ScheduleDetailModel = ScheduleDetailModel()
                        
                        newItem.arrive = buffStart.addingTimeInterval(TimeInterval(detail.dewell))
                        newItem.depart = newItem.arrive.addingTimeInterval(TimeInterval(detail.duration))
                        
                        buffStart = newItem.arrive
                        
                        if let station = detail.station{
                            newItem.station = station.id
                        }
                        
                        if let to = detail.toStation{
                            newItem.to = to.id
                        }
                        
                        if let from = detail.fromStation{
                            newItem.from = from.id
                        }
                        newItem.car = car.id
                            
                        newCarSchedule.arSchedule.append(newItem)
                    }
                    
                }
            }
            
            
        }
        
        
        
        return newCarSchedule
        
    }
    
    
    
    func broadcastCars(cars:[String:Any]){
        self.myService.sendCarsMessage(json: cars)
    }
    
    
    
    
    func getCarWith(carID:String)->CarDataModel?{
        guard let ms = ShareData.shared.masterVC else {
            return nil
        }
        
        var car:CarDataModel? = nil
        
        for c in ms.carListViewDataModel.arCars{
            if c.id == carID || c.name == carID {
                car = c
                break
            }
        }
        
        return car
    }
    
    
    func setStatusCarWith(carID:String, status:CarDataModel.ActiveStatus){
        
        
        guard let ms = ShareData.shared.masterVC else {
            return
        }
        
        for c in ms.carListViewDataModel.arCars{
            if c.id == carID{
                
                if(status == .emergencyStop){
                    c.lastActiveStatus = c.activeStatus
                }
                if(c.lastActiveStatus == .inProgress){
                    c.lastActiveStatus = .onTheWay
                }
                
                c.activeStatus = status
                
                break
            }
        }
        
        ms.reloadCarsListView()
    }

    
  
    func setSpeedCarWith(carID:String, speed:Double){

        guard speed >= 0 else { return }
        guard speed <= 1 else { return }
        
        guard let ms = ShareData.shared.masterVC else {
            return
        }
        for c in ms.carListViewDataModel.arCars{
            if c.id == carID{
                c.setMaxSpeed(speed: speed)
                break
            }
        }
        
        ms.reloadCarsListView()
    }
    
    
}

extension Coordinater:ServiceDelegate{
    func getTimeTableWith(stationID: String) {
        
        let arData = self.getStationScheduleWhit(stationID: stationID)
        var arDic:[[String:Any]] = [[String:Any]]()
        for item in arData{
            arDic.append(item.getDicData())
        }
        
        self.myService.sendStationTimeTable(stationId: stationID, json: arDic)
        
    }
    
    func stopCarWith(carID:String){
        self.setStatusCarWith(carID: carID, status: .emergencyStop)
    }
    func continueCarWith(carID:String){
        self.setStatusCarWith(carID: carID, status: .inProgress)
    }
    func carArrive(carID:String, stationID:String){
        print(">>>>>>carArrive")
        guard let car = self.getCarWith(carID: carID) else {
            print("error1")
            return
        }
        guard let detail = car.timeDetail else {
//            self.setStatusCarWith(carID: carID, status: .error)
            print("error2")
            return
        }
        
        guard let to = detail.toStation else {
//            self.setStatusCarWith(carID: carID, status: .error)
            print("error3")
            return
        }
        
        print(">>>>>> \(stationID) >>> to: \(to.id)")
        if(to.id == stationID){
            self.setStatusCarWith(carID: car.id, status: .arrived)
            self.myLoop()
        }else{
//            self.setStatusCarWith(carID: car.id, status: .error)
        }
        
        
    }
    
    func restartSimulator(){
        guard let mvc = ShareData.shared.masterVC else { return }
        
        mvc.resetController()
        
        mvc.startRunWithSimulator()
    }
    
    
    func registerCars(carName: String) {
        
       
        self.countUpdateActiveCar = 0
        
        
        guard let ms = ShareData.shared.masterVC else {
            return
        }
        
     
        let now:Date = Date()
        
        var needUpdate = false
        for online in ms.carListViewDataModel.arCars{
            
            let last = online.online
            let diff = now.timeIntervalSinceNow - online.lastUpdate.timeIntervalSinceNow
            if(diff > 6){
                online.online = false
                
            }
            
            if(online.name == carName){
                online.online = true
                online.lastUpdate = Date()
      
            }
            
            if(last != online.online){
                needUpdate = true
            }
        }
        
        if(needUpdate){
            if let ccv = ms.myCarControllView{
                ccv.myCollection.reloadData()
            }
            
            if let clv = ms.myCarsCollection{
                if let collection = clv.myCollection{
                    collection.reloadData()
                }
            }
        }
        
        
        
    }
    
    
    func registerController(controllID: String) {
        self.countController = 0
        
        
    }
    
   
}

