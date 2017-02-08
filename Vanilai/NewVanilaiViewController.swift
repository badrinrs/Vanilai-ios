//
//  NewVanilaiViewController.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/5/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit
import MapKit
import MMDrawerController

class NewVanilaiViewController: UIViewController, CLLocationManagerDelegate {
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentPrecipitation: UILabel!
    @IBOutlet weak var weatherSummaryLabel: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var dailyWeatherButton: UIButton!
    @IBOutlet weak var hourlyWeatherButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var centerContainer: MMDrawerController!
    
    var forecast: Forecast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let centerViewController = self
        
        let rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "DrawerController") as! DrawerController
        
        let rightSideNav = UINavigationController(rootViewController: rightViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        centerContainer = MMDrawerController(center: centerNav, rightDrawerViewController: rightSideNav)
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
        appDelegate.window?.rootViewController = centerContainer
        appDelegate.window?.makeKeyAndVisible()
        
        createRoundedButton(button: hourlyWeatherButton)
        createRoundedButton(button: dailyWeatherButton)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(title: "Error Geocoding Location", message: "Please Try Again Later")
                self.locationLabel.text = ""
            } else {
                let placemark = placemarks?[0]
                self.locationLabel.text = placemark?.locality
            }
        }
        activityIndicator.startAnimating()
        Api().getForecast(latitude: latitude, longitude: longitude) { (forecast, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print("Error getting forecast: \(error.localizedDescription)")
                self.showAlert(title: "Error Getting Forcast!", message: "Please Try Again Later!")
            } else {
                if let forecast = forecast {
                    self.currentTemperature.text = "\(forecast.temperature)\u{00B0}"
                    self.weatherSummaryLabel.text = forecast.summary
                    self.currentHumidity.text = "\(Int(forecast.humidity*100))%"
                    self.currentPrecipitation.text = "\(Int(forecast.precipProbability*100))%"
                    self.weatherImage.image = forecast.getIcon()
                    self.currentWeatherImage.image = forecast.getWeatherImage()
                    self.forecast = forecast
                }
            }
        }
        
        
    }
    
    
    @IBAction func getHourlyDetails(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DailyWeatherController") as! DailyWeatherController
        viewController.forecast = forecast
        viewController.forecastType = "hourly"
        viewController.location = self.locationLabel.text
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func getDailyDetails(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DailyWeatherController") as! DailyWeatherController
        viewController.forecast = forecast
        viewController.forecastType = "daily"
        viewController.location = self.locationLabel.text
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func toggleMenu(_ sender: Any) {
        centerContainer.toggle(.right, animated: true, completion: nil)
    }
    
    func createRoundedButton(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
}
