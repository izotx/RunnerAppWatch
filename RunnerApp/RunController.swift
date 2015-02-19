//
//  RunController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

enum runstate{
    case active
    case stopped
    case paused
}

enum measurements{
    case mph
    case kph
}

enum lengths : Double{
    case km = 1000.0
    case mile = 1687.0
}


protocol RunProtocol{
    func speedUpdated(speed:String)
    func distanceUpdated(distance:String)
    func timeUpdated(time:String)
    func statusUpdated(status: CLAuthorizationStatus)
    func stateUpdated(state:runstate)

    
    
}

class RunController: NSObject {
    var currentRunIndex: Int
    var speedMode:measurements
    var speed:Double
    var time:Int
    var timer:NSTimer
    var distance:Double
    var dataManager:DataController = DataController()
    
    var state : runstate{
        didSet{
            for observer in self.observers {
                observer.stateUpdated(self.state)
            }

        }
    
    } //= runstate.stopped
    
    var observers: [RunProtocol] = []
    var locationStatus  : CLAuthorizationStatus
    private var locationController:LocationController =  LocationController()
 
    func addRunObserver(observer:RunProtocol){
        self.observers.append(observer)
    }
    
    class func getDistance(rawDistance:Double, mode:measurements)->String{
        var km = round (100 * rawDistance/lengths.km.rawValue )/100
        var miles = round (100 * rawDistance/lengths.mile.rawValue )/100
        
        var displayText = ""
        if(mode == measurements.kph)
        {
            displayText = "\(km)"
        }
        else{
            displayText = "\(miles)"
        }
        return displayText
    }
    

    
    override init() {
        self.currentRunIndex = -1
        self.speedMode = measurements.kph
        self.speed = 0
    
        self.time = 0
        self.timer = NSTimer();
        self.distance = 0
        self.locationStatus = self.locationController.status
        self.state = runstate.stopped

        super.init()
    
        locationController.addObserver(self, forKeyPath: "status", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "speed", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "distanceDelta", options:.New , context: nil)
        locationController.addObserver(self, forKeyPath: "currentLocation", options:.New , context: nil)

        self.addObserver(self, forKeyPath: "state", options:.New , context: nil)
        self.locationController.startUpdating();
        
    }
    
    func start(){
        //create new run
        self.locationController.startUpdating()

        if(self.state == runstate.paused){
            self.resume()
            return
        }
        if(self.state == runstate.stopped){
            self.time = 0
            self.distance = 0.0
        }

        if !self.timer.valid
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true);
            
            var nsrunloop = NSRunLoop();
            nsrunloop.addTimer(self.timer, forMode: NSRunLoopCommonModes)
        }
        
        self.state = runstate.active
        //create new data manager
        dataManager.startRun()

    }
    
    func timerTick()->Void
    {
        self.time += 1
         dataManager.updateTime(self.time)
        var displayText = RunController.convertTimeToText(self.time)

        for observer in self.observers {
            observer.timeUpdated(displayText)
        }
    }
    
    func stop(){
        //stop running
        dataManager.updateTime(self.time)
        dataManager.updateDistance(self.distance)
        dataManager.stopRun()

        self.time = 0
        self.timer.invalidate()
        self.state = runstate.stopped

    }
    
    func pause(){
        //pause running
        self.timer.invalidate();
        self.state = runstate.paused
        //self.locationController.stopUpdating();
    }
    
    func resume(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerTick"), userInfo: nil, repeats: true);
        
        var nsrunloop = NSRunLoop();
        nsrunloop.addTimer(self.timer, forMode: NSRunLoopCommonModes)
        self.state = runstate.active
          self.locationController.startUpdating();
    }

    class func calculateSpeed(speed: Double, mode:measurements )->Double{
            switch mode {
        case measurements.kph:
            return round(10 * speed * 3600.0 / lengths.km.rawValue) / 10

        case measurements.mph:
            return round( 10 * speed * 3600.0 / lengths.mile.rawValue) / 10
    

       // default: return speed
        }
        
    }
    
    func changeMeasurements(){
        self.speedMode = (self.speedMode == measurements.kph ) ? measurements.mph : measurements.kph
        
    }
    
    func createNewRun(){
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
 }
    
    
   class func convertTimeToText(time:Int)->String{
        var hours = time/(3600)
        var minutes = (time/60) - (hours * 60)
        var seconds = time%60
        var displayTime = ""
        if(hours < 10) {
            
            displayTime = "\(hours):"
            if(hours == 0){
                displayTime = ""
            }
            
            if(minutes < 10 ) {
                displayTime = "\(displayTime)0\(minutes):"
            }
            else{
                displayTime = "\(displayTime)\(minutes):"
            }
            
            if(seconds < 10 ) {
                displayTime = "\(displayTime)0\(seconds)"
            }
            else{
                displayTime = "\(displayTime)\(seconds)"
            }
            
            
            
        }
        else{
            displayTime = "\(hours)"
        }
        return displayTime
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if(keyPath == "status"){
               // self.checkPermissions()
            self.locationStatus = self.locationController.status
            //notify observers
            for observer in self.observers {
                observer.statusUpdated(self.locationStatus)
            }
        }
        
        if(keyPath == "speed"){
            //update speed
            var rawSpeed: Double  = change[NSKeyValueChangeNewKey] as Double
            self.speed = rawSpeed
            var localizedSpeed = RunController.calculateSpeed(self.speed, mode:self.speedMode)
          
            var displayText = "\(localizedSpeed)"
            
            for observer in self.observers {
                observer.speedUpdated(displayText)
            }
        }
        
        if(keyPath == "distanceDelta"){
            //update speed
            //self.runController.distance
            if(self.state != runstate.active) { return }
            
            var newDistance: Double  = change[NSKeyValueChangeNewKey] as Double
            self.distance = self.distance + newDistance
                dataManager.updateDistance(self.distance)
            
            for observer in self.observers {
                observer.distanceUpdated(RunController.getDistance(self.distance,mode: self.speedMode))
            }
        }
        if(keyPath == "state"){
            for observer in self.observers {
                observer.stateUpdated(self.state)
            }
    
        }
        if(keyPath == "currentLocation"){
            var newLocation: CLLocation  = change[NSKeyValueChangeNewKey] as CLLocation
            self.dataManager.updateLocation(newLocation)
        }
        
    }
    
    
}


