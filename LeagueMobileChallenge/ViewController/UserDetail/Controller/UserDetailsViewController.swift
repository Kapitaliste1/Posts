//
//  UserDetailsViewController.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-04.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit
import MessageUI

class UserDetailsViewController: UIViewController {
    var user : User?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var websiteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserDetailsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    @IBAction func emailSendAction(_ sender: UIButton) {
        if let destinator = sender.title(for: .normal), MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([destinator])
            present(mail, animated: true)
        } else {
            let alertController = self.prensentFailedAlert(error: RequestError.emailAccountUnavailable) {}
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func phoneCallAction(_ sender: UIButton) {
        if let phoneNumber = sender.title(for: .normal),
           let phoneCallURL:URL = URL(string: "tel:\(phoneNumber)") ,
           UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, completionHandler: { _ in
                
            })
        }else{
            let alertController = self.prensentFailedAlert(error: RequestError.wrongPhoneNumberFormat) {}
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

//MARK: - View set up
extension UserDetailsViewController{
    fileprivate func setUserDetailsView(){
        if let currentUser = self.user{
            self.usernameLabel.text = currentUser.username
            self.emailButton.setTitle(currentUser.email, for: .normal)
            self.phoneButton.setTitle(currentUser.phone, for: .normal)
            self.websiteTextView.delegate = self
            self.websiteTextView.text = currentUser.website
            if let avatar = currentUser.avatar, let urlImg =  URL(string: avatar), let placeHolder = UIImage(named: "load.png"){
                self.avatarImageView?.sd_setImage(with: urlImg, placeholderImage: placeHolder)
            }
        }
    }
}

//MARK: - UITextView delegate handler
extension UserDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return true
    }
    
}


//MARK: - View set up
extension UserDetailsViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


