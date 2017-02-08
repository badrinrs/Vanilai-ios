//
//  LocationSearchTable.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/4/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var matchingItems:[MKMapItem] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.locality
        cell.detailTextLabel?.text = "\(selectedItem.administrativeArea ?? "") \(selectedItem.countryCode ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.selectLocation(coordinate: selectedItem.coordinate, name: "\(cell.textLabel?.text ?? ""), \(cell.detailTextLabel?.text ?? "")")
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            
            self.matchingItems = response.mapItems
            
            self.tableView.reloadData()
        }
    }
}
