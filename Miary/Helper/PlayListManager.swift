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
    
    func updatePlayListName(newName : String, playListKey : String){
        // 플레이리스트 이름 변경
        
    }
    func updatePlayListCount(playListKey : String){
        //곡 추가하고 호출 되야 함
        
    }
    
    func addMusicToPlayList(albumID : String, album : Resource, playListKey : String, index : Int){
        let userId = MiaryLoginManager.getUserInfo().uid
        
        let artWork = album.attributes?.artwork
        let track = album.relationships?.tracks![index]
        let songName = track?.attributes?.name!
        let artist = track?.attributes?.artistName!
        let songID = track?.id!
        let url = artWork?.imageURL(width: 80, height: 80)!
        
        let dic : Dictionary<String,String> = ["songName" : songName!,
                                               "artist" : artist!,
                                               "songID": songID!,
                                               "imageURL" : (url?.absoluteString)!,
                                               ]


        var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)")
        let autokey = DBRef.childByAutoId().key
        DBRef = DBRef.child(autokey)
        

        DBRef.setValue(dic)
        
    }
    
    
    
   
}
