//
//  FeedTableViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 12..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth
import SwiftyJSON
import StoreKit

class FeedTableViewController: UITableViewController {
    
    var feeds : [FeedItem] = []
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //downloadFromServer()
        //prepareSKCloud()
        getAllFeed()
        tableView.addSubview(feedRefreshControler)
        
    }
    
    lazy var feedRefreshControler : UIRefreshControl = {
        
        let refreshControl  = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getAllFeedSelector), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.blue
        return refreshControl
    }()
    //    lazy var refreshControl : UIRefreshControl = {
    //        let refreshControl = UIRefreshControl()
    //
    //        refreshControl.addTarget(self, action: #selector(self.updatePlayList), for: UIControlEvents.valueChanged)
    //        refreshControl.tintColor = UIColor.red
    //        return refreshControl
    //
    //    }()
    
    @objc func getAllFeedSelector(_ refreshControler : UIRefreshControl){
        
//        feedManager.getAllFeed { (list) in
//            DispatchQueue.main.async {
//                self.feeds = list
//                self.tableView.reloadData()
//            }
//        }
        refreshControler.endRefreshing()
        
    }
    
    func getAllFeed(){
//        feedManager.getAllFeed { (list) in
//            DispatchQueue.main.async {
//                self.feeds = list
//                self.tableView.reloadData()
//            }
//        }
        downloadFromServer()
    }
    
    func prepareSKCloud(){
        
        SKCloudServiceController.requestAuthorization { status in
            guard status == .authorized else { return }
            print("Authorization status is authorized")
        }
        
        let skcloudSericeController = SKCloudServiceController()
        let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlpaNDRCOFMzTk0ifQ.eyJpYXQiOjE1MzM5ODI0MTMsImV4cCI6MTU0OTUzNDQxMywiaXNzIjoiODc4OFI4MjY1TCJ9.uhoZnZ1vPJ8WXBJZuywHTWs8RfeOenWAodLsWnFbciND8PPStL_9unJRESvvcr6oeFAHhMJfogPxiTiFTb92pw"
        
        
        skcloudSericeController.requestUserToken(forDeveloperToken: developerToken) { (string, error) in
            
            if error != nil {
                print("error occured")
                print(error)
                
            }else{
                print(string)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feeds.count
    }
    
    
    func downloadFromServer(){
        SVProgressHUD.show()
        
        print("downloadFromServer")
        let userId = Auth.auth().currentUser!.uid
        let DBRef = Database.database().reference().child("\(userId)/feed/")
        let STRef = Database.database().reference().child("\(userId)/feed/")
        let rootRef = Database.database().reference().child("\(userId)/feed")
        
        
        rootRef.observe(.value) { (snapshot) in
            print(snapshot)
            if snapshot.hasChildren() == false {
                SVProgressHUD.dismiss()
            }
        }
        
        
        DBRef.observe(.childAdded) { (snapshot) in
            print("Firebase DB Observe!!")
            let data = snapshot.value as! Dictionary<String,AnyObject>
            if !snapshot.hasChildren() {
                SVProgressHUD.dismiss()
                return
            }
            
            var newFeed = FeedItem()
            do{
                newFeed.key = snapshot.key
                let str = data["imageUrl"] as! String
                
                let imageUrl = URL(string:str)
                
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newFeed.image = UIImage(data: imageData)!
                }catch{
                    
                }
                newFeed.title = data["title"] as! String
                newFeed.date = data["date"] as! String
                newFeed.count = data["count"] as! String
                newFeed.firstMusicTitle = data["firstMusicTitle"] as! String
                //newFeed.city = data["city"] as! String
                self.feeds.append(newFeed)
                
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
            catch{
                SVProgressHUD.dismiss()
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItem", for: indexPath) as! FeedTableViewCell
        cell.feedImage.image = feeds[indexPath.row].image
        cell.feedTitle.text = feeds[indexPath.row].title
        cell.firstMusicTitle.text = feeds[indexPath.row].firstMusicTitle
        cell.feedDate.text = feeds[indexPath.row].date
        cell.musicCount.text = feeds[indexPath.row].count
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "feedDetail"){
            let nextVC = segue.destination as! FeedDetailViewController
            let key = feeds[tableView.indexPathForSelectedRow!.row].key
            nextVC.key = key
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "feedDetail", sender: nil)
        
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
