//
//  ProfileDetail.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 30/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

class ProfileDetail {
    
    let name: String
    let phoneNumber: String
    let email: String
    let registeredDate: String
    var userImage: UIImage?
    
    init(name: String, phoneNumber: String, email: String, registeredDate: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.registeredDate = registeredDate
    }
    
}

