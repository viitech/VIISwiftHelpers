//
//  UIWindow.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
	
	@nonobjc
	func setRootViewController(rootViewController rootVC: UIViewController) {
		self.rootViewController = rootVC
	}
	
	@nonobjc
    func setRootViewController(rootViewController rootVC: UIViewController, withAnimation options: UIViewAnimationOptions, completion: @escaping (() -> Void) = {}) {
        UIView.transition(with: self, duration: 0.3, options: options, animations: {
            self.rootViewController = rootVC
            }, completion: { _ in
                completion()
        })
    }
    
}
