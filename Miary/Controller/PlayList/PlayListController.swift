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
    
    
    
    var playLists : [PlayListItem] = []
    
    @IBOutlet var tableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllPlayList()
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
        
        self.getPlayListsFromserver()
    }
    
    func getPlayListsFromserver(){
        PlayListManager.instance.getAllPlayLists { (playlist) in
            DispatchQueue.main.async {
                self.playLists = playlist
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getAllPlayList(){
        if playLists.count == 0 {
            SVProgressHUD.show()
            PlayListManager.instance.getAllPlayLists { (playlist) in
                DispatchQueue.main.async {
                    self.playLists = playlist
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }else {
            self.playLists = PlayListManager.instance.getAllPlayListsFromManager()
        }
    }
    
    @IBAction func onButtonPressed(_ sender: Any){
        
        let alertController = UIAlertController(title: "Add new play list", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Play list name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            SVProgressHUD.show()
            PlayListManager.instance.makeNewPlayList(playListName: firstTextField.text!, completion: {(playlistKey)-> Void  in
                SVProgressHUD.dismiss()
            })
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
        cell.playListCount.text = item.musicCount
        cell.playListTitle.text = item.playListTitle
        print(#function)
        print(item.musicCount)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
            
            SVProgressHUD.show()
            PlayListManager.instance.deleteMusicList(playListKey: self.playLists[indexPath.row].key, completion: {
                self.playLists.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                SVProgressHUD.dismiss()
            })
            
            completionHandler(true)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfiguration
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard?.instantiateViewController(withIdentifier: "specificPlayList") as! UINavigationController
        let nextVC = navVC.topViewController as! SpecificPlayList
        nextVC.playListKey = playLists[indexPath.row].key as! String
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.show(nextVC, sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if segue.identifier == "specificPlayList"{
//            let nextVC = segue.destination as! UINavigationController
//            let topVC = nextVC.topViewController as! SpecificPlayList
//            let index = tableView.indexPathForSelectedRow
//            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
//            topVC.playListKey = playLists[index!.row].key as! String
//            //performSegue(withIdentifier: "specificPlayList", sender: self)
//        }
//    }
    
    
    
}
