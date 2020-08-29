//
//  AppSettings.swift
//  Birdoo
//
//  Created by Credify Technologies Private Limited on 31/01/20.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit

class AppSettings: NSObject
{
    static var sharedInstance = AppSettings()
    
    let BASE_URL = "http://35.183.46.74:3000/api/"  // Live Base URL
            
    let VERSION = "v1/" // API Version
    
}

