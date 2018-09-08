//
//  PlayListTableViewCell.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 26..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class PlayListTableViewCell: UITableViewCell {

    @IBOutlet var backgroundImage : UIImageView!
    @IBOutlet var playListTitle : UILabel!
    @IBOutlet var playListCount : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
