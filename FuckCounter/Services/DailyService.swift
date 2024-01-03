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
        if Date() > (AppData.dailyKey?.endDate ?? Date()) {
            AppData.dailyKey = DailyModel()
        }
        
        appendTimeInterval()
        
        calculateTimeIntervals()
    }
    
    func appendTimeInterval() {
        AppData.dailyKey?.times.append(TimeModel())
    }
    
    func updateTimeInterval() {
        guard let lastTime = AppData.dailyKey?.times.last,
              let index = AppData.dailyKey?.times.firstIndex(where: {$0.id == lastTime.id}) else { return }
        
        if !lastTime.isUpdate {
            AppData.dailyKey?.times[index].endDate = Date()
            AppData.dailyKey?.times[index].isUpdate = true
        }
    }
    
    func calculateTimeIntervals() {
        guard let times = AppData.dailyKey?.times else { return }
        var count = 0
        
        for time in times where time.isUpdate == true {
            count += Int(time.endDate.timeIntervalSince(time.startDate))
        }
        
        timeSlice = count
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
//        if days > 0 {  return "\(days)d" }
        if hours > 0 && minutes > 0 { return "\(hours):\(minutes)h" }
        if hours > 0 { return "\(hours)h" }
        
        if minutes > 0 { return "\(minutes)min" }
        return "\(seconds)sec"
    }
}
