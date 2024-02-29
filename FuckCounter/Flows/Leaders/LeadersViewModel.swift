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
    @Published var isLoading: Bool
    @Published var error: String?
    
    private let reference = Database.database().reference()
    
    init() {
        self.leadersTimeType = .daily
        self.users = []
        self.showAddUserSheet = false
        self.isLoading = true
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
                self.isLoading = true
                await self.updateUser(dict)
            }
        }
        reference.child(AppConstants.cUsers).observe(.childRemoved) { _ in
            Task {
                self.isLoading = true
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
            
            self.isLoading = false
        } catch let error {
            debugPrint(error.localizedDescription)
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
                let createdDate = $0.createdDate?.toDate() ?? Date()
                return fromToDate.0 <= createdDate && createdDate <= fromToDate.1
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
        
        users.sort(by: { $0.points >= $1.points && $0.wins >= $1.wins })
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    @MainActor
    private func filterDailyLeaders() async throws {
        var items = try await loadUsersFromServer()
        items.enumerated().forEach { model in
            let filterWords = model.element.words?.filter({$0.createdDate?.toDate().get(.day).day == Date().get(.day).day})
            items[model.offset].words = filterWords
            items[model.offset].points = items[model.offset].reducePoints
        }
        
        items.sort(by: { $0.points >= $1.points && $0.wins >= $1.wins })
        self.users = items
    }
    
    @MainActor
    private func filterWeeklyLeaders() async throws {
        var items = try await loadUsersFromServer()
        items.enumerated().forEach { model in
            let filterWords = model.element.words?.filter({
                let createdDate = $0.createdDate?.toDate() ?? Date()
                return fromToDate.0 <= createdDate && createdDate <= fromToDate.1
            })
            items[model.offset].words = filterWords
            items[model.offset].points = items[model.offset].reducePoints
        }

        items.sort(by: { $0.points >= $1.points && $0.wins >= $1.wins })
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
        
        items.sort(by: { $0.points >= $1.points && $0.wins >= $1.wins })
        self.users = items
    }
}
