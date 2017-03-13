//
//  EarthquakeController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 3/8/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EarthquakeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var earthquakes: [Earthquake]!
    
    @IBOutlet weak var earthquakeTableView: UITableView!
    @IBOutlet weak var bannerAd: GADBannerView!
    
    override func viewDidLoad() {
        bannerAd.adUnitID = VanilaiConstants.MOBILE_ADS_UNIT_ID
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
        self.navigationItem.title = "Earthquakes"
        earthquakeTableView.dataSource = self
        earthquakeTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "earthquakeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EarthquakeCell
        cell.location.text = earthquakes[indexPath.row].place
        cell.magnitude.text = "\(earthquakes[indexPath.row].magnitude)"
        if earthquakes[indexPath.row].tsunami == TsunamiEnum.TSUNAMI_WARN {
            cell.tsunamiImage.image = #imageLiteral(resourceName: "tsunami").imageWithColor(color: .red)
        } else {
            cell.tsunamiImage.image = #imageLiteral(resourceName: "earthquake")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let earthquakeSelected = earthquakes[indexPath.row]
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "earthquakeDetailVC") as! EarthquakeDetailController
        detailViewController.earthquake = earthquakeSelected
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
