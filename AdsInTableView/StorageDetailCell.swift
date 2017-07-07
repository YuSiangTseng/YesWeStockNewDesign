//
//  StorageDetailCell.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 19/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import iCarousel

class StorageDetailCell: UITableViewCell {
    @IBOutlet weak var storagePicImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postcodeLabel: UILabel!
    
    @IBOutlet weak var amentitLabel: UILabel!
    
    @IBOutlet weak var availableDateLabel: UILabel!
    @IBOutlet weak var EndingDateLabel: UILabel!
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerAboutLabel: UILabel!
    
    @IBOutlet weak var priceByDayLabel: UILabel!
    @IBOutlet weak var priceByWeekLabel: UILabel!
    @IBOutlet weak var priceByMonthLabel: UILabel!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet var carousel: iCarousel!
    
    func setCollectionViewDataSourceDelegate
        <D: iCarouselDataSource & iCarouselDelegate>
        (_ dataSourceDelegate: D, forRow row: Int) {
        
        carousel.delegate = dataSourceDelegate
        carousel.dataSource = dataSourceDelegate
        //collectionView.tag = row
        //collectionView.isPagingEnabled = true
        carousel.reloadData()
        carousel.type = .cylinder
    }
}
