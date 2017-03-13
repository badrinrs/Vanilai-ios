//
//  ViewController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/1/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit
import MapKit
import MMDrawerController
import GoogleMobileAds

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
    @IBOutlet weak var getEarthquakes: UIButton!
    @IBOutlet weak var bannerAd: GADBannerView!
    @IBOutlet weak var temperatureType: UISegmentedControl!
    
    
    var locationManager = CLLocationManager()
    var api = Api()
    var forecast: Forecast!
    
    var centerContainer: MMDrawerController!
    var coordinate: CLLocationCoordinate2D!

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
        
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()

        let geocoder = CLGeocoder()
        print("Location: \(locationManager.location)")
        if let location = locationManager.location {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.showAlert(title: "Error Geocoding Location", message: "Please Try Again Later!")
                    self.locationLabel.text = ""
                } else {
                    let placemark = placemarks?[0]
                    self.locationLabel.text = placemark?.locality
                }
            }
        }
        guard let coordinate = locationManager.location?.coordinate else {
            showAlert(title: "Error Getting Location!", message: "Please try again later!")
            return
        }
        self.coordinate = coordinate
        activityIndicator.startAnimating()
        api.getForecast(latitude: coordinate.latitude, longitude: coordinate.longitude) { (forecast, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(title: "Error getting forecast!", message: "Please Try again!")
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
    
    @IBAction func getEarthquakeInformation(_ sender: Any) {
        if let location = locationManager.location {
            activityIndicator.startAnimating()
            api.getEarthquakes(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (earthquakes, error) in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert(title: "Error!", message: "Please try again later!")
                } else {
                    if let earthquakes = earthquakes {
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "earthquakeVC") as! UITabBarController
                        (viewController.viewControllers?[0] as! EarthquakeMapController).earthquakes = earthquakes
                        (viewController.viewControllers?[0] as! EarthquakeMapController).coordinate = self.coordinate
                        ((viewController.viewControllers?[1] as! UINavigationController).viewControllers[0] as! EarthquakeController).earthquakes = earthquakes
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Location: \(location)")
            let coordinate = location.coordinate
            self.coordinate = coordinate
            activityIndicator.startAnimating()
            api.getForecast(latitude: coordinate.latitude, longitude: coordinate.longitude) { (forecast, error) in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.showAlert(title: "Error getting forecast!", message: "Please Try again!")
                } else {
                    if let forecast = forecast {
                        self.currentTemperature.text = "\(Int(forecast.temperature))\u{00B0}F"
                        self.temperatureType.selectedSegmentIndex = 0
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
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if(activityIndicator.isAnimating) {
            activityIndicator.stopAnimating()
        }
        print(error.localizedDescription)
        showAlert(title: "Failed to get Location", message: "Please try again Later!")
    }
    
    
    @IBAction func toggleMenu(_ sender: Any) {
        centerContainer.toggle(.right, animated: true, completion: nil)
    }
}

