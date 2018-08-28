//
//  PlayListManager.swift
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
import SwiftyJSON
class PlayListManager{
    
    static func makeNewPlayList(playListName : String){
        SVProgressHUD.show()
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let userId = MiaryLoginManager.getUserInfo().uid
        
        var DBRef = Database.database().reference().child("\(userId)/playLists/")
        var STRef = Storage.storage().reference().child("\(userId)/playLists/")
        let key  = DBRef.childByAutoId().key
        
        DBRef = DBRef.child(key)
        STRef = STRef.child(key)
        let logoImage = UIImage(named:"AppIcon29x29")
        let data = UIImagePNGRepresentation(logoImage!)
        
        
        STRef.putData(data!).observe(.success) { (snapshot) in
            if let error = snapshot.error {
                SVProgressHUD.dismiss()
                return}else{
                //success
                STRef.downloadURL(completion: { (url, error) in
                    if let error = snapshot.error{
                        SVProgressHUD.dismiss()
                        return}else{
                        let dataDic : [String: AnyObject] =
                            ["user" : userId as AnyObject,
                             "imageUrl" : url?.absoluteString as AnyObject,
                             "title" : playListName as AnyObject,
                             "date":   " " as AnyObject,
                             "count" : " " as AnyObject,
                             "firstMusicTitle" : " " as AnyObject]
                        DBRef.setValue(dataDic)
                        SVProgressHUD.dismiss()
                    }
                })
            }
        }
    }
    func getPlayLists(completion : @escaping ([PlayListItem])->Void){
        
        let completionOnmain : ([PlayListItem]) -> Void = {(result)->Void in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var lists : [PlayListItem] = []
        SVProgressHUD.show()
        
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/playLists/")
        var STRef = Storage.storage().reference().child("\(userId)/playLists/")
        DBRef.observe(.value) { (snapshot) in
            if snapshot.hasChildren() == false {
                SVProgressHUD.dismiss()
            }
            
            guard let data : Dictionary<String,AnyObject> = snapshot.value as? Dictionary<String,AnyObject> else {return}
            
            let keys = data.keys
            for k in keys {
                let item = JSON(data[k])
                var newPlayListItem = PlayListItem()
                newPlayListItem.key = k
                newPlayListItem.date = item["date"].rawString()
                let str = item["imageUrl"].rawString()!
                let imageUrl = URL(string:str)
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newPlayListItem.coverImage = UIImage(data: imageData)!
                }catch{}
                newPlayListItem.playListTitle = item["title"].rawString()!
                newPlayListItem.firstMusicTitle = item["firstMusicTitle"].rawString()!
                newPlayListItem.musicCount = item["count"].rawString()!
                newPlayListItem.user = item["user"].rawString()!
                lists.append(newPlayListItem)
            }
            SVProgressHUD.dismiss()
            completionOnmain(lists)
        }
    }
    func updatePlayListName(newName : String){}
    func deletePlatList(playListKey : String ){
        
        SVProgressHUD.show()
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)")
        var STRef = Storage.storage().reference().child("\(userId)/playLists/\(playListKey)")
//
//        let group = DispatchGroup()
//        let q1 = DispatchQueue(label: "Storage remove")
//        let q2 = DispatchQueue(label: "Databare remove")
//        let w1 = DispatchWorkItem {
//            STRef.delete { (error) in
//
//            }
//        }
//        let w2 = DispatchWorkItem {
//            DBRef.removeValue()
//
//        }
//        q1.async(group: group, execute: w1)
//        q1.async(group: group, execute: w2)
//        group.notify(queue: DispatchQueue.main) {
//            SVProgressHUD.dismiss()
//        }
        
        STRef.delete { (error) in
            
        }
        DBRef.removeValue()
        SVProgressHUD.dismiss()
       
        
        
    }
}
