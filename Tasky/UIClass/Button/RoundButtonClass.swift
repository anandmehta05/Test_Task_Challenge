//
//  RoundButtonClass.swift
//  Creditt
//
//  Created by Macbook Pro on 14/05/18.
//  Copyright © 2018 Geekmindz Solutions LLP. All rights reserved.
//

import UIKit
import Foundation

class RoundButtonClass: UIButton {
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.minimumScaleFactor = 0.01
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    

}
