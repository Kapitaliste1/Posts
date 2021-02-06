//
//  PostTableViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit
import SDWebImage

protocol PostTableViewCellProtocol {
    func showUserDetail(user : User)
}

class PostTableViewCell: UITableViewCell {
    static let identifier : String = "PostTableViewCell"
    var delegate : PostTableViewCellProtocol?
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
    }
    
    var post : Post?{
        didSet{
            if let item = self.post {
                self.descriptionLabel.text = item.body
                self.titleLabel.text = item.title
            }
        }
    }
    
    var user : User?{
        didSet{
            if let item = self.user {
                self.usernameLabel.text = item.username
                if let avatar = item.avatar, let urlImg =  URL(string: avatar), let placeHolder = UIImage(named: "avatar.png"){
                    self.avatarImage?.sd_setImage(with: urlImg, placeholderImage: placeHolder)
                }
            }
        }
    }
    
    
    @IBAction func showUserDetail(_ sender: UIButton) {
        if let del = self.delegate, let currentUser = self.user {
            del.showUserDetail(user: currentUser)
        }
    }
    
}
