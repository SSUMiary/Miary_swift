//
//  MusicSearchViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 14..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class PlayListInFeedViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var tableView : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tablecell = tableView.dequeueReusableCell(withIdentifier: "musicListCell") as! MusicListTableViewCell
        return tablecell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
