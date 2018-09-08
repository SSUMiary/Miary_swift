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

class AddFeedTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectCityDelegate,onPlayListSelectedListener, diaryContentListner {
    
    @IBOutlet weak var playListAlbumCover :UIImageView!
    @IBOutlet weak var playListTitle : UILabel!
    
    @IBOutlet weak var citySearchButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var DateFieldText: UITextField!
    @IBOutlet weak var diaryTitle: UILabel!
    @IBOutlet weak var diaryCaption : UILabel!
    @IBOutlet weak var cityName: UITextField!
    
    var diaryTitleStr : String!
    var diaryCaptionStr : String!
    
    let titleTouchedGuesture = UITapGestureRecognizer()
    let captionTouchedGuesture = UITapGestureRecognizer()
    
    
    
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
        print(#function)
        print(self.playList.key)
        playListAlbumCover.image = playList_.coverImage
        playListTitle.text = playList_.playListTitle
    }
    @objc func onDiaryTitleTextViewTouched(_ sender : UITapGestureRecognizer){
        print(#function)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyBoard.instantiateViewController(withIdentifier: "editDiary") as! UINavigationController
        let nextVC = navVC.topViewController as! DiaryContentTableViewController
        nextVC.delegate = self
        nextVC.diaryCaptionStr = diaryCaption.text!
        nextVC.diaryTitleStr = diaryTitle.text!
        
        self.navigationController?.show(nextVC, sender: self)
    }
    @objc func onDiaryCaptionTextViewTouched(_ sender : UITapGestureRecognizer){
        print(#function)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyBoard.instantiateViewController(withIdentifier: "editDiary") as! UINavigationController
        let nextVC = navVC.topViewController as! DiaryContentTableViewController
        nextVC.delegate = self
        self.navigationController?.show(nextVC, sender: self)
        nextVC.diaryCaptionStr = diaryCaptionStr
        nextVC.diaryTitleStr = diaryTitleStr
    }
    func setupUI(){
        diaryTitle.isUserInteractionEnabled = true
        diaryCaption.isUserInteractionEnabled = true
        titleTouchedGuesture.addTarget(self, action: #selector(onDiaryTitleTextViewTouched))
        captionTouchedGuesture.addTarget(self, action: #selector(onDiaryCaptionTextViewTouched))
        diaryTitle.addGestureRecognizer(titleTouchedGuesture)
        diaryCaption.addGestureRecognizer(captionTouchedGuesture)
        
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
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        let newFeed = FeedItem()
        
        newFeed.image = imageView.image!
        newFeed.title = diaryTitle.text!
        newFeed.date = DateFieldText.text!
        newFeed.latitude = "\(cityLatitude)"
        newFeed.longitude = "\(cityLongitude)"
        print(#function)
        print(playList.key!)
        newFeed.playListKey = playList.key!
        newFeed.city = cityName.text!
        newFeed.caption = diaryCaption.text!
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
    func onSaveDiaryContent(title: String, caption: String) {
        
        print(#function)
        diaryTitle.text = title
        diaryCaption.text = caption
    }
    
    func userEnteredCityName(city: String, latitude: Double, longitude: Double){
        print(#function)
        cityLongitude = longitude
        cityLatitude = latitude
        
        cityName.text = city
        
    }
    
}



