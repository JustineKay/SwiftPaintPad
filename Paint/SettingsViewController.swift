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
    
    var width: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    struct Settings {
        static let WidthKey = "width"
        static let OpacityKey = "opacity"
        static let RedKey = "red"
        static let GreenKey = "green"
        static let BlueKey = "blue"
        
        static let SettingsSavedKey = "saved"
    }
    
    func saveSettings() {
        defaults.setFloat(Float(width), forKey: Settings.WidthKey)
        defaults.setFloat(Float(opacity), forKey: Settings.OpacityKey)
        defaults.setFloat(Float(red), forKey: Settings.RedKey)
        defaults.setFloat(Float(green), forKey: Settings.GreenKey)
        defaults.setFloat(Float(blue), forKey: Settings.BlueKey)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
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
        defaults.setBool(true, forKey: Settings.SettingsSavedKey)
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
