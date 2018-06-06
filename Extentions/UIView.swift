//
//  UIViewExtension.swift
//  LearnFlow
//

import UIKit
import QuartzCore

/// Computed properties, based on the backing CALayer property, that are visible in Interface Builder.
extension UIView {
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    /* Storyboard Inspectables */
    
    /// The width of the layer's border, inset from the layer bounds. The border is composited above the layer's content and sublayers and includes the effects of the `cornerRadius' property. Defaults to zero. Animatable.
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    /// The color of the layer's border. Defaults to opaque black. Colors created from tiled patterns are supported. Animatable.
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
//    /// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
//    @IBInspectable var shadowColor: UIColor? {
//        get {
//            return UIColor(cgColor: self.layer.shadowColor!)
//        }
//        set {
//            self.layer.shadowColor = newValue?.cgColor
//        }
//    }
//    
//    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
//    @IBInspectable var shadowOpacity: Float {
//        get {
//            return self.layer.shadowOpacity
//        }
//        set {
//            self.layer.shadowOpacity = newValue
//        }
//    }
//    
//    /// The shadow offset. Defaults to (0, -3). Animatable.
//    @IBInspectable var shadowOffset: CGSize {
//        get {
//            return self.layer.shadowOffset
//        }
//        set {
//            self.layer.shadowOffset = newValue
//        }
//    }
//    
//    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
//    @IBInspectable var shadowRadius: Double {
//        get {
//            return Double(self.layer.shadowRadius)
//        }
//        set {
//            self.layer.shadowRadius = CGFloat(newValue)
//        }
//    }
//    
//    @IBInspectable var imagePattern: UIImage?{
//        get {
//            return nil;
//        }
//        set {
//            
//            if let image = imagePattern{
//                backgroundColor = UIColor(patternImage: image)
//            }
//        }
//    }
    
    /* Custom Borders */
    
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.white, thickness: CGFloat = 1) {
        
        
        func border() -> UIView {
            let border = UIView(frame: CGRect())
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["top": top]))
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["left": left]))
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["right": right]))
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["bottom": bottom]))
        }
    }
    
    /* Get Identifier */
    
    class var identifier: String { return String.className(self) }
    
    /* Set Rounded (Circle) */
    
    func setRounded() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let radius = self.layer.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /* Un-Rounded (Circle) */
    
    func unroundRoundedView() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let radius = self.layer.frame.width * 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /* Get current first responser in view (with all sub-sub-sub views) */
    
    func currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
    
    /* Set Corner Radius Top only or Bottom only */
    
    func setCornerTop(radius: Int) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        self.layer.mask = rectShape
    }
    
    func setCornerBottom(radius: Int) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        self.layer.mask = rectShape
    }
    
    /* Open Activity Controller to share text, send the text and it will be shared! */
    
    func shareText(_ textToShare: String) -> UIActivityViewController {
        // set up activity view controller
        let objectsToShare: [AnyObject] = [ textToShare as AnyObject ]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self // so that iPads won't crash
        
        return activityViewController
    }
    
    /* */
    
    func rotateDegrees(rotationValue: Double = 1.0, duration: CFTimeInterval = 1.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * rotationValue)
        rotateAnimation.duration = duration
        rotateAnimation.isCumulative = true
        
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func reLayoutView() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
