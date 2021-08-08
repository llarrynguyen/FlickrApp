//
//  FlickrImage.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import Foundation

struct SearchData {
    let photos: SearchEntity
}

extension SearchData: Decodable {
    
    private enum FlickrImagesResponseCodingKeys: String, CodingKey {
        case photos = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FlickrImagesResponseCodingKeys.self)
        
        photos = try container.decode(SearchEntity.self, forKey: .photos)
    }
}

struct SearchEntity {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let flickrImages: [FlickrImage]
}

extension SearchEntity: Decodable {
    
    private enum FlickrImageResponseCodingKeys: String, CodingKey {
        case page = "page"
        case numberOfResults = "perpage"
        case numberOfPages = "pages"
        case flickrImages = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FlickrImageResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        flickrImages = try container.decode([FlickrImage].self, forKey: .flickrImages)
        
    }
}


public struct FlickrImage {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let url_m: String
}

extension FlickrImage: Decodable {
    
    enum FlickrImageCodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case url_m
    }
    
    
    public init(from decoder: Decoder) throws {
        let flickrImageContainer = try decoder.container(keyedBy: FlickrImageCodingKeys.self)
        
        id = try flickrImageContainer.decode(String.self, forKey: .id)
        owner = try flickrImageContainer.decode(String.self, forKey: .owner)
        secret = try flickrImageContainer.decode(String.self, forKey: .secret)
        server = try flickrImageContainer.decode(String.self, forKey: .server)
        farm = try flickrImageContainer.decode(Int.self, forKey: .farm)
        title = try flickrImageContainer.decode(String.self, forKey: .title)
        url_m = try flickrImageContainer.decode(String.self, forKey: .url_m)
        
    }
}


extension FlickrImage: Equatable {
    
    public static func == (lhs: FlickrImage, rhs: FlickrImage) -> Bool {
        return lhs.farm == rhs.farm &&
            lhs.server == rhs.server &&
            lhs.secret == rhs.secret &&
            lhs.id == rhs.id
    }
}

extension FlickrImage {
    func flickrImageKey() -> String {
        return "\(self.server)/\(self.id)_\(self.secret).jpg"
    }
}

