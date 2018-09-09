//
//  LoginViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 12..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FacebookLogin
import FirebaseAuth
import FirebaseCore
import FacebookCore
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    
    @IBAction func LoginButtonFacebook(_ sender: UIButton) {
        MiaryLoginManager.instance.loginFacebook(self)
        //MiaryLoginManager.loginFacebook(self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func moveToFeed(){
        performSegue(withIdentifier: "goToFeed", sender: self)
        self.dismiss(animated: true, completion: nil)
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
