//
//  FeedDetailViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 13..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedDetailViewController: UITableViewController {
    
    
    var key : String = ""
    var feedIndex : Int!
    var feedItem : FeedItem!
    var barButtonStatus : Bool!
    @IBOutlet var feedTitle : UITextView!
    @IBOutlet var feedImage : UIImageView!
    @IBOutlet var feedCaption : UITextView!
    @IBOutlet var barButton : UIBarButtonItem!
    @IBOutlet var location : UILabel!
    @IBOutlet var playListButton : UIButton!
    
    let touchGeusture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        
        location.isUserInteractionEnabled = true
        touchGeusture.addTarget(self, action: #selector(onLocationButtonClicked))
        location.addGestureRecognizer(touchGeusture)
        
        
        
    }
    @objc func onLocationButtonClicked(_ sender : UITapGestureRecognizer){
        if feedItem.city != "" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyBoard.instantiateViewController(withIdentifier: "mapViewInFeed") as! UINavigationController
            let nextVC = navVC.topViewController as! MapViewInFeedViewController
            nextVC.feedItem  = self.feedItem
            self.navigationController?.show(nextVC, sender: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        prepare()
    }
    
    func prepare(){
        
        SVProgressHUD.show()
        DispatchQueue.main.async {
            FeedManager.instance.getSpecificFeedFromServer(feedKey: self.key, completion: { (item) in
                self.feedItem = item
                self.title = self.feedItem.date
                if self.feedItem.city != "" {
                    self.location.text = self.feedItem.city
                }
                self.barButtonStatus = true
                self.feedTitle.text = self.feedItem.title
                self.feedCaption.text = self.feedItem.caption
                
                self.feedImage.image = self.feedItem.image
                self.feedCaption.isEditable = false
                self.feedTitle.isEditable = false
                SVProgressHUD.dismiss()
            })
        }
        
        
    }
    func getFeedInfo(){
        print(#function)
        print(feedIndex)
        feedItem = FeedManager.instance.getSpecificFeedFromManager(index: feedIndex)
        
        print(feedItem.playListKey)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //
    //    @IBAction func onCancelPressed(){
    //        print(#function)
    //        self.dismiss(animated: true, completion: nil)
    //    }
    func updateFeed(){
        feedItem.title = feedTitle.text
        feedItem.caption = feedCaption.text
        SVProgressHUD.show()
        DispatchQueue.main.async {
            FeedManager.instance.updateFeed(feedInfo: self.feedItem) {
                SVProgressHUD.dismiss()
            }
        }
        
    }
    @IBAction func onEditPressed(){
        if barButtonStatus {
            //edit
            barButtonStatus = false
            barButton.title = "Save"
            feedCaption.isEditable = true
            feedTitle.isEditable = true
            
            
        }else {
            barButton.title = "Edit"
            barButtonStatus = true
            feedCaption.isEditable = false
            feedTitle.isEditable = false
            updateFeed()
            //save
        }
    }
    
    @IBAction func onPlayListButtonClicked(){
        if feedItem.playListKey == ""{
            let alertController = UIAlertController(title: "Add new play list", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Play list name"
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                SVProgressHUD.show()
                PlayListManager.instance.makeNewPlayList(playListName: firstTextField.text!, completion: {(playlistKey)-> Void  in
                    self.feedItem.playListKey = playlistKey
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let navVC = storyBoard.instantiateViewController(withIdentifier: "specificPlayList") as! UINavigationController
                    let nextVC = navVC.topViewController as! SpecificPlayList
                    nextVC.playListKey = playlistKey
                    
                    let date = Date()
                    
                    self.updateFeed()
                    self.navigationController?.show(nextVC, sender: self)
                    SVProgressHUD.dismiss()
                })
                //add new playlist
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in })
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyBoard.instantiateViewController(withIdentifier: "specificPlayList") as! UINavigationController
            let nextVC = navVC.topViewController as! SpecificPlayList
            
            nextVC.playListKey = feedItem.playListKey
            self.navigationController?.show(nextVC, sender: self)
            
        }
    }
    
}
