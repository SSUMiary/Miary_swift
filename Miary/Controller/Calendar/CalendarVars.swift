//
//  CalendarVars.swift
//  Miary
//
//  Created by 조병관 on 2018. 9. 2..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
