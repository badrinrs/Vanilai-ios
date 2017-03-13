//
//  PermissionViewController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/6/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit
import PermissionScope

class PermissionViewController: UIViewController {
    let pscope = PermissionScope()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pscope.addPermission(LocationWhileInUsePermission(),
                             message: "We use this to show weather\r\nfor all locations where you would be.")
        pscope.addPermission(LocationAlwaysPermission(), message: "We use this to show weather\r\nfor all locations where you would be.")
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
            if results[0].status == .authorized && results[1].status == .authorized {
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
