//
//  Location+CoreDataClass.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/6/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import Foundation
import CoreData


public class Location: NSManagedObject {
    convenience init(location: AddedLocation, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = location.latitude
            self.longitude = location.longitude
            self.name = location.name
        } else {
            fatalError("Unable to find Entity name \"Location\"!")
        }
    }
}
