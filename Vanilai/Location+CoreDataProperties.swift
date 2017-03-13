//
//  Location+CoreDataProperties.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/6/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?

}
