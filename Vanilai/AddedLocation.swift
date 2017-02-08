//
//  AddedLocation.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/4/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
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
