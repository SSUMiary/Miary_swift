//
//  ApiClient.swift
//  MiaryApiClient
//
//  Created by Euijoon Jung on 2018. 8. 14..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum ResponseError: Error {
    case invalidResponse(URLResponse?)
    case unacceptableStatusCode(Int)
}


class ApiClient{
    //    static let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlpaNDRCOFMzTk0ifQ.eyJpYXQiOjE1MzM5ODI0MTMsImV4cCI6MTU0OTUzNDQxMywiaXNzIjoiODc4OFI4MjY1TCJ9.uhoZnZ1vPJ8WXBJZuywHTWs8RfeOenWAodLsWnFbciND8PPStL_9unJRESvvcr6oeFAHhMJfogPxiTiFTb92pw"
    
    static let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlpaNDRCOFMzTk0ifQ.eyJpYXQiOjE1MzM5ODI0MTMsImV4cCI6MTU0OTUzNDQxMywiaXNzIjoiODc4OFI4MjY1TCJ9.uhoZnZ1vPJ8WXBJZuywHTWs8RfeOenWAodLsWnFbciND8PPStL_9unJRESvvcr6oeFAHhMJfogPxiTiFTb92pw"
    static let countryCode = "kr"
    
    
    static let imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "APIClientImage"
        cache.countLimit = 20
        cache.totalCostLimit = 10 * 1024 * 1024
        return cache
    }()
    
    func search(term : String, completion : @escaping (SearchResult)->Void){
        
        let completionOnMain : (SearchResult?) -> Void  = { (SearchResult) -> Void in
            DispatchQueue.main.async {
                completion(SearchResult!)
            }
        }
        
        let url = "https://api.music.apple.com/v1/catalog/\(ApiClient.countryCode)/search"
        let params : Dictionary = ["term":term,
                                   "limit" : "10",
                                   "types" : "albums"]
        var headers = HTTPHeaders()
        headers["Authorization"] = "Bearer \(ApiClient.developerToken)"
        Alamofire.request(url,method : .get, parameters : params, headers : headers).responseJSON{
            response in
            if response.result.isSuccess{
                print("Success! Got the music data")
                print(response)
                let data : JSON = JSON(response.result.value!)
                print(data)
                guard let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data.rawData()) else {
                    print(#function, "JSON Decode Failed");
                    print(data)
                    completionOnMain(nil)
                    return
                }
                completionOnMain(searchResult)
                
            }
            else{
                print(#function)
                print("Error \(response.result.error)")
                
            }
        }
    }
    
    func image(url: URL, completion: @escaping ((UIImage?) -> Void)) {
        let completionOnMain: (UIImage?) -> Void = { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        if let image = ApiClient.imageCache.object(forKey: url.absoluteString as NSString) {
            print(#function, "image is Cacheed");
            completion(image)
            return
        }
        
        data(with: URLRequest(url: url)) { data, error -> Void in
            guard error == nil else {
                print(#function, "URL Session Task Failed", error!)
                completionOnMain(nil)
                return
            }
            
            if let image = UIImage(data: data!) {
                ApiClient.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completionOnMain(image)
            } else {
                print(#function, "image convert Failed");
                completionOnMain(nil)
            }
        }
    }
    
    func album(id: String, completion: @escaping (Resource?) -> Swift.Void) {
        let completionOnMain: (Resource?) -> Void = { resource in
            DispatchQueue.main.async {
                completion(resource)
            }
        }
        
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(ApiClient.countryCode)/albums/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(ApiClient.developerToken)",
            forHTTPHeaderField: "Authorization")
        
        data(with: request) { data, error -> Void in
            guard error == nil else {
                print(#function, "URL Session Task Failed", error!)
                completionOnMain(nil)
                return
            }
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data!),
                let dictionary = jsonData as? [String: Any],
                let dataArray = dictionary["data"] as? [[String: Any]],
                let albumDictionary = dataArray.first,
                let albumData = try? JSONSerialization.data(withJSONObject: albumDictionary),
                let album = try? JSONDecoder().decode(Resource.self, from: albumData) else {
                    print(#function, "JSON Decode Failed");
                    completionOnMain(nil)
                    return
            }
            completionOnMain(album)
        }
    }
    
    
}

extension ApiClient {
    func data(with request: URLRequest, completion: @escaping (Data?, Error?) -> Swift.Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, ResponseError.invalidResponse(response))
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(nil, ResponseError.unacceptableStatusCode(httpResponse.statusCode))
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }
}
