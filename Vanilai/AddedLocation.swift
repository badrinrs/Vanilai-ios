//
//  AddedLocation.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/4/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import Foundation

class AddedLocation {
    let latitude: Double
    let longitude: Double
    let name: String
    
    init(latitude: Double, longitude: Double, name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
