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
    
    private var width = CGFloat()
    private var opacity = CGFloat()
    private var red = CGFloat()
    private var green = CGFloat()
    private var blue = CGFloat()
    
    private var eraserSelected = false
    private let eraserImageName = "eraser"
    
    private let defaults = NSUserDefaults.standardUserDefaults()

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Settings.updateSettings(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        
        if defaults.boolForKey(Settings.EraserSettings.eraserSavedKey) {
            eraserSelected = true
            previewImageView.image = UIImage(named: eraserImageName)
        } else {
            drawPreview()
            eraserSelected = false
        }
        updateSliders()
        
    }
    
    @IBAction func resetToDefaultSettings(sender: UIButton)
    {
        Settings.DefaultSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        drawPreview()
        updateSliders()
    }
    
    private func updateSliders()
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
    
    private func saveSettings() {
        if eraserSelected {
            defaults.setFloat(Float(width), forKey: Settings.SavedSettings.WidthKey)
            defaults.setFloat(Float(opacity), forKey: Settings.SavedSettings.OpacityKey)
            Settings.EraserSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        } else {
            defaults.setFloat(Float(width), forKey: Settings.SavedSettings.WidthKey)
            defaults.setFloat(Float(opacity), forKey: Settings.SavedSettings.OpacityKey)
            defaults.setFloat(Float(red), forKey: Settings.SavedSettings.RedKey)
            defaults.setFloat(Float(green), forKey: Settings.SavedSettings.GreenKey)
            defaults.setFloat(Float(blue), forKey: Settings.SavedSettings.BlueKey)
            defaults.setBool(true, forKey: Settings.SavedSettings.SavedKey)
            defaults.setBool(false, forKey: Settings.EraserSettings.eraserSavedKey)
        }
        
    }
    
    @IBAction func toggleEraser(sender: UIButton)
    {
        if !eraserSelected {
            previewImageView.image = UIImage(named: eraserImageName)
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
    
    private func drawPreview() {
        UIGraphicsBeginImageContext(previewImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, width)
        
        //TODO - draw eraser image instead of using icon
//        if defaults.boolForKey(Settings.EraserSettings.eraserSavedKey) {
//            let path = CGPathCreateMutable()
//            CGContextSetLineWidth(context, 40);
//            CGPathAddArc(path, nil, previewImageView.image!.size.width/2, previewImageView.image!.size.height/2, 45, 0*CGFloat(M_PI)/180, 64.0*CGFloat(M_PI)/180.0, true)
//            CGContextAddPath(context, path)
//            CGContextStrokePath(context)
//        } else {
//            CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
//        }
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextMoveToPoint(context, 64.0, 64.0)
        CGContextAddLineToPoint(context, 64.0, 64.0)
        CGContextStrokePath(context)
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(previewImageView.frame.size)
    }
}
