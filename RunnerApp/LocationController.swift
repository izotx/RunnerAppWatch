//
//  LocationController.swift
//  RunnerApp
//
//  Created by sadmin on 1/17/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    dynamic var status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    dynamic var speed: Double
    dynamic var direction: CLLocationDirection
    dynamic var currentLocation:CLLocation?
    dynamic var distanceDelta:Double
    var lastTimestamp:NSDate
    var locations:[CLLocation] = []
    
    override init() {
        self.speed = 0
        self.direction = 0

       // self.currentLocation: = CLLocation();
        self.distanceDelta = 0
        self.lastTimestamp = NSDate()
        super.init();
        
        //check for permissions
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.desiredAccuracy = 5
        
        //saving battery
        self.locationManager.pausesLocationUpdatesAutomatically = true

        //specifying activity type as fitness
        self.locationManager.activityType = CLActivityType.Fitness
    }
    
    func stopUpdating(){
        self.locationManager.stopUpdatingLocation();
    }
    
    func startUpdating(){
        self.locationManager.startUpdatingLocation()
    }
    
    func checkPermissions(){
        if(CLLocationManager.headingAvailable())
        {   self.locationManager.headingFilter = 5
            self.locationManager .startUpdatingHeading()
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
           self.direction = newHeading.trueHeading
    }
    
    
    func averageLocation(locs: [CLLocation]) -> CLLocation
    {
         var maxx:CLLocationDegrees = -180
        var maxy:CLLocationDegrees = -90
        var minx:CLLocationDegrees = 180
        var miny:CLLocationDegrees = 90
        
//            var points : [CLLocationCoordinate2D] = []
            for(var i = 0; i<locs.count; i++) {
                var loc:CLLocation = locs[i]
                
                var loc2d = loc.coordinate
             //   points.append(loc2d)
                if(maxy < loc2d.latitude) {maxy = loc2d.latitude}
                if(maxx < loc2d.longitude ) {maxx = loc2d.longitude}
                if(minx > loc2d.longitude ) {minx = loc2d.longitude}
                if(miny > loc2d.latitude ) {miny = loc2d.latitude}
            
                
        
        }
            var centerAvLat = CLLocationDegrees((maxy+miny)/2.0)
            var centerAvLon = CLLocationDegrees((maxx+minx)/2.0)
            //drop the element with a biggest distance to neighbors
        
        var cl:  CLLocation = CLLocation(latitude: centerAvLat, longitude: centerAvLon)

        
        
        return cl
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        self.status = status
        println("status changed \(self.status)")
        if(status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            //self.locationManager.startUpdatingLocation()
        }
    }
    
    
    
   
    func filterByAverage(loc: CLLocation )->(Bool, CLLocation){
        locations.append(loc)
        if(locations.count < 6 )
        {
             return (false, loc)
        }

        locations.removeAtIndex(0)
        var cl = averageLocation(locations)
        return (true, cl)
    }
    
    
    func filterBadResults(newLocation : CLLocation)->Bool{
        if (newLocation.horizontalAccuracy < 0) {
            println("wrong reading horizontal accuracy \(newLocation.horizontalAccuracy))")

            return false
        
        }
        if (newLocation.horizontalAccuracy > 66) {
            println("wrong reading: horizontal Accuracy \(newLocation.verticalAccuracy)")

            return false
        }
        
        if (newLocation.verticalAccuracy < 0) {
         //   return false
          //   println("wrong reading vertical Accuracy \(newLocation.verticalAccuracy)")
            
        }
        
        
        var tempDistance = newLocation.distanceFromLocation(self.currentLocation)

        if(tempDistance > 50){
            println("wrong reading: Distance \(tempDistance)")
          //  return false;
        
        }
        
        if(self.currentLocation != nil){
            var timePassed : NSTimeInterval = newLocation.timestamp.timeIntervalSince1970 - self.currentLocation!.timestamp.timeIntervalSince1970
            var tempDistance = newLocation.distanceFromLocation(self.currentLocation)

            var newSpeed = tempDistance / timePassed
     
            var speedDelta = newSpeed - self.speed
            if((speedDelta) > 4) {
             
                println("wrong speed Accuracy \(speedDelta)")
            
            }
        }
        
        //Bool
        return true
    }
    

    /**This method will be use to track user's location*/
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        //    if(oldLocation == nil){return}
        //    if(newLocation == nil){return}
        
            var avg = filterByAverage(newLocation)
            if avg.0 == false {return}
            var avgLocation = avg.1
        
         //   if !self.filterBadResults(newLocation) {return}
            
            var timePassed : NSTimeInterval = newLocation.timestamp.timeIntervalSince1970 - self.lastTimestamp.timeIntervalSince1970
       
            self.distanceDelta = avgLocation.distanceFromLocation(self.currentLocation)
            self.speed = self.distanceDelta / timePassed
            self.currentLocation = avgLocation
            self.lastTimestamp = NSDate()

    }
}
