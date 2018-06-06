//
//  UIImage.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

/**
	Usage:
	let originalImage = UIImage(named: "cat")
	let tintedImage = originalImage.tintWithColor(UIColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0))
*/

import Alamofire
import AlamofireImage

extension UIImage {
	
	// colorize image with given tint color
	// this is similar to Photoshop's "Color" layer blend mode
	// this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
	// white will stay white and black will stay black as the lightness of the image is preserved
	func tint(color: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
		let context = UIGraphicsGetCurrentContext()
  
		// flip the image
		context!.scaleBy(x: 1.0, y: -1.0)
		context!.translateBy(x: 0.0, y: -self.size.height)
		
		// multiply blend mode
		context!.setBlendMode(.multiply)
		
		let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		context!.clip(to: rect, mask: self.cgImage!)
		color.setFill()
		context!.fill(rect)
		
		// create uiimage
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
    
    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tintColor(color: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            color.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    private func modifiedImage(draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
	
    func multiply(color: UIColor) -> UIImage? {
        let rect = CGRect(origin: .zero, size: self.size)
        
        //image colored
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //image multiply
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // fill the background with white so that translucent colors get lighter
        context!.setFillColor(UIColor.white.cgColor)
        context!.fill(rect)
        
        self.draw(in: rect, blendMode: .normal, alpha: 1)
        coloredImage?.draw(in: rect, blendMode: .multiply, alpha: 1)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
}

extension UIImageView {
	
    func setImageWithPath(path: String?, placeholder: UIImage = Images.imagePlaceholder, completion: (()->Void)? = {} ) {
        if let path = path, path != "" {
            if let url = URL(string: path) {
//                let filter = AspectScaledToFitSizeFilter(size: self.frame.size)
                self.af_setImage(withURL: url, placeholderImage: placeholder, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { _ in
                    completion?()
                })
            }
        } else {
            self.image = placeholder
        }
	}
}
