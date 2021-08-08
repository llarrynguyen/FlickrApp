//
//  FlickrListViewModel.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

class FlickrListViewModel {
        
    static var imageCache = NSCache<NSString, AnyObject>()
    
    var needsRefresh: Binder<Bool> = Binder(false) {
        didSet {
            needsRefresh.value = false // Reset Flag
        }
    }
    
    
    var canLoadMore: Bool = true
    
    var searchTerm: String = "" {
        didSet {
            didUpdateSearchTerm { [weak self] photos in
                self?.flickrImages = photos
            }
        }
    }
    
    var flickrImages: [FlickrImage] = [] {
        didSet {
            needsRefresh.value = true
        }
    }
    
    private let interval: Double = 1.5
    private var apiClient: APIClient!
    private var searchGroup: SearchData?
    
    private lazy var throttler: Throttler = {
        let requestThrottler = Throttler(seconds: interval)
        return requestThrottler
    }()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func didUpdateSearchTerm(completion: @escaping ([FlickrImage]) -> ()) {
        guard searchTerm != "" else { return }
        throttler.throttle { [unowned self] in
            self.loadSearchResults(with: self.searchTerm, clearResults: true, completion: completion)
        }
    }
    
    func loadMoreResults(completion: @escaping ([FlickrImage]) -> ()) {
        guard canLoadMore else { return }
        loadSearchResults(with: searchTerm, clearResults: false, completion:completion)
    }
    
}

extension FlickrListViewModel {
    func loadSearchResults(with query: String, enableThrottling: Bool = false, clearResults: Bool = false, completion: @escaping ([FlickrImage]) -> ()) {
        
        let currentPage = searchGroup?.photos.page ?? 0
        let nextPage = currentPage + 1
        
        
        apiClient.fetchData(endpoint: FlickerEndpoint.getFlicker(searchTerm: query, page: String(nextPage))){ [weak self] (searchData: SearchData?) in
            print(searchData)
            guard let self_ = self else {
                completion([])
                return
            }
            
            guard let searchData = searchData else {
                self_.canLoadMore = false
                completion([])
                return
            }
            
            if clearResults {
                self_.flickrImages = searchData.photos.flickrImages
                
            } else {
                self_.flickrImages.append(contentsOf: searchData.photos.flickrImages)
            }
            
            self_.searchGroup = searchData
            completion(self_.flickrImages)
        }
    }
}


