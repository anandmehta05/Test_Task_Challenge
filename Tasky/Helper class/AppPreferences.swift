//
//  AppPreferences.swift
//  HousePark
//
//  Created by Kaushik on 19/11/19.
//  Copyright © 2019 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit

class AppPreferences: NSObject {
    
    static let sharedInstance = AppPreferences()
    
    var pref_token = preferences.object(forKey: AppConstants.preferences.token) as? String
    var pref_id = preferences.object(forKey: AppConstants.preferences.id) as? Int
    var pref_firstName = preferences.object(forKey: AppConstants.preferences.firstName) as? String
    var pref_role = preferences.object(forKey: AppConstants.preferences.role) as? String
    var pref_lastName = preferences.object(forKey: AppConstants.preferences.lastName) as? String
}
