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
    
    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        getFeedInfo()
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        prepare()
    }
    
    func prepare(){
        self.title = feedItem.date
        if feedItem.city != "" {
            location.text = feedItem.city
        }
        barButtonStatus = true
        feedTitle.text = feedItem.title
        feedCaption.text = feedItem.caption
        print(feedItem.title)
        feedImage.image = feedItem.image
        feedCaption.isEditable = false
        feedTitle.isEditable = false
        
    }
    func getFeedInfo(){
        feedItem = FeedManager.instance.getSpecificFeedFromManager(index: feedIndex)
        print(#function)
        print(feedItem.playListKey)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func onCancelPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    func updateFeed(){
        feedItem.title = feedTitle.text
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayListInFeed" {
            let navVC = segue.destination as! UINavigationController
            let nextVC = navVC.topViewController as! SpecificPlayList
            nextVC.playListKey = feedItem.playListKey
            print(feedItem.playListKey)
        }
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
