//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation

extension Date{
    
    public func daysBetween(fromDateTime: Date, toDateTime: Date) -> Int {
        let uintFlag = NSCalendar.Unit.day
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let components : DateComponents = ((calendar as NSCalendar?)?.components(uintFlag, from: fromDateTime, to: toDateTime, options: NSCalendar.Options.init(rawValue: 0)))!
        
        return components.day! + 1
    }
    
    public var startOfMonth: Date {
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return (interval?.start.toLocalTime)! // Without toLocalTime it give last months last date
    }

    public var endOfMonth: Date {
        let interval = Calendar.current.dateInterval(of: .month, for: self)
        return interval!.end
    }
    
    public var toLocalTime: Date {
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    public var firstStatrdWeek: Int{
        NSCalendar.current.component(.weekday, from: self.startOfMonth)
    }
    
    public var days: Int{
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year,  from: self)
        dateComponents.month = Calendar.current.component(.month,  from: self)
        if let d = Calendar.current.date(from: dateComponents),
           let interval = Calendar.current.dateInterval(of: .month, for: d),
           let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day {
            return days
        } else {
            return 0
        }
    }
    
    public var localTime: Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    public var string_yyyyMMdd: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }
    
}
