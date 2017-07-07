//
//  SearchListAPI.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 13/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import Foundation
import Alamofire

enum APIResult {
    case Success([StorageDetail])
    case Failure(Error)
}

enum CurrencyAPIError: Error {
    case InvalidJSONData
}

class SearchListAPI {
    
    let searchURLString = "https://yeswestock.com/listing/search"
    var storageDetailStore: StorageDetailStore?
    
    func loadData(completion: @escaping (APIResult) -> Void) {
        guard let url = URL(string: searchURLString) else {
            return;
        }
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
            
            switch response.result {
            case .success(let resultdata):
                
                //JSON response
                OperationQueue.main.addOperation({
                    guard let data = response.data,
                        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] else {
                            return
                    }
                    let result =  self.storageDetailWithJsonObject(jsonObject: jsonObject!)
                    completion(result)
                })
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }
        }
        
        
    }
    
    func storageDetailWithJsonObject(jsonObject: [String : AnyObject]) -> APIResult {
        guard let listingArray = jsonObject["listings"] as? [[String : AnyObject]] else {
            return .Failure(CurrencyAPIError.InvalidJSONData)
        }
        var finalListings = [StorageDetail]()
        for listing in listingArray {
            if let storageDetail = listingWithArray(json: listing) {
                finalListings.append(storageDetail)
            }
        }
        
        return .Success(finalListings)
        
    }
    
    func isCoverPhotoWithJsonObject(jsonObject: [[String : AnyObject]]) -> [StorageCoverPhoto]? {
        
        var isStorageCoverPhoto = [StorageCoverPhoto]()
        for item in jsonObject {
            if let isCover = item["is_cover"] as? Bool {
                if let photoUrl = item["url"] as? String {
                    isStorageCoverPhoto.append(StorageCoverPhoto(propertyPicturesUrl: photoUrl, isCoverPhoto: isCover))
                } else {
                    isStorageCoverPhoto.append(StorageCoverPhoto(propertyPicturesUrl: "", isCoverPhoto: isCover))
                }
            } else {
                if let photoUrl = item["url"] as? String {
                    isStorageCoverPhoto.append(StorageCoverPhoto(propertyPicturesUrl: photoUrl, isCoverPhoto: false))
                } else {
                    isStorageCoverPhoto.append(StorageCoverPhoto(propertyPicturesUrl: "", isCoverPhoto: false))
                }
            }
            
        }
        
        if isStorageCoverPhoto.count == 0 {
            print("dasdsadsadasdasdasdsadsadasdasdasd")
        }
        
        return isStorageCoverPhoto
        
    }
    
    func photoUrlsWithJsonObject(jsonObject: [[String : AnyObject]]) -> [String]? {
        var photoUrls = [String]()
        for item in jsonObject {
            if let photoUrl = item["url"] as? String {
                photoUrls.append(photoUrl)
            } else {
                photoUrls.append("")
            }
        }
        
        return photoUrls
        
    }
    
    
    private func listingWithArray(json: [String : AnyObject]) -> StorageDetail? {
        
        guard let address = json["address"] as? [String : AnyObject],
            let fullAddress = address["formatted_address"] as? String,
            let postcode = address["postal_code"] as? String,
            let amenity = json["amenities"] as? [String],
            let availableDate = json["available_date"] as? String,
            let endingDate = json["ending_date"] as? String,
            var ownerPictureUrl = json["user_avatar_url"] as? String,
            let propertyDescription = json["description"] as? String,
            let propertyPicturesInformation = json["pictures"] as? [[String : AnyObject]],
            let isStorageCoverPhoto = isCoverPhotoWithJsonObject(jsonObject: propertyPicturesInformation),
            let priceByDay = json["price_by_day"] as? Double,
            let priceByWeek = json["price_by_week"] as? Double,
            let priceByMonth = json["price_by_month"] as? Double else {
                return nil
        }
        
        if ownerPictureUrl.contains("https://") == false {
            ownerPictureUrl = "https://yeswestock.com" + ownerPictureUrl
            print(ownerPictureUrl)
        }
        
        return StorageDetail(address: fullAddress, postcode: postcode, amenity: amenity, availableDate: availableDate, endingDate: endingDate, ownerPictureUrl: ownerPictureUrl, propertyDescription: propertyDescription, priceByDay: priceByDay, priceByWeek: priceByWeek, priceByMonth: priceByMonth, isStorageCoverPhoto: isStorageCoverPhoto)
        
        
    }
    
}

