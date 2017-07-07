//
//  FacebookAdLoader.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 12/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import FBAudienceNetwork

protocol FacebookAdLoaderDelegate: class {
    func facebookAdLoader(_ facebookAdLoader: FacebookAdLoader, didReceiveView: UIView)
    func facebookAdLoaderFailed(_ facebookAdLoader: FacebookAdLoader)
}

class FacebookAdLoader: NSObject, FBNativeAdDelegate, AdNetwork {
    
    weak var delegate: FacebookAdLoaderDelegate?
    weak var rootViewController: UIViewController?
    var facebookNativeAd: FBNativeAd
    private (set) var numberOfAdLoaded = 0
    
    init(FBNativeAd: FBNativeAd = FBNativeAd(placementID: "755355157970837_755356844637335")) {
        self.facebookNativeAd = FBNativeAd
    }
    
    func loadAd(rootViewController: UIViewController) {
        loadFacebookAd(rootViewController: rootViewController)
    }
    

    func loadFacebookAd(rootViewController: UIViewController) {
        FBAdSettings.addTestDevices([FBAdSettings.testDeviceHash(), "e76b3000c917796885256817988ec925d7ab58e1"])
        facebookNativeAd.delegate = self
        self.rootViewController = rootViewController
        facebookNativeAd.load()
    }
    
    
    //MARK:- FBNativeAdDelegate
    
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        if numberOfAdLoaded == 0 {
            if let rootViewController = self.rootViewController {
                if let facebookAdView = FacebookAdView.instance(nativeAd: nativeAd, rootViewController: rootViewController) {
                    delegate?.facebookAdLoader(self, didReceiveView: facebookAdView)
                }
            }
            
        }
        numberOfAdLoaded += 1
        
    }
    
    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        
    }
    
}
