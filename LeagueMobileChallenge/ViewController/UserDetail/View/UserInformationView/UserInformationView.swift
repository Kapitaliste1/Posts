//
//  UserInformationView.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-06.
 
//

import UIKit
import MessageUI
import CoreDataPackage

protocol CardViewDelegate {
    func openEmail(emailComposeVC : MFMailComposeViewController)
    func showAlert(error : Error)
 }

class UserInformationView: UIView {
    var delegate : CardViewDelegate?
    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatareImage: UIImageView!
    @IBOutlet var view: UIView!
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    func xibSetup() {
        self.view = loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(self.view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserInformationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    func setupView(user : User) {
        self.usernameLabel.text = user.username
        self.emailButton.setTitle(user.email, for: .normal)
        self.phoneButton.setTitle(user.phone, for: .normal)
        self.websiteTextView.delegate = self
        self.websiteTextView.text = user.website
        self.websiteTextView.underlined()
        if let avatar = user.avatar, let urlImg =  URL(string: avatar), let placeHolder = UIImage(named: "avatar.png"){
            self.avatareImage?.sd_setImage(with: urlImg, placeholderImage: placeHolder)
        }
        self.setNeedsDisplay()
    }
    
    
    @IBAction func emailSendAction(_ sender: UIButton) {
        if let destinator = sender.title(for: .normal), MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([destinator])
            if let del = self.delegate{
                del.openEmail(emailComposeVC: mail)
            }
        } else {
            if let del = self.delegate{
                del.showAlert(error: RequestError.emailAccountUnavailable)
            }

        }
    }
    
    @IBAction func phoneCallAction(_ sender: UIButton) {
        if let phoneNumber = sender.title(for: .normal),
           let phoneCallURL:URL = URL(string: "tel:\(phoneNumber)") ,
           UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, completionHandler: { _ in
                
            })
        }else{
            if let del = self.delegate{
                del.showAlert(error: RequestError.wrongPhoneNumberFormat)
            }
         }
    }
     
 
}


//MARK: - UITextView delegate handler
extension UserInformationView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return true
    }
    
}


//MARK: - Mail set up
extension UserInformationView : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


 
