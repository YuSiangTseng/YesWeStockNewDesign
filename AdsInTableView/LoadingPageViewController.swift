//
//  LoadingPageViewController.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 28/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingPageViewController: UIViewController {
    
    var activityIndicatorView: NVActivityIndicatorView?
    let userDefaults = UserDefaults.standard
    var storageDetailStore: StorageDetailStore?
    var isLoadingData = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: "isLogin") {
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70), type: .ballGridBeat, color: UIColor.brown, padding: 10)
            activityIndicatorView?.center = view.center
            view.addSubview(activityIndicatorView!)
            activityIndicatorView?.startAnimating()
            loadListingData()
        } else {
            performSegue(withIdentifier: "showLogin", sender: nil)
        }

    }
    
    func loadListingData() {
        SearchListAPI().loadData() {
            (APIResult) -> Void in
            switch APIResult {
            case let .Success(storageDetails):
                self.storageDetailStore = StorageDetailStore(storageDetails: storageDetails, reviews: [])
                self.isLoadingData = false
                    self.activityIndicatorView?.stopAnimating()
                    self.performSegue(withIdentifier: "showTabBar", sender: nil)
            case .Failure(_): break
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTabBar" {
            let tabBarViewController = segue.destination as? UITabBarController
            let navigationController = tabBarViewController?.viewControllers?[0] as? UINavigationController
            let storageListViewController = navigationController?.topViewController as? StorageListTableViewController
            storageListViewController?.storageDetailStore = self.storageDetailStore
        }
        dismiss(animated: true, completion: nil)
    }
    
}
