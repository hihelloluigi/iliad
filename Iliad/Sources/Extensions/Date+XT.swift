//
//  Date+XT.swift
//  BikeApp
//
//  Created by Francesco Colleoni on 24/01/17.
//  Copyright © 2017 Mindtek srl. All rights reserved.
//

import Foundation

public enum DateRoundingType {
    case round
    case ceil
    case floor
}

extension Date {
    
    public var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    // MARK: - From String to Date
    public static func from(string: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    // MARK: - From Date to formatted String
    public func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    public func formattedWithCurrentLocale(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    public func dayInWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        
        return dateFormatter.string(from: self)
    }

    public func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    public func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "LLLL"//"LL" to get short style
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: - From Date to String
    public func localizedString(dateWithStyle style: DateFormatter.Style) -> String {
        return localizedString(withDateStyle: style, timeStyle: .none)
    }

    public func localizedString(timeWithStyle style: DateFormatter.Style) -> String {
        return localizedString(withDateStyle: .none, timeStyle: style)
    }
    
    public func localizedString(withDateStyle dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = dateStyle
        
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter.string(from: self)
    }
    
    public func components(_ calendarUnits: [Calendar.Component]) -> [Calendar.Component: Int] {
        var result: [Calendar.Component: Int] = [: ]
            for unit in calendarUnits {
                result[unit] = component(unit)
        }
        return result
    }

    public func adding(seconds: Int, minutes: Int = 0, hours: Int = 0, days: Int = 0, years: Int = 0) -> Date {
        var timeInterval = Double(seconds)
        
        timeInterval += 60 * Double(minutes)
        timeInterval += 60 * 60 * Double(hours)
        timeInterval += 24 * 60 * 60 * Double(days)
        timeInterval += 24 * 60 * 60 * 365 * Double(years)

        return addingTimeInterval(timeInterval)
    }

    public func removing(seconds: Int, minutes: Int = 0, hours: Int = 0, days: Int = 0, years: Int = 0) -> Date {
        var timeInterval = Double(seconds)
        
        timeInterval -= 60 * Double(minutes)
        timeInterval -= 60 * 60 * Double(hours)
        timeInterval -= 24 * 60 * 60 * Double(days)
        timeInterval -= 24 * 60 * 60 * 365 * Double(years)
        
        return addingTimeInterval(timeInterval)
    }

    public func component(_ calendarUnit: Calendar.Component) -> Int {
        return Calendar.current.component(calendarUnit, from: self)
    }
    
    public static func with(calendar: Calendar = .current, units: [Calendar.Component: Int], timeZone: TimeZone = Calendar.current.timeZone) -> Date? {
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            era: units[.era],
                                            year: units[.year],
                                            month: units[.month],
                                            day: units[.day],
                                            hour: units[.hour],
                                            minute: units[.minute],
                                            second: units[.second],
                                            nanosecond: units[.nanosecond],
                                            weekday: units[.weekday],
                                            weekdayOrdinal: units[.weekdayOrdinal],
                                            quarter: units[.quarter],
                                            weekOfMonth: units[.weekOfMonth],
                                            weekOfYear: units[.weekOfYear],
                                            yearForWeekOfYear: units[.yearForWeekOfYear])
        return Calendar.current.date(from: dateComponents)
    }
    
    public func combineDateWithTime(date: Date?, time: Date?) -> Date? {
        guard let date = date, let time = time else {
            return nil
        }
        
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
    
    public func nextHourDate() -> Date? {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.era, .year, .day, .hour], from: self)
        
        repeat {
            guard let date = comps.day, let hour = comps.hour else {
                return nil
            }
            var newHour = hour + 1
            
            if newHour > 23 {
                newHour = 0
                let newDay = date + 1
                comps.day = newDay
            }
            comps.hour = newHour
        } while comps.hour! % 3 != 0

        let newMinute = 0
        comps.minute = newMinute
        
        guard let newDate =  calendar.date(from: comps) else {
            return nil
        }
        return newDate
    }

    public func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }

    public func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }

    private static let dateFormatterUTC: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss 'UTC'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    public var UTC: String {
        return Date.dateFormatterUTC.string(from: self)
    }
}

internal extension Calendar.Component {
    func value(fromDate date: Date) -> Int {
        return date.component(self)
    }
}
