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
    
    
    
    
    let apiClient = ApiClient()
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
    
    func updatePlayListName(newName : String, playListKey : String){
        // 플레이리스트 이름 변경
        let userId = MiaryLoginManager.getUserInfo().uid
        let DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)")
        DBRef.updateChildValues(["title" : newName])
        
        //SVProgressHUD.showSuccess(withStatus: "update finished")
        
    }
    func updatePlayListCount(playListKey : String){
        //곡 추가하고 호출 되야 함
        
    }
    
    func getAllPlayLists(completion : @escaping (_ lists : [PlayListItem])-> Void){
        
        print(#function)
        let mainCompletion : ([PlayListItem]) -> Void = {(items)->Void in
            DispatchQueue.main.async {
                completion(items)
            }
        }
        
        
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/playLists")
        var STRef = Storage.storage().reference().child("\(userId)/playLists")
        var lists : [PlayListItem] = []
        
        
        DBRef.observe(.value) { (snapshot) in
            //print(#function)
            //print(snapshot.value)
            if !snapshot.hasChildren() {
                var emptyList : [PlayListItem] = []
                mainCompletion(emptyList)
                return
            }
            
            if lists.count>0 { lists = []}
            
            let data = snapshot.value as! NSDictionary
            let keys = data.allKeys as! [String]
            
            for k in keys {
                let newPlayList = PlayListItem()
                let item = data[k] as! NSDictionary
                let str  : String = item["imageUrl"] as! String
                let imageUrl = URL(string:str)
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newPlayList.coverImage = UIImage(data: imageData)!
                }catch{}
                newPlayList.key = k
                newPlayList.playListTitle = item["title"] as! String
                newPlayList.firstMusicTitle = item["firstMusicTitle"] as! String
                newPlayList.user = item["user"] as! String
                newPlayList.date = item["date"] as! String
                newPlayList.musicCount = item["count"] as! String
                lists.append(newPlayList)
            }
            mainCompletion(lists)
        }
    }
    

    func deleteMusicFromPlaylist(playListKey : String, songKey: String){
        
        
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)/\(songKey)")
        
        DBRef.removeValue()
        
    }
    
    func addMusicToPlayList(albumID : String, album : Resource, playListKey : String, index : Int){
        
        let userId = MiaryLoginManager.getUserInfo().uid
        
        let artWork = album.attributes?.artwork
        let track = album.relationships?.tracks![index]
        let songName = track?.attributes?.name!
        let artist = track?.attributes?.artistName!
        let songID = track?.id!
        let url = artWork?.imageURL(width: 80, height: 80)!
        
        var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)")
        let autokey = DBRef.childByAutoId().key
        
        
        let dic : Dictionary<String,String> = ["songName" : songName!,
                                               "artist" : artist!,
                                               "songID": songID!,
                                               "imageURL" : (url?.absoluteString)!,
                                               "songKey" : autokey
        ]
        
        DBRef = DBRef.child(autokey)
        
        let g = DispatchQueue(label: "add")
        let q1 = DispatchWorkItem() {
            DBRef.setValue(dic)
        }
        g.async(execute: q1)
    }
}
