//
//  AdLoader.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 12/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

protocol AdLoaderDelegate: class {
    func adsLoad(ads: [UIView])
}

class AdLoader: FacebookAdLoaderDelegate, GoogleAdLoaderDelegate {
    
    var facebookAdLoader: FacebookAdLoader
    var googleAdLoader: GoogleAdLoader
    weak var delegate: AdLoaderDelegate?
    var ads: [UIView] = []
    init() {
        facebookAdLoader = FacebookAdLoader()
        googleAdLoader = GoogleAdLoader()
        facebookAdLoader.delegate = self
        googleAdLoader.delegate = self
    }
    
    func loadAd(rootViewController: UIViewController) {
        facebookAdLoader.loadAd(rootViewController: rootViewController)

        googleAdLoader.loadAd(rootViewController: rootViewController)
    }
    
    func facebookAdLoader(_ facebookAdLoader: FacebookAdLoader, didReceiveView: UIView) {
        ads.append(didReceiveView)
        delegate?.adsLoad(ads: ads)
    }
    func facebookAdLoaderFailed(_ facebookAdLoader: FacebookAdLoader) {
        
    }
    
    func googleAdLoader(_ googleAdLoader: GoogleAdLoader, didReceiveView: UIView) {
        ads.append(didReceiveView)
        delegate?.adsLoad(ads: ads)
    }
    func googleAdLoaderFailed(_ googleAdLoader: GoogleAdLoader) {
        
    }

    
}
