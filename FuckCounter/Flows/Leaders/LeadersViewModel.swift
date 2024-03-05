//
//  LeadersViewModel.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import SwiftUI
import Foundation
import FirebaseDatabase

class LeadersViewModel: ObservableObject {
    
    @Published var leadersTimeType: LeadersTimeType
    @Published var users: [UserModel]
    @Published var leadersEvent: LeadersEvent?
    @Published var showAddUserSheet: Bool
    @Published var error: String?
    
    private let reference = Database.database().reference()
    
    init() {
        self.leadersTimeType = .daily
        self.users = []
        self.showAddUserSheet = false
    }
        
    private var fromToDate: (Date, Date) {
        let fromDate = Date().getWeekDays().0?.toString().toDate() ?? Date()
        let toDate = Date().getWeekDays().1?.toString().toDate() ?? Date()
        return (fromDate, toDate)
    }
    
    func subscribeObserveUsers() async {
        reference.child(AppConstants.cUsers).observe(.childChanged) { dataSnapshot in
            Task { @MainActor in
                guard let dict = dataSnapshot.value as? [String: Any] else { return }
                await self.updateUser(dict)
            }
        }
        reference.child(AppConstants.cUsers).observe(.childRemoved) { _ in
            Task {
                await self.loadUsers()
            }
        }
    }
    
    @MainActor
    func loadUsers() async {
        do {
            
            switch leadersTimeType {
            case .daily:
                try await filterDailyLeaders()
            case .weekly:
                try await filterWeeklyLeaders()
            case .yearly:
                try await filterYearlyLeaders()
            }
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    func loadUsersFromServer() async throws -> [UserModel] {
        let snapshot = try await reference.child(AppConstants.cUsers).getData()
        return ((snapshot.value as? [String: [String: Any]])?.values)?
            .compactMap({UserModel($0)}) ?? []
    }
    
    @MainActor
    func updateUser(_ dict: [String: Any]) async {
        
        var user = UserModel(dict)
        switch leadersTimeType {
        case .daily:
            let filterWords = user.words?.filter({$0.createdDate?.toDate().get(.day).day == Date().get(.day).day})
            user.words = filterWords
            user.points = user.reducePoints
        case .weekly:
            let filterWords = user.words?.filter({
                return ($0.createdDate?.toDate() ?? Date()).isBetween(fromToDate.0, and: fromToDate.1)
            })
            user.words = filterWords
            user.points = user.reducePoints
        case .yearly:
            let filterWords = user.words?.filter({$0.createdDate?.toDate().get(.year).year == Date().get(.year).year})
            user.words = filterWords
            user.points = user.reducePoints
        }
        
        if let index = users.firstIndex(where: {$0.id == user.id}) {
            users[index] = user
        } else {
            users.append(user)
        }
        
        users.sort(by: { $0.points >= $1.points })
    }
    
    @MainActor
    private func filterDailyLeaders() async throws {
        var items = try await loadUsersFromServer()
        items.enumerated().forEach { model in
            let filterWords = model.element.words?.filter({$0.createdDate?.toDate().get(.day).day == Date().get(.day).day})
            items[model.offset].words = filterWords
            items[model.offset].points = items[model.offset].reducePoints
        }
        
        items.sort(by: { $0.points >= $1.points })
        self.users = items
    }
    
    @MainActor
    private func filterWeeklyLeaders() async throws {
        var items = try await loadUsersFromServer()
        items.enumerated().forEach { model in
            let filterWords = model.element.words?.filter({
                return ($0.createdDate?.toDate() ?? Date()).isBetween(fromToDate.0, and: fromToDate.1)
            })
            items[model.offset].words = filterWords
            items[model.offset].points = items[model.offset].reducePoints
        }

        items.sort(by: { $0.points >= $1.points })
        self.users = items
    }
    
    @MainActor
    private func filterYearlyLeaders() async throws {
        var items = try await loadUsersFromServer()
        items.enumerated().forEach { model in
            let filterWords = model.element.words?.filter({$0.createdDate?.toDate().get(.year).year == Date().get(.year).year})
            items[model.offset].words = filterWords
            items[model.offset].points = items[model.offset].reducePoints
        }
        
        items.sort(by: { $0.points >= $1.points })
        self.users = items
    }
}
