//
//  SketchPadViewController.swift
//  Paint
//
//  Created by Justine Kay on 6/7/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class SketchPadViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let mainImageKey = "mainImage"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if defaults.valueForKey(mainImageKey) != nil {
            let image : UIImage = UIImage(data: (defaults.valueForKey(mainImageKey) as? NSData)!)!
            mainImageView.image = image
        }
        
        updateBrushSettings()
    }
    
    func updateBrushSettings() {
        if defaults.boolForKey("saved") {
            //TODO: set all brush setting to saved settings
            brushWidth = CGFloat(defaults.floatForKey(SettingsViewController.Settings.WidthKey))
            opacity = CGFloat(defaults.floatForKey(SettingsViewController.Settings.OpacityKey))
            red = CGFloat(defaults.floatForKey(SettingsViewController.Settings.RedKey))
            green = CGFloat(defaults.floatForKey(SettingsViewController.Settings.GreenKey))
            blue = CGFloat(defaults.floatForKey(SettingsViewController.Settings.BlueKey))
            
        }
    }
    
    @IBAction func clearButton(sender: UIBarButtonItem)
    {
        mainImageView.image = nil
        tempImageView.image = nil
        defaults.setValue(nil, forKey: mainImageKey)
    }
    
    //MARK: - Actions

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch  = touches.first! as? UITouch {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first! as? UITouch {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y:0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        let imageData: NSData = UIImagePNGRepresentation(mainImageView.image!)!
        defaults.setValue(imageData, forKey: mainImageKey)
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, .Normal)
        
        CGContextStrokePath(context)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
}
