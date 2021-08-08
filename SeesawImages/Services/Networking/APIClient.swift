//
//  APIClient.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

typealias NetworkCompletion = (_ data: Data?, _ errorMessage: String?) -> ()

func mainQueue( _ block: (() -> ())?) {
    DispatchQueue.main.async {
        block?()
    }
}

enum Result<String> {
    case success
    case failure(String)
}

enum NetworkError: String {
    case authError
    case badRequest
    case outdated
    case failed
    case noData
    case failToDecode
    case requestError
}

class APIClient {
    private var task : URLSessionTask?
    private func request(endpoint: EndpointProtocol, completion: @escaping NetworkCompletion){
        guard let request =  endpoint.request else {
            completion(nil, NetworkError.badRequest.rawValue)
            return
        }
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration:config)
        
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkError.requestError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result  {
                    case .success:
                        guard let data = data else {
                            completion(nil, NetworkError.noData.rawValue)
                            return
                        }
                        
                        completion(data, nil)
                    case .failure(let errorMessage):
                        completion(nil, errorMessage)
                }
            }
            
        })
        
        task?.resume()
    }
    
    private func simpleDataRequest(urlString: String, completion: @escaping NetworkCompletion){
        guard let url = URL(string: urlString), let request =  URLRequest(url: url) as? URLRequest else {
            completion(nil, NetworkError.badRequest.rawValue)
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration:config)
        
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(nil, NetworkError.requestError.rawValue)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result  {
                    case .success:
                        guard let data = data else {
                            completion(nil, NetworkError.noData.rawValue)
                            return
                        }
                        
                        completion(data, nil)
                    case .failure(let errorMessage):
                        completion(nil, errorMessage)
                }
            }
            
        })
        
        task?.resume()
    }
    
    func fetchData<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping (T?) -> ()){
        self.request(endpoint: endpoint) { (data, errorMessage) in
            
            guard let data = data, errorMessage == nil else {
                debugPrint(errorMessage ?? "")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let object = try decoder.decode(T.self, from: data)
                completion(object)
                
            } catch {
                completion(nil)
            }
        }
    }
    
    func downloadImage(urlString: String, completion: @escaping (Data?) -> ()) {
        self.simpleDataRequest(urlString: urlString) { data, errorMessage in
            if errorMessage == nil, data != nil {
                completion(data)
            }
            completion(nil)
        }
    }
    
    private func handleNetworkResponse( _ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
            case 200...299: return .success
            case 401...500: return .failure(NetworkError.authError.rawValue)
            case 501...599: return .failure(NetworkError.badRequest.rawValue)
            case 600: return .failure(NetworkError.outdated.rawValue)
            default : return .failure(NetworkError.failed.rawValue)
        }
    }
}

