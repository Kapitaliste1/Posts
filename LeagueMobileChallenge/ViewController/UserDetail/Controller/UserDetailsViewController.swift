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
    var albumArray : [Album]?
    var photosArray : [Photo]?
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var websiteTextView: UITextView!
    var cellWidth : CGFloat = 150

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setUserDetailsView()
        self.collectionView.reloadData()
    }
    
    
    @IBAction func emailSendAction(_ sender: UIButton) {
        if let destinator = sender.title(for: .normal), MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([destinator])
            present(mail, animated: true)
        } else {
            self.prensentFailedAlert(error: RequestError.emailAccountUnavailable) {}
        }
    }
    
    @IBAction func phoneCallAction(_ sender: UIButton) {
        if let phoneNumber = sender.title(for: .normal),
           let phoneCallURL:URL = URL(string: "tel:\(phoneNumber)") ,
           UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, completionHandler: { _ in
                
            })
        }else{
           self.prensentFailedAlert(error: RequestError.wrongPhoneNumberFormat) {}
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
            if let avatar = currentUser.avatar, let urlImg =  URL(string: avatar), let placeHolder = UIImage(named: "avatar.png"){
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


//MARK: - Mail set up
extension UserDetailsViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


//MARK: - Album collection view
extension UserDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func registerCells() {
        self.cellWidth = (self.collectionView.frame.width / 3) - 30
        let cell = UINib(nibName: AlbumThumnailCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(cell, forCellWithReuseIdentifier: AlbumThumnailCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : UICollectionViewCell = UICollectionViewCell()
        
        if let thumnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumThumnailCollectionViewCell.identifier, for: indexPath) as? AlbumThumnailCollectionViewCell{
            thumnailCell.widthConstraint.constant = self.cellWidth
            if let albumId = self.albumArray?[indexPath.row].id{
               PhotoRepository.shared.selectByAlbumId(albumId: albumId, successHandler: { (photoData) in
                thumnailCell.photo = photoData
                cell = thumnailCell
               }) { (_) in
                
               }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let albumId = self.albumArray?[indexPath.row].id{
            PhotoRepository.shared.selectByAlbumId(albumId: albumId, successHandler: { (photoData) in
                if let photoVC = self.navigateTo(storyboard: .UserDetail, viewControllerIdentifier: .PhotoViewController) as? PhotoViewController{
                    photoVC.photo = photoData
                    photoVC.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.present(photoVC, animated: true, completion: nil)
                }
            }) { (_) in
             
            }
            
        }
    }
    
}

