//
//  HourlyForecastData.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/3/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit

class HourlyForecastData {
    var currentTime: Date
    var summary: String
    var icon: String
    var temperature: Double
    var humidity: Double
    var precipProbability: Double
    var apparentTemperature: Double
    var windSpeed: Double
    var windBearing: Int
    var precipType: String
    var cloudCover: Double
    var dewPoint: Double
    var precipIntensity: Double
    var visibility: Double
    var ozone: Double
    var pressure: Double
    
    init(currentTime: Date, summary: String, icon: String, temperature: Double, humidity: Double,
         precipProbability: Double, apparentTemperature: Double, windSpeed: Double,
         windBearing: Int, precipType: String, cloudCover: Double, dewPoint: Double,
         precipIntensity: Double, visibility: Double, ozone: Double, pressure: Double) {
        self.currentTime = currentTime
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.humidity = humidity
        self.precipProbability = precipProbability
        self.apparentTemperature = apparentTemperature
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.precipType = precipType
        self.cloudCover = cloudCover
        self.dewPoint = dewPoint
        self.precipIntensity = precipIntensity
        self.visibility = visibility
        self.ozone = ozone
        self.pressure = pressure
    }
    
    func getIcon() -> UIImage {
        let image: UIImage
        switch icon {
        case "clear-day":
            image = #imageLiteral(resourceName: "sunny")
            break
        case "clear-night":
            image = #imageLiteral(resourceName: "moon")
            break
        case "rain":
            image = #imageLiteral(resourceName: "rainy")
            break
        case "snow":
            image = #imageLiteral(resourceName: "snow")
            break
        case "sleet":
            image = #imageLiteral(resourceName: "sleet")
            break
        case "wind":
            image = #imageLiteral(resourceName: "windy")
            break
        case "fog":
            image = #imageLiteral(resourceName: "foggy")
            break
        case "cloudy":
            image = #imageLiteral(resourceName: "cloud")
            break
        case "partly-cloudy-day":
            image = #imageLiteral(resourceName: "partiallycloudy")
            break
        case "partly-cloudy-night":
            image = #imageLiteral(resourceName: "partiallycloudynight")
            break
        case "hail":
            image = #imageLiteral(resourceName: "hail")
            break
        case "thunderstorm":
            image = #imageLiteral(resourceName: "thunderstorm")
            break
        case "tornado":
            image = #imageLiteral(resourceName: "tornado")
            break
        default:
            image = #imageLiteral(resourceName: "sunny")
        }
        return image
    }
}
