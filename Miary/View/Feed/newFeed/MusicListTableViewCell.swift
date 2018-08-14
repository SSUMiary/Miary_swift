//
//  MusicListTableViewCell.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 14..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class MusicListTableViewCell: UITableViewCell {

    
    @IBOutlet var albumImage : UIImageView!
    @IBOutlet var musicTitle : UILabel!
    @IBOutlet var singerName : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
