//
//  LoginView.swift
//  getAvis
//
//  Created by SS142 on 01/08/16.
//  Copyright © 2016 SS142. All rights reserved.
//

import Foundation


let ApplicationDelegate = UIApplication.shared.delegate as! AppDelegate
var hud: MBProgressHUD!


class supportingfuction: NSObject
{
   class func showProgressHudForViewMy (view:AnyObject, withDetailsLabel:String, labelText:NSString)
    {
        hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window!, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.detailsLabel.text = withDetailsLabel as String
        hud.label.text = labelText as String
    }
    
    
   class func showMessageHudWithMessage(message:String, delay:CGFloat)
    {
        
        hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = message as String
        let delay = TimeInterval(delay)
        hud.hide(animated: true, afterDelay: delay)
        
    }
    
  class func hideProgressHudInView(view:AnyObject)
    {
        if hud != nil
        {
            hud.hide(animated: true)
        }
    }
 
    class func showMessageHudWithMessageAndHideWhenTouched(message:NSString)
    {
        
        hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = message as String
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideHudWhenTapped(_:)))
        hud.addGestureRecognizer(tapGesture)
        
    }
    
    class func hideHudWhenTapped(_ sender: UITapGestureRecognizer)
    {
        self.hideProgressHudInView(view: UIView())
        hud.removeGestureRecognizer(sender)
    }

    
 //MARK:- New Progress HUD
    
    class func indeterminateExample() {
        // Show the HUD on the root view (self.view is a scrollable table view and thus not suitable,
        // as the HUD would move with the content as we scroll).
        let hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window!, animated: true)
        // Fire off an asynchronous task, giving UIKit the opportunity to redraw wit the HUD added to the
        // view hierarchy.
        DispatchQueue.global(qos: .utility).async(execute: {() -> Void in
            // Do something useful in the background
            self.doSomeWork()
            // IMPORTANT - Dispatch back to the main thread. Always access UI
            // classes (including MBProgressHUD) on the main thread.
            DispatchQueue.main.async(execute: {() -> Void in
                hud.hide(animated: true)
            })
        })
    }
    
    class func doSomeWork() {
        // Simulate by just waiting.
        sleep(UInt32(3.0))
    }

    
    class func customViewExample() {
        
        let hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window!, animated: true)
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDMode.customView
        // Set an image view with a checkmark.
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        hud.customView = UIImageView(image: image)
        // Looks a bit nicer if we make it square.
        hud.customView?.superview?.backgroundColor = UIColor.blue
        hud.isSquare = true
        // Optional label text.
        hud.label.text = NSLocalizedString("Done", comment: "HUD done title")
        hud.label.textColor = UIColor.white
        hud.hide(animated: true, afterDelay: 3.0)
    }
    
    
       class func determinateNSProgressExample() {
        let hud = MBProgressHUD.showAdded(to: ApplicationDelegate.window!, animated: true)
        // Set the determinate mode to show task progress.
        hud.mode = MBProgressHUDMode.determinate
        hud.label.text = NSLocalizedString("Loading...", comment: "HUD loading title")
        hud.label.textColor = UIColor.white
        // Set up NSPorgress
        hud.label.superview?.backgroundColor = UIColor.orange
        
        let progressObject = Progress(totalUnitCount: 100)
        hud.progressObject = progressObject
        hud.contentColor = UIColor.white
        // Configure a cacnel button.
        hud.button.setTitle(NSLocalizedString("Cancel", comment: "HUD cancel button title"), for: .normal)
        hud.button.addTarget(progressObject, action: #selector(hud.progressObject?.cancel), for: .touchUpInside)
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWork(withProgressObject: progressObject)
            DispatchQueue.main.async(execute: {() -> Void in
                hud.hide(animated: true)
            })
        })
    }
    
    class func doSomeWork(withProgressObject progressObject: Progress) {
        // This just increases the progress indicator in a loop.
        while progressObject.fractionCompleted < 1.0 {
            if progressObject.isCancelled {
                break
            }
            progressObject.becomeCurrent(withPendingUnitCount: 1)
            progressObject.resignCurrent()
            usleep(50000)
        }
    }
    
    class func encrypt(string: NSString) -> String
    {
        var result = ""
        let key: NSString = "45555"
        for i in 0..<string.length
        {
            let keychar = key.character(at: (i%key.length))
            let char = string.character(at: i)
            let sum = keychar + char
            result.append("\(String(UnicodeScalar(sum)!))")
        }
        
        let other_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxys0123456789~!@#$^&*()_+`-={}|:<>?[]\';,./";
        let length:UInt32 = arc4random_uniform(15)
        let salt:NSString = ""
        
        for i in 0..<length
        {
            salt.appending("\(other_string[other_string.index(other_string.startIndex, offsetBy: Int(i))])")
        }
        
        let salt_length = salt.length
        let end_length = "\(salt_length)".characters.count
        result.append(salt.appending("\(salt_length)".appending("\(end_length)")))
        
        // Base64 encode UTF 8 string
        // fromRaw(0) is equivalent to objc 'base64EncodedStringWithOptions:0'
        // Notice the unwrapping given the NSData! optional
        // NSString
        
        let utf8str = result.data(using: String.Encoding.utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        
        
        return base64Encoded!
    }
    
    class func isValidDate(from: String, until: String) -> Bool
    {
        switch from.compare(until)
        {
        case .orderedAscending     :
            return true
            
        case .orderedDescending    :
            return false
            
        case .orderedSame          :
            return true
        }
    }

    
    class commonValidations: NSObject
    {
        
//        class func convertToDictionary(text: String) -> NSArray {
//            if let data = text.data(using: .utf8) {
//                do {
//                    return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//            return nil
//        }
        
        
        class func isValidEmail(testStr:String) -> Bool {
            let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
        
        class func isValidNRIC(testStr:String) -> Bool
        {
            let nricRegEx = "(^[A-Z]{1}[0-9]{8}[A-Z]{1})"
            let nrictest = NSPredicate(format: "SELF MATCH %@", nricRegEx)
            return nrictest.evaluate(with: testStr)
        }
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
