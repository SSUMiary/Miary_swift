//
//  TabBarViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 13..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //#bc91ee
        self.tabBar.tintColor = UIColor(red: 0xbc/255.0, green: 0x91/255.0, blue: 0xee/255.0, alpha: 1)
        //button.setTitle("ADD", for: .normal)
        //button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        //#eae8ff
        button.backgroundColor = UIColor(red: 0xea/255.0, green: 0xe8/255.0, blue: 0xff/255.0, alpha: 1)
        //UIColor(red: 0x3B/255.0, green: 0x59/255.0, blue: 0x98/255.0, alpha: 1)
        let image = UIImage(named: "add_active")
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 32
        //button.layer.borderWidth = 4
        //button.layer.borderColor = UIColor.yellow.cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        
    }
    @objc func onButtonTapped(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "addNewFeed")
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        //let height = self.tabBarController?.tabBar.frame.size.height;
        
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 64, width: 64, height: 64)
        //button.frame = CGRect.init(x : self.tabBar.center.x - value, y: self.tabBar.center.y - value, width : value*2, height: value*2)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
