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
        print("search")
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
            print("request")
            if response.result.isSuccess{
                print("Success! Got the music data")
                
                
                //
                //                let data : JSON = JSON(response.result.value!)
                //                //json 에서 title만 일단 담아서 searchResult 담기
                //                guard let albumsData = data.dictionaryValue["results"]?.dictionaryValue["albums"]?.dictionary!["data"] else{ return}
                //                let dataArray = albumsData.arrayValue
                //                //print(data.dictionary!["results"]?.dictionary!["albums"]?.dictionary!["data"])
                //
                //                var searchResult = SearchResult()
                //                var titleArray : [String] = []
                //
                //                for item in (dataArray){
                //                    let anyString = item.dictionaryValue["attributes"]!["name"]
                //                    print(anyString.rawString()!)
                //                    titleArray.append(anyString.rawString()!)
                //                }
                //                searchResult.results = titleArray
                //                completionOnMain(searchResult)
                //
                ////                for item in albumsData
                
                let data : JSON = JSON(response.result.value!)
                guard let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data.rawData()) else {
                    print(#function, "JSON Decode Failed");
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
