//
//  UIColor+Extensions.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/13/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func lightBlue() -> UIColor {
        let color = UIColor(displayP3Red: 132.0/255.0, green: 112/255.0, blue: 255.0/255.0, alpha: 1.0)
        return color
    }
    
    class func pink() -> UIColor {
        let color = UIColor(displayP3Red: 255.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        return color
    }
}
