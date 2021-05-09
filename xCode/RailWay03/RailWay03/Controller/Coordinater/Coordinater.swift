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
        case stationOffline
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
    
    var timerCheckStatus:Timer! = nil
    
    var mode:Mode = .simulator
    var controllStatus:ControllStatus = .ideal
    
    var myService:Service = Service()
    var myDataBase:DatabaseService = DatabaseService.shared
    
    
    var trackCarID:String = ""
    
    var arQueue:[CarDataModel] = [CarDataModel]()

    var arShipControll:[ShipControllModel] = [ShipControllModel]()
    
    
    var arQuereArrival:[DelayCarArrival] = [DelayCarArrival]()
    
   
    
    private var countController:NSInteger = 0
    override init() {
        super.init()
        
        myService.delegate = self
//        self.registerShipControll()
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
            arShipControll.append(self.createShipControll(id: ""))
        }
        
        
        initControlShipLabel()
        updateControllCount()
        self.startCheckStatusTimmer()
        
    }
    
    func initControlShipLabel(){
        
        print(self.arShipControll.count)
        if(self.arShipControll.count >= 14){
            
            
            
            if let ms = ShareData.shared.masterVC{
                arShipControll[0].label = ms.lbC01
                arShipControll[1].label = ms.lbC02
                arShipControll[2].label = ms.lbC03
                arShipControll[3].label = ms.lbC04
                arShipControll[4].label = ms.lbC05
                arShipControll[5].label = ms.lbC06
                arShipControll[6].label = ms.lbC07
                arShipControll[7].label = ms.lbC08
                arShipControll[8].label = ms.lbC09
                arShipControll[9].label = ms.lbC10
                arShipControll[10].label = ms.lbC11
                arShipControll[11].label = ms.lbC12
                arShipControll[12].label = ms.lbC13
                arShipControll[13].label = ms.lbC14
            }
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
        
        
        self.checkQueueArrival()
        
        
    }
    
    
    func carWitNextStation(stationID:String)->CarDataModel?{
        guard let mvc = ShareData.shared.masterVC else { return nil }
        
        var carActive:CarDataModel?
        
        for car in mvc.activeCars {
            
            if let nextStation = car.getNextStation() {
                if( nextStation.id.lowercased() == stationID.lowercased() ){
                    carActive = car
                    break
                }
            }
            
        }
        
        return carActive
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
//                    startTime = r.startTime
                    startTime = r.stringTimeToDateToday(str: r.strStartTime)
                }
                
                // find Start time
                if(r.startTime.timeIntervalSince1970 < startTime.timeIntervalSince1970){
//                    startTime = r.startTime
                    startTime = r.stringTimeToDateToday(str: r.strStartTime)
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
                
//                let oldTime = r.startTime
                let oldTime = r.stringTimeToDateToday(str: r.strStartTime)
                if(r.buffStartTime == nil){
//                    r.buffStartTime = r.startTime
                    r.buffStartTime = r.stringTimeToDateToday(str: r.strStartTime)
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
    
    
    
    
    
    func carArrive(acarid:String, stationID:String){
        print(">>>>>>carArrive")
        
        var carID = acarid
        if(carID == ""){
            if let searchCar = self.carWitNextStation(stationID: stationID) {
                carID = searchCar.id
            }else{
                print("error4")
            }
        }
        
        
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
            
            if(self.mode == .controll){
                
                
                switch stationID.lowercased() {
                case "b11-a":
                    addArrivalToQueue(carID: car.id, delay: 2)
                    break
                case "b11-b":
                    addArrivalToQueue(carID: car.id, delay: 2)
                    break
                case "b11-c":
                    addArrivalToQueue(carID: car.id, delay: 2)
                    break
                case "b11-d":
                    addArrivalToQueue(carID: car.id, delay: 2)
                    break
                case "tb04":
                    addArrivalToQueue(carID: car.id, delay: 1)
                    break
                case "tb03":
                    addArrivalToQueue(carID: car.id, delay: 1)
                    break
                case "tb05":
                    addArrivalToQueue(carID: car.id, delay: 1)
                    break
                case "tb06":
                    addArrivalToQueue(carID: car.id, delay: 1)
                    break
                default:
                    self.setStatusCarWith(carID: car.id, status: .arrived)
                    break
                }
                
                
                self.myLoop()
                
                
            }else{
                self.setStatusCarWith(carID: car.id, status: .arrived)
                self.myLoop()
            }
            
        
        }else{
//            self.setStatusCarWith(carID: car.id, status: .error)
        }
        
        
    }
    
    
    func addArrivalToQueue(carID:String, delay:NSInteger){
        
        
        let newItem:DelayCarArrival = DelayCarArrival()
        newItem.id = carID
        newItem.delaySec = delay
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        newItem.activeTime = calendar.date(byAdding: .second, value: Int(delay), to: Date()) ?? Date()
        
        arQuereArrival.append(newItem)
    }
    
    func checkQueueArrival() {
        if(arQuereArrival.count > 0){
            let now = Date()
            var count = arQuereArrival.count - 1
            
            while count >= 0 {
                
                if(count < arQuereArrival.count){
                    let item = arQuereArrival[count]
                    if(now.timeIntervalSinceNow > item.activeTime.timeIntervalSinceNow){
                        self.setStatusCarWith(carID: item.id, status: .arrived)
                        
                        
                        arQuereArrival.remove(at: count)
                    }
                }
                
                
                count -= 1
            }
        }
    }
    
    
    func restartSimulator(){
        guard let mvc = ShareData.shared.masterVC else { return }
        
        mvc.resetController()
        
        mvc.startRunWithSimulator()
    }
    
    
    func registerCars(carName: String) {
        
        
        
        guard let ms = ShareData.shared.masterVC else {
            return
        }
        
     
        let now:Date = Date()
        
        var needUpdate = false
        for online in ms.carListViewDataModel.arCars{
            
            let last = online.online
            let diff = now.timeIntervalSinceNow - online.lastUpdate.timeIntervalSinceNow
            if(diff >= 5){
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
        
        
        
        for item in self.arShipControll {
            if(controllID.lowercased() == item.id.lowercased()){
                item.countOffline = 0
                item.updateStatus()
                break
            }
        }
    
    }
    
    func updateControllCount() {
        var haveOfline = false
        for item in self.arShipControll {
            
            item.countOffline += 1
            
            item.updateStatus()
            if(item.countOffline >= item.limitOfline){
                haveOfline = true
            }
        }
        
        
        /*
        if(haveOfline){
            if let ms = ShareData.shared.masterVC {
                
                if(self.mode == .controll){
                    if(self.controllStatus == .runing){
                        
                        self.stopAll()
                        
                        self.controllStatus = .emercencyBreak
                        ms.setDisplayEmergenct()
                    }
                }
                
               
            }
        }*/
        
        
    }
    

    func startCheckStatusTimmer(){
        if(self.timerCheckStatus != nil){
            return
        }
        
        
    
        self.timerCheckStatus = Timer.scheduledTimer(timeInterval: waitTimeToReRun, target: self, selector: #selector(checkStatusLoop), userInfo: nil, repeats: true)
    }
    
    func stopCheckStatusTimmer(){
        if(self.timerCheckStatus != nil){
            self.timerCheckStatus.invalidate()
        }
        self.timerCheckStatus = nil
    }
    
    
    @objc func checkStatusLoop(){
        
        self.updateControllCount()
        
        self.registerCars(carName: "")
        
    }
   
}

