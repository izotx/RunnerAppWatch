//
//  MapViewController.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/2/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, LocationUpdated, MKMapViewDelegate{
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: mphButton!
    @IBOutlet weak var timeLabel: SingleLabel!
    @IBOutlet weak var distanceLabel: DoubleLabel!
    @IBOutlet weak var speedLabel: DoubleLabel!
    @IBOutlet weak var metricsButton: mphButton!
    
    var metrics:measurements = measurements.kph
    
    @IBAction func changeMetrics(sender: AnyObject) {

        if(self.metrics == measurements.kph)
        {
            self.metrics = measurements.mph
            self.metricsButton.text = "mph"
            self.distanceLabel.bottomText = "miles"
            self.speedLabel.bottomText = "mph"
        }
        else{
            self.metrics = measurements.kph
            self.metricsButton.text = "kph"
            self.distanceLabel.bottomText = "km"
            self.speedLabel.bottomText = "kmh"
        }
        if let tempRun = currentRun
        {
            self.updateLables(tempRun)
        }
    }
    
    var currentRun: Run?{didSet{
        if let tempRun = currentRun {
            self.addOverlay(tempRun)
            self.updateLables(tempRun)
            }
        }}
    
    var dataController:DataController?
   
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.removeOverlays(self.mapView.overlays)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.text = "Back"
        //get app delegate
        self.dataController?.observer = self
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.changeMetrics(self)
    }
    
    
    func updateLables(run:Run)
    {
        var tempDist = 0.0
        var tempTime = 0
        var averageSpeed = 0.0
        
        if let distance = run.distance {
            self.distanceLabel.topText =  RunController.getDistance(distance.doubleValue, mode: self.metrics)
            tempDist = distance.doubleValue
        }
        
        if let time = run.time {
            self.timeLabel.text =  RunController.convertTimeToText(time.integerValue)
            tempTime  = time.integerValue
        }
        
       if tempTime != 0
       {
            averageSpeed = tempDist / Double(tempTime)
        
       }

        self.speedLabel.topText = "\(RunController.calculateSpeed(averageSpeed, mode: self.metrics))"
    }
    
    func addOverlay(run:Run){
        var maxx:Float = -180
        var maxy:Float = -90
        var minx:Float = 180
        var miny:Float = 90
        
        var children =  run.mutableOrderedSetValueForKey("locations")
        var points : [CLLocationCoordinate2D] = []
        
        if children.count == 0 {return}
        
        for(var i = 0; i<children.count; i++) {
            var loc:Location = children.objectAtIndex(i) as Location
            
            var loc2d =   CLLocationCoordinate2D(latitude: CLLocationDegrees(loc.latitude!.floatValue), longitude: CLLocationDegrees(loc.longitude!.floatValue))
            points.append(loc2d)
            if(maxy < loc.latitude!.floatValue ) {maxy = loc.latitude!.floatValue}
            if(maxx < loc.longitude!.floatValue ) {maxx = loc.longitude!.floatValue}
            if(minx > loc.longitude!.floatValue ) {minx = loc.longitude!.floatValue}
            if(miny > loc.latitude!.floatValue ) {miny = loc.latitude!.floatValue}
        }
        
        
        var lonDelta:CLLocationDegrees  = abs(CLLocationDegrees(maxx-minx))
        var latDelta: CLLocationDegrees = abs(CLLocationDegrees(maxy-miny))
        
        var centerAvLat = CLLocationDegrees((maxy+miny)/2.0)
        var centerAvLon = CLLocationDegrees((maxx+minx)/2.0)
        var center = CLLocationCoordinate2D(latitude: centerAvLat, longitude:centerAvLon)
        var span = MKCoordinateSpanMake(latDelta*1.7, lonDelta*1.7)
        var mkregion = MKCoordinateRegionMake(center, span)
       
        self.mapView.setRegion(mkregion, animated: true)
        
        var polygon: MKPolyline = MKPolyline(coordinates: &points, count: points.count)
        self.mapView.addOverlay(polygon)
        
    }


    func updateRun(run: Run?) {
        //display the overlay
       
        if let tempRun:Run = run {
            self.addOverlay(tempRun)
            self.updateLables(tempRun)
        }
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return nil
    }
    
}