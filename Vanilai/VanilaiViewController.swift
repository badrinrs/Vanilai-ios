//
//  ViewController.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/1/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit
import MapKit
import MMDrawerController

class VanilaiViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentPrecipitation: UILabel!
    @IBOutlet weak var hourlyWeatherButton: UIButton!
    @IBOutlet weak var dailyWeatherButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var api = Api()
    var forecast: Forecast!
    
    var centerContainer: MMDrawerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

        locationManager.startMonitoringSignificantLocationChanges()
        createRoundedButton(button: hourlyWeatherButton)
        createRoundedButton(button: dailyWeatherButton)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationManager.location!) { (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(title: "Error Geocoding Location", message: "Please Try Again Later!")
                self.locationLabel.text = ""
            } else {
                let placemark = placemarks?[0]
                self.locationLabel.text = placemark?.locality
            }
        }
        guard let coordinate = locationManager.location?.coordinate else {
            showAlert(title: "Error Getting Location!", message: "Please try again later!")
            return
        }
        activityIndicator.startAnimating()
        api.getForecast(latitude: coordinate.latitude, longitude: coordinate.longitude) { (forecast, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(title: "Error getting forecast!", message: "Please Try again!")
            } else {
                if let forecast = forecast {
                    self.currentTemperature.text = "\(forecast.temperature)\u{00B0}"
                    self.currentWeatherLabel.text = forecast.summary
                    self.currentHumidity.text = "\(Int(forecast.humidity*100))%"
                    self.currentPrecipitation.text = "\(Int(forecast.precipProbability*100))%"
                    self.weatherImage.image = forecast.getIcon()
                    self.currentWeatherImage.image = forecast.getWeatherImage()
                    
                    self.forecast = forecast
                }
            }
        }

    }

    @IBAction func hourlyWeather(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DailyWeatherController") as! DailyWeatherController
        viewController.forecast = forecast
        viewController.forecastType = "hourly"
        viewController.location = self.locationLabel.text
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func dailyWeather(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DailyWeatherController") as! DailyWeatherController
        viewController.forecast = forecast
        viewController.forecastType = "daily"
        viewController.location = self.locationLabel.text
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            activityIndicator.startAnimating()
            api.getForecast(latitude: coordinate.latitude, longitude: coordinate.longitude) { (forecast, error) in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.showAlert(title: "Error getting forecast!", message: "Please Try again!")
                } else {
                    if let forecast = forecast {
                        self.currentTemperature.text = "\(forecast.temperature)\u{00B0}"
                        self.currentWeatherLabel.text = forecast.summary
                        self.currentHumidity.text = "\(Int(forecast.humidity*100))%"
                        self.currentPrecipitation.text = "\(Int(forecast.precipProbability*100))%"
                        self.weatherImage.image = forecast.getIcon()
                        self.currentWeatherImage.image = forecast.getWeatherImage()
                        self.forecast = forecast
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if(activityIndicator.isAnimating) {
            activityIndicator.stopAnimating()
        }
        showAlert(title: "Failed to get Location", message: "Please try again Later!")
    }
    
    func createRoundedButton(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    @IBAction func toggleMenu(_ sender: Any) {
        centerContainer.toggle(.right, animated: true, completion: nil)
    }
}

