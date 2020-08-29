//
//  AppURLConstants.swift
//  Birdoo
//
//  Created by Credify Technologies Private Limited on 31/01/20.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit

class AppURLConstants: NSObject {
    static var sharedInstance = AppURLConstants()
    let signin = AppSettings.sharedInstance.BASE_URL + AppSettings.sharedInstance.VERSION  + "signin"
    let stories = AppSettings.sharedInstance.BASE_URL + AppSettings.sharedInstance.VERSION  + "stories"
}
