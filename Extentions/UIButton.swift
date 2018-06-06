//
//  UIButton.swift
//  Springring
//
//  Created by Abdulla Allaith on 07/08/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setupButton(backgroundColor: UIColor? = nil, textColor: UIColor? = nil, cornerRadius: Double = 0.0) {
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if let textColor = textColor {
            self.titleLabel?.textColor = textColor
        }
        
        if (cornerRadius >= 0) {
            self.cornerRadius = cornerRadius
        } else {
            self.setRounded()
        }
        
    }
    
    func setTitleColor(_ color: UIColor) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .focused)
        self.setTitleColor(color, for: .disabled)
        self.setTitleColor(color, for: .reserved)
        self.setTitleColor(color, for: .application)
    }
    
    func loadingStart() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        // Create spinner
        let myIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        myIndicator.tintColor = UIColor.black
        // Resize and Position the spinner
        myIndicator.sizeToFit()
        myIndicator.center = self.center
        // Add to button
        self.addSubview(myIndicator)
        // Start the animation
        myIndicator.startAnimating()
        self.setTitle("", for: .normal)
        self.isEnabled = false
    }
    
    func loadingEnd(_ title: String? = nil) {
        for btnView in self.subviews {
            if btnView is UIActivityIndicatorView {
                btnView.removeFromSuperview()
            }
        }
        //reset the button title
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        
        self.isEnabled = true
    }
    
}
