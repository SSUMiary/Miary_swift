//
//  FeedViewPresenter.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 9. 2..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class FeedViewPresenter {
    
    var delegate : FeedProtocol?
    
    func updateFeeds(){
        FeedManager.instance.getAllFeedFromServer(completion: { (result) in
            self.delegate?.updateFeeds(feeds: result)
        })
    }
}
