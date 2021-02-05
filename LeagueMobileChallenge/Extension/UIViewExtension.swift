//
//  UIImageViewExtension.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-04.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}


public extension UIViewController{
     func prensentFailedAlert(error : Error,completion : @escaping () -> Void) -> UIAlertController{
        var body : String = ""
        let alertController = UIAlertController(title: "Alert", message: body, preferredStyle: .alert)
        
        switch error{
        case RequestError.userTokenIsNill:
            body = "We are facing troubles to load the content, please try to reload."
            let reloadAction = UIAlertAction(title: "Reload", style: .default) { (action:UIAlertAction) in
                completion()
            }
            alertController.addAction(reloadAction)
            break
        case RequestError.requestFailed:
            body = "We are unable to load the content."
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertController.addAction(dismissAction)
            break
        case RequestError.noInternetConntion:
            body = "Your device is not connected to internet."
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertController.addAction(dismissAction)
            break
        case RequestError.wrongPhoneNumberFormat:
            body = "The phone number format is wrong."
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertController.addAction(dismissAction)
            break
        case RequestError.emailAccountUnavailable:
            body = "Please set up a default email account on your device."
            let settingAction = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { _ in
                        
                    })
                }
            }
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertController.addAction(settingAction)
            alertController.addAction(dismissAction)
            break
        default:
            body = error.localizedDescription
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertController.addAction(dismissAction)
            break
        }
        alertController.message = body
        return alertController
    }
}


