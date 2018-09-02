//
//  MiaryLoginManager.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 26..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FacebookLogin
import FirebaseAuth
import FirebaseCore
import FacebookCore
import FBSDKCoreKit

class MiaryLoginManager{
    
    static func loginFacebook(_ viewContorller : UIViewController){
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile], viewController: viewContorller)
        { (loginResult) in
            switch loginResult {
                
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                print("Logged in!")
                struct MyProfileRequest: GraphRequestProtocol {
                    struct Response: GraphResponseProtocol {
                        var dictonaryValue : Dictionary<String,Any> = ["":""]
                        init(rawResponse: Any?) {
                            // Decode JSON from rawResponse into other properties here.
                            let dataFromServer = rawResponse as! Dictionary<String,Any>
                            dictonaryValue["id"] = dataFromServer["id"] as! String
                            dictonaryValue["name"] = dataFromServer["name"] as! String
                            let userInfo : Dictionary<String,Any> = dataFromServer["picture"] as! Dictionary<String,Any>
                            dictonaryValue["profile_pic"] = (userInfo["data"] as? [String :Any])?["url"]
                        }
                    }
                    
                    var graphPath = "/me"
                    var parameters: [String : Any]? = ["fields": "id, name, email, picture.type(large)"]
                    var accessToken = AccessToken.current
                    
                    var httpMethod: GraphRequestHTTPMethod = .GET
                    var apiVersion: GraphAPIVersion = .defaultVersion
                    
                }
                let connection = GraphRequestConnection()
                connection.add(MyProfileRequest()) { response, result in
                    switch result {
                    case .success(let response):
                        print("Custom Graph Request Succeeded: \(response)")
                        
                        print("My AccessToken is \(AccessToken.current)")
                        print("My facebook id is \(response.dictonaryValue["id"])")
                        print("My name is \(response.dictonaryValue["name"])")
                        print("ProfilePic : \(response.dictonaryValue["profile_pic"])")
                        
                    case .failed(let error):
                        print("Custom Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                self.loginFireBase(viewContorller)
            }
        }
    }
    
    static func getUserInfo() -> User{
        
        return Auth.auth().currentUser!
        
    }
    
    static func loginFireBase(_ viewController : UIViewController){
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        let VC = viewController as! LoginViewController
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if error != nil {
                print("firebase integration failed!!")
                print(error)
            }else {
                print("firebase integration success!")
                print(result)
                print(result?.user.photoURL)
                print(result?.user.displayName)
                VC.moveToFeed()
                
            }
        }
    }
}