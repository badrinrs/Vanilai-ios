//
//  EarthquakeDetailController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 3/10/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EarthquakeDetailController: UIViewController {
    
    var earthquake: Earthquake!
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var earthquakeTypeImage: UIImageView!
    @IBOutlet weak var earthquakeMagnitude: UILabel!
    @IBOutlet weak var alertLevel: UILabel!
    @IBOutlet weak var significance: UILabel!
    @IBOutlet weak var reportedAt: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var moreInformationButton: UIButton!
    @IBOutlet weak var earthquakeBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = VanilaiConstants.MOBILE_ADS_UNIT_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        placeName.text = earthquake.place
        if earthquake.tsunami == TsunamiEnum.NO_TSUNAMI {
            earthquakeTypeImage.image = #imageLiteral(resourceName: "earthquake")
        } else {
            earthquakeTypeImage.image = #imageLiteral(resourceName: "tsunami").imageWithColor(color: .red)
        }
        earthquakeMagnitude.text = "\(earthquake.magnitude)"
        
        switch(earthquake.alert) {
        case .GREEN:
            alertLevel.text = "GREEN"
            alertLevel.textColor = UIColor.green
            break
        case .ORANGE:
            alertLevel.text = "ORANGE"
            alertLevel.textColor = UIColor.orange
            break
        case .RED:
            alertLevel.text = "RED"
            alertLevel.textColor = UIColor.red
            break
        case .YELLOW:
            alertLevel.text = "YELLOW"
            alertLevel.textColor = UIColor.yellow
            break
        case .DEFAULT:
            alertLevel.text = "No Alerts"
            alertLevel.textColor = UIColor.white
            break
        }
        
        significance.text = "\(earthquake.sig)"
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        reportedAt.text = formatter.string(from: earthquake.time)
        earthquakeBackground.image = earthquake.getEarthquakeImage()
    }
    
    @IBAction func getMoreInformation(_ sender: Any) {
        let url = URL(string: earthquake.detailUrl)
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
        } else {
            showAlert(title: "No Details Found!", message: "Please Try Again Later!")
        }
    }
}
