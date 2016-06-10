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
    
    @IBOutlet weak var previewImageViewBackgroundView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var eraserButtonBackgroundView: UIView!
    
    @IBOutlet weak var rgbLabel: UILabel!
    
    private var width = CGFloat()
    private var opacity = CGFloat()
    private var red = CGFloat()
    private var green = CGFloat()
    private var blue = CGFloat()
    
    private var eraserSelected = false
    private let eraserImageName = "eraser"
    
    var selectButtonLabelText = String()
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        eraserButtonBackgroundView.layer.borderWidth = 1.5
        eraserButtonBackgroundView.layer.borderColor = UIColor.blackColor().CGColor
        eraserButtonBackgroundView.layer.cornerRadius = 15
        
        previewImageViewBackgroundView.layer.cornerRadius = 15
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        eraserSelected = defaults.boolForKey(Settings.EraserSettings.EraserSavedKey)
        Settings.updateSettings(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        
        updatEraserButtonUI()
        updateSelectButtonText()
        updateRGBSliders()
        updateSliders()
        drawPreview()
    }
    
    //MARK: - Actions
    
    @IBAction func resetToDefaultSettings(sender: UIButton)
    {
        Settings.DefaultSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        drawPreview()
        updateSliders()
    }
    
    @IBAction func selectButtonTapped(sender: AnyObject)
    {
        saveSettings()
    }
    
    private func saveSettings()
    {
        if eraserSelected {
            defaults.setFloat(Float(width), forKey: Settings.SavedSettings.WidthKey)
            defaults.setFloat(Float(opacity), forKey: Settings.SavedSettings.OpacityKey)
            defaults.setBool(true, forKey: Settings.EraserSettings.EraserSavedKey)
            Settings.EraserSettings.set(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
        } else {
            defaults.setFloat(Float(width), forKey: Settings.SavedSettings.WidthKey)
            defaults.setFloat(Float(opacity), forKey: Settings.SavedSettings.OpacityKey)
            defaults.setFloat(Float(red), forKey: Settings.SavedSettings.RedKey)
            defaults.setFloat(Float(green), forKey: Settings.SavedSettings.GreenKey)
            defaults.setFloat(Float(blue), forKey: Settings.SavedSettings.BlueKey)
            defaults.setBool(true, forKey: Settings.SavedSettings.SavedKey)
            defaults.setBool(false, forKey: Settings.EraserSettings.EraserSavedKey)
        }
    }
    
    @IBAction func toggleEraser(sender: AnyObject)
    {
        updateEraserSavedKey()
        updatEraserButtonUI()
        updateSelectButtonText()
        updateRGBSliders()
        updateSliders()
        drawPreview()
    }
    
    private func updateEraserSavedKey()
    {
        if !eraserSelected {
            defaults.setBool(true, forKey:Settings.EraserSettings.EraserSavedKey)
        } else {
            defaults.setBool(false, forKey:Settings.EraserSettings.EraserSavedKey)
        }
        
        eraserSelected = defaults.boolForKey(Settings.EraserSettings.EraserSavedKey)
        
    }
    
    //MARK: - Update UI
    
    private func updateSliders()
    {
        widthSlider.value = Float(width)
        opacitySlider.value = Float(opacity)
        redSlider.value = Float(red * 255.0)
        greenSlider.value = Float(green * 255.0)
        blueSlider.value = Float(blue * 255.0)
    }

    func updatEraserButtonUI()
    {
        if eraserSelected {
            eraserButtonBackgroundView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        } else {
            eraserButtonBackgroundView.layer.backgroundColor = UIColor.clearColor().CGColor
        }
    }
    
    private func updateSelectButtonText()
    {
        if eraserSelected {
            selectButton.setTitle(Settings.EraserSettings.EraserSelected, forState: .Normal)
        } else {
            selectButton.setTitle(Settings.EraserSettings.ColorSelected, forState: .Normal)
        }
    }
    
    private func updateRGBSliders()
    {
        if eraserSelected {
            rgbLabel.hidden = true
            redSlider.hidden = true
            greenSlider.hidden = true
            blueSlider.hidden = true
        } else {
            rgbLabel.hidden = false
            redSlider.hidden = false
            greenSlider.hidden = false
            blueSlider.hidden = false
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
    
    
    //MARK: - Drawing
    
    private func drawPreview()
    {
        UIGraphicsBeginImageContext(previewImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, width)
        
        if eraserSelected {
            CGContextSetRGBStrokeColor(context, 0, 0, 0, opacity)
            previewImageViewBackgroundView.backgroundColor = UIColor.clearColor()
        } else {
            if red == 1.0 && green == 1.0 && blue == 1.0 {
                CGContextSetRGBStrokeColor(context, red, blue, green, opacity)
                selectButton.setTitle("White", forState: .Normal)
                previewImageViewBackgroundView.backgroundColor = UIColor.blackColor()
            } else {
                CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
                updateSelectButtonText()
                previewImageViewBackgroundView.backgroundColor = UIColor.clearColor()
            }
        }
        
        CGContextMoveToPoint(context, 64.0, 64.0)
        CGContextAddLineToPoint(context, 64.0, 64.0)
        CGContextStrokePath(context)
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(previewImageView.frame.size)
    }
}
