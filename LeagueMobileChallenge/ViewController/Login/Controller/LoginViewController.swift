//
//  LoginViewController.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var activityIndicatorView : UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardDismissal()
        self.setPlaceholdersTextColor()
        self.activityIndicatorView = self.setupActivityIndicator()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        let username : String = self.usernameTextField.text ?? ""
        let password : String = self.passwordTextField.text ?? ""
        if let indicator = self.activityIndicatorView {
            self.startAnimatingActivityIndicator(activityIndicatorView: indicator)
            self.view.isUserInteractionEnabled = false
            LoginRepository.shared.login(username: username, password: password) {
                self.view.isUserInteractionEnabled = true
                self.stopActivityIndicator(activityIndicatorView: indicator)
                let story = UIStoryboard(name: StoryboardIdenfiers.Home.rawValue, bundle:nil)
                let vc = story.instantiateInitialViewController()
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            } failureHandler: { (error) in
                self.view.isUserInteractionEnabled = true
                self.prensentFailedAlert(error: error) {
                }
            }
        }
    }
    
    func setPlaceholdersTextColor(){
        self.passwordTextField.attributedPlaceholder =  NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.usernameTextField.attributedPlaceholder =  NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    
    
}
