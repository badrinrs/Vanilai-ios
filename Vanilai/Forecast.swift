//
//  CurrentForecast.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/1/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit

class Forecast {
    var currentTime: Date
    var summary: String
    var icon: String
    var temperature: Double
    var humidity: Double
    var precipProbability: Double
    var apparentTemperature: Double
    var windSpeed: Double
    var windBearing: Int
    var cloudCover: Double
    var dewPoint: Double
    var precipIntensity: Double
    var visibility: Double
    var ozone: Double
    var pressure: Double
    var nearestStormBearing: Int
    var nearestStormDistance: Int
    var dailyForecast: DailyForecast
    var hourlyForecast: HourlyForecast
    var alert: [ForecastAlert]
    
    init(currentTime: Date, summary: String, icon: String, temperature: Double, humidity: Double,
         precipProbability: Double, apparentTemperature: Double, windSpeed: Double,
         windBearing: Int, cloudCover: Double, dewPoint: Double, nearestStormBearing: Int, nearestStormDistance: Int,
         precipIntensity: Double, visibility: Double, ozone: Double, pressure: Double, dailyForecast: DailyForecast,
         hourlyForecast: HourlyForecast, alert: [ForecastAlert]) {
        self.currentTime = currentTime
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.humidity = humidity
        self.precipProbability = precipProbability
        self.apparentTemperature = apparentTemperature
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.cloudCover = cloudCover
        self.dewPoint = dewPoint
        self.precipIntensity = precipIntensity
        self.visibility = visibility
        self.ozone = ozone
        self.pressure = pressure
        self.dailyForecast = dailyForecast
        self.hourlyForecast = hourlyForecast
        self.alert = alert
        self.nearestStormBearing = nearestStormBearing
        self.nearestStormDistance = nearestStormDistance
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
    
    func getWeatherImage() -> UIImage {
        let image: UIImage
        switch icon {
        case "clear-day":
            image = #imageLiteral(resourceName: "clear-day.jpg")
            break
        case "clear-night":
            image = #imageLiteral(resourceName: "clear-night.jpg")
            break
        case "rain":
            image = #imageLiteral(resourceName: "rainy-day.jpg")
            break
        case "snow":
            image = #imageLiteral(resourceName: "snow-day.jpg")
            break
        case "sleet":
            image = #imageLiteral(resourceName: "snow-day.jpg")
            break
        case "wind":
            image = #imageLiteral(resourceName: "windy-day.jpg")
            break
        case "fog":
            image = #imageLiteral(resourceName: "fog.jpg")
            break
        case "cloudy":
            image = #imageLiteral(resourceName: "cloudy-day.jpg")
            break
        case "partly-cloudy-day":
            image = #imageLiteral(resourceName: "cloudy-day.jpg")
            break
        case "partly-cloudy-night":
            image = #imageLiteral(resourceName: "cloudy-night.jpg")
            break
        case "hail":
            image = #imageLiteral(resourceName: "rainy-day.jpg")
            break
        case "thunderstorm":
            image = #imageLiteral(resourceName: "thunderstorm-weather.jpg")
            break
        case "tornado":
            image = #imageLiteral(resourceName: "tornado-weather.jpg")
            break
        default:
            image = #imageLiteral(resourceName: "clear-day.jpg")
        }
        return image
    }
}
