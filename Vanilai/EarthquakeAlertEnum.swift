//
//  EarthquakeAlertEnum.swift
//  Vanilai
//
//  Created by Ravichandran Ramachandran on 3/6/17.
//  Copyright © 2017 Ravichandran Ramachandran. All rights reserved.
//

import Foundation
enum EarthquakeAlertEnum: String {
    case GREEN = "green"
    case YELLOW = "yellow"
    case ORANGE = "orange"
    case RED = "red"
    case DEFAULT = ""
}

enum TsunamiEnum: Int {
    case TSUNAMI_WARN = 1
    case NO_TSUNAMI = 0
}
