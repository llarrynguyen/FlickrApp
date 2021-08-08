//
//  FlickrResultViewModel.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

struct FlickrResultViewModel {
    
    private var apiClient: APIClient!
    
    var title: String?
    var imageURL: String?
    
    private func flickrImageKey(_ searchResult: FlickrImage) -> String {
        return "\(searchResult.server)/\(searchResult.id)_\(searchResult.secret).jpg"
    }
    
    init(apiClient: APIClient,searchResult: FlickrImage) {
        self.apiClient = apiClient
        self.title = searchResult.title
        self.imageURL = flickrImageKey(searchResult)
    }
    
}

