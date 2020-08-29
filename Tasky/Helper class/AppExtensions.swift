//
//  AppExtensions.swift
//  HousePark
//
//  Created by Kaushik on 12/11/19.
//  Copyright © 2019 GeekMindz Solutions LLP. All rights reserved.
//

import Foundation
import  UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    static var randomColor: UIColor
    {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 0.7)
    }
}
extension Dictionary
{
    func nullKeyRemove() -> Dictionary
    {
        let replace :NSMutableDictionary = NSMutableDictionary(dictionary: self)
        
        for key in replace.allKeys
        {
            if("\(replace.object(forKey: "\(key)")!)" == "<null>")
            {
                replace.setValue("", forKey: key as! String)
            }
            else if (replace.object(forKey: "\(key)")!) is NSNull
            {
                replace.setValue("", forKey: key as! String)
            }
            else if ("\(replace.object(forKey: "\(key)")!)" == "nil")
            {
                replace.setValue("", forKey: key as! String)
            }
            else if ("\(replace.object(forKey: "\(key)")!)" == "null")
            {
                replace.setValue("", forKey: key as! String)
            }
            else if (replace.object(forKey: "\(key)")!) is Dictionary
            {
                replace.setValue(((replace.object(forKey: "\(key)")!) as! Dictionary).nullKeyRemove(), forKey: key as! String)
                
            }
            else if (replace.object(forKey: "\(key)")!) is NSArray
            {
                let arrays: NSMutableArray = replace.object(forKey: "\(key)")! as! NSMutableArray
                for i in 0..<arrays.count
                {
                    if (replace.object(forKey: "\(key)")!) is Dictionary
                    {
                        arrays[i] = (arrays[i] as! Dictionary).nullKeyRemove()
                    }
                    
                }
                
                replace.setValue(arrays, forKey: key as! String)
            }
            
        }
        
        return replace as! Dictionary<Key, Value>
    }
}
extension String {

    // formatting text for currency textField
    func currencyTextFieldFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyISOCode
        formatter.currencySymbol = "$"
        formatter.internationalCurrencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.paddingPosition = .afterPrefix
        formatter.paddingCharacter = " "


        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

       
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        // putting space between currency and amount
        if let amountString = formatter.string(from: number)
        {
            formatter.formatWidth = amountString.count + 1
        }
        else
        {
            return ""
        }
        
        if let amount = formatter.string(from: number)
        {
            return amount
        }
        else
        {
            return ""
        }
    }
     func currencyInputFormatting() -> String {

            var number: NSNumber!
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyISOCode
            formatter.currencySymbol = "$"
            formatter.internationalCurrencySymbol = "$"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.paddingPosition = .afterPrefix
            formatter.paddingCharacter = " "


    //        var amountWithPrefix = self
            
            // remove from String: "$", ".", ","
    //        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    //        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

           
            if let double = Double(self){
                number = NSNumber(value: double)
            }
            else
            {
                number = NSNumber(value: 0.00)
            }

            // if first number is 0 or all numbers were deleted
            guard number != 0 as NSNumber else {
                return ""
            }
            
            // putting space between currency and amount
            if let amountString = formatter.string(from: number)
            {
                formatter.formatWidth = amountString.count + 1
            }
            else
            {
                return ""
            }
            
            if let amount = formatter.string(from: number)
            {
                return amount
            }
            else
            {
                return ""
            }
        }
    func removeCurrencyFormatting() -> String
    {
        let number = self.filter { "0123456789.".contains($0)}
        if number != ""
        {
            return number
        }
        else
        {
            return "0.00"
        }
    }
}
