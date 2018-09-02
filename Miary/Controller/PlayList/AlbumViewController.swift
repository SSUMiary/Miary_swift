//
//  AlbumViewController.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/14.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class AlbumViewController: UITableViewController, UINavigationBarDelegate, SKCloudServiceSetupViewControllerDelegate {
    
    let apiClient = ApiClient()
    let cloudServiceController = SKCloudServiceController()
    var cloudServiceSetupController = SKCloudServiceSetupViewController()
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    let playListManager = PlayListManager()
    var albumID: String!
    var album: Resource?
    
    var playListKey : String!
    
    var canMusicCatalogPlayback = false
    
    @IBAction func onCancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudServiceSetupController.delegate = self
        prepare()
    }
    
}

extension AlbumViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard album != nil else { return 0 }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let album = album else { return 0 }
        if section == 0 {
            return 1
        } else {
            return album.relationships!.tracks!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumHeaderCell", for: indexPath) as! AlbumHeaderCell
            cell.nameLabel.text = album!.attributes?.name
            cell.artistLabel.text = album!.attributes?.artistName
            cell.yearLabel.text = album!.attributes?.releaseDate
            if let url = album!.attributes?.artwork?.imageURL(width: 220, height: 220) {
                apiClient.image(url: url) { image in
                    cell.thumbnailView.image = image
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let track = album?.relationships!.tracks![indexPath.row]
        
        cell.textLabel?.text = track?.attributes?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        playListManager.addMusicToPlayList(albumID: albumID, album: album!, playListKey: playListKey, index: indexPath.row)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension AlbumViewController {
    
    
    
    func prepare() {
        apiClient.album(id: albumID) { [unowned self] album in
            DispatchQueue.main.async {
                self.album = album
                self.tableView.reloadData()
            }
        }
        
        self.cloudServiceController.requestCapabilities { capabilities, error in
            
            if error != nil {
                print(#function)
                print("capability erorr")
                print(error)
            }
            
            guard capabilities.contains(.musicCatalogPlayback) else {
                print(#function)
                print("musicCatalogPlayBack denied")
                //애플 뮤직 링크
                let optionsKeys = SKCloudServiceSetupOptionsKey(rawValue: "optionKey")
                
                
                self.cloudServiceSetupController.load(options: [optionsKeys : "key"], completionHandler: { (result, error) in
                    print(#function)
                    print(result)
                    print(error)
                })
                return }
            self.canMusicCatalogPlayback = true
        }
    }
}

class AlbumHeaderCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}
