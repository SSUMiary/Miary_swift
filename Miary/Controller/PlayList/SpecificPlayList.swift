//
//  SpecificPlayList.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 28..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth
import SwiftyJSON

import StoreKit
import MediaPlayer

class SpecificPlayList: UIViewController, UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate {
    
    //플레이리스트 눌렀을때 그 플레이 리스트에 해당하는 곡들이 보여야 함
    
    var canMusicCatalogPlayback = false
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    let cloudServiceController = SKCloudServiceController()

    @IBOutlet var tableView : UITableView!
    @IBOutlet var playListTitle : UILabel!
    var playListKey : String?
    let apiClient = ApiClient()
    let playListManager = PlayListManager()
    var playListTitleSource :String?
    var playListCount : String?
    
    
    var songs : [SimpleSongModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        getPlayListInformation()
        prepare()
        
    }
    func prepare(){
        self.cloudServiceController.requestCapabilities { capabilities, error in
            if error != nil {
                print(#function)
                print(error)
            }
            guard capabilities.contains(.musicCatalogPlayback) else { return }
            self.canMusicCatalogPlayback = true
        }
    }
    
    func getPlayListInformation(){
        //서버로 부터 playListTitle 에 대한 플레이 리스트 정보를 받아옴
        //그 정보를 albums에 저장하고, albums에 대한 정보로 tableview에 뿌려줌
        
        let userId = MiaryLoginManager.getUserInfo().uid
        let key = playListKey as! String
        
        
        
        let DBRef = Database.database().reference().child("\(userId)/playLists/\(key)/")
        DBRef.observe(.childAdded) { (snapshot) in
            //print(#function)
            
            if snapshot.hasChildren() {
               // print(snapshot)
                //print(snapshot.key)
                let data = snapshot.value as! Dictionary<String,String>
                let song = SimpleSongModel()
                song.artist = data["artist"]
                song.songName = data["songName"]
                song.imageURL = data["imageURL"]
                song.songID = data["songID"]
                self.songs.append(song)
                self.tableView.reloadData()
                
                
            }else{
                if snapshot.key == "title" {
                    self.playListTitle.text = snapshot.value as! String
                }
                
                //let song = SimpleSongModel()
                //self.playListTitle.text = data["title"] as! String
            }
        }
    }
    
    
    
    @IBAction func onCancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonPressed(){
        let playListManager = PlayListManager()
        let alertController = UIAlertController(title: "Edit play list name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = self.playListTitle.text
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if firstTextField.text == "" {
                return
            }
            let newPlayListName = firstTextField.text
            
            self.playListManager.updatePlayListName(newName: newPlayListName!, playListKey: self.playListKey!)
            //add new playlist
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func addSongs(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "addSongs") as! UINavigationController
        let topVC = nextVC.topViewController as! SearchMusicViewController
        topVC.playListkey = playListKey
        navigationController?.pushViewController(topVC, animated: true)
        
        
        //navigationController?.present(nextVC, animated: true, completion: nil)
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard canMusicCatalogPlayback else { return }
        //guard indexPath.section == 1 else { return }
        
        let item = songs[indexPath.row]
        let trackIDs = songs.map { (model) -> String in
            (model as! SimpleSongModel).songID!
            
        }
        
        let startTrackID = songs[indexPath.row].songID!
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: trackIDs)
        descriptor.startItemID = startTrackID
        musicPlayer.setQueue(with: descriptor)
        musicPlayer.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListTableViewCell") as! MusicListTableViewCell
        let item = songs[indexPath.row]
        
        do{
            let url = try item.imageURL?.asURL()
            apiClient.image(url: url!) { (image) in
                cell.albumImage.image = image
                cell.setNeedsLayout()
            }
        }
        catch{
            print("imageParsing error")
        }
        
        cell.musicTitle.text = item.songName
        cell.singerName.text = item.artist
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
