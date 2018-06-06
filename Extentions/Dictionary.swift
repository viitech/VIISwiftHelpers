//
//  Dictionary.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

extension Dictionary {
	func mergedWith(otherDictionary: [Key: Value]?) -> [Key: Value] {
		if let dictionary = otherDictionary {
			var mergedDict: [Key: Value] = [:]
			[self, dictionary].forEach { dict in
				for (key, value) in dict {
					mergedDict[key] = value
				}
			}
			return mergedDict
		} else {
			return self
		}
	}
}
