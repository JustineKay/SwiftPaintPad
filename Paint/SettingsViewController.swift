//
//  SettingsViewController.swift
//  Paint
//
//  Created by Justine Kay on 6/7/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var width: CGFloat = Constant.defaultSettings.width
    var opacity: CGFloat = Constant.defaultSettings.opacity
    var red: CGFloat = Constant.defaultSettings.red
    var green: CGFloat = Constant.defaultSettings.green
    var blue: CGFloat = Constant.defaultSettings.blue
    
    private let defaults = NSUserDefaults.standardUserDefaults()

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if defaults.boolForKey(Constant.Settings.SettingsSavedKey) {
            width = CGFloat(defaults.floatForKey(Constant.Settings.WidthKey))
            opacity = CGFloat(defaults.floatForKey(Constant.Settings.OpacityKey))
            red = CGFloat(defaults.floatForKey(Constant.Settings.RedKey))
            green = CGFloat(defaults.floatForKey(Constant.Settings.GreenKey))
            blue = CGFloat(defaults.floatForKey(Constant.Settings.BlueKey))
        }
        
        widthSlider.value = Float(width)
        opacitySlider.value = Float(opacity)
        redSlider.value = Float(red * 255.0)
        greenSlider.value = Float(green * 255.0)
        blueSlider.value = Float(blue * 255.0)
        
        drawPreview()
    }
    
    @IBAction func selectButtonTapped(sender: AnyObject)
    {
        saveSettings()
    }
    
    
    func saveSettings() {
        defaults.setFloat(Float(width), forKey: Constant.Settings.WidthKey)
        defaults.setFloat(Float(opacity), forKey: Constant.Settings.OpacityKey)
        defaults.setFloat(Float(red), forKey: Constant.Settings.RedKey)
        defaults.setFloat(Float(green), forKey: Constant.Settings.GreenKey)
        defaults.setFloat(Float(blue), forKey: Constant.Settings.BlueKey)
        defaults.setBool(true, forKey: Constant.Settings.SettingsSavedKey)
    }
    
    
    @IBAction func sliderChanged(sender: UISlider)
    {
        
        if sender == widthSlider {
            width = CGFloat(sender.value)
        } else if sender == opacitySlider {
            opacity = CGFloat(sender.value)
        } else {
            red = CGFloat(redSlider.value / 255)
            green = CGFloat(greenSlider.value / 255)
            blue = CGFloat(blueSlider.value / 255)
        }
        
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(previewImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, width)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(previewImageView.frame.size)
    }
}
