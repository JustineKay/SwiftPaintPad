//
//  Settings.swift
//  Paint
//
//  Created by Justine Kay on 6/8/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation
import UIKit

class Settings
{
    
    struct SavedSettings
    {
        static let WidthKey = "width"
        static let OpacityKey = "opacity"
        static let RedKey = "red"
        static let GreenKey = "green"
        static let BlueKey = "blue"
        static let SavedKey = "saved"
        
        static func set(inout width: CGFloat, inout opacity: CGFloat, inout red: CGFloat, inout green: CGFloat, inout blue: CGFloat)
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            width = CGFloat(defaults.floatForKey(WidthKey))
            opacity = CGFloat(defaults.floatForKey(OpacityKey))
            red = CGFloat(defaults.floatForKey(RedKey))
            green = CGFloat(defaults.floatForKey(GreenKey))
            blue = CGFloat(defaults.floatForKey(BlueKey))
        }
    }
    
    struct DefaultSettings
    {
        static let width: CGFloat = 10.0
        static let opacity: CGFloat = 1.0
        static let red: CGFloat = 0.0
        static let green: CGFloat = 0.0
        static let blue: CGFloat = 0.0
        
        static func set(inout width: CGFloat, inout opacity: CGFloat, inout red: CGFloat, inout green: CGFloat, inout blue: CGFloat)
        {
            width = self.width
            opacity = self.opacity
            red = self.red
            green = self.green
            blue = self.blue
            
        }

    }
    
    class func updateSettings(inout width: CGFloat, inout opacity: CGFloat, inout red: CGFloat, inout green: CGFloat, inout blue: CGFloat)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey(Settings.SavedSettings.SavedKey) {
            Settings.SavedSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        } else {
            Settings.DefaultSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        }
    }
    
}