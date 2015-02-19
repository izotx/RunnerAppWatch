//
//  Location.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/2/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import CoreData
@objc(Location)
class Location: NSManagedObject {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var speed: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var run: Run

}
