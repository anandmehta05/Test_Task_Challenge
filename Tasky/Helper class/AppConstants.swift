//
//  AppConstants.swift
//  HousePark
//
//  Created by Kaushik on 12/11/19.
//  Copyright © 2019 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit

struct AppConstants
{
    struct headersKey {
        static let accessToken = "authorization"
    }
    
    struct preferences{
        static let token = "token"
        static let id = "id"
        static let firstName = "first_name"
        static let role = "role"
        static let lastName = "last_name"
    }
    
    struct userType{
        static let admin = "admin"
        static let user = "user"
    }
    
    struct alertDismissTime {
        static let shortTime = 3.0
        static let mediumTime = 4.0
        static let longTime = 5.0
    }
    
    struct notificationObserver {
        static let reloadStoryList = "reload_story_list"
    }
}
