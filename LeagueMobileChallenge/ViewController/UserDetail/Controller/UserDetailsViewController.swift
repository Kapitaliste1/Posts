//
//  UserDetailsViewController.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-04.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit
import MessageUI

class UserDetailsViewController: UIViewController, CAAnimationDelegate {
    var user : User?
    var isCompanyCardVisible : Bool = false
    var albumArray : [Album]?
    var photosArray : [Photo]?
    var panGesture       = UIPanGestureRecognizer()
    var userInformationView : UserInformationView?
    var companyDetailView : CompanyDetailView?
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cellWidth : CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.collectionView.reloadData()
        self.setupCardView()

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

//MARK: - Card view
extension UserDetailsViewController : CardViewDelegate{
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = event?.allTouches?.first {
            let realeasePoint : CGPoint = touch.location(in: touch.view)
            /*
             TODO: use the last position touched on the screen to check if it's over the
             half of the detail View y axis in order to automatically complete the rotation animation
             */
            print("## last point \(realeasePoint)")
             

        }
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        
        let translation = sender.translation(in: self.view)
        
        if #available(iOS 13.0, *) {
            let rotationAngle : CGFloat = CGFloat(translation.x * CGFloat.pi / 180)
            self.detailView.transform3D = CATransform3DRotate(self.detailView.transform3D, rotationAngle, 0, 1, 0)
            let radians:Double = atan2( Double(detailView.transform3D.m11), Double(detailView.transform3D.m44))
            let degrees:CGFloat = CGFloat(radians) * (180 / CGFloat.pi )
            
            if degrees > 0 {
                print("### front view \(self.detailView.transform3D)")
                self.userInformationView?.isHidden = false
                self.companyDetailView?.isHidden = true
            }else{
                print("### back view \(self.detailView.transform3D)")
                self.userInformationView?.isHidden = true
                self.companyDetailView?.isHidden = false
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    
    func setupCardView() {
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        self.detailView.isUserInteractionEnabled = true
        self.detailView.addGestureRecognizer(panGesture)
        
        if let userData = self.user{
            
            self.userInformationView = UserInformationView(frame: self.detailView.bounds)
            self.userInformationView?.setupView(user: userData)
            self.userInformationView?.delegate = self
            self.userInformationView?.isHidden = false
            if let view = self.userInformationView{
                self.detailView.addSubview(view)
            }
            
            CompanyRepository.shared.selectByUserId(userId: userData.id) { (company) in
                self.companyDetailView = CompanyDetailView(frame: self.detailView.bounds)
                self.companyDetailView?.setupView(company: company)
                self.companyDetailView?.isHidden = true
                if let view = self.companyDetailView{
                    self.detailView.addSubview(view)
                }
            } failureHandler: { (error) in
                self.prensentFailedAlert(error: error) {
                    
                }
            }
        }
    }
    
    func openEmail(emailComposeVC: MFMailComposeViewController) {
        self.present(emailComposeVC, animated: true)
    }
    
    func showAlert(error: Error) {
        self.prensentFailedAlert(error: error) {
            
        }
    }
 
}


 
