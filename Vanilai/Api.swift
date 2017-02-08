//
//  Api.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/1/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

class Api {
    
    func getForecast(latitude: Double, longitude: Double, completion: @escaping(_ forecast: Forecast?, _ error: NSError?) -> ()) {
        let url = buildUrl(latitude: latitude, longitude: longitude)
        Alamofire.request(url).responseJSON { (response) in
            switch(response.result) {
            case .success(let data):
                let json = JSON(data)
                var forecastAlerts = [ForecastAlert]()
                var dailyForecastData = [DailyForecastData]()
                var hourlyForecasts = [HourlyForecastData]()
                if let alerts = json["alerts"].array {
                    for alert in alerts {
                        let alertTitle = alert["title"].stringValue
                        let description = alert["description"].stringValue
                        let expiry = alert["expiry"].int64Value
                        forecastAlerts.append(ForecastAlert(alertTitle: alertTitle, alertDescription: description, expiry: Date(timeIntervalSince1970: TimeInterval(expiry))))
                    }
                }
                let daily = json["daily"]
                let dailySummary = daily["summary"].string
                let dailyIcon = daily["icon"].string
                if let data = daily["data"].array {
                    for dailyData in data {
                        let time = dailyData["time"].int64Value
                        let sunsetTime = dailyData["sunsetTime"].int64Value
                        let sunriseTime = dailyData["sunriseTime"].int64Value
                        let summary = dailyData["summary"].stringValue
                        let icon = dailyData["icon"].stringValue
                        let minTemperature = dailyData["temperatureMin"].doubleValue
                        let maxTemperature = dailyData["temperatureMax"].doubleValue
                        let humidity = dailyData["hmidity"].doubleValue
                        let precipProbability = dailyData["precipProbability"].doubleValue
                        let minTemperatureTime = dailyData["temperatureMinTime"].int64Value
                        let maxTemperatureTime = dailyData["temperatureMaxTime"].int64Value
                        let apparentMaxTemperature = dailyData["apparentTemperatureMax"].doubleValue
                        let apparentMinTemperature = dailyData["apparentTemperatureMin"].doubleValue
                        let apparentMinTemperatureTime = dailyData["apparentTemperatureMinTime"].int64Value
                        let apparentMaxTemperatureTime = dailyData["apparentTemperatureMaxTime"].int64Value
                        let windSpeed = dailyData["windSpeed"].doubleValue
                        let pressure = dailyData["pressure"].doubleValue
                        let precipIntensity = dailyData["precipIntensity"].doubleValue
                        let dewPoint = dailyData["dewPoint"].doubleValue
                        let precipType = dailyData["precipType"].stringValue
                        let windBearing = dailyData["windBearing"].intValue
                        let cloudCover = dailyData["cloudCover"].doubleValue
                        let ozone = dailyData["ozone"].doubleValue
                        dailyForecastData.append(DailyForecastData(time: Date(timeIntervalSince1970: TimeInterval(time)), summary: summary, icon: icon, sunriseTime: Date(timeIntervalSince1970: TimeInterval(sunriseTime)), sunsetTime: Date(timeIntervalSince1970: TimeInterval(sunsetTime)), precipProbability: precipProbability, minTemperature: minTemperature, minTemperatureTime: Date(timeIntervalSince1970: TimeInterval(minTemperatureTime)), maxTemperature: maxTemperature, maxTemperatureTime: Date(timeIntervalSince1970: TimeInterval(maxTemperatureTime)), apparentMinTemperature: apparentMinTemperature, apparentMinTemperatureTime: Date(timeIntervalSince1970: TimeInterval(apparentMinTemperatureTime)), apparentMaxTemperature: apparentMaxTemperature, apparentMaxTemperatureTime: Date(timeIntervalSince1970: TimeInterval(apparentMaxTemperatureTime)), humidity: humidity, windSpeed: windSpeed, pressure: pressure, precipIntensity: precipIntensity, dewPoint: dewPoint, precipType: precipType, windBearing: windBearing, cloudCover: cloudCover, ozone: ozone))
                    }
                }
                let dailyForecast = DailyForecast(summary: dailySummary!, icon: dailyIcon!, dailyForecastData: dailyForecastData)
                let hourly = json["hourly"]
                let hourlySummary = hourly["summary"].stringValue
                let hourlyIcon = hourly["icon"].stringValue
                let hourlyData = hourly["data"].arrayValue
                for hourlyForecast in hourlyData {
                    let temperature = hourlyForecast["temperature"].doubleValue
                    let windSpeed = hourlyForecast["windSpeed"].doubleValue
                    let humidity = hourlyForecast["humidity"].doubleValue
                    let windBearing = hourlyForecast["windBearing"].intValue
                    let precipType = hourlyForecast["precipType"].stringValue
                    let cloudCover = hourlyForecast["cloudCover"].doubleValue
                    let time = hourlyForecast["time"].int64Value
                    let dewPoint = hourlyForecast["dewPoint"].doubleValue
                    let summary = hourlyForecast["summary"].stringValue
                    let icon = hourlyForecast["icon"].stringValue
                    let precipIntensity = hourlyForecast["precipIntensity"].doubleValue
                    let visibility = hourlyForecast["visibility"].doubleValue
                    let ozone = hourlyForecast["ozone"].doubleValue
                    let apparentTemperature = hourlyForecast["apparentTemperature"].doubleValue
                    let pressure = hourlyForecast["pressure"].doubleValue
                    let precipProbability = hourlyForecast["precipProbability"].doubleValue
                    hourlyForecasts.append(HourlyForecastData(currentTime: Date(timeIntervalSince1970: TimeInterval(time)), summary: summary, icon: icon, temperature: temperature, humidity: humidity, precipProbability: precipProbability, apparentTemperature: apparentTemperature, windSpeed: windSpeed, windBearing: windBearing, precipType: precipType, cloudCover: cloudCover, dewPoint: dewPoint, precipIntensity: precipIntensity, visibility: visibility, ozone: ozone, pressure: pressure))
                }
                let hourlyForecast = HourlyForecast(summary: hourlySummary, icon: hourlyIcon, hourlyForecasts: hourlyForecasts)
                let currently = json["currently"]
                let temperature = currently["temperature"].doubleValue
                let windSpeed = currently["windSpeed"].doubleValue
                let humidity = currently["humidity"].doubleValue
                let cloudCover = currently["cloudCover"].doubleValue
                let windBearning = currently["windBearing"].intValue
                let time = currently["time"].int64Value
                let dewPoint = currently["dewPoint"].doubleValue
                let summary = currently["summary"].stringValue
                let icon = currently["icon"].stringValue
                let precipIntensity = currently["precipIntensity"].doubleValue
                let visibility = currently["visibility"].doubleValue
                let nearestStormBearing = currently["nearestStormBearing"].intValue
                let apparentTemperature = currently["apparentTemperature"].doubleValue
                let pressure = currently["pressure"].doubleValue
                let precipProbability = currently["precipProbability"].doubleValue
                let nearestStormDistance = currently["nearestStormDistance"].intValue
                let ozone = currently["ozone"].doubleValue
                
                let forecast = Forecast(currentTime: Date(timeIntervalSince1970: TimeInterval(time)), summary: summary, icon: icon, temperature: temperature, humidity: humidity, precipProbability: precipProbability, apparentTemperature: apparentTemperature, windSpeed: windSpeed, windBearing: windBearning, cloudCover: cloudCover, dewPoint: dewPoint, nearestStormBearing: nearestStormBearing, nearestStormDistance: nearestStormDistance, precipIntensity: precipIntensity, visibility: visibility, ozone: ozone, pressure: pressure, dailyForecast: dailyForecast, hourlyForecast: hourlyForecast, alert: forecastAlerts)
                completion(forecast, nil)
                break
            case .failure(let error):
                completion(nil, error as NSError?)
            }
        }
    }
    
    func buildUrl(latitude: Double, longitude: Double) -> String {
        var url = ""
        url.append(VanilaiConstants.PROTOCOL)
        url.append("://")
        url.append(VanilaiConstants.HOST)
        url.append(VanilaiConstants.PATH_DIVIDER)
        url.append(VanilaiConstants.PATH)
        url.append(VanilaiConstants.PATH_DIVIDER)
        url.append(VanilaiConstants.FORECAST_API_KEY)
        url.append(VanilaiConstants.PATH_DIVIDER)
        url.append("\(latitude),\(longitude)")
        return url
    }
}
