//
//  TextField.swift
//  Springring
//
//  Created by Abdulla Allaith on 07/08/2017.
//  Copyright © 2017 Springring. All rights reserved.
//

import Material

extension TextField {
    func defaultSetup(withPlaceholder placeholderText: String) {
        self.dividerNormalColor = Colors.alto
        self.dividerActiveColor = Colors.default
        self.placeholderNormalColor = Colors.alto
        self.placeholderActiveColor = Colors.default
        self.placeholder = placeholderText
        self.placeholderVerticalOffset = 15
    }
}
