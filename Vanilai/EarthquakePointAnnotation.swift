//
//  EarthquakePointAnnotation.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 3/12/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import MapKit
import UIKit

class EarthquakePointAnnotation: NSObject, MKAnnotation {
    var earthquake: Earthquake
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(earthquake: Earthquake) {
        self.title = "Magnitude: \(earthquake.magnitude)"
        self.coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
        self.subtitle = "\(earthquake.place), \(earthquake.depth)km depth"
        self.earthquake = earthquake
    }

    
}
