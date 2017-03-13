//
//  Api.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/1/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit
import Firebase

class Api {
    
    func getForecast(latitude: Double, longitude: Double, completion: @escaping(_ forecast: Forecast?, _ error: NSError?) -> ()) {
        let url = buildUrl(latitude: latitude, longitude: longitude)
        Alamofire.request(url).responseJSON { (response) in
            FIRCrashMessage("Forecast Url: \(response.request?.url)")
            FIRCrashMessage("Response Result: \(response.result.debugDescription)")
            switch(response.result) {
            case .success(let data):
                let json = JSON(data)
                var forecastAlerts = [ForecastAlert]()
                var dailyForecastData = [DailyForecastData]()
                var hourlyForecasts = [HourlyForecastData]()
                if let alerts = json["alerts"].array {
                    for alert in alerts {
                        let alertTitle = Util.toString(string: alert["title"].string)
                        let description = Util.toString(string: alert["description"].string)
                        let expiry = Util.toDate(int64Value: alert["expiry"].int64)
                        forecastAlerts.append(ForecastAlert(alertTitle: alertTitle, alertDescription: description, expiry: expiry))
                    }
                }
                let daily = json["daily"]
                let dailySummary = daily["summary"].string
                let dailyIcon = daily["icon"].string
                if let data = daily["data"].array {
                    for dailyData in data {
                        let time = Util.toDate(int64Value: dailyData["time"].int64)
                        let sunsetTime = Util.toDate(int64Value: dailyData["sunsetTime"].int64)
                        let sunriseTime = Util.toDate(int64Value: dailyData["sunriseTime"].int64)
                        let summary = Util.toString(string: dailyData["summary"].string)
                        let icon = Util.toString(string: dailyData["icon"].string)
                        let minTemperature = Util.toDouble(double: dailyData["temperatureMin"].double)
                        let maxTemperature = Util.toDouble(double: dailyData["temperatureMax"].double)
                        let humidity = Util.toDouble(double: dailyData["hmidity"].double)
                        let precipProbability = Util.toDouble(double: dailyData["precipProbability"].double)
                        let minTemperatureTime = Util.toDate(int64Value: dailyData["temperatureMinTime"].int64)
                        let maxTemperatureTime = Util.toDate(int64Value: dailyData["temperatureMaxTime"].int64)
                        let apparentMaxTemperature = Util.toDouble(double: dailyData["apparentTemperatureMax"].double)
                        let apparentMinTemperature = Util.toDouble(double: dailyData["apparentTemperatureMin"].double)
                        let apparentMinTemperatureTime = Util.toDate(int64Value: dailyData["apparentTemperatureMinTime"].int64)
                        let apparentMaxTemperatureTime = Util.toDate(int64Value: dailyData["apparentTemperatureMaxTime"].int64)
                        let windSpeed = Util.toDouble(double: dailyData["windSpeed"].double)
                        let pressure = Util.toDouble(double: dailyData["pressure"].double)
                        let precipIntensity = Util.toDouble(double: dailyData["precipIntensity"].double)
                        let dewPoint = Util.toDouble(double: dailyData["dewPoint"].double)
                        let precipType = Util.toString(string: dailyData["precipType"].string)
                        let windBearing = Util.toInt(int: dailyData["windBearing"].int)
                        let cloudCover = Util.toDouble(double: dailyData["cloudCover"].double)
                        let ozone = Util.toDouble(double: dailyData["ozone"].double)
                        dailyForecastData.append(DailyForecastData(time: time, summary: summary, icon: icon, sunriseTime: sunriseTime, sunsetTime: sunsetTime, precipProbability: precipProbability, minTemperature: minTemperature, minTemperatureTime: minTemperatureTime, maxTemperature: maxTemperature, maxTemperatureTime: maxTemperatureTime, apparentMinTemperature: apparentMinTemperature, apparentMinTemperatureTime: apparentMinTemperatureTime, apparentMaxTemperature: apparentMaxTemperature, apparentMaxTemperatureTime: apparentMaxTemperatureTime, humidity: humidity, windSpeed: windSpeed, pressure: pressure, precipIntensity: precipIntensity, dewPoint: dewPoint, precipType: precipType, windBearing: windBearing, cloudCover: cloudCover, ozone: ozone))
                    }
                }
                let dailyForecast = DailyForecast(summary: dailySummary!, icon: dailyIcon!, dailyForecastData: dailyForecastData)
                let hourly = json["hourly"]
                let hourlySummary = hourly["summary"].stringValue
                let hourlyIcon = hourly["icon"].stringValue
                let hourlyData = hourly["data"].arrayValue
                for hourlyForecast in hourlyData {
                    let temperature = Util.toDouble(double: hourlyForecast["temperature"].double)
                    let windSpeed = Util.toDouble(double: hourlyForecast["windSpeed"].double)
                    let humidity = Util.toDouble(double: hourlyForecast["humidity"].double)
                    let windBearing = Util.toInt(int: hourlyForecast["windBearing"].int)
                    let precipType = Util.toString(string: hourlyForecast["precipType"].string)
                    let cloudCover = Util.toDouble(double: hourlyForecast["cloudCover"].double)
                    let time = Util.toDate(int64Value: hourlyForecast["time"].int64)
                    let dewPoint = Util.toDouble(double: hourlyForecast["dewPoint"].double)
                    let summary = Util.toString(string: hourlyForecast["summary"].string)
                    let icon = Util.toString(string: hourlyForecast["icon"].string)
                    let precipIntensity = Util.toDouble(double: hourlyForecast["precipIntensity"].double)
                    let visibility = Util.toDouble(double: hourlyForecast["visibility"].double)
                    let ozone = Util.toDouble(double: hourlyForecast["ozone"].double)
                    let apparentTemperature = Util.toDouble(double: hourlyForecast["apparentTemperature"].double)
                    let pressure = Util.toDouble(double: hourlyForecast["pressure"].double)
                    let precipProbability = Util.toDouble(double: hourlyForecast["precipProbability"].double)
                    hourlyForecasts.append(HourlyForecastData(currentTime: time, summary: summary, icon: icon, temperature: temperature, humidity: humidity, precipProbability: precipProbability, apparentTemperature: apparentTemperature, windSpeed: windSpeed, windBearing: windBearing, precipType: precipType, cloudCover: cloudCover, dewPoint: dewPoint, precipIntensity: precipIntensity, visibility: visibility, ozone: ozone, pressure: pressure))
                }
                let hourlyForecast = HourlyForecast(summary: hourlySummary, icon: hourlyIcon, hourlyForecasts: hourlyForecasts)
                let currently = json["currently"]
                let temperature = Util.toDouble(double: currently["temperature"].double)
                let windSpeed = Util.toDouble(double: currently["windSpeed"].double)
                let humidity = Util.toDouble(double: currently["humidity"].double)
                let cloudCover = Util.toDouble(double: currently["cloudCover"].doubleValue)
                let windBearning = Util.toInt(int: currently["windBearing"].int)
                let time = Util.toDate(int64Value: currently["time"].int64)
                let dewPoint = Util.toDouble(double: currently["dewPoint"].double)
                let summary = Util.toString(string: currently["summary"].string)
                let icon = Util.toString(string: currently["icon"].string)
                let precipIntensity = Util.toDouble(double: currently["precipIntensity"].double)
                let visibility = Util.toDouble(double: currently["visibility"].double)
                let nearestStormBearing = Util.toInt(int: currently["nearestStormBearing"].int)
                let apparentTemperature = Util.toDouble(double: currently["apparentTemperature"].double)
                let pressure = Util.toDouble(double: currently["pressure"].double)
                let precipProbability = Util.toDouble(double: currently["precipProbability"].double)
                let nearestStormDistance = Util.toInt(int: currently["nearestStormDistance"].int)
                let ozone = currently["ozone"].doubleValue
                
                let forecast = Forecast(currentTime: time, summary: summary, icon: icon, temperature: temperature, humidity: humidity, precipProbability: precipProbability, apparentTemperature: apparentTemperature, windSpeed: windSpeed, windBearing: windBearning, cloudCover: cloudCover, dewPoint: dewPoint, nearestStormBearing: nearestStormBearing, nearestStormDistance: nearestStormDistance, precipIntensity: precipIntensity, visibility: visibility, ozone: ozone, pressure: pressure, dailyForecast: dailyForecast, hourlyForecast: hourlyForecast, alert: forecastAlerts)
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
    
    func buildEarthquakeUrl(latitude: Double, longitude: Double) -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = VanilaiConstants.PROTOCOL
        urlComponents.host = VanilaiConstants.EARTHQUAKE_HOST
        urlComponents.path = VanilaiConstants.EARTHQUAKE_PATH
        let formatQueryItem = URLQueryItem(name: "format", value: "geojson")
        let latitudeQueryItem = URLQueryItem(name: "latitude", value: "\(latitude)")
        let longitudeQueryItem = URLQueryItem(name: "longitude", value: "\(longitude)")
        let maxRadiusQueryItem = URLQueryItem(name: "maxradiuskm", value: VanilaiConstants.MAX_RADIUS)
        let limitQueryItem = URLQueryItem(name: "limit", value: "20")
        urlComponents.queryItems = [formatQueryItem, latitudeQueryItem, longitudeQueryItem, maxRadiusQueryItem, limitQueryItem]
        return (urlComponents.url?.absoluteString)!
    }
    
    func getEarthquakes(latitude: Double, longitude: Double, completion: @escaping(_ earthquakes: [Earthquake]?, _ error: Error?) -> ()) {
        Alamofire.request(buildEarthquakeUrl(latitude: latitude, longitude: longitude)).responseJSON { (response) in
            FIRCrashMessage("Forecast Url: \(response.request?.url)")
            FIRCrashMessage("Response Result: \(response.result.debugDescription)")
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let features = json["features"].array
                if let features = features {
                    var earthquakes = [Earthquake]()
                    for feature in features {
                        let properties = feature["properties"]
                        let geometry = feature["geometry"]
                        let coordinates = geometry["coordinates"].array
                        var depth: Double = 0
                        var latitude: Double = 0
                        var longitude: Double = 0
                        if let coordinates = coordinates {
                            longitude = Util.toDouble(double: coordinates[0].double)
                            latitude = Util.toDouble(double: coordinates[1].double)
                            depth = Util.toDouble(double: coordinates[2].double)
                        }
                        let mag = Util.toDouble(double: properties["mag"].double)
                        let place = Util.toString(string: properties["place"].string)
                        let time = Util.toDate(int64Value: properties["time"].int64)
                        let updatedTime = Util.toDate(int64Value: properties["updated"].int64)
                        let url = Util.toString(string: properties["url"].string)
                        let detail = Util.toString(string: properties["detail"].string)
                        let cdi = Util.toDouble(double: properties["cdi"].double)
                        let mmi = Util.toDouble(double: properties["mmi"].double)
                        let sig = Util.toInt(int: properties["sig"].int)
                        let alert = Util.toEarthquakeAlertEnum(value: properties["alert"].string)
                        let tsunami = Util.toTsunamiEnum(value: properties["tsunami"].int)
                        let title = Util.toString(string: properties["title"].string)
                        earthquakes.append(Earthquake(magnitude: mag, place: place, time: time, updatedAt: updatedTime, url: url, detailUrl: detail, cdi: cdi, mmi: mmi, alert: alert, tsunami: tsunami, title: title, sig: sig, latitude: latitude, longitude: longitude, depth: depth))
                    }
                    completion(earthquakes, nil)
                } else {
                    completion(nil, NSError(domain: "Earthquake", code: 1, userInfo: ["Earthquake":"No Earthquakes found!"]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
