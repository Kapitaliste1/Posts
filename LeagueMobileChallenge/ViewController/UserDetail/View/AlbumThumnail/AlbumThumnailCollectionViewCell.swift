//
//  AlbumThumnailCollectionViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit

class AlbumThumnailCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "AlbumThumnailCollectionViewCell"
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    @IBOutlet weak var thumbNailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var photo : Photo?{
        didSet{
            if let item = self.photo{
                if let avatar = item.thumbnailUrl, let urlImg =  URL(string: avatar), let placeHolder = UIImage(named: "load.png"){
                    self.thumbNailImage?.sd_setImage(with: urlImg, placeholderImage: placeHolder)
                }
            }
        }
    }

}
