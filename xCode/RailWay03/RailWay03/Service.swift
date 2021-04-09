//
//  Service.swift
//  RailWay03
//
//  Created by T2P mac mini on 30/8/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SocketIO
import WebKit


@objc protocol ServiceDelegate {
    @objc optional func getTimeTableWith(stationID:String)
    @objc optional func stopCarWith(carID:String)
    @objc optional func continueCarWith(carID:String)
    @objc optional func carArrive(carID:String, stationID:String)
    @objc optional func restartSimulator()
    @objc optional func registerCars(carName:String)
}

class Service: NSObject {
    
    enum Host:String{
        case localHost = "http://localhost:5000"
        case internet = "https://rsu-railway.herokuapp.com"
    }
    
    
    //static let shared = Service()
    
    
    var hasInit:Bool = false
    
    var manager:SocketManager! = nil
    var socket:SocketIOClient! = nil

    
    var delegate:ServiceDelegate? = nil
    
    var myHost:Host = .localHost
    func conntecServer(){
        if(self.hasInit == false){
            
            
            guard let url = URL(string: myHost.rawValue) else {
                return
            }
            
            
            self.manager = SocketManager(socketURL: url, config: [.log(false), .compress])
            self.socket = self.manager.defaultSocket
            
            socket.on(clientEvent: .connect) {data, ack in
                self.hasInit = true
                print("socket connected")
                
             
                
            }
            
            
            socket.on(clientEvent: .disconnect) { (datas, ack) in
                
                self.hasInit = false
                print("socket disconnect")
                
                
                
            }
            
  
            /*
            socket.on("cars") {data, ack in
                
                guard let message = data[0] as? [String:Any] else { return }
                print("cars ------")
                print(message)
                
                
            }*/
            
            
            socket.on("gettimetable"){ data, ack in
                guard let message = data[0] as? [String:Any] else { return }
                print("gettimetable ------")
                print(message)
                
                var strID:String = ""
                if let stationID = message["stationID"] as? String{
                    strID = stationID
                }else if let stationID = message["stationID"] as? NSInteger{
                    strID = "\(stationID)"
                }
                
                if(strID != ""){
                    
                    if let de = self.delegate{
                        de.getTimeTableWith?(stationID: strID)
                    }
                   
                }
            }
            
            
          
            socket.on("stop"){ data, ack in
                guard let message = data[0] as? [String:Any] else { return }
                print("stop ------")
                print(message)
                var strID:String = ""
                if let stationID = message["carID"] as? String{
                    strID = stationID
                }else if let stationID = message["carID"] as? NSInteger{
                    strID = "\(stationID)"
                }
                
                if(strID != ""){
                    
                    if let de = self.delegate{
                        de.stopCarWith?(carID: strID)
                    }
                   
                }
                
            }
            
            
            
            socket.on("restartsim"){ data, ack in
                guard let message = data[0] as? [String:Any] else { return }
                print("restartsim ------")
                print(message)
                
                if let de = self.delegate{
                    de.restartSimulator?()
                }
                
            }
            
            
            socket.on("registerCar"){ data, ack in
                guard let message = data[0] as? [String:Any] else { return }
                print("registerCar ------")
                print(message)
                
                
                var name:String = ""
                if let value = message["name"] as? String{
                    name = value
                }else if let value = message["name"] as? NSInteger{
                    name = "\(value)"
                }
                
                if( name != "" ){
                    if let de = self.delegate{
                        de.registerCars?(carName: name)
                    }
                }
                
                
                
            }
            
            
            socket.on("continue"){ data, ack in
                guard let message = data[0] as? [String:Any] else { return }
                print("continue ------")
                print(message)
                var strID:String = ""
                if let stationID = message["carID"] as? String{
                    strID = stationID
                }else if let stationID = message["carID"] as? NSInteger{
                    strID = "\(stationID)"
                }
                
                if(strID != ""){
                    
                    if let de = self.delegate{
                        de.continueCarWith?(carID: strID)
                    }
                   
                }
                
            }
            
            
            socket.on("arrived"){ data, ack in
                guard let message = data[0] as? [String:Any] else { return }
                print("arrived ------")
                print(message)
                var carid:String = ""
                if let carID = message["carID"] as? String{
                    carid = carID
                }else if let carID = message["carID"] as? NSInteger{
                    carid = "\(carID)"
                }
                
                var strID:String = ""
                if let stationID = message["stationID"] as? String{
                    strID = stationID
                }else if let stationID = message["stationID"] as? NSInteger{
                    strID = "\(stationID)"
                }
                
                
                if((strID != "") && (carid != "")){
                    print(">>strID:\(strID), carid:\(carid)")
                    if let de = self.delegate{
                        de.carArrive?(carID: carid, stationID: strID)
                    }
                   
                }
                
            }
            
            socket.connect()
            
        }
        
    }
    
    
    
    func disconnectServer(){
        if(socket != nil){
            socket.disconnect()
        }
        
        self.socket = nil
        self.manager = nil
        self.hasInit = false
    
    }
    
    func sendCarsMessage(json:[String:Any]){
        if(self.hasInit == false){
            self.conntecServer()
        }
        socket.emit("command", json)

    }
    
    
    func sendStopAllMessage(){
        if(self.hasInit == false){
            self.conntecServer()
        }
        let json:[String:Any] = ["stop":"all"]
        socket.emit("stopAll", json)

    }
    
    
    func sendCarSchedule(json:[String:Any]){
        if(self.hasInit == false){
            self.conntecServer()
        }
        var newDic:[String:Any] = [String:Any]()
        newDic["carSchedule"] = json
        socket.emit("schedule", newDic)
        
    }
    
    func sendStationTimeTable(stationId:String, json:[[String:Any]]) {
        if(self.hasInit == false){
            self.conntecServer()
        }

        
        var messageDic:[String:Any] = [String:Any]()
        var content:[String:Any] = [String:Any]()
        content["schedule"] = json
        content["stationId"] = stationId
        
        messageDic["timetable"] = content
        print("---")
        print(messageDic)
        print("---")
        socket.emit("command", messageDic)
        
    }
    
    
    func sendJunctionControl(){
        if(self.hasInit == false){
            self.conntecServer()
        }
        
        
        let myJSON:[String : Any] = [
            "name": "011",
            "id": "011",
            "message": 1
            ]
        
        socket.emit("junction", myJSON)
        
    }
    

}
