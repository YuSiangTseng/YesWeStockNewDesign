//
//  StorageListCell.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 13/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

class StorageListCell: UITableViewCell {
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateSpinnerWithImage(image: UIImage?) {
        guard image != nil else {
            spinner.startAnimating()
            coverPhotoImageView.image = nil
            return
        }
        spinner.stopAnimating()
        coverPhotoImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        updateSpinnerWithImage(image: nil)
    }

    
    func updateOwnerImage(image: UIImage?) {
        guard image != nil else {
            ownerAvatarImageView.image = UIImage(named: "placeholder")
            return
        }
        ownerAvatarImageView.image = image
    }
    
    
    func updatePropertyCoverPhoto(image: UIImage?) {
        guard image != nil else {
            coverPhotoImageView.image = UIImage(named: "placeholder")
            return
        }
        coverPhotoImageView.image = image
        
    }

}
