//
//  FlickrEndpoint.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import Foundation

enum FlickerEndpoint {
    case getFlicker(searchTerm: String, page: String)
    static let apiKey = "6343a66eb46c461c91934e8a7a981056"
    static let search = "flickr.photos.search"
}

extension FlickerEndpoint : EndpointProtocol {
    
    var baseUrl: String {
        switch self {
            case .getFlicker:
                return Domain.flicker.rawValue
        }
        
    }
    
    var path: String {
        switch self {
            case .getFlicker:
                return "/services/rest"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .getFlicker:
                return .get
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
            case .getFlicker(let searchTerm, let page):
                
                var queryItems: [URLQueryItem] = [
                    URLQueryItem(name: "api_key", value: FlickerEndpoint.apiKey),
                    URLQueryItem(name: "method", value: FlickerEndpoint.search)
                ]
                
                
                let parameters: [String: Any] = [
                    "extras": [
                        "media",
                        "url_sq",
                        "url_m"
                    ],
                    "format": "json",
                    "nojsoncallback": "true",
                    "tags": searchTerm,
                    "page": String(page)
                ]
                
                queryItems.append(contentsOf: generateParameters(dictionary: parameters))
                return queryItems
        }
    }
    
    
    var request: URLRequest? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.queryItems = parameters
        if let url = urlComponents?.url {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.allHTTPHeaderFields = headers
            return request
        }
        return nil
    }
    
    var headers: HTTPHeaders? {
        switch self {
            case .getFlicker:
                return [
                    "Content-Type" : "application/json"
                ]
                
        }
        
    }
}


private func generateParameters(dictionary: [String: Any]) -> [URLQueryItem] {
    var queryItems = [URLQueryItem]()
    for (key, value) in dictionary {
        if let value = value as? String {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        } else if let values = value as? [String] {
            for value in values {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
    }
    return queryItems
}

