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


protocol onPlayListSelectedListener{
    func onPlayListSelected(playList_ : PlayListItem)
}

class PlayListInFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var tableView : UITableView!
    
    var delegate : onPlayListSelectedListener?
    var playLists : [PlayListItem] = []
    let apiClient = ApiClient()
    let playListManager = PlayListManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        PlayListManager.instance.getAllPlayLists { (list) in
            self.playLists = list
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    @IBAction func onNewButtonPreessed(){
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Play list name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            SVProgressHUD.show()
            PlayListManager.instance.makeNewPlayList(playListName: firstTextField.text!, completion: {(playListKey) -> Void in
                SVProgressHUD.dismiss()
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        delegate?.onPlayListSelected(playList_: playLists[indexPath.row])
        print(playLists[indexPath.row].key)
        navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicList", for: indexPath) as! PlayListTableViewCell
        let item = playLists[indexPath.row]
        cell.backgroundImage.image = item.coverImage
        cell.playListTitle.text = item.playListTitle
        //cell.playListCount.text = item.musicCount
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playLists.count
    }
 
}
