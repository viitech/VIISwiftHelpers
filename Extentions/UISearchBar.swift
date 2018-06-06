//
//  UISearchBar.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit

extension UISearchBar {
	
	func cancelButtonTintColor(color: UIColor) {
		let view: UIView = self.subviews[0] as UIView
		for subView: UIView in view.subviews {
			if (subView is UIButton) {
				subView.tintColor = color
			}
		}
	}
	
}
