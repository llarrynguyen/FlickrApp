//
//  ImageDownloader.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit
typealias ImageCompletionHandler = ((UIImage?) -> Void)?
typealias backgroundQueue = (() -> ())?

class ImageDownloader {
    static let imageCache = NSCache<NSString, AnyObject>()
    
    class func downloadImage(from flickrImage: FlickrImage?, completion: ImageCompletionHandler = nil) {
        guard let flickrImage = flickrImage else {
            completion?(nil)
            return
        }
        let cacheKey = NSString(string: flickrImage.url_m)
        if let cachedImage = imageCache.object(forKey: cacheKey) as? UIImage {
            completion?(cachedImage)
        } else {
            APIClient().downloadImage(urlString:flickrImage.url_m, completion: { data in
                if let data = data, let image = UIImage(data: data) {
                    mainQueue{completion?(image)}
                    
                }
            })
        }
        
    }
}

