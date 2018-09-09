//
//  DiaryContentTableViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 9. 6..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

protocol diaryContentListner {
    func onSaveDiaryContent(title : String, caption : String)
}

class DiaryContentTableViewController: UITableViewController {
    
    @IBOutlet weak var diaryTitle : UITextField!
    @IBOutlet weak var diaryCaption : UITextView!
    
    
    var diaryTitleStr : String!
    var diaryCaptionStr : String!
    
    var delegate : diaryContentListner!
    
    let titleGesture = UITapGestureRecognizer()
    let captionGesture = UITapGestureRecognizer()
    
    
    var isFirstToEditTitle : Bool!
    var isFirstToEditCaption : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        
    }
    
    @objc func clearTitleTextField(){
        if isFirstToEditTitle {
            diaryTitle.text = ""
            
            diaryTitle.removeGestureRecognizer(titleGesture)
        }
    }
    
    @objc func clearCaptionTextField(){
        if isFirstToEditCaption{
            diaryCaption.text = ""
            diaryCaption.removeGestureRecognizer(captionGesture)
        }
    }
    
    func prepare(){
        
        diaryTitle.text = diaryTitleStr
        diaryCaption.text = diaryCaptionStr
        if isFirstToEditTitle {
            titleGesture.addTarget(self, action: #selector(clearTitleTextField))
            diaryTitle.addGestureRecognizer(titleGesture)
        }
        if isFirstToEditCaption {
            captionGesture.addTarget(self, action: #selector(clearCaptionTextField))
            diaryCaption.addGestureRecognizer(captionGesture)
        }
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        delegate?.onSaveDiaryContent(title: diaryTitle.text!, caption: diaryCaption.text!)
    }
    
}
