//
//  MusicListController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 26..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth
import SwiftyJSON

class PlayListController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate {
    
    
    let playListManager = PlayListManager()
    var playLists : [PlayListItem] = []
    
    @IBOutlet var tableView : UITableView!
    
    
    @IBAction func onButtonPressed(_ sender: Any){
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC = storyBoard.instantiateViewController(withIdentifier: "addSongs")
//        self.navigationController?.present(nextVC,animated: true,completion: nil)
        //navigationController?.present(nextVC, animated: true, completion: nil)
        
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        getPlayLists()

        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    //

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playLists.count
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
        
            SVProgressHUD.show()
            let playListKey : String = self.playLists[indexPath.row].key
            let userId = MiaryLoginManager.getUserInfo().uid
            var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)/")
            var STRef = Storage.storage().reference().child("\(userId)/playLists/\(playListKey)/")
            STRef.delete { (error) in
                print(#function)
                print(error)
                
            }
            DBRef.removeValue()
            self.playLists.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            SVProgressHUD.dismiss()
            completionHandler(true)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfiguration
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
