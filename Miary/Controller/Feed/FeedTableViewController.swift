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

class FeedTableViewController: UITableViewController,FeedProtocol, UIGestureRecognizerDelegate {
    
    var feeds : [FeedItem] = []
    let presenter = FeedViewPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //downloadFromServer()
        prepareSKCloud()
        
        getAllFeed()
        presenter.delegate = self
        tableView.addSubview(feedRefreshControler)
        let longTabGesture = UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongTabbed))
        longTabGesture.minimumPressDuration = 1.0
        longTabGesture.delegate = self
        longTabGesture.allowableMovement = 15
        tableView.addGestureRecognizer(longTabGesture)
        
    }
    @objc func tableViewLongTabbed(_ longPressGuesture : UILongPressGestureRecognizer){
        
        let touchPoint = longPressGuesture.location(in: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        
        let deleteFeedAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            SVProgressHUD.show()
            FeedManager.instance.deleteFeed(feedKey: self.feeds[indexPath.row].key, completion: {
                self.feeds.remove(at: indexPath.row)
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            })
        }
        
        alertController.addAction(deleteFeedAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
    //protocol
    func updateFeeds(feeds: [FeedItem]) {
        
        self.feeds = feeds
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
        
    }
    
    lazy var feedRefreshControler : UIRefreshControl = {
        
        let refreshControl  = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.swipeToGetFeed), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.blue
        return refreshControl
    }()
    
    
    @objc func swipeToGetFeed(_ refreshControler : UIRefreshControl){
        
        DispatchQueue.main.async {
            self.presenter.updateFeeds()
        }
        refreshControler.endRefreshing()
        
    }
    
    func getAllFeed(){
        
        print(self)
        print(#function + "start")
        SVProgressHUD.show()
        
        if feeds.count == 0{
            
            DispatchQueue.main.async {
                self.presenter.updateFeeds()
            }
        }else {
            self.feeds = FeedManager.instance.getFeeds()
            self.tableView.reloadData()
        }
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
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItem", for: indexPath) as! FeedTableViewCell
        cell.feedImage.image = feeds[indexPath.row].image
        cell.feedTitle.text = feeds[indexPath.row].title
        cell.location.text = feeds[indexPath.row].city
        cell.feedDate.text = feeds[indexPath.row].date
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyBoard.instantiateViewController(withIdentifier: "feedDetailView") as! UINavigationController
        let nextVC = navVC.topViewController as! FeedDetailViewController
        
        nextVC.key = feeds[indexPath.row].key
        nextVC.feedIndex = indexPath.row
        print(#function)
        print(nextVC.feedIndex)
        print(nextVC.key)
        
        self.navigationController?.show(nextVC, sender: self)
        
    }
    
}
