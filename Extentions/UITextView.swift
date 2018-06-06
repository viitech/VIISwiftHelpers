//
//  UITextView.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit

extension UITextView {
    
    /*
     The following functions are all for
     creating a placeholder for UITextView
     */
    
    @nonobjc static var ignorePredictive = false
    
    func showFakePlaceholder(withText text: String, textColor: UIColor, fontSize: CGFloat = 17) {
        let placeholderLabel = UILabel(frame: CGRect(x: 5.0, y: 8.0, width: self.frame.width, height: self.frame.height))
        placeholderLabel.text = text
        placeholderLabel.textColor = textColor
        placeholderLabel.font = UIFont(name: placeholderLabel.font.fontName, size: fontSize)
        placeholderLabel.tag = 77
        for subview in self.subviews {
            if (subview.tag == 77) {
                subview.removeFromSuperview()
            }
        }
        self.addSubview(placeholderLabel)
    }
    
    func endEditCheck() {
        var hide = true
        // Check if text is empty
        if self.text.isEmpty {
            // Empty field
            hide = false
        }
        
        for subview in self.subviews {
            if (subview.tag == 77) {
                subview.isHidden = hide
            }
        }
    }
    
    func changingText(range: NSRange, text: String, placeholder: String) -> Bool {
        if (UITextView.ignorePredictive) {
            UITextView.ignorePredictive = false
            return false
        }
        var hide = true
        var changeText = true
        let newLength = self.text.utf16.count + text.utf16.count - range.length
        if newLength == 0 // no text, so show the placeholder
        {
            hide = false
        }
        
        for subview in self.subviews {
            if (subview.tag == 77) {
                if (hide && text != "") {
                    UITextView.ignorePredictive = true
                    if (range.location != self.text.utf16.count) {
                        let startToLocation = self.text.index(self.text.startIndex, offsetBy: range.location)
                        let endToLocation = self.text.index(self.text.endIndex, offsetBy: -(self.text.utf16.count-range.location)+range.length)
                        self.text = self.text[...startToLocation] + text + self.text[...endToLocation]
                        let cursorPosition = self.position(from: self.beginningOfDocument, in: UITextLayoutDirection.right, offset: range.location+(text.count))!
                        self.selectedTextRange = self.textRange(from: cursorPosition, to: cursorPosition)
                    } else {
                        self.text = self.text.trunc(self.text.utf16.count - range.length, trailing: "") + text
                    }
                    UITextView.ignorePredictive = false
                    changeText = false
                } else if (!hide) {
                    self.text = ""
                    changeText = false
                }
                subview.isHidden = hide
            }
        }
        
        // always return true
        return changeText
    }
    
}
