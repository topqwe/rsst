//
//  SaveToAlbum.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import Photos
import UIKit
class SaveToAlbum {
    
    static let sharedInstance = SaveToAlbum()
    
    var assetCollection: PHAssetCollection!
    
    var assetCollectionPlaceholder: PHObjectPlaceholder!
    
    func save(image:UIImage, toAlbum:String, withCallback:((Bool)->Void)? = nil) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", toAlbum)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {//second then delete first album //fourth
            
            assetCollection = collection.firstObject
            
            if self.assetCollection != nil {
                PHPhotoLibrary.shared().performChanges({
                    
                    let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                    albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
                }, completionHandler: { (_ didComplete:Bool, _ error:Error?) -> Void in
                    if withCallback != nil {
                        withCallback!(didComplete && error == nil)
                    }
                })
                
            } else {
                if withCallback != nil {
                    // Failure to save
                    withCallback!(false)
                }
            }
            
        } else {//first //third
            
            PHPhotoLibrary.shared().performChanges({
                
                let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: toAlbum)
                self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                
            }, completionHandler: { success, error in
                
                if success {
                    
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.assetCollectionPlaceholder.localIdentifier], options: nil)
                    print(collectionFetchResult)
                    self.assetCollection = collectionFetchResult.firstObject
                    
                    if self.assetCollection != nil {
                        PHPhotoLibrary.shared().performChanges({
                            
                            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
                            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
                        }, completionHandler: { (_ didComplete:Bool, _ error:Error?) -> Void in
                            if withCallback != nil {
                                withCallback!(didComplete && error == nil)
                            }
                        })
                        
                    } else {
                        if withCallback != nil {
                            // Failure to save
                            withCallback!(false)
                        }
                    }
                    
                }else{
                    if withCallback != nil {
                        // Failure to save
                        withCallback!(false)
                    }
                }
            })
        }
        
    }
    
}

