//
//  UIViewController.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class var identifier: String { return String.className(self) }
    class var closeBarBtn: UIBarButtonItem { return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissVC)) }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
	
	func makePullToRefreshToTableView(table: UITableView, methodName: String) -> UIRefreshControl {
		let refreshControl: UIRefreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: Selector(methodName), for: .valueChanged)
		table.addSubview(refreshControl)
		return refreshControl
	}
	
	func makePullToRefreshToCollectionView(collection: UICollectionView, methodName: String) -> UIRefreshControl{
		let refreshControl: UIRefreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: Selector(methodName), for: .valueChanged)
		collection.addSubview(refreshControl)
		return refreshControl
	}
    
    func showAlert(error: Errors.errorMsgs, cancelHandler: ((UIAlertAction) -> Void)? = { _ in }) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: cancelHandler)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
	
    func showAlert(title: String, message: String, cancelHandler: ((UIAlertAction) -> Void)? = { _ in }) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: cancelHandler)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
    func showConfirmation(_ title: String? = nil, message: String? = nil, cancelBtnText: String? = nil, confirmBtnText: String? = nil, thirdBtnText: String? = nil, forthBtnText: String? = nil, fifthBtnText: String? = nil, cancelHandler: ((UIAlertAction) -> Void)? = { _ in }, confirmHandler: ((UIAlertAction) -> Void)? = { _ in }, thirdHandler: ((UIAlertAction) -> Void)? = { _ in }, forthHandler: ((UIAlertAction) -> Void)? = { _ in }, fifthHandler: ((UIAlertAction) -> Void)? = { _ in }) {
        
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Cancel Text
        var cancelTxt = "Cancel"
        if let cancelBtnText = cancelBtnText {
            cancelTxt = cancelBtnText
        }
        // Confirm Text
        var confirmTxt = "Confirm"
        var confirmStyle = UIAlertActionStyle.default
        
        if let confirmBtnText = confirmBtnText {
            confirmTxt = confirmBtnText
            if confirmTxt == "Delete" || confirmTxt == "Unenroll" {
                confirmStyle = UIAlertActionStyle.destructive
            }
        }
        
		let cancelAction = UIAlertAction(title: cancelTxt, style: .cancel, handler: cancelHandler)
		let confirmAction = UIAlertAction(title: confirmTxt, style: confirmStyle, handler: confirmHandler)
		
		alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        if let thirdBtnText = thirdBtnText {
            let thirdAction = UIAlertAction(title: thirdBtnText, style: UIAlertActionStyle.default, handler: thirdHandler)
            alert.addAction(thirdAction)
        }
        
        if let forthBtnText = forthBtnText {
            let forthAction = UIAlertAction(title: forthBtnText, style: UIAlertActionStyle.default, handler: forthHandler)
            alert.addAction(forthAction)
        }
        
        if let fifthBtnText = fifthBtnText {
            let fifthAction = UIAlertAction(title: fifthBtnText, style: UIAlertActionStyle.default, handler: fifthHandler)
            alert.addAction(fifthAction)
        }
		
		self.present(alert, animated: true, completion: nil)
	}
    
    class func encloseWithNavCtrl<T:UIViewController>(viewCtrl: T.Type) -> UINavigationController {
        let nav = UINavigationController()
        let vc: T = UIStoryboard(name: Auth.storyboardID, bundle: nil).instantiateViewController(withIdentifier: T.identifier) as! T
        nav.viewControllers.append(vc)
        return nav
    }
}
