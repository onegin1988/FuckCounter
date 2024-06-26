//
//  Date+Extensions.swift
//  SwearCounter
//
//  Created by Alex on 13.02.2024.
//

import Foundation

extension Date {
    
    func toString(format: String = AppConstants.defaultDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func getWeekDays() -> (Date?, Date?) {
        let dateInWeek = Date.createCustomDate()

        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek) - 1
        if let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek) {
            let days = (weekdays.lowerBound ..< weekdays.upperBound)
                .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek) }
            return (days.first, days.last)
        }
        return (dateInWeek, Date.createCustomDate())
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    static func createCustomDate() -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.year = currentDate.get(.year).year
        dateComponents.month = currentDate.get(.month).month
        dateComponents.day = currentDate.get(.day).day
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return calendar.date(from: dateComponents) ?? Date()
    }
}
