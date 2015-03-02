//
//  RunsViewController.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/5/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit

class RunCell:UITableViewCell{
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var distance:UILabel!
    @IBOutlet weak var time:UILabel!

}

class RunsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var runOutletButton: mphButton!
    @IBOutlet weak var tableView: UITableView!
    var runs = [Run]()
    var mapController:MapViewController?;

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.runOutletButton.text = "Back"
        self.runs = DataController.getRuns()!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return runs.count
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell =  tableView.dequeueReusableCellWithIdentifier("runid") as! RunCell

        var run = runs[indexPath.row]
        if let nr = run.distance {
            var d = nr as NSNumber
            var distance : Float = d.floatValue
            var initial = distance / Float(lengths.mile.rawValue)
            
            cell.distance.text = "\(round(initial * 10.0)/10.0 ) miles"
        }
        
        
                let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        
        
        if let start = run.started  {
            var stringValue = formatter.stringFromDate(start)
            cell.date.text = "\(stringValue)"
            println(cell.date.text)
        }
        if let time = run.time {
            cell.time.text = "\(RunController.convertTimeToText(time.integerValue))"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var run = runs[indexPath.row]
        self.mapController = storyboard!.instantiateViewControllerWithIdentifier(
            "map") as? MapViewController
        
        self.presentViewController(self.mapController!, animated: true) { () -> Void in
              self.mapController!.currentRun = run
        }
    }
    
}