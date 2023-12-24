//
//  DailyService.swift
//  FuckCounter
//
//  Created by Alex on 24.12.2023.
//

import SwiftUI

class DailyService: ObservableObject {
    
    @Published var timeSlice: Int
    
    init() {
        if AppData.dailyKey == nil {
            AppData.dailyKey = DailyModel()
        }
        self.timeSlice = 0
    }
    
    func calculateDates() {
        AppData.dailyKey?.updateDate = Date()
        
        guard let updateDate = AppData.dailyKey?.updateDate, let startDate = AppData.dailyKey?.startDate else { return }
        timeSlice = Int(updateDate.timeIntervalSince(startDate))
    }
    
    func calculateTimeIntervals() {
        
    }
    
    var totalSlice: Int {
        guard let endDate = AppData.dailyKey?.endDate, let startDate = AppData.dailyKey?.startDate else { return 0 }
        return Int(endDate.timeIntervalSince(startDate))
    }
    
    private var years: Int {
        return timeSlice / 31536000
    }
    
    private var days: Int {
        return (timeSlice % 31536000) / 86400
    }
    
    private var hours: Int {
        return (timeSlice % 86400) / 3600
    }
    
    private var minutes: Int {
        return (timeSlice % 3600) / 60
    }
    
    private var seconds: Int {
        return timeSlice % 60
    }
    
    var hoursMinutesAndSeconds: (hours: Int, minutes: Int, seconds: Int) {
        return (hours, minutes, seconds)
    }
    
    var timeSliceResult: String {
        if days > 0 {  return "\(days)d" }
        if hours > 0 { return "\(hours)h" }
        if minutes > 0 { return "\(minutes)m" }
        return "\(seconds)s"
    }
}
