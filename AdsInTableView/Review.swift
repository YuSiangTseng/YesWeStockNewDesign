//
//  Review.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 13/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import Foundation

class Review {
    
    var reviewTitle: String
    var reviewDescription: String
    var reviewerName: String
    
    init(reviewTitle: String, reviewDescription: String, reviewerName: String) {
        self.reviewTitle = reviewTitle
        self.reviewDescription = reviewDescription
        self.reviewerName = reviewerName
    }
    
}
