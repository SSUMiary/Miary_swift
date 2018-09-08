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

import FirebaseAuth
import SwiftyJSON
class PlayListManager{
    
    var playLists : [PlayListItem] = []
    static let instance : PlayListManager = PlayListManager()
    let apiClient = ApiClient()
    func makeNewPlayList(playListName : String, completion : @escaping (String)->Void){
        
        let userId = MiaryLoginManager.getUserInfo().uid
        
        var DBRef = Database.database().reference().child("\(userId)/playLists/")
        var STRef = Storage.storage().reference().child("\(userId)/playLists/")
        let key  = DBRef.childByAutoId().key
        
        DBRef = DBRef.child(key)
        STRef = STRef.child(key)
        let logoImage = UIImage(named:"pl_img2")
        let data = UIImagePNGRepresentation(logoImage!)
        STRef.putData(data!).observe(.success) { (snapshot) in
            if let error = snapshot.error {
                
                return}else{
                //success
                STRef.downloadURL(completion: { (url, error) in
                    if let error = snapshot.error{
                        
                        return}else{
                        let dataDic : [String: AnyObject] =
                            ["user" : userId as AnyObject,
                             "imageUrl" : url?.absoluteString as AnyObject,
                             "title" : playListName as AnyObject,
                             "date":   " " as AnyObject,
                             "count": "0" as AnyObject
                        ]
                        DBRef.setValue(dataDic)
                        completion(key)
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
    
    func getAllPlayListsFromManager() -> [PlayListItem]{
        return playLists
    }
    
    func getSpecificPlayList(playListKey : String, completion : @escaping (PlayListItem) -> Void) {
        print(#function)
        print(playListKey)
        let mainCompletion : (PlayListItem) -> Void = {(item) -> Void in
            DispatchQueue.main.async {
                completion(item)
            }
        }
        
        let userId = MiaryLoginManager.getUserInfo().uid
        let DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)/")
        DBRef.observe(.value) { (snapshot) in
            //print(#function)
            let data = snapshot.value as! NSDictionary
            let keys = data.allKeys as! [String]
            let playListItem = PlayListItem()
            playListItem.songs = []
            playListItem.key = snapshot.key
            playListItem.user = userId
            
            for k in keys{
                if k == "title" {
                    playListItem.playListTitle = data[k] as! String
                    
                }else if k == "count"{}
                else if k == "date" {}
                else if k == "user"{playListItem.user = data[k] as! String}
                else if k == "imageUrl"{}
                else if k == "firstMusicTitle"{}
                else{
                    let newSong = SimpleSongModel()
                    let item = data[k] as! Dictionary<String,AnyObject>
                    newSong.songKey = k
                    newSong.artist = item["artist"] as! String
                    newSong.songName = item["songName"] as! String
                    newSong.imageURL = item["imageURL"] as! String
                    newSong.songID = item["songID"] as! String
                    playListItem.songs.append(newSong)
                    
                }
                
            }
            mainCompletion(playListItem)
        }
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
        
        DBRef.observe(.value) { (snapshot) in
            //print(#function)
            //print(snapshot.value)
            if !snapshot.hasChildren() {
                var emptyList : [PlayListItem] = []
                mainCompletion(emptyList)
                return
            }
            
            if self.playLists.count>0 { self.playLists = []}
            
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
                newPlayList.user = item["user"] as! String
                newPlayList.musicCount = item["count"] as! String
                self.playLists.append(newPlayList)
            }
            mainCompletion(self.playLists)
        }
    }
    
    
    func deleteMusicList(playListKey : String, completion : @escaping ()->Void) {
        
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)/")
        var STRef = Storage.storage().reference().child("\(userId)/playLists/\(playListKey)/")
        STRef.delete { (error) in
            print(#function)
            print(error)
            
        }
        DBRef.removeValue()
        completion()
        
    }
    
    func deleteMusicFromPlaylist(playListKey : String, songKey: String, completion : @escaping ()->Void){
        
        
        let userId = MiaryLoginManager.getUserInfo().uid
        var songDBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)/\(songKey)")
        var playListDBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)")
     
        songDBRef.removeValue()
        completion()
        
    }
    
    
    func addMusicToPlayList(albumID : String, album : Resource, playListKey : String, index : Int, completion : @escaping ()->Void){
        
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
                                               "songKey" : autokey]
        DBRef = DBRef.child(autokey)
        let g = DispatchQueue(label: "add")
        let q1 = DispatchWorkItem() {
            DBRef.setValue(dic)
            completion()
        }
        g.async(execute: q1)
    }
}
