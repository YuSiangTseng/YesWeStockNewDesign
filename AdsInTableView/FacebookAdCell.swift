//
//  FacebookAdCell.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 12/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import FBAudienceNetwork

class FacebookAdCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var nativeAdView: UIView!
    
//    class func instance(nativeAd: FBNativeAd) -> FacebookAdCell? {
//        let adCell = Bundle.main.loadNibNamed("FacebookAdCell", owner: nil, options: nil)![0] as! FacebookAdCell
//        adCell.title.text = nativeAd.title
//        adCell.message.text = nativeAd.body
//        adCell.callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
//        if let pic = nativeAd.coverImage {
//            adCell.postImage.imageFromServerURL(urlString: pic.url.absoluteString)
//        }
//        
//        return adCell
//    }
    
}
