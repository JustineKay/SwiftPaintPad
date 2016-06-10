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
    
    var width = CGFloat()
    var opacity = CGFloat()
    var red = CGFloat()
    var green = CGFloat()
    var blue = CGFloat()
    var lastPoint = CGPoint.zero
    var swiped = false
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let mainImageKey = "mainImage"
    
    override func canBecomeFirstResponder() -> Bool
    {
        return true
    }
    
    //MARK: - LifeCycle Methods
    
    override func viewDidAppear(animated: Bool)
    {
        self.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if defaults.valueForKey(mainImageKey) != nil {
            let image : UIImage = UIImage(data: (defaults.valueForKey(mainImageKey) as? NSData)!)!
            mainImageView.image = image
        }
        
        Settings.updateSettings(&width, opacity: &opacity, red: &red, green: &green, blue: &blue)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if defaults.boolForKey(Settings.EraserSettings.EraserSavedKey) {
            var destination = segue.destinationViewController as? UIViewController
            if let navCon = destination as? UINavigationController {
                destination = navCon.visibleViewController
            }
            if let settingsVC = destination as? SettingsViewController {
                settingsVC.selectButtonLabelText = "Eraser"
            }
            
        }
    }
    
    //MARK: - Actions
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        if motion == UIEventSubtype.MotionShake {
            clearSketchPadAnimation()
        }
    }
    
    func clearSketchPadAnimation()
    {
        //TODO - Fade out image view
        UIView.animateWithDuration(0.75, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.mainImageView.alpha = 0
            }) { (true) in
                self.mainImageView.image = nil
                self.tempImageView.image = nil
                self.defaults.setValue(nil, forKey: self.mainImageKey)
        }
    }
    
    @IBAction func clearSketchPad(sender: UIBarButtonItem)
    {
        mainImageView.image = nil
        tempImageView.image = nil
        defaults.setValue(nil, forKey: mainImageKey)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        swiped = false
        if let touch  = touches.first {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        tempImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        let imageData: NSData = UIImageJPEGRepresentation(mainImageView.image!, 1.0)!
        defaults.setValue(imageData, forKey: mainImageKey)
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    //MARK: - Drawing
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint)
    {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, width)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, .Normal)
        
        CGContextStrokePath(context)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
}
