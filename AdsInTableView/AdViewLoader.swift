//
//  AdViewLoader.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 12/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds

protocol AdViewLoaderDelegate: class {
    func adViewLoader(_ adViewLoader: AdViewLoader, didReceiveView: AnyObject)
    func adViewLoaderFailed(_ adViewLoader: AdViewLoader)
}

class AdViewLoader: NSObject, FBNativeAdDelegate, GADNativeExpressAdViewDelegate {
    
    weak var delegate: AdViewLoaderDelegate?
    var facebookNativeAd: FBNativeAd
    let request: GADRequest
    let adView: GADNativeExpressAdView
    private (set) var numberOfAdLoaded = 0
    
    init(request: GADRequest = GADRequest(),
         adView: GADNativeExpressAdView = GADNativeExpressAdView(frame: CGRect(x: 0, y: 0, width: 300, height: 132)),FBNativeAd: FBNativeAd = FBNativeAd(placementID: "755355157970837_755356844637335")) {
        self.facebookNativeAd = FBNativeAd
        self.request = request
        self.adView = adView
        self.adView.adUnitID = "ca-app-pub-1738448963642929/8530109496"
        self.request.testDevices = [kGADSimulatorID]
    }
    
    func loadAd(rootViewController: UIViewController) {
        loadFacebookAd()
        loadGoogleAd(rootViewController: rootViewController)
    }
    
    func loadGoogleAd(rootViewController: UIViewController){
        adView.delegate = self
        adView.rootViewController = rootViewController
        adView.load(request)
    }
    
    func loadFacebookAd() {
        FBAdSettings.addTestDevices([FBAdSettings.testDeviceHash(), "e76b3000c917796885256817988ec925d7ab58e1"])
        facebookNativeAd.delegate = self
        facebookNativeAd.load()
    }
    
    
    //MARK:- FBNativeAdDelegate
    
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        if numberOfAdLoaded == 0 {
            delegate?.adViewLoader(self, didReceiveView: nativeAd)
        }
        numberOfAdLoaded += 1
        
    }
    
    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        
    }
    
    //MARK:- GADNativeExpressAdViewDelegate
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        if numberOfAdLoaded == 0 {
            delegate?.adViewLoader(self, didReceiveView: nativeExpressAdView)
        }
        numberOfAdLoaded += 1
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        print("hello")
    }
}
