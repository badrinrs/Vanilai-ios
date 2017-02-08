//
//  PermissionViewController.swift
//  Vanilai
//
//  Created by Badri Narayanan Ravichandran Sathya on 2/6/17.
//  Copyright © 2017 Badri Narayanan Ravichandran Sathya. All rights reserved.
//

import UIKit
import PermissionScope

class PermissionViewController: UIViewController {
    let pscope = PermissionScope()
    var countAuthorized = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pscope.addPermission(LocationWhileInUsePermission(),
                             message: "We use this to shownweather\r\nfor all locations where you would be.")
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
            if results[0].status == .authorized {
                let initialVC = self.storyboard?.instantiateViewController(withIdentifier: "VanilaiViewController") as! VanilaiViewController
                self.present(initialVC, animated: true, completion: nil)
            } else {
                //Show Alert to enable Access
            }
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })
    }
}
