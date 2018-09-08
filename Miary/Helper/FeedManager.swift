//
//  FeedManager.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 27..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//


import UIKit
import FacebookLogin
import FirebaseAuth
import FirebaseCore
import FacebookCore
import FBSDKCoreKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth

class FeedManager{
    
    var feedList : [FeedItem] = []
    static let instance = FeedManager()
    private init(){}
    
    func getFeeds()->[FeedItem] {
        return feedList
    }
    func updateFeed(feedInfo : FeedItem, completion : @escaping ()->Void){
        let userId = MiaryLoginManager.getUserInfo().uid
        let DBRef = Database.database().reference().child("\(userId)/feed/\(feedInfo.key)")
        DBRef.updateChildValues(["title" : feedInfo.title])
        print(#function + "end")
        completion()
    }
    
    func getSpecificFeedFromManager(index : Int) -> FeedItem{
        return feedList[index]
    }
    func makeNewFeed(feedInfo : FeedItem, completion : @escaping ()->Void){
        var latitude : Double
        var longitude : Double
        let userId = Auth.auth().currentUser!.uid
        var DBRef = Database.database().reference().child("/\(userId)/feed/")
        var STRef = Storage.storage().reference().child("/\(userId)/feed/")
        let key = DBRef.childByAutoId().key
        STRef = STRef.child(key)
        DBRef = DBRef.child(key)
        print(#function)
        print(feedInfo.playListKey)
        if feedInfo.image != nil {
            let data = UIImageJPEGRepresentation(feedInfo.image, 0.01)
            STRef.putData(data!).observe(.success) { (snapshot) in
                if snapshot.error != nil {
                    print(snapshot.error)
                }else {
                    STRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("downloadError!!!")
                            print(error)
                        }else {
                            let dataDic : [String: AnyObject] =
                                ["user" : userId as AnyObject ,
                                 "imageUrl" : url?.absoluteString as AnyObject,
                                 "title" : feedInfo.title as AnyObject,
                                 "date": feedInfo.date as AnyObject,
                                 "count" : feedInfo.count as AnyObject,
                                 "cityName": feedInfo.city as AnyObject,
                                 "latitude" : feedInfo.latitude as AnyObject,
                                 "longitude" : feedInfo.longitude as AnyObject,
                                 "playListKey" : feedInfo.playListKey as AnyObject]
                            DBRef.setValue(dataDic)
                            
                        }
                    })
                }
            }
        }
    }
    
    func deleteFeed(feedKey : String, completion : @escaping ()->Void){
        
        
        print(feedKey)
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/feed/\(feedKey)/")
        var STRef = Storage.storage().reference().child("\(userId)/feed/\(feedKey)/")
        STRef.delete { (error) in
            print(#function)
            print(error)
            
        }
        DBRef.removeValue()
        completion()
    }
    
    
    func getAllFeedFromServer(completion : @escaping ([FeedItem])->Void){
        
        let mainCompletion :([FeedItem])-> Void = {(result) -> Void in
            print(#function)
            completion(result)
        }
        print(#function + "start")
        
        let userId = Auth.auth().currentUser!.uid
        let DBRef = Database.database().reference().child("\(userId)/feed/")
        
        DBRef.observe(.value) { (snapshot) in
            print("Firebase DB Observe!!")
            
            if !snapshot.hasChildren() {
                let emptyArr : [FeedItem] = []
                mainCompletion(emptyArr)
                return;
            }
            
            let data = snapshot.value as! NSDictionary
            let keys = data.allKeys as! [String]
            if self.feedList.count>0 {
                self.feedList = []
            }
            
            for k in keys {
                let newItem = FeedItem()
                
                let item = data[k] as! NSDictionary
                let str  : String = item["imageUrl"] as! String
                
                let imageUrl = URL(string:str)
                
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newItem.image = UIImage(data: imageData)!
                }catch{
                    
                }
                newItem.key = k as! String
                newItem.title = item["title"] as! String
                newItem.date = item["date"] as! String
                newItem.count = item["count"] as! String
                newItem.city = item["cityName"] as! String
                newItem.longitude = item["longitude"] as! String
                newItem.latitude = item["latitude"] as! String
                newItem.playListKey = item["playListKey"] as! String
                
                self.feedList.append(newItem)
            }
            mainCompletion(self.feedList)
            print(#function + "end")
            
        }
        
    }
    
    
}
