//
//  StorageDetail.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 13/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import Foundation
import UIKit

class StorageDetail {
    
    
    let address: String
    let postcode: String
    
    let amenity: [String]
    
    let availableDate: String
    let endingDate: String
    
    
    var ownerPicture: UIImage?
    let ownerPictureUrl: String
    let propertyDescription: String
    var propertyPictures: [UIImage]?
    var propertyCoverPhoto: UIImage?
//    let propertyPicturesUrls: [String]?
//    let isCoverPhoto: [Bool]?
    
    let priceByDay: Double
    let priceByWeek: Double
    let priceByMonth: Double
    
    let isStorageCoverPhoto: [StorageCoverPhoto]?
    
    init(address: String, postcode: String, amenity: [String], availableDate: String, endingDate: String, ownerPictureUrl: String, propertyDescription: String, priceByDay: Double, priceByWeek: Double, priceByMonth: Double, isStorageCoverPhoto: [StorageCoverPhoto]) {
        self.address = address
        self.postcode = postcode
        self.amenity = amenity
        self.availableDate = availableDate
        self.endingDate = endingDate
        self.ownerPictureUrl = ownerPictureUrl
        self.propertyDescription = propertyDescription
        self.priceByDay = priceByDay
        self.priceByWeek = priceByWeek
        self.priceByMonth = priceByMonth
//        self.propertyPicturesUrls = propertyPicturesUrls
//        self.isCoverPhoto = isCoverPhoto
        self.isStorageCoverPhoto = isStorageCoverPhoto
    }
}

