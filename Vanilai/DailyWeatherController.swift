//
//  FutureWeatherController.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/3/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit

class DailyWeatherController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var forecastTableView: UITableView!
    var forecast: Forecast!
    var location: String!
    fileprivate var color: UIColor!
    fileprivate var dailyForecast: DailyForecast!
    fileprivate var hourlyForecast: HourlyForecast!
    var forecastType: String!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherSummary: UILabel!
    
    @IBOutlet weak var weatherSummaryImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        locationLabel.text = location
        navigationController?.navigationItem.backBarButtonItem?.title = "Vanilai"
        var imageView: UIImageView
        if forecastType == "daily" {
            let forecastData = forecast.dailyForecast
            weatherSummary.text = forecastData.summary
            weatherSummaryImage.image = forecastData.getIcon()
            imageView = UIImageView(image: forecastData.getWeatherImage())
            imageView.contentMode = .scaleAspectFill
            imageView.frame = forecastTableView.bounds
            self.forecastTableView.backgroundView = imageView
        } else if forecastType == "hourly" {
            let forecastData = forecast.hourlyForecast
            weatherSummary.text = forecastData.summary
            weatherSummaryImage.image = forecastData.getIcon()
            imageView = UIImageView(image: forecastData.getWeatherImage())
            imageView.contentMode = .scaleAspectFill
            imageView.frame = forecastTableView.bounds
            self.forecastTableView.backgroundView = imageView
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if forecastType == "daily" {
            count = forecast.dailyForecast.dailyForecastData.count
        } else if forecastType == "hourly" {
            count = forecast.hourlyForecast.hourlyForecasts.count
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath) as! HourlyDailyWeatherCell
        if forecastType == "daily" {
            let forecastCell = forecast.dailyForecast.dailyForecastData[indexPath.row]
            cell.weatherImage.image = forecastCell.getIcon()
            let image = #imageLiteral(resourceName: "blankWhite").alpha(0.5).addText(drawText: "\(Int(forecastCell.maxTemperature))" as NSString, atPoint: CGPoint(x: 50, y: 40), textColor: UIColor.black, textFont: nil)
            cell.temperatureImageView.image = image
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            cell.day.text = dateFormatter.string(from: forecastCell.time).capitalized
        } else if forecastType == "hourly" {
            let forecastCell = forecast.hourlyForecast.hourlyForecasts[indexPath.row]
            cell.weatherImage.image = forecastCell.getIcon()
            let image = #imageLiteral(resourceName: "blankWhite").alpha(0.5).addText(drawText: "\(Int(forecastCell.temperature))" as NSString, atPoint: CGPoint(x: 50, y: 40), textColor: UIColor.black, textFont: nil)
            cell.temperatureImageView.image = image
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, h:mm a"
            
            cell.day.text = dateFormatter.string(from: forecastCell.currentTime)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
}
