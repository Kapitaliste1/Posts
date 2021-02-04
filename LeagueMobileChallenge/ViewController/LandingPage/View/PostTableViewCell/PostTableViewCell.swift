//
//  PostTableViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    static let identifier : String = "PostTableViewCell"
    
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
            self.setText()
        }
    }
    
    func setText() {
        if let item = self.post {
            self.descriptionLabel.text = item.body
            self.titleLabel.text = item.title
//            if let urlImg =  URL(string: item.)
//            imageView.sd_setImage(with: , placeholderImage: UIImage(named: "placeholder.png"))
        }
    }
    
}
