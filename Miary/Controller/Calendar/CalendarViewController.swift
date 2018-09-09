//
//  CalendarViewController.swift
//  Miary
//
//  Created by 조병관 on 2018. 9. 2..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation
import UIKit
import VACalendar

class CalendarViewController: UIViewController {
    
  //  @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var weekDaysView: VAWeekDaysView!{
        didSet{
            let appeareance = VAWeekDaysViewAppearance(symbolsType: .short, calendar: defaultCalendar)
            weekDaysView.appearance = appeareance
        }
    }
   
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    var calendarView : VACalendarView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        let startDate = formatter.date(from: "01.01.2015")!
        let endDate = formatter.date(from: "01.01.2021")!
        
        let calendar = VACalendar(
            startDate: startDate,
            endDate: endDate,
            calendar: defaultCalendar
        )
        
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = false
        calendarView.selectionStyle = .single
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .vertical
        
        var arr = FeedManager.instance.getFeeds()
        
        var arrCount = FeedManager.instance.getFeeds().count
        
        var days : [String] = []
        var daysIn : [Date] = []
        
        for i in 0..<arrCount{
            days.append(arr[i].date)

        
        //print("days(arr):" + days)
        
        daysIn.append(ConvertDate.instance.stringToDate(dataFromServer: days[i]))
        print("daysIn")
        print(daysIn)
        daysIn[i] = Date(timeInterval: 9*3600, since: daysIn[i])
        print("daysInTimeInterval")
        print(daysIn)
        
        calendarView.setSupplementaries([(daysIn[i], [VADaySupplementary.bottomDots([.red])])])      //
        }
//        if calendarView == days{
//             calendarView.setSupplementaries([(day, [VADaySupplementary])])
//        }
        
        view.addSubview(calendarView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height - weekDaysView.frame.maxY
            )
            calendarView.setup()
        }
    }
}

extension CalendarViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}


extension CalendarViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension CalendarViewController: VACalendarViewDelegate {
    
    func selectedDate(_ date: Date) {
        print(date)
    }
    
}



