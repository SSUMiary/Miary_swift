//
//  FeedItem.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 13..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class FeedItem {
    var key : String
    var image : UIImage
    var title : String
    var firstMusicTitle : String
    var date : String
    var  count: String
    var city :  String
    var latitude : Double
    var longitude : Double
    
    init(key_ : String,image_ : UIImage, title_ : String, firstMusicTitle_ : String, date_ : String, count_:String, city_: String, latitude_: Double , longitude_: Double ) {
        self.key = key_
        self.image = image_
        self.title = title_
        self.firstMusicTitle = firstMusicTitle_
        self.date = date_
        self.count = count_
        self.city = city_
        self.latitude = latitude_
        self.longitude = longitude_
        
    }
    
    convenience init(){
        self.init(key_: "", image_: UIImage(), title_: "", firstMusicTitle_: "", date_: "", count_: "", city_: "" , latitude_: 0, longitude_: 0)
        //self.init(key_ : "", image_ : UIImage(), firstMusicTitle_ : "", date_ : "", count_ : "")
    }
    
}
