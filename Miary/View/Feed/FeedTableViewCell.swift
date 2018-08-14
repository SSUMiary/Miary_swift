//
//  FeedTableViewCell.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 13..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var feedImage : UIImageView!
    @IBOutlet var feedTitle : UILabel!
    @IBOutlet var feedDate : UILabel!
    @IBOutlet var firstMusicTitle : UILabel!
    @IBOutlet var musicCount : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
