//
//  CoreDataController.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/2/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

protocol LocationUpdated{
    func updateRun(run:Run?)
}
class DataController{
    var currentRun:Run?
    var delegate :AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var observer:LocationUpdated?

    init() {
       
    }
    
    class func getRuns()->[Run]?{
        var fetch:  NSFetchRequest  = NSFetchRequest(entityName:
            "Run")
        fetch.sortDescriptors = []
        var dataController = DataController()
        var result =    dataController.delegate.managedObjectContext?.executeFetchRequest(fetch, error: nil)
        
        return result as? [Run];
        
    }
    
    func createNewRun()-> Run{
        var description: NSEntityDescription = NSEntityDescription.entityForName("Run", inManagedObjectContext: delegate.managedObjectContext!)!
        var object = NSManagedObject(entity: description, insertIntoManagedObjectContext: delegate.managedObjectContext)  as! Run
        saveToDatabase()

        return object
    }
    
    func createNewLocation()-> Location{
        var description: NSEntityDescription = NSEntityDescription.entityForName("Location", inManagedObjectContext: delegate.managedObjectContext!)!
        var object = NSManagedObject(entity: description, insertIntoManagedObjectContext: delegate.managedObjectContext)as! Location

        return object
    }
    
    
    func startRun(){
        self.currentRun = createNewRun()
        self.currentRun!.started = NSDate()
    }
    
    //resets run to default value?
    func stopRun(){
        saveToDatabase()
        self.currentRun = nil
        

    }
    
    func updateTime(time:Int){
        self.currentRun?.time = time
        saveToDatabase()
    }
    
    func updateDistance(distance:Double){
         self.currentRun?.distance = distance
          saveToDatabase()
    }
    
    func updateLocation(_location:CLLocation)
    {
        var location = createNewLocation()
        location.timestamp = NSDate()
        location.latitude = _location.coordinate.latitude
        location.longitude = _location.coordinate.longitude
        
        if  let run = self.currentRun
        {
         var children =  run.mutableOrderedSetValueForKey("locations")
         children.addObject(location)
       

            saveToDatabase()
        }
        //push no
    }
    
    func saveToDatabase(){
        var error:NSError? = nil
        if(delegate.managedObjectContext!.save(&error)){
             self.observer?.updateRun(self.currentRun)
            return
        }

        println("Error: \(error)")
    
    }
    
    
    
    
    

}