//
//  FacebookAdView.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 13/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import FBAudienceNetwork

class FacebookAdView: UIView {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    
    
    class func instance(nativeAd: FBNativeAd, rootViewController: UIViewController) -> FacebookAdView? {
        let adView = Bundle.main.loadNibNamed("FacebookAdView", owner: nil, options: nil)![0] as! FacebookAdView
        adView.title.text = nativeAd.title
        adView.message.text = nativeAd.body
        adView.callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
        nativeAd.registerView(forInteraction: adView, with: rootViewController)
        if let pic = nativeAd.coverImage {
            adView.postImage.imageFromServerURL(urlString: pic.url.absoluteString)
        }

        return adView
    }
    
}
