//
//  UIColor.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import Foundation
import UIKit

/**
UIColor extension that add a whole bunch of utility functions like:
- HTML/CSS RGB format conversion (i.e. 0x124672)
- lighter color
- darker color
- color with modified brightness
*/
extension UIColor {
    /**
    Construct a UIColor using an HTML/CSS RGB formatted value and an alpha value
    
    - parameter rgbValue: RGB value
    - parameter alpha: color alpha value
    
    - returns: an UIColor instance that represent the required color
    */
    class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
	
	/**
	Return a modified color using any hex code 0xXXXXXX
	
	- parameter rgbValue: hex value
	- parameter alpha: color alpha value
	
	- returns: an UIColor instance that represent the required color
	*/
	class func colorWithHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
		let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
		let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
		let blue = CGFloat(rgbValue & 0xFF)/256.0
		
		return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
	}
	
	class func colorWithHexString(hex:String, alpha:Double=1.0) -> UIColor {
		var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
		
		if (cString.hasPrefix("#")) {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
		}
		
		if ((cString.count) != 6) {
			return UIColor.gray
		}
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
    /**
    Returns a lighter color by the provided percentage
    
    - parameter lighting: percent percentage
    - returns: lighter UIColor
    */
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    
    /**
    Returns a darker color by the provided percentage
    
    - parameter darking: percent percentage
    - returns: darker UIColor
    */
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 - percent));
    }
    
    /**
    Return a modified color using the brightness factor provided
    
    - parameter factor: brightness factor
    - returns: modified color
    */
    func colorWithBrightnessFactor(_ factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }

}
