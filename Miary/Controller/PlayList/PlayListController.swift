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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "addSongs")
        self.navigationController?.present(nextVC,animated: true,completion: nil)
        //navigationController?.present(nextVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        playListManager.getPlayLists {[unowned self] (list) in
            DispatchQueue.main.async(execute: {
                self.playLists = list
                self.tableView.reloadData()
            })


        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        guard let playLists = playLists else {return 0}
    //
    //        return playLists.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return playLists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("???")
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicList", for: indexPath) as! PlayListTableViewCell
        let item = playLists[indexPath.row]
        print(item)
        cell.backgroundImage.image = item.coverImage
        cell.date.text = item.date
        cell.playListTitle.text = item.playListTitle
        cell.firstMusicTitle.text = item.firstMusicTitle
        cell.playListCount.text = item.musicCount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
         
            
            //self.playListManager.deletePlatList(playListKey: self.playLists[indexPath.row].key)
           
            SVProgressHUD.show()
            let playListKey = self.playLists[indexPath.row].key
            let userId = MiaryLoginManager.getUserInfo().uid
            var DBRef = Database.database().reference().child("\(userId)/playLists/\(playListKey)")
            var STRef = Storage.storage().reference().child("\(userId)/playLists/\(playListKey)")
            STRef.delete { (error) in
                
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
