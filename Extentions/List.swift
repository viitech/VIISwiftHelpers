//
//  List.swift
//  Springring
//
//  Created by Abdulla Allaith on 29/10/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import UIKit
import RealmSwift

extension List {
    
    func toArray() -> [T] {
        var array: [T] = []
        for item in self {
            array.append(item)
        }
        return array
    }
	
}

extension List where T: StringObject {
    func toStringArray() -> [String]{
        let arr = self.toArray()
        
        var strArr: [String] = []
        for strObj in arr {
            strArr.append(strObj.id)
        }
        
        return strArr
    }
}
