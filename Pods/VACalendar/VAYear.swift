//
//  VAYear.swift
//  Alamofire
//
//  Created by 조병관 on 2018. 9. 2..
//

import Foundation

class VAYear {
    
    var months = [VAMonth]()
    let lastYear: Date
    let date: Date
    
    var isCurrend: Bool{
        return Calendar.isdate(date, equalTo: Date(), toGranularity: .year)
    }
    
    var numberOfMonths: Int{
        return months.count
    }
}
