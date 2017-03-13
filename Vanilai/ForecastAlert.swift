//
//  ForecastAlert.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/1/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//
import Foundation

class ForecastAlert {
    var alertTitle: String
    var alertDescription: String
    var expiry: Date
    
    init(alertTitle: String, alertDescription: String, expiry: Date) {
        self.alertDescription = alertDescription
        self.alertTitle = alertTitle
        self.expiry = expiry
    }
}
