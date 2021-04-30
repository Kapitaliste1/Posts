//
//  PhotoViewController.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
 
//

import UIKit
import CoreDataPackage

class PhotoViewController: UIViewController {

    var photo : Photo?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImage()
        // Do any additional setup after loading the view.
    }
     
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setImage() {
        if let item = self.photo{
            if let avatar = item.thumbnailUrl, let urlImg =  URL(string: avatar), let placeHolder = UIImage(named: "loading.png"){
                self.imageView?.sd_setImage(with: urlImg, placeholderImage: placeHolder)
            }
        }
    }
}
