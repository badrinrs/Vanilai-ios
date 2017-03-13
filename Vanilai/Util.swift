//
//  Util.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 3/8/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import Foundation

class Util {
    static func toString(string: String?) -> String {
        var str = ""
        if let string = string {
            str = string
        }
        return str
    }
    
    static func toDate(int64Value: Int64?) -> Date {
        var date: Date = Date()
        if let int64Value = int64Value {
            date = Date(timeIntervalSince1970: TimeInterval(int64Value/1000))
        }
        return date
    }
    
    static func toDouble(double: Double?) -> Double {
        var value:Double = 0
        if let double = double {
            value = double
        }
        return value
    }
    
    static func toInt(int: Int?) -> Int {
        var value:Int = 0
        if let int = int {
            value = int
        }
        return value
    }
    
    static func toEarthquakeAlertEnum(value: String?) -> EarthquakeAlertEnum {
        var earthquakeAlertEnum: EarthquakeAlertEnum = EarthquakeAlertEnum.DEFAULT
        if let value = value {
            if let alertEnum = EarthquakeAlertEnum(rawValue: value) {
                earthquakeAlertEnum = alertEnum
            }
        }
        return earthquakeAlertEnum
    }
    
    static func toTsunamiEnum(value: Int?) -> TsunamiEnum {
        var tsunamiEnum = TsunamiEnum.NO_TSUNAMI
        if let value = value {
            if let tsunamiAlert = TsunamiEnum(rawValue: value) {
                tsunamiEnum = tsunamiAlert
            }
        }
        return tsunamiEnum
    }
    
    static func toTemperature(temperatureType: String, temperature: Double, completion: @escaping(_ temperatureType: String, _ temperature: Int) -> ()) {
        var newTemperatureType = ""
        var newTemperature: Double = 0
        if temperatureType == "\u{00B0}F" {
            newTemperatureType = "\u{00B0}C"
            newTemperature = ((temperature-32)*5)/9
        }
        else {
            newTemperatureType = "\u{00B0}F"
        }
        completion(newTemperatureType, Int(newTemperature))
    }
}
