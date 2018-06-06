//
//  Results.swift
//  Springring
//
//  Created by Abdulla Allaith on 29/10/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit
import RealmSwift

extension Results where T: SpringringObject {
    func emptyResults() -> Results<T> {
        return self.filter("id = '-1'")
    }
    
    func toArray() -> [T] {
        var array: [T] = []
        for item in self {
            array.append(item)
        }
        return array
    }
    
    func idStringArray() -> [String] {
        var array: [String] = []
        for item in self {
            array.append(item.id)
        }
        return array
    }
    
//    func idStringObjectsArray() -> [StringObject] {
//        var array: [StringObject] = []
//        for item in self {
//            let stringObj = StringObject()
//            stringObj.id = item.id
//            array.append(stringObj)
//        }
//        return array
//    }
}
