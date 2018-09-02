//
//  SearchMusicViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 26..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class SearchMusicViewController: UIViewController ,UISearchResultsUpdating, UITableViewDelegate,UITableViewDataSource, UINavigationBarDelegate{
    
    //음원 검색 할때 처음 보이는 뷰
    
    var albums : [Resource]?
    let apiClient = ApiClient()
    var playListkey : String!
    
    @IBOutlet var tableView: UITableView!
//    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
//        
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func onSaveButtonPressed(_ sender : UIBarButtonItem){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        prepare()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let albums = albums else {return 0}
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let albums_ = albums
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult") as! MusicListTableViewCell
        cell.musicTitle.text = albums![indexPath.row].attributes?.name
        cell.singerName.text = albums![indexPath.row].attributes?.artistName
        
        if let imageUrl = albums![indexPath.row].attributes?.artwork?.imageURL(width: 80, height: 80){
            apiClient.image(url: imageUrl) { (image) in
                cell.albumImage.image = image
                cell.setNeedsLayout()
            }
        } else {}
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{return}
        if text.count>0 {
            apiClient.search(term: text) { (result) in
                
                print(result)
                self.albums = result.albums
                
                self.tableView.reloadData()
            }
        }else{
            self.albums = nil
            tableView.reloadData()
        }
        
    }
    func prepare(){
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        tableView.tableFooterView = UIView()
        
        //tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumViewController"{
            let vc = segue.destination as! UINavigationController
            let topVC = vc.topViewController as! AlbumViewController
            let index = tableView.indexPathForSelectedRow
            topVC.albumID = albums![index!.row].id!
            topVC.playListKey = playListkey
            
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let album = albums![indexPath.row]
//        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
//        //let topVc = vc.topViewController as! AlbumViewController
//        //topVc.albumID = album.id
//        //topVc.playListKey = playListkey
//        vc.albumID = album.id
//        vc.playListKey = playListkey
//        navigationController?.pushViewController(vc, animated: true)
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
