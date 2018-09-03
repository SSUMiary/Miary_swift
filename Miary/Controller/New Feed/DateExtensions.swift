//
//  DateExtensions.swift
//  Miary
//
//  Created by 조병관 on 2018. 9. 3..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation

extension Date{
    var mediumDateString: String{
        let formatter = DateFormatter()
       formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
