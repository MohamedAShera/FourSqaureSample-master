//
//  Date+Helpers.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation

extension Date {
    init(serverDateUTC: String) {
           self = Formatter.iso8601.date(from: serverDateUTC) ?? Date()
       }
       
       var uiFormatted: String {
           return Formatter.uiFormatter.string(from: self)
       }
       func getCurrentMinute() ->Int {
           let date = Date()
          let calendar = Calendar.current
           let hour = calendar.component(.hour, from: date)
           let minutes = calendar.component(.minute, from: date)
           return minutes
       }
       func getCurrentSecond() ->Int {
           let date = Date()
          let calendar = Calendar.current
           let hour = calendar.component(.hour, from: date)
           let seconds = calendar.component(.second, from: date)
           return seconds
       }
}


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    static let uiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        return formatter
    }()
}
