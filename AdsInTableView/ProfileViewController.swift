//
//  ProfileViewController.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 30/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import Keychain
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleMobileAds
import FBAudienceNetwork

class ProfileViewController: UITableViewController, AdLoaderDelegate {
    
    
    var finalProfileDetail = [ProfileDetail]()
    var storageDetailStore: StorageDetailStore?
    var image = UIImage(named: "ProfileBlue")
    var isLoadingData = true
    let adLoader = AdLoader()
    var ad: UIView?
    var isGotOneAd = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
        tableView.separatorColor = UIColor.black
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
        tableView.setNeedsLayout()
        tableView.delegate = self
        //tableView.tableFooterView = UIView()
        adLoader.delegate = self
        adLoader.loadAd(rootViewController: self)
        loadTestingDataFromJsonFile()
        
        // Do any additional setup after loading the view.
    }
    
    func adsLoad(ads: [UIView]) {
        if isGotOneAd {
            self.ad = ads.first
            isGotOneAd = false
            tableView.reloadData()
//            for ad in ads {
//                if let ad = ad as? FacebookAdView {
//                    self.ad = ad
//                    isGotOneAd = false
//                    tableView.reloadData()
//                }
//            }
        }
        //adIndex = 4
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isLoadingData {
            SVProgressHUD.show(withStatus: "Loading...")
        }
    }
    
    func loadTestingDataFromJsonFile() {
        if let token = Keychain.load("userToken") {
            let header = ["token" : token]
            Alamofire.request(URL(string: "https://yeswestock.com/JSON/user/pages/data")!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in
                switch response.result {
                case .success(let result):
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        if let profileDetail = self.profileDetailWithJson(json: JSON)
                        {
                            self.finalProfileDetail.append(profileDetail)
                            self.isLoadingData = false
                            SVProgressHUD.dismiss()
                            self.tableView.reloadData()
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
            
        }
    }
    
    func profileDetailWithJson(json: NSDictionary) -> ProfileDetail? {
        guard let email = json["email"] as? String,
            let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let phoneNumber = json["phone"] as? String,
            let registeredDate = json["registered_on"] as? String else {
                return nil
        }
        
        return ProfileDetail(name: firstName + " " + lastName, phoneNumber: "\(phoneNumber)", email: email, registeredDate: registeredDate)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isLoadingData ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoadingData ? 0 : 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellDetail(indexPath: indexPath)
        return cell
    }
    
    func cellDetail(indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicCell", for: indexPath) as! ProfileDetailCell
            cell.userPicImageView.layer.cornerRadius = cell.userPicImageView.frame.size.width / 2
            cell.userPicImageView.clipsToBounds = true
            cell.userPicImageView.image = image
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! ProfileDetailCell
            cell.nameLabel.text = finalProfileDetail.first?.name
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! ProfileDetailCell
            cell.phoneNumber.text = finalProfileDetail.first?.phoneNumber
            cell.email.text = finalProfileDetail.first?.email
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegisteredDateCell", for: indexPath) as! ProfileDetailCell
            cell.registeredDate.text = finalProfileDetail.first?.registeredDate
            
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if let ad = self.ad {
            return ad.frame.size.height
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let ad = self.ad {
            ad.backgroundColor = UIColor.lightGray
            return ad
        }
        return UIView()
    }
    
   func logOut(_ sender: AnyObject) {
        
        //alert view if user wishes to logout
        let title = "Log Out"
        let message = "Are you sure you want to logout?"
        
        let logoutAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default, handler: { action in
            print("Logout button pressed")
            print("View dismissed")
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "isLogin")
            userDefaults.synchronize()
            Keychain.delete("userToken")
            //presenting = who presents me,  presented = who I present
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("Cancel button pressed")
        })
        
        logoutAlert.addAction(logoutAction)
        logoutAlert.addAction(cancelAction)
        present(logoutAlert, animated: true, completion: nil)
    }
    
    
    
    
}

