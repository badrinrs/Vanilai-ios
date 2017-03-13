//
//  DrawerController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/4/17.
//  Copyright © 2017 Racivhandran Ramachandran. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import GooglePlaces

class DrawerController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet weak var searchLocationTextField: UITextField!
    
    var resultSearchController:UISearchController? = nil
    
    var addedLocations = [AddedLocation]()
    var locationManager = CLLocationManager()
    var context: NSManagedObjectContext!
    fileprivate var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawerTableView.delegate = self
        drawerTableView.dataSource = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startMonitoringSignificantLocationChanges()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        searchLocationTextField.delegate = self
        
        let location = locationManager.location
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    let locality = placemark.locality ?? ""
                    self.addedLocations.insert(AddedLocation(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), name: locality), at: 0)
                    if(self.addedLocations.count>1) {
                        self.addedLocations.remove(at: 1)
                    }
                    self.drawerTableView.reloadData()
                } else {
                    //TODO Error
                }
            }
        }
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")
        do {
            locations = try context.fetch(fetchRequest) as! [Location]
            for location in locations {
                let addedLocation = AddedLocation(latitude: location.latitude, longitude: location.longitude, name: location.name ?? "")
                addedLocations.append(addedLocation)
                drawerTableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @IBAction func searchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true) {
            self.drawerTableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        CLGeocoder().reverseGeocodeLocation(location!) { (placemarks, error) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let locality = placemark.locality ?? ""
                self.addedLocations.insert(AddedLocation(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, name: locality), at: 0)
                if(self.addedLocations.count>1) {
                    self.addedLocations.remove(at: 1)
                }
                self.drawerTableView.reloadData()
            } else {
                //TODO Error
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationCell
        if indexPath.row == 0 {
            cell.currentLocationImage.image = #imageLiteral(resourceName: "currentLocation").imageWithColor(color: .white)
        } else {
            cell.currentLocationImage.isHidden = true
        }
        cell.locationLabel.text = addedLocations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0) {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VanilaiViewController") as! VanilaiViewController
            self.navigationController?.present(viewController, animated: true, completion: nil)
        } else {
            let location = addedLocations[indexPath.row]
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NewVanilaiViewController") as! NewVanilaiViewController
            viewController.latitude = location.latitude
            viewController.longitude = location.longitude
            self.navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row != 0 {
            addedLocations.remove(at: indexPath.row)
            let location = locations.remove(at: indexPath.row)
            context.delete(location)
            do {
                try context.save()
            } catch let error as NSError {
                //TODO Alert
                print("Error removing from DB: \(error), \(error.userInfo)")
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

extension DrawerController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let addedLocation = AddedLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, name: place.name)
        addedLocations.append(addedLocation)
        let location = Location(location: addedLocation, context: context)
        locations.append(location)
        do {
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.drawerTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
