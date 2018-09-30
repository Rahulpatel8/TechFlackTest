//
//  ImageDetailCell.swift
//  RSTechFlackTest
//
//  Created by RS on 26/09/18.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

class ImageDetailCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
