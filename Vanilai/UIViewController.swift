//
//  UIViewController.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 2/7/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
