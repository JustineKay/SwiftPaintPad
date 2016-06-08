//
//  Constant.swift
//  Paint
//
//  Created by Justine Kay on 6/8/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation
import UIKit

class Settings
{
    
    struct SavedSettings {
        static let WidthKey = "width"
        static let OpacityKey = "opacity"
        static let RedKey = "red"
        static let GreenKey = "green"
        static let BlueKey = "blue"
        static let SavedKey = "saved"
    }
    
    struct DefaultSettings {
        static let width: CGFloat = 10.0
        static let opacity: CGFloat = 1.0
        static let red: CGFloat = 0.0
        static let green: CGFloat = 0.0
        static let blue: CGFloat = 0.0
    }
}