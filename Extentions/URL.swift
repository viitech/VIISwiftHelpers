//
//  URL.swift
//  Springring
//
//  Created by Abdulla Allaith on 5/31/18.
//  Copyright © 2018 Springring. All rights reserved.
//

import Foundation

extension URL {
    
    public var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return [:]
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
