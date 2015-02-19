//
//  RunnerApp.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/2/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import CoreData

class RunnerApp: NSManagedObject {

    @NSManaged var averagespeed: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var started: NSDate
    @NSManaged var time: NSNumber
    @NSManaged var locations: NSOrderedSet

}
