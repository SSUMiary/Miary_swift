//
//  AddFeedTableViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 13..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth

class AddFeedTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectCityDelegate,onPlayListSelectedListener {
  
    
    
    @IBOutlet weak var playListAlbumCover :UIImageView!
    @IBOutlet weak var playListTitle : UILabel!
    
    @IBOutlet weak var citySearchButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var DateFieldText: UITextField!
    @IBOutlet weak var diaryTitle: UITextField!
    @IBOutlet weak var cityName: UITextField!
  
    var datePicker: UIDatePicker{
        get{
            let datePicker = UIDatePicker()
            datePicker.date = Date()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
            
            return datePicker
        }
    }
    
    var accessoryToolbar: UIToolbar{
        get{
            let accessoryToolbar = UIToolbar()
            accessoryToolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTapped))
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            
            accessoryToolbar.items = [flexibleSpace,doneButton]

            return accessoryToolbar
        }
    }
    var playList : PlayListItem = PlayListItem()
    var cityLatitude : Double = 0.0
    var cityLongitude : Double = 0.0
    
    
    @IBOutlet var labels: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
    }
    
    func onPlayListSelected(playList_ : PlayListItem) {
        self.playList = playList_
    }
    
    func setupUI(){
        DateFieldText.inputView = datePicker
        DateFieldText.inputAccessoryView = accessoryToolbar
        DateFieldText.text = Date().mediumDateString
        
    }
    
    @objc func onDateChanged(sender: UIDatePicker){
        DateFieldText.text = sender.date.mediumDateString
    }
    
    @objc func onDoneButtonTapped(sender: UIBarButtonItem){
        if DateFieldText.isFirstResponder{
            DateFieldText.resignFirstResponder()
        }
    }
    
    func onPlayListSelected(playListKey: String) {
        
    }
    
    @objc func tableviewTappedOutFocus(){
        print(#function)
        
        //dateTextField.endEditing(true)
        diaryTitle.endEditing(true)
        cityName.endEditing(true)
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        let newFeed = FeedItem()
    
        newFeed.image = imageView.image!
        newFeed.title = diaryTitle.text!
        newFeed.date = DateFieldText.text!
        newFeed.latitude = "\(cityLatitude)"
        newFeed.longitude = "\(cityLongitude)"
        newFeed.playListKey = playList.key
        newFeed.city = cityName.text!
        
        SVProgressHUD.show()
        FeedManager.instance.makeNewFeed(feedInfo: newFeed) {
            FeedManager.instance.getAllFeedFromServer(completion: { (list) in
                if list.count>0 {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            alertController.addAction(photoLibraryAction)
            present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            
        }
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: imageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: imageView.superview, attribute: .top, multiplier: 1, constant: 0)
        
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: imageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        bottomConstraint.isActive = true
        
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 5
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 5
    //    }
    
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    //
    //
    //
    //        return cell
    //    }
    //
    
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
    @IBAction func citySearch(_ sender: UIButton) {
        
        if cityName != nil{
            
        }
        else
        {
            // performSegue(withIdentifier: "CitySelect", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?){
        if segue.identifier == "CitySelect"{
            let denstinationVC = segue.destination as! UINavigationController
            let destVC = denstinationVC.topViewController as! citySelectViewController
            destVC.delegate = self
        }
        if segue.identifier == "selectPlayList" {
            let nextVC = segue.destination as! PlayListInFeedViewController
            nextVC.delegate = self
            
        }
    }
    func userEnteredCityName(city: String, latitude: Double, longitude: Double){
        print(#function)
        cityLongitude = longitude
        cityLatitude = latitude
        
        cityName.text = city
        
    }
    
}



