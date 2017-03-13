//
//  NewVanilaiViewController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/5/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit
import MapKit
import MMDrawerController
import GoogleMobileAds

class NewVanilaiViewController: UIViewController, CLLocationManagerDelegate {
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentPrecipitation: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var dailyWeatherButton: UIButton!
    @IBOutlet weak var hourlyWeatherButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var getEarthquakes: UIButton!
    @IBOutlet weak var bannerAd: GADBannerView!
    @IBOutlet weak var temperatureType: UISegmentedControl!
    
    var centerContainer: MMDrawerController!
    
    var forecast: Forecast!
    let api = Api()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerAd.adUnitID = VanilaiConstants.MOBILE_ADS_UNIT_ID
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
        
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
        api.getForecast(latitude: latitude, longitude: longitude) { (forecast, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print("Error getting forecast: \(error.localizedDescription)")
                self.showAlert(title: "Error Getting Forcast!", message: "Please Try Again Later!")
            } else {
                if let forecast = forecast {
                    self.currentTemperature.text = "\(Int(forecast.temperature))\u{00B0}F"
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
    
    @IBAction func toggleTemperatureType(_ sender: Any) {
        var temperature = forecast.temperature
        if temperatureType.selectedSegmentIndex == 1 {
            temperature = (temperature-32)*5/9
            currentTemperature.text = "\(Int(temperature))\u{00B0}C"
        }
        else {
            currentTemperature.text = "\(Int(temperature))\u{00B0}F"
        }
    }
    
    @IBAction func toggleMenu(_ sender: Any) {
        centerContainer.toggle(.right, animated: true, completion: nil)
    }
    
    @IBAction func getEarthquakeInformation(_ sender: Any) {
        api.getEarthquakes(latitude: latitude, longitude: longitude) { (earthquakes, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showAlert(title: "Error!", message: "Please try again later!")
            } else {
                if let earthquakes = earthquakes {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "earthquakeVC") as! UITabBarController
                    (viewController.viewControllers?[0] as! EarthquakeMapController).earthquakes = earthquakes
                    (viewController.viewControllers?[0] as! EarthquakeMapController).coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                    ((viewController.viewControllers?[1] as! UINavigationController).viewControllers[0] as! EarthquakeController).earthquakes = earthquakes
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}
