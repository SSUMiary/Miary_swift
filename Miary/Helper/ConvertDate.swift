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
            let replaced = dataFromServer.replacingOccurrences(of: "Jan", with: "01")
            
            forData = replaced
        }
        else if dataFromServer.contains("Feb") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Feb", with: "02")
            
            forData = replaced
        }
        else if dataFromServer.contains("Mar") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Mar", with: "03")
            
            forData = replaced
        }
        else if dataFromServer.contains("Apr") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Apr", with: "04")
            
            forData = replaced
        }
        else if dataFromServer.contains("May") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "May", with: "05")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Jun") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Jun", with: "06")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Jul") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Jul", with: "07")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Aug") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Aug", with: "08")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Sep") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Sep", with: "9")
            forData = replaced
        }
            
        else if dataFromServer.contains("Oct") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Oct", with: "10")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Nov") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Nov", with: "11")
            
            forData = replaced
        }
            
        else if dataFromServer.contains("Dec") == true {
            let replaced = dataFromServer.replacingOccurrences(of: "Dec", with: "12")
            
            forData = replaced
        }
        else{
            forData = dataFromServer
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
