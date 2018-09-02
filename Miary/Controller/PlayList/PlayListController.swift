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
    var test : [PlayListItem] = []
    @IBOutlet var tableView : UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        getAllPlayList()
    
//        playListManager.getAllPlayLists { (playList) in
//            DispatchQueue.main.async {
//                self.playLists = playList
//                let list = self.test
//                print(#function)
//                for i in 0..<list.count {
//                    print(list[i])
//                }
//            }
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(self.updatePlayList), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
        
    }()
    
    @objc func updatePlayList(_ refreshControl : UIRefreshControl){
        print(#function)
        print("swipe action started")
        refreshControl.endRefreshing()

        getAllPlayList()
    }
    
    func getAllPlayList(){
        playListManager.getAllPlayLists { (playlist) in
            DispatchQueue.main.async {
                self.playLists = playlist
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onButtonPressed(_ sender: Any){
        
        
        let playListManager = PlayListManager()
        let alertController = UIAlertController(title: "Add new play list", message: "", preferredStyle: .alert)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
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
        SVProgressHUD.show()

        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
            
            
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

            completionHandler(true)
        }
            SVProgressHUD.dismiss()
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "specificPlayList"{
            let nextVC = segue.destination as! UINavigationController
            let topVC = nextVC.topViewController as! SpecificPlayList
            let index = tableView.indexPathForSelectedRow
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            topVC.playListKey = playLists[index!.row].key as! String
            //performSegue(withIdentifier: "specificPlayList", sender: self)
        }
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
