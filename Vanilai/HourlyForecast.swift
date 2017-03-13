//
//  HourlyForecast.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/1/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//
import UIKit

class HourlyForecast {
    var summary: String
    var icon: String
    var hourlyForecasts: [HourlyForecastData]
    
    init(summary: String, icon: String, hourlyForecasts: [HourlyForecastData]) {
        self.summary = summary
        self.icon = icon
        self.hourlyForecasts = hourlyForecasts
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
