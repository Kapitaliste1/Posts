//
//  UIImageViewExtension.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-04.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit


//MARK:- Enumerations
/*
 This enumeration has for goal to list out every single viewController that
 we might have in the project, in order to ease the navigation between them and keep track of them.
 */
public enum ViewControllerIdentifiers : String {
    case PostTableViewController = "PostTableViewController"
    case UserDetailsViewController = "UserDetailsViewController"
    case PhotoViewController = "PhotoViewController"
    case LoginViewController = "LoginViewController"
}

public enum StoryboardIdenfiers : String {
    case Home = "Main"
    case UserDetail = "UserDetail"
    case Login = "Login"
}


//MARK:- UIView custom changes
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

//MARK:- UIViewController custom changes
extension UIViewController{
    
    public func navigateTo(storyboard : StoryboardIdenfiers, viewControllerIdentifier : ViewControllerIdentifiers? = nil) -> UIViewController? {
        var viewController : UIViewController?
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        if let identifier = viewControllerIdentifier {
            viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        }else{
            viewController = storyboard.instantiateInitialViewController()
        }
        return viewController
    }
    
    func setupActivityIndicator() -> UIActivityIndicatorView{
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }
 
    func stopActivityIndicator(activityIndicatorView : UIActivityIndicatorView){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    func startAnimatingActivityIndicator(activityIndicatorView : UIActivityIndicatorView){
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }
    
    func setKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    func prensentFailedAlert(error : Error,completion : @escaping () -> Void){
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
            let dismissAction = UIAlertAction(title: "Dissmiss", style: .destructive) { _ in
                completion()
            }
            alertController.addAction(dismissAction)
            break
        case RequestError.noInternetConntion:
            body = "Your device is not connected to internet."
            let dismissAction = UIAlertAction(title: "Dissmiss", style: .destructive) { _ in
                completion()
            }
            alertController.addAction(dismissAction)
            break
        case RequestError.wrongPhoneNumberFormat:
            body = "The phone number format is wrong."
            let dismissAction = UIAlertAction(title: "Dissmiss", style: .destructive) { _ in
                completion()
            }
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
                        completion()
                    })
                }
            }
            let dismissAction = UIAlertAction(title: "Dissmiss", style: .destructive) { _ in
                completion()
            }
            alertController.addAction(settingAction)
            alertController.addAction(dismissAction)
            break
        default:
            body = error.localizedDescription
            let dismissAction = UIAlertAction(title: "Dissmiss", style: .destructive) { _ in
                completion()
            }
            alertController.addAction(dismissAction)
            break
        }
        alertController.message = body
        self.present(alertController, animated: true, completion: nil)
    }
}
