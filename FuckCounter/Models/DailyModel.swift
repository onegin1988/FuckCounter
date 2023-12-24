//
//  DailyModel.swift
//  FuckCounter
//
//  Created by Alex on 24.12.2023.
//

import Foundation

struct DailyModel: Codable {
    
    let startDate: Date
    var updateDate: Date
    var endDate: Date
    var times: [TimeModel]
    
    init() {
        self.startDate = Date()
        self.updateDate = Date()
        self.endDate = Calendar.current.date(byAdding: .hour, value: 24, to: startDate) ?? Date()
        self.times = []
    }
}

struct TimeModel: Codable {
    
    let startDate: Date
    var endDate: Date
    
    init() {
        self.startDate = Date()
        self.endDate = Date()
    }
}
