//
//  String.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

extension String {
	static func className(_ aClass: AnyClass) -> String {
		return NSStringFromClass(aClass).components(separatedBy: ".").last!
	}
	
	func trunc(_ length: Int, trailing: String = "...") -> String {
        if self.count > length {
            //return String(self.substring(to: (self.startIndex.advancedBy(length)) + trailing))
            return String(self[...self.index(self.startIndex, offsetBy: length)] + trailing)
		} else {
			return String(self)
		}
	}
	
	func toUInt() -> UInt32? {
		var rgbValue:UInt32 = 0
		Scanner(string: self).scanHexInt32(&rgbValue)
		return rgbValue
	}
	
	// UUID (Writen by Abdullah Allaith) very creative, wow
	static func generateUUID() -> String {
		return (NSUUID().uuidString as NSString).substring(to: 8)
	}
	
	var firstWord : String? {
		return self.regex("^([\\w\\-]+)")!.first
	}
	
	// regex function to return the first object
	func regex(_ pattern: String) -> [String]? {
		do {
			let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
			let nsstr = self as NSString
			let all = NSRange(location: 0, length: nsstr.length)
			var matches : [String] = [String]()
			regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
				(result : NSTextCheckingResult?, _, _) in
				if let r = result {
					let result = nsstr.substring(with: r.range) as String
					matches.append(result)
				}
			}
			return matches
		} catch {
			return [String]()
		}
	}
	
	func replaceWithRegex(_ pattern: String, with: String) -> String {
		var s = self

//		while let range = s.rangeOfString(pattern, options: .RegularExpressionSearch) {
//			s.replaceRange(range, with: with)
//		}
		
		if let replace = s.regex(pattern)!.first {
			s = s.replacingOccurrences(of: replace, with: with)
		}
		
		return s
		
	}
	
	func removeWithRegex(_ pattern: String) -> String {
		var s = self
		
		while let range = s.range(of: pattern, options: .regularExpression) {
			s.removeSubrange(range)
		}
		
		return s
	}
	
	func addFilter(_filter: String) -> String{
		if self.count == 0 {
			return _filter
		} else if self.contains(_filter.firstWord!) {
			return self.replaceWithRegex("\(_filter.firstWord!)([\\W]+)[\\d]+", with: _filter)
		} else {
			return self + " AND \(_filter)"
		}
	}
	
	func removeFilter(_filter: String) -> String{
		var s = self
		
		if self.contains(_filter) {
			s = s.removeWithRegex("\(_filter)([\\W]+)[\\d]+")
			s = s.removeWithRegex("^([\\s]+(AND)+[\\s]+)|([\\s]+(AND)+[\\s]+)$")
		}
		
		return s
	}
	
	var removeWhitespace : String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
	}
}
