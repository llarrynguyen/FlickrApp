//
//  EndpointProtocol.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol EndpointProtocol {
    var baseUrl : String { get }
    var path: String { get }
    var httpMethod : HTTPMethod { get }
    var parameters : [URLQueryItem]? { get }
    var request: URLRequest? { get }
    var headers: HTTPHeaders? { get}
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case post = "POST"
}

enum Domain: String {
    case flicker = "https://api.flickr.com"
}

