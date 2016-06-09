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
    
    var eraserSelected = false
    
    private let defaults = NSUserDefaults.standardUserDefaults()

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Settings.updateSettings(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        updateSliders()
        drawPreview()
    }
    
    @IBAction func resetToDefaultSettings(sender: UIButton)
    {
        Settings.DefaultSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        drawPreview()
        updateSliders()
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
    @IBAction func toggleEraser(sender: UIButton)
    {
        if !eraserSelected {
            previewImageView.image = UIImage(named: "eraser")
            eraserSelected = true
        } else {
            drawPreview()
            eraserSelected = false
        }
        
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
        CGContextMoveToPoint(context, 64.0, 64.0)
        CGContextAddLineToPoint(context, 64.0, 64.0)
        CGContextStrokePath(context)
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(previewImageView.frame.size)
    }
}
