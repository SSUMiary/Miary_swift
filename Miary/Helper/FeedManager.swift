////
////  FeedManager.swift
////  Miary
////
////  Created by Euijoon Jung on 2018. 8. 27..
////  Copyright © 2018년 Euijoon Jung. All rights reserved.
////
//
//
//import UIKit
//import FacebookLogin
//import FirebaseAuth
//import FirebaseCore
//import FacebookCore
//import FBSDKCoreKit
//import FirebaseDatabase
//import FirebaseStorage
//import SVProgressHUD
//import FirebaseAuth
//
//class FeedManager{
//    
//    static var feedList : [FeedItem] = []
//    
//    static func getAllFeed(){
//        
//        let userId = Auth.auth().currentUser!.uid
//        let DBRef = Database.database().reference().child("\(userId)/feed/")
//        let STRef = Database.database().reference().child("\(userId)/feed/")
//        let rootRef = Database.database().reference().child("\(userId)/feed")
//        
//        DBRef.observe(.value) { (snapshot) in
//            print("Firebase DB Observe!!")
//            
//            if !snapshot.hasChildren() {
//                return
//            }
//            
//            let data = snapshot.value as! NSDictionary
//            let keys = data.allKeys as! [String]
//            if self.feedList.count>0 {
//                self.feedList = []
//            }
//            
//            for k in keys {
//                let newItem = FeedItem()
//                
//                let item = data[k] as! NSDictionary
//                let str  : String = item["imageUrl"] as! String
//                
//                let imageUrl = URL(string:str)
//                
//                do{
//                    let imageData = try Data(contentsOf: imageUrl!)
//                    newItem.image = UIImage(data: imageData)!
//                }catch{
//                    
//                }
//                newItem.title = data["title"] as! String
//                newFeed.date = data["date"] as! String
//                newFeed.count = data["count"] as! String
//                newFeed.firstMusicTitle = data["firstMusicTitle"] as! String
//                //newFeed.city = data["city"] as! String
//                list.append(newFeed)
//            }
//            
//        }
//        
//    }
//    
//    
//}
