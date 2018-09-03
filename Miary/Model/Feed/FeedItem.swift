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
    var date : String
    var count: String
    var city :  String
    var latitude : Double
    var longitude : Double
    var playListKey : String
    init(key_ : String,image_ : UIImage, title_ : String, date_ : String, count_:String, city_: String, latitude_: Double , longitude_: Double, playListKey_ : String ) {
        self.key = key_
        self.image = image_
        self.title = title_
        self.date = date_
        self.count = count_
        self.city = city_
        self.latitude = latitude_
        self.longitude = longitude_
        self.playListKey = playListKey_
    }
    
    convenience init(){
        self.init(key_: "", image_: UIImage(), title_: "", date_: "", count_: "", city_: "" , latitude_: 0, longitude_: 0, playListKey_ : "")
    }
    
}
