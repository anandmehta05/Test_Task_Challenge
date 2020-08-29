//
//  AppLoader.swift
//  Creditt
//
//  Created by Macbook Pro on 14/05/18.
//  Copyright © 2018 Geekmindz Solutions LLP. All rights reserved.
//

import UIKit
import SVProgressHUD


class AppLoader: NSObject
{
    
    static var sharedInstance = AppLoader()
    
    func startLoader(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(.black)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.show()
    }
    
   
    func stopLoader(){
        SVProgressHUD.dismiss()
    }
    
}
