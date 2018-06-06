//
//  ObjectMapper.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// Object of Realm's List type
public func <- <T: Mappable>(left: List<T>, right: Map) {
	var array: [T]?
	
	if right.mappingType == .toJSON {
		array = Array(left)
	}
	
	array <- right
	
	if right.mappingType == .fromJSON {
		if let theArray = array {
			left.append(objectsIn: theArray)
		}
	}
}

/// Object of Realm's RealmOptional type
public func <- <T>(left: RealmOptional<T>, right: Map) {
	var optional: T?
	
	if right.mappingType == .toJSON {
		optional = left.value
	}
	
	optional <- right
	
	if right.mappingType == .fromJSON {
		if let theOptional = optional {
			left.value = theOptional
		}
	}
}

public class DateFormatterTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    let dateFormatter: DateFormatter!
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let dateString = value as? String {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

public class Base64StringTransform: TransformType {
    public typealias Object = Data
    public typealias JSON = String
    
    public init() {
        
    }
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let dataBase64String = value as? String {
            return Data(base64Encoded: dataBase64String, options: Data.Base64DecodingOptions())
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if value != nil {
            return value?.base64EncodedString(options: Data.Base64EncodingOptions())
        }
        return nil
    }
}
