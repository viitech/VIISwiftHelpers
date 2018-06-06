//
//  Data.swift
//  LearnFlo
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import Foundation

extension Data {
	
	/// Return hexadecimal string representation of NSData bytes
	public var hexadecimalString: String {
        var bytes = [UInt8]()
		copyBytes(to: &bytes, count: count)
		
		let hexString = NSMutableString()
		for byte in bytes {
			hexString.appendFormat("%02x", UInt(byte))
		}
		
		return String(hexString)
	}
}
