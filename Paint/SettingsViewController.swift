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
    
    var width = CGFloat()
    var opacity = CGFloat()
    var red = CGFloat()
    var green = CGFloat()
    var blue = CGFloat()
    
    private let defaults = NSUserDefaults.standardUserDefaults()

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if defaults.boolForKey(Settings.SavedSettings.SavedKey) {
            width = CGFloat(defaults.floatForKey(Settings.SavedSettings.WidthKey))
            opacity = CGFloat(defaults.floatForKey(Settings.SavedSettings.OpacityKey))
            red = CGFloat(defaults.floatForKey(Settings.SavedSettings.RedKey))
            green = CGFloat(defaults.floatForKey(Settings.SavedSettings.GreenKey))
            blue = CGFloat(defaults.floatForKey(Settings.SavedSettings.BlueKey))
        } else {
            defaultSettings()
        }
        
        updateSliders()
        drawPreview()
    }
    
    @IBAction func resetButtonTapped(sender: UIButton)
    {
        defaultSettings()
        drawPreview()
        updateSliders()
    }
    
    func defaultSettings()
    {
        width = Settings.DefaultSettings.width
        opacity = Settings.DefaultSettings.opacity
        red = Settings.DefaultSettings.red
        green = Settings.DefaultSettings.green
        blue = Settings.DefaultSettings.blue
    }
    
    func updateSliders()
    {
        widthSlider.value = Float(width)
        opacitySlider.value = Float(opacity)
        redSlider.value = Float(red * 255.0)
        greenSlider.value = Float(green * 255.0)
        blueSlider.value = Float(blue * 255.0)
    }
    
    @IBAction func selectButtonTapped(sender: AnyObject)
    {
        saveSettings()
    }
    
    func saveSettings() {
        defaults.setFloat(Float(width), forKey: Settings.SavedSettings.WidthKey)
        defaults.setFloat(Float(opacity), forKey: Settings.SavedSettings.OpacityKey)
        defaults.setFloat(Float(red), forKey: Settings.SavedSettings.RedKey)
        defaults.setFloat(Float(green), forKey: Settings.SavedSettings.GreenKey)
        defaults.setFloat(Float(blue), forKey: Settings.SavedSettings.BlueKey)
        defaults.setBool(true, forKey: Settings.SavedSettings.SavedKey)
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
