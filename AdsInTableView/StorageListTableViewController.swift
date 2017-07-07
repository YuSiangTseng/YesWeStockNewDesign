//
//  StorageListTableViewController.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 12/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds
import SwiftyJSON
import SVProgressHUD

class StorageListTableViewController: UITableViewController/*, AdViewLoaderDelegate*/, AdLoaderDelegate {
    
    let adLoader = [AdLoader(), AdLoader(), AdLoader(), AdLoader()]
    var nativeAd: AnyObject?
    var ads: [UIView?] = []
    var storageImage: UIImage?
    var list: [AnyObject?] = []
    let userDefaults = UserDefaults.standard
    var storageDetailStore: StorageDetailStore? {
        didSet {
            if let storageDetails = storageDetailStore?.storageDetails {
                self.list = storageDetails
                for adLoader in self.adLoader {
                    adLoader.delegate = self
                    adLoader.loadAd(rootViewController: self)
                }
//                self.adLoader.delegate = self
//                self.adLoader.loadAd(rootViewController: self)
                self.isLoadingData = false
                tableView.dataSource = self
                self.tableView.separatorColor = UIColor.orange
                SVProgressHUD.dismiss()

            }
        }

    }
        
    var isLoadingData = true
    var isLoadingAd = true
    var adIndex = 4
    
    func loadListingData() {
        SearchListAPI().loadData() {
            (APIResult) -> Void in
            switch APIResult {
            case let .Success(storageDetails):
                self.storageDetailStore = StorageDetailStore(storageDetails: storageDetails, reviews: [])
                self.isLoadingData = false
                SVProgressHUD.dismiss()
                self.tableView.separatorColor = UIColor.orange
                self.tableView.reloadData()
                
            case .Failure(_): break
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if storageDetailStore == nil {
            loadListingData()
        }
        
//        tableView.register(UINib(nibName: "FacebookAdCell", bundle: nil),
//                           forCellReuseIdentifier: "FacebookAdCell")
//        tableView.register(UINib(nibName: "GoogleAdCell", bundle: nil),
//                           forCellReuseIdentifier: "GoogleAdCell")

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        //tableView.dataSource = self
        //loadListingData()
    }
    
    func adsLoad(ads: [UIView]) {
        self.ads = ads
        for ad in self.ads {
            if !list.contains(where: { $0 === ad }) {
                list.insert(ad, at: adIndex)
                adIndex += 4
            }
        }
        tableView.reloadData()
        //adIndex = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoadingData {
            SVProgressHUD.show(withStatus: "Loading Data...")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return isLoadingData ? 0 : list.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: "GreetingCell",
                                                               for: indexPath) as! GreetingCell
            return reusableAdCell
        } else {
            if let nativeAd = self.list[indexPath.row] as? FacebookAdView {
                let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: "FacebookAdCellTemp",
                                                                   for: indexPath) as! FacebookAdCell
                reusableAdCell.nativeAdView.addSubview(nativeAd)
                nativeAd.center = reusableAdCell.contentView.center
                return reusableAdCell
                
                //        if let nativeAd = self.ads[indexPath.row] as? FBNativeAd {
                //            let cell = tableView.dequeueReusableCell(withIdentifier: "FacebookAdCell", for: indexPath) as! FacebookAdCell
                //            cell.message.text = nativeAd.body
                //            cell.title.text = nativeAd.title
                //            cell.callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
                //            if let pic = nativeAd.coverImage {
                //                cell.postImage.imageFromServerURL(urlString: pic.url.absoluteString)
                //            }
                //            nativeAd.registerView(forInteraction: cell, with: self)
                //            cell.layoutIfNeeded()
                //            return cell
                
            } else if let nativeAd = self.list[indexPath.row] as? GADNativeExpressAdView {
                let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: "GoogleAdCell",
                                                                   for: indexPath) as! GoogleAdCell
                nativeAd.removeFromSuperview()
                reusableAdCell.nativeAdView.addSubview(nativeAd)
                nativeAd.center = reusableAdCell.nativeAdView.convert(reusableAdCell.nativeAdView.center, from: reusableAdCell.nativeAdView.superview)
                return reusableAdCell
                
            } else {
                let storageListCell = tableView.dequeueReusableCell(withIdentifier: "StorageListCell", for: indexPath) as! StorageListCell
                //storageListCell.backgroundColor = UIColor.lightGray
                storageListCell.ownerAvatarImageView.layer.cornerRadius = storageListCell.ownerAvatarImageView.frame.size.width/2
                storageListCell.ownerAvatarImageView.clipsToBounds = true
                storageListCell.ownerAvatarImageView.image = nil
                storageListCell.coverPhotoImageView.image = nil
                
                if let storageDetail = list[indexPath.row] as? StorageDetail {
                    //                storageDetailStore?.fetchOwnerAvatar(storageDetail: storageDetail, completion: { (result) in
                    //                    storageListCell.updateOwnerImage(image: storageDetail.ownerPicture)
                    //                })
                    storageListCell.ownerAvatarImageView.imageFromServerURL(urlString: storageDetail.ownerPictureUrl)
                    storageDetailStore?.fetchCoverPhoto(storageDetail: storageDetail, completion: { (result) in
                        switch result {
                        case .Success( _):
                            storageListCell.updateSpinnerWithImage(image: storageDetail.propertyCoverPhoto)
                        case .Failure(_):
                            print("image error")
                            break
                        }
                        //storageListCell.updateSpinnerWithImage(image: storageDetail.propertyCoverPhoto)
                    })
                }
                
                return storageListCell
            }
            
            
        }

        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if let _ = list[indexPath.row] as? StorageDetail {
                performSegue(withIdentifier: "showPropertyDetail", sender: indexPath)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPropertyDetail" {
            let destinationVC = segue.destination as! StorageDetailTableViewController
            destinationVC.list = list
            destinationVC.storageDetailStore = self.storageDetailStore
            if let indexPath = sender as? IndexPath {
                destinationVC.storageDetailIndexPath = indexPath
            }
        }
    }
    
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "Can't get image")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    
    
}

