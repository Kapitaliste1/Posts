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
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var album : Album?{
        didSet{
            if let item = self.album{
                self.titleLabel.text = item.title
            }
        }
    }

}
