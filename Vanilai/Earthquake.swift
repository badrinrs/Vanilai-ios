//
//  Earthquake.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 3/6/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit

class Earthquake {
    var magnitude: Double
    var place: String
    var time: Date
    var updatedAt: Date
    var url: String
    var detailUrl: String
    var maxReportedIntensity: Double  //cdi
    var maxEstimatedInstrumentalIntensity: Double  //mmi
    var alert: EarthquakeAlertEnum
    var tsunami: TsunamiEnum
    var title: String
    var sig: Int
    var latitude: Double
    var longitude: Double
    var depth: Double
    
    init(magnitude: Double, place: String, time: Date, updatedAt: Date, url: String, detailUrl: String, cdi: Double, mmi: Double, alert: EarthquakeAlertEnum, tsunami: TsunamiEnum, title: String, sig: Int, latitude: Double, longitude: Double, depth: Double) {
        self.magnitude = magnitude
        self.place = place
        self.time = time
        self.updatedAt = updatedAt
        self.url = url
        self.detailUrl = detailUrl
        self.maxReportedIntensity = cdi
        self.maxEstimatedInstrumentalIntensity = mmi
        self.alert = alert
        self.tsunami = tsunami
        self.title = title
        self.sig = sig
        self.latitude = latitude
        self.longitude = longitude
        self.depth = depth
    }
    
    func getEarthquakeImage() -> UIImage {
        if tsunami == TsunamiEnum.NO_TSUNAMI {
            return #imageLiteral(resourceName: "earthquake_wall.jpg")
        } else {
            return #imageLiteral(resourceName: "tsunami_wall.jpg")
        }
    }
    
}
