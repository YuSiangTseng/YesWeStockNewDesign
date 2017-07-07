//
//  StorageDetailStore.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 13/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum ImageArrayResult {
    case Success([UIImage])
    case Failure(Error)
}

enum PhotoError: Error {
    case ImageCreationError
}

class StorageDetailStore {
    private (set) var storageDetails: [StorageDetail]
    private (set) var reviews: [Review]
    init(storageDetails: [StorageDetail], reviews: [Review]) {
        self.storageDetails = storageDetails
        self.reviews = reviews
    }
    
    func fetchOwnerAvatar(storageDetail: StorageDetail, completion: @escaping (ImageResult) -> Void) {
        
        guard let url = URL(string: storageDetail.ownerPictureUrl) else {
            return
        }
        if let image = storageDetail.ownerPicture {
            completion(.Success(image))
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            OperationQueue.main.addOperation({
                let result = self.processImageWithData(data: data)
                if case let .Success(image) = result {
                    storageDetail.ownerPicture = image
                }
                completion(result)
            })
            }.resume()
        
    }
    
    func fetchCoverPhoto(storageDetail: StorageDetail, completion: @escaping (ImageResult) -> Void) {
        
        if let image = storageDetail.propertyCoverPhoto {
            completion(.Success(image))
            return
        }

        guard storageDetail.isStorageCoverPhoto?.count != 0  else {
            storageDetail.propertyCoverPhoto = UIImage(named: "placeholder")
            completion(.Success(storageDetail.propertyCoverPhoto!))
            return
        }
        
        if let isStorageCoverPhoto = storageDetail.isStorageCoverPhoto {
            for isCoverPhotoWithUrl in isStorageCoverPhoto {
                if let isCoverPhoto = isCoverPhotoWithUrl.isCoverPhoto {
                    if isCoverPhoto {
                        if let coverPhotoUrl = isCoverPhotoWithUrl.propertyPicturesUrl {
                            if let coverPhotoUrl = URL(string: coverPhotoUrl) {
                                let session = URLSession.shared
                                session.dataTask(with: coverPhotoUrl) { (data, response, error) in
                                    OperationQueue.main.addOperation({
                                        let result = self.processImageWithData(data: data)
                                        if case let .Success(image) = result {
                                            storageDetail.propertyCoverPhoto = image
                                        }
                                        completion(result)
                                    })
                                    }.resume()
                            }
                            
                        }
                    }
        
                }
            }
        }
    }
    
    func fetchPropertyPhoto(storageDetail: StorageDetail, photoUrl: String, photoArrayIndex: Int, completion: @escaping (ImageResult) -> Void) {
        if let image = storageDetail.propertyPictures?[photoArrayIndex] {
            completion(.Success(image))
            return
        }
        
        let session = URLSession.shared
        if let photoUrl = URL(string: photoUrl) {
            session.dataTask(with: photoUrl) { (data, response, error) in
                OperationQueue.main.addOperation({
                    let result = self.processImageWithData(data: data)
                    if case let .Success(image) = result {
                        storageDetail.propertyPictures?[photoArrayIndex] = image
                    }
                    completion(result)
                })
                
                }.resume()
 
        }

    }

    
    private func processImageWithData(data: Data?) -> ImageResult {
        guard data != nil,
            let image = UIImage(data: data!) else {
                return .Failure(PhotoError.ImageCreationError)
        }
        
        return .Success(image)
    }
    
}

