//
//  ConvertDate.swift
//  Miary
//
//  Created by 조병관 on 2018. 9. 9..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation

class ConvertDate{
    static let instance = ConvertDate()
    private init(){}
    func stringToDate(dataFromServer : String) -> Date {
        
        var forData : String = "not Converted"
        var FinalData : Date = Date()
        
        
        if dataFromServer.contains("Jan") == true{
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "01", with: "Jan")
            
            
            forData = replaced
        }
        else if dataFromServer.contains("Feb") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "02", with: "Feb")
            
            forData = replaced
        }
        else if dataFromServer.contains("Mar") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "03", with: "Mar")
            
            forData = replaced
        }
        else if dataFromServer.contains("Apr") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "04", with: "Apr")
            
            forData = replaced
        }
        else if dataFromServer.contains("May") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "05", with: "May")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Jun") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "06", with: "Jun")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Jul") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "07", with: "Jul")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Aug") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "08", with: "Aug")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Sep") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Sep", with: "9")
            forData = replaced
        }
            
        else if dataFromServer.contains("Oct") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "10", with: "Oct")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Nov") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "11", with: "Nov")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Dec") == true {
            let replaced = (dataFromServer as NSString).replacingOccurrences(of: "12", with: "Dec")
            
            forData = replaced
        }
        else{
            print("forDate:" + forData)
            forData = dataFromServer
            print("forDate2:" + forData)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd."
            FinalData = formatter.date(from: forData)!
        
            return FinalData
        }
        let dayArr :[String] = forData.components(separatedBy: " ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY"
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let comp  = DateComponents(year : Int(dayArr[2]), month : Int(dayArr[1]), day: Int(dayArr[0]))
        let calendar = Calendar(identifier: .gregorian)
        if var testing = calendar.date(from: comp){
            let timeInteval : TimeInterval = TimeInterval(9*3600)
            testing = Date(timeInterval: 9*3600, since: testing)
            print(#function)
            print(testing)
            FinalData = testing
        }
        
        
        return FinalData
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
