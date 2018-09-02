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

class AddFeedTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectCityDelegate {
    
    
    
    
    @IBOutlet weak var citySearchButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstMusicTitle: UITextField!
    @IBOutlet weak var playListCount: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var playListTextField: UITextField!
    @IBOutlet weak var cityName: UITextField!
    
    
    
    @IBOutlet var labels: [UILabel]!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func tableviewTappedOutFocus(){
        print(#function)
        firstMusicTitle.endEditing(true)
        playListCount.endEditing(true)
        dateTextField.endEditing(true)
        playListTextField.endEditing(true)
        cityName.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        let userId = Auth.auth().currentUser!.uid
        print("onSaveButtonPressed")
        print(userId)
        var DBRef = Database.database().reference().child("/\(userId)/feed/")
        var STRef = Storage.storage().reference().child("/\(userId)/feed/")
        let key = DBRef.childByAutoId().key
        STRef = STRef.child(key)
        
        if imageView.image != nil {
            let data = UIImageJPEGRepresentation(imageView.image!, 0.01)
            STRef.putData(data!).observe(.success) { (snapshot) in
                if snapshot.error != nil {
                    
                    SVProgressHUD.dismiss()
                    let alertController = UIAlertController(title: "", message: "upload failed", preferredStyle: .alert)
                    let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alert)
                    self.present(alertController, animated: true, completion: nil)
                    print(snapshot.error)
                }else {
                    
                    STRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("downloadError!!!")
                            print(error)
                            SVProgressHUD.dismiss()
                            
                            let alertController = UIAlertController(title: "", message: "download url error", preferredStyle: .alert)
                            let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alert)
                            self.present(alertController, animated: true, completion: nil)
                        }else {
                            SVProgressHUD.dismiss()
                            print(url?.absoluteString)
                            
                            DBRef = DBRef.child(key)
                            let dataDic : [String: AnyObject] =
                                ["user" : userId as AnyObject ,
                                 "imageUrl" : url?.absoluteString as AnyObject,
                                 "title" : self.playListTextField.text as AnyObject,
                                 "date": self.dateTextField.text as AnyObject,
                                 "count" : self.playListCount.text as AnyObject,
                                 "firstMusicTitle" : self.firstMusicTitle.text as AnyObject,
                                 "cityName": self.cityName.text as AnyObject]
                            DBRef.setValue(dataDic)
                            let alertController = UIAlertController(title: "", message: "upload success", preferredStyle: .alert)
                            let alert = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            })
                            //let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alert)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    })
                    
                    
                }
            }
        }
        
        
    }
    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonPressed(_ sender: UIBarButtonItem) {
        
//                SVProgressHUD.show()
//                let userId = Auth.auth().currentUser!.uid
//                print("onSaveButtonPressed")
//                print(userId)
//                var DBRef = Database.database().reference().child("/\(userId)/feed/")
//                var STRef = Storage.storage().reference().child("/\(userId)/feed/")
//                let key = DBRef.childByAutoId().key
//                STRef = STRef.child(key)
//
//                if imageView.image != nil {
//                    let data = UIImageJPEGRepresentation(imageView.image!, 0.01)
//                    STRef.putData(data!).observe(.success) { (snapshot) in
//                        if snapshot.error != nil {
//
//                            SVProgressHUD.dismiss()
//                            let alertController = UIAlertController(title: "", message: "upload failed", preferredStyle: .alert)
//                            let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
//                            alertController.addAction(alert)
//                            self.present(alertController, animated: true, completion: nil)
//                            print(snapshot.error)
//                        }else {
//
//                            STRef.downloadURL(completion: { (url, error) in
//                                if error != nil {
//                                    print("downloadError!!!")
//                                    print(error)
//                                    SVProgressHUD.dismiss()
//
//                                    let alertController = UIAlertController(title: "", message: "download url error", preferredStyle: .alert)
//                                    let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                    alertController.addAction(alert)
//                                    self.present(alertController, animated: true, completion: nil)
//                                }else {
//                                    SVProgressHUD.dismiss()
//                                    print(url?.absoluteString)
//
//                                    DBRef = DBRef.child(key)
//                                    let dataDic : [String: AnyObject] =
//                                        ["user" : userId as AnyObject ,
//                                         "imageUrl" : url?.absoluteString as AnyObject,
//                                         "title" : self.playListTextField.text as AnyObject,
//                                         "date": self.dateTextField.text as AnyObject,
//                                         "count" : self.playListCount.text as AnyObject,
//                                         "firstMusicTitle" : self.firstMusicTitle.text as AnyObject,
//                                            "cityName": self.cityName.text as AnyObject]
//                                    DBRef.setValue(dataDic)
//                                    let alertController = UIAlertController(title: "", message: "upload success", preferredStyle: .alert)
//                                    let alert = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                                        self.dismiss(animated: true, completion: nil)
//                                    })
//                                    //let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                    alertController.addAction(alert)
//                                    self.present(alertController, animated: true, completion: nil)
//                                }
//
//                            })
//
//
//                        }
//                    }
//                }
//
//
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
        
        // Do any additional setup after loading the view.
        if cityName != nil{
            
        }
        else
        {
            performSegue(withIdentifier: "CitySelect", sender: self)
            
        }
        //ctrl + I
    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?){
        if segue.identifier == "SelectCity"{
            let denstinationVC = segue.destination as! UINavigationController
            let destVC = denstinationVC.topViewController as! citySelectViewController
            destVC.delegate = self
        }
    
    }
    func userEnteredCityName(city: String, latitude: Double, longitude: Double){
        print(#function)
        print(city)
        print(latitude)
        print(longitude)
        
        cityName.text = city
        
    }
    
}



