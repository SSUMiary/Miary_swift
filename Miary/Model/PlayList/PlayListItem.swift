//
//  PlayListItem.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 26..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class PlayListItem{
    var key : String!
    var playListTitle : String!
    var coverImage : UIImage!
    var musicCount : String!
    var user : String!
    var songs : [SimpleSongModel]!
    //var albums : [Resources]
    //resource 들어가야함
    init(key_ : String, title_ : String, image : UIImage, count : String, user_ : String, songs_ : [SimpleSongModel]){
        key = key_
        playListTitle = title_
        coverImage = image
        musicCount = count
        user = user_
        songs = songs_
    }
    
    convenience init(){
        self.init(key_: "", title_: "", image: UIImage(), count: "", user_: "", songs_: [])
    }
}
