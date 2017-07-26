//
//  StorageDetailTableViewController.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 19/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import iCarousel

class StorageDetailTableViewController: UITableViewController {
    
    var storageDetailStore: StorageDetailStore? 
    
    var images1: [UIImage] = [
        UIImage(named: "image1")!,
        UIImage(named: "image1")!,
    ]
    
    var list: [AnyObject?] = [] {
        didSet{
            navigationItem.title = "Storage Detail"
        }
    }
    
    var storageDetail: StorageDetail?
    var storageDetailIndexPath: IndexPath?
    var storageImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.setNeedsLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = cellDetail(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let tableViewCell = cell as? StorageDetailCell {
                tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            }
        }
    }
    
    func cellDetail(indexPath: IndexPath) -> UITableViewCell {
        
        guard let index = storageDetailIndexPath?.row,
              let storageDetail = list[index] as? StorageDetail else {
                return UITableViewCell()
        }

        
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! StorageDetailCell
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! StorageDetailCell

                cell.addressLabel.text = "Address: " + storageDetail.address
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmenityCell", for: indexPath) as! StorageDetailCell
            var amenityString = ""
                for i in 0 ..< storageDetail.amenity.count {
                    if i == storageDetail.amenity.count - 1 {
                        amenityString += storageDetail.amenity[i]
                    } else {
                        amenityString += storageDetail.amenity[i] + ", "
                    }
                }
                
                cell.amentitLabel.text = "Amenity: " + amenityString
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! StorageDetailCell
            cell.availableDateLabel.text = "Available Date: " + storageDetail.availableDate
            cell.EndingDateLabel.text =  "Ending Date: " + storageDetail.endingDate
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerCell", for: indexPath) as! StorageDetailCell
            //cell.ownerNameLabel.text = storageDetailStore?.storageDetails.first?.ownerName
            cell.ownerAboutLabel.text = storageDetail.propertyDescription
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! StorageDetailCell
            cell.priceByDayLabel.text = "Price per day: " + "\(storageDetail.priceByDay)"
            cell.priceByWeekLabel.text = "Price per week: " + "\(storageDetail.priceByWeek)"
            cell.priceByMonthLabel.text = "Price per month: " + "\(storageDetail.priceByMonth)"
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
}

extension StorageDetailTableViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        guard let index = storageDetailIndexPath?.row,
            let storageDetail = list[index] as? StorageDetail,
            let propertyPictures = storageDetail.isStorageCoverPhoto,
            propertyPictures.count != 0 else {
                return 1
        }
        return propertyPictures.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIImageView? = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        if let view = view as? UIImageView {
            itemView = view
        } else {
            if let indexForList = storageDetailIndexPath?.row {
                if let storageDetail = list[indexForList] as? StorageDetail {
                    if storageDetail.isStorageCoverPhoto?.count != 0 {
                        if let propertyPhotos = storageDetail.isStorageCoverPhoto {
                            
                            if let photoUrl = propertyPhotos[index].propertyPicturesUrl {
                                storageDetailStore?.fetchPropertyPhoto(storageDetail: storageDetail, photoUrl: photoUrl, photoArrayIndex: index, completion: { (result) in
                                    switch result {
                                    case .Success(let image):
                                        itemView?.image = UIImage(cgImage: image.cgImage!, scale: image.size.width/300, orientation: image.imageOrientation)
                                        itemView?.contentMode = .center
                                    case .Failure(_):
                                        print("image error")
                                        break
                                    }
                                })
                                
                            }
                            
                        }
                        
                    } else {
                        itemView?.image = UIImage(named: "placeholder")
                    }
                }
            }

        }
        
        return itemView!
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.5
        }
        return value
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyImageCell", for: indexPath) as! PropertyImageCell
        if let index = storageDetailIndexPath?.row {
            if let storageDetail = list[index] as? StorageDetail {
                if storageDetail.isStorageCoverPhoto?.count != 0 {
                    if let propertyPhotos = storageDetail.isStorageCoverPhoto {
                        
                        if let photoUrl = propertyPhotos[indexPath.row].propertyPicturesUrl {
                            storageDetailStore?.fetchPropertyPhoto(storageDetail: storageDetail, photoUrl: photoUrl, photoArrayIndex: indexPath.row, completion: { (result) in
                                switch result {
                                case .Success(let image):
                                    cell.propertyImageView.image = image
                                case .Failure(_):
                                    print("image error")
                                    break
                                }
                            })
                            
                        }
                        
                    }
                    
                }
            }
        }

        return cell
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }

        
}

