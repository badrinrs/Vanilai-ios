//
//  DailyForecastData.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/1/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//
import UIKit

class DailyForecastData {
    var time: Date
    var summary: String
    var icon: String
    var sunriseTime: Date
    var sunsetTime: Date
    var precipProbability: Double
    var minTemperature: Double
    var minTemperatureTime: Date
    var maxTemperature: Double
    var maxTemperatureTime: Date
    var apparentMinTemperature: Double
    var apparentMinTemperatureTime: Date
    var apparentMaxTemperature: Double
    var apparentMaxTemperatureTime: Date
    var humidity: Double
    var windSpeed: Double
    var pressure: Double
    var precipIntensity: Double
    var dewPoint: Double
    var precipType: String
    var windBearing: Int
    var cloudCover: Double
    var ozone: Double
    
    init(time: Date, summary: String, icon: String, sunriseTime: Date, sunsetTime: Date, precipProbability: Double,
         minTemperature: Double, minTemperatureTime: Date, maxTemperature: Double, maxTemperatureTime: Date,
         apparentMinTemperature: Double, apparentMinTemperatureTime: Date,
         apparentMaxTemperature: Double, apparentMaxTemperatureTime: Date, humidity: Double, windSpeed: Double,
         pressure: Double, precipIntensity: Double, dewPoint: Double, precipType: String, windBearing: Int, cloudCover: Double, ozone: Double) {
        self.time = time
        self.summary = summary
        self.sunsetTime = sunsetTime
        self.sunriseTime = sunriseTime
        self.precipProbability = precipProbability
        self.minTemperature = minTemperature
        self.minTemperatureTime = minTemperatureTime
        self.maxTemperature = maxTemperature
        self.maxTemperatureTime = maxTemperatureTime
        self.apparentMinTemperature = apparentMinTemperature
        self.apparentMaxTemperature = apparentMaxTemperature
        self.apparentMinTemperatureTime = apparentMinTemperatureTime
        self.apparentMaxTemperatureTime = apparentMaxTemperatureTime
        self.humidity = humidity
        self.icon = icon
        self.windSpeed = windSpeed
        self.pressure = pressure
        self.precipIntensity = precipIntensity
        self.dewPoint = dewPoint
        self.precipType = precipType
        self.windBearing = windBearing
        self.cloudCover = cloudCover
        self.ozone = ozone
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
