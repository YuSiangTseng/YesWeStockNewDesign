//
//  StorageCoverPhoto.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 14/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import Foundation

class StorageCoverPhoto {
    var propertyPicturesUrl: String?
    var isCoverPhoto: Bool?
    
    init(propertyPicturesUrl: String, isCoverPhoto: Bool) {
        self.propertyPicturesUrl = propertyPicturesUrl
        self.isCoverPhoto = isCoverPhoto
    }
}
