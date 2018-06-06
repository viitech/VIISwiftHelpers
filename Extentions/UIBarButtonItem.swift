//
//  UIBarButtonItem.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    var hidden: Bool {
        get {
            return self.isEnabled && self.tintColor! == UIColor.clear
        }
        set {
            self.tintColor = newValue ? UIColor.clear : nil
            self.isEnabled = !newValue
        }
    }
    
    func loadingStart() {
        // Create spinner
        let myIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        // Position the spinner
        let btnView = self.value(forKey: "view") as! UIView
        let width = self.width
        myIndicator.center = CGPoint(x: btnView.frame.size.width / 2, y: btnView.frame.size.height / 2)
        // Add to button
        btnView.addSubview(myIndicator)
        // Start the animation
        myIndicator.startAnimating()
        self.title = ""
        self.image = nil
        self.width = width
        self.isEnabled = false
    }
    
    func loadingEnd(title: String? = nil, image: UIImage? = nil) {
        let btnView = self.value(forKey: "view") as! UIView
        for btnView in btnView.subviews {
            if btnView is UIActivityIndicatorView {
                btnView.removeFromSuperview()
            }
        }
        //reset the button title
        if let title = title {
            self.title = title
        } else if let image = image {
            self.image = image
        }
        
//        self.isEnabled = true
    }
}
