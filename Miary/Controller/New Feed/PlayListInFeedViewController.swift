//
//  MusicSearchViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 14..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth
import SwiftyJSON

class PlayListInFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var tableView : UITableView!
    
    var playLists : [PlayListItem] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        getPlayLists()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onNewButtonPreessed(){
        let playListManager = PlayListManager()
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Play list name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            PlayListManager.makeNewPlayList(playListName: firstTextField.text!)
            //add new playlist
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC = storyBoard.instantiateViewController(withIdentifier: "addNewPlayList")
//        self.navigationController?.present(nextVC,animated: true,completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "specificPlayList" {
            let vc = segue.destination as! UINavigationController
            let topVC = vc.topViewController as! SpecificPlayList
            let index = tableView.indexPathForSelectedRow
            topVC.playListKey = playLists[index!.row].key as! String
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicList", for: indexPath) as! PlayListTableViewCell
        let item = playLists[indexPath.row]
        cell.backgroundImage.image = item.coverImage
        cell.date.text = item.date
        cell.playListTitle.text = item.playListTitle
        cell.firstMusicTitle.text = item.firstMusicTitle
        cell.playListCount.text = item.musicCount
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playLists.count
    }
    
    
    func getPlayLists(){
        SVProgressHUD.show()
        let userId = MiaryLoginManager.getUserInfo().uid
        var DBRef = Database.database().reference().child("\(userId)/playLists")
        var STRef = Storage.storage().reference().child("\(userId)/playLists")
        var lists : [PlayListItem] = []
        
        DBRef.observe(.childAdded) { (snapshot) in
            if snapshot.hasChildren() == false {
                print("no data")
                SVProgressHUD.dismiss()
            }
            let data = snapshot.value as! Dictionary<String,AnyObject>
            
            var newPlayListItem = PlayListItem()
            do{
                newPlayListItem.key = snapshot.key
                let str = data["imageUrl"] as! String
                
                let imageUrl = URL(string:str)
                
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newPlayListItem.coverImage = UIImage(data: imageData)!
                }catch{
                    
                }
                
                newPlayListItem.playListTitle = data["title"] as! String
                newPlayListItem.date = data["date"] as! String
                newPlayListItem.musicCount = data["count"] as! String
                newPlayListItem.firstMusicTitle = data["firstMusicTitle"] as! String
                newPlayListItem.user = data["user"] as! String
                
                self.playLists.append(newPlayListItem)
                self.tableView.reloadData()
                
            }
            catch{
                SVProgressHUD.dismiss()
            }
            self.tableView.reloadData()
        }
        SVProgressHUD.dismiss()
        
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
