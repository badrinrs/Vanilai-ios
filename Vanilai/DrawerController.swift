//
//  DrawerController.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/4/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol HandleMapSearch {
    func selectLocation(coordinate: CLLocationCoordinate2D, name: String)
}

class DrawerController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var drawerTableView: UITableView!
    
    var resultSearchController:UISearchController? = nil
    
    var addedLocations = [AddedLocation]()
    var locationManager = CLLocationManager()
    var context: NSManagedObjectContext!
    fileprivate var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawerTableView.delegate = self
        drawerTableView.dataSource = self
        
        locationManager.startMonitoringSignificantLocationChanges()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for locations"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        let location = locationManager.location
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
            cell.currentLocationImage.image = #imageLiteral(resourceName: "nearMe").imageWithColor(color: .blue)
        }
        cell.locationLabel.text = addedLocations[indexPath.row].name
        print("indexPath: \(indexPath.row)")
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

extension DrawerController: HandleMapSearch {
    func selectLocation(coordinate: CLLocationCoordinate2D, name: String) {
        let addedLocation = AddedLocation(latitude: coordinate.latitude, longitude: coordinate.longitude, name: name)
        addedLocations.append(addedLocation)
        let location = Location(location: addedLocation, context: context)
        locations.append(location)
        do {
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        drawerTableView.reloadData()
    }
}
