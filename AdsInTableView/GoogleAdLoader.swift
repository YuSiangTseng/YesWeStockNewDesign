//
//  GoogleAdLoader.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 12/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import GoogleMobileAds

protocol GoogleAdLoaderDelegate: class {
    func googleAdLoader(_ googleAdLoader: GoogleAdLoader, didReceiveView: UIView)
    func googleAdLoaderFailed(_ googleAdLoader: GoogleAdLoader)
}

class GoogleAdLoader: NSObject, GADNativeExpressAdViewDelegate, AdNetwork {
    
    weak var delegate: GoogleAdLoaderDelegate?
    let request: GADRequest
    let adView: GADNativeExpressAdView
    
    init(request: GADRequest = GADRequest(),
         adView: GADNativeExpressAdView = GADNativeExpressAdView(frame: CGRect(x: 0, y: 0, width: 300, height: 132))) {
        self.request = request
        self.adView = adView
        self.adView.adUnitID = "ca-app-pub-1738448963642929/8530109496"
        self.request.testDevices = [kGADSimulatorID, "9afe09c4a2fff4311e9153526ea37597", "eb9e576b97d267b3e6589a0a6f507d15"]
    }
    
    func loadAd(rootViewController: UIViewController) {
        loadGoogleAd(rootViewController: rootViewController)
    }
    
    func loadGoogleAd(rootViewController: UIViewController){
        adView.delegate = self
        adView.rootViewController = rootViewController
        adView.load(request)
    }
    
    
    //MARK:- GADNativeExpressAdViewDelegate
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
            delegate?.googleAdLoader(self, didReceiveView: nativeExpressAdView)
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        print("hello")
    }
}
