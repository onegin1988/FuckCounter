//
//  HomeViewModel.swift
//  FuckCounter
//
//  Created by Alex on 07.12.2023.
//

import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var level: Level
    @Published var counter: Int
    @Published var isPlay: Bool
    @Published var timeSlice: String
    @Published var isShowAppPush: Bool
    @Published var homeEvent: HomeEvent?
    @Published var error: String?
    
    private(set) var userModel: UserModel?
    private(set) var isChamp: Bool
    private(set) var totalCount: Int
    
    private let reference = Database.database().reference()
    private var countForAppPush: Int
    
    init() {
        self.level = .green
        self.counter = 0
        self.isPlay = false
        self.timeSlice = ""
        self.countForAppPush = 0
        self.isShowAppPush = false
        self.isChamp = false
        self.totalCount = 0
    }
    
    func checkLevel() {
        withAnimation {
            switch self.counter {
            case 0...5:
                self.level = .green
            case 6...15:
                self.level = .orange
            case 16...:
                self.level = .red
            default:
                self.level = .green
            }
        }
    }
    
    func resetCounter() {
        counter = 0
        totalCount = 0
        checkLevel()
    }
    
    func updateCountForAppPush() {
        countForAppPush += 1
        if countForAppPush >= 5 {
            withAnimation {
                isShowAppPush = true
            }
        }
    }
    
    func resetCountForAppPush() {
        countForAppPush = 0
        withAnimation {
            isShowAppPush = false
        }
    }
    
    @MainActor
    func subscribeHomeObservers() async {
        reference.child(AppConstants.cUsers).observe(.childChanged) { _ in
            Task {
                await self.loadUsers()
            }
        }
    }
    
    @MainActor
    func checkWinner() async {
        if Calendar.current.isDateInYesterday(AppData.lastDate) {
            AppData.lastDate = Date()
            do {
                let users = try await getUsers()
                var filtered = users.filter { model in
                    (model.words ?? []).contains(where: {
                        ($0.createdDate?.toDate().get(.day).day ?? 0 - 1) == (Date().get(.day).day ?? 0 - 1)
                    })
                }
                filtered.enumerated().forEach { model in
                    let filteredWords = model.element.words?.filter({
                        ($0.createdDate?.toDate().get(.day).day ?? 0 - 1) == (Date().get(.day).day ?? 0 - 1)
                    })
                    filtered[model.offset].words = filteredWords
                    filtered[model.offset].points = filtered[model.offset].reducePoints
                }
                
                filtered.sort(by: {$0.points > $1.points})
                
                if let user = filtered.first, let uid = user.uid {
                    try await reference.child(AppConstants.cUsers).child(uid).updateChildValues(["wins": user.wins + 1])
                }
            } catch let error {
                self.error = error.localizedDescription
            }
        }
    }
    
    private func getUsers() async throws -> [UserModel] {
        let snapshot = try await reference.child(AppConstants.cUsers).getData()
        let users = ((snapshot.value as? [String: [String: Any]])?.values)?
            .compactMap({UserModel($0)}) ?? []
        return users
    }
    
    @MainActor
    func loadUsers() async {
        do {
            let users = try await getUsers()
            
            var filtered = users.filter { model in
                (model.words ?? []).contains(where: {
                    $0.createdDate?.toDate().get(.day).day == Date().get(.day).day
                })
            }
            filtered.enumerated().forEach { model in
                let filteredWords = model.element.words?.filter({
                    $0.createdDate?.toDate().get(.day).day == Date().get(.day).day
                })
                filtered[model.offset].words = filteredWords
                filtered[model.offset].points = filtered[model.offset].reducePoints
            }
            filtered.sort(by: {$0.points > $1.points})
            
            if let userWinModel = filtered.first {
                let myUser = filtered.first(where: {$0.id == AppData.userLoginModel?.id})
                let rate = filtered.firstIndex(where: {$0.id == AppData.userLoginModel?.id}) ?? 0
                self.userModel = myUser
                
                isChamp = rate == 1 && AppData.lastRate != rate && AppData.lastRate != 0
                totalCount = isChamp ? myUser?.points ?? 0 : counter
                AppData.lastRate = rate
            } else {
                userModel = nil
            }
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    func calculateWordProcess(fullText: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            var totalCounter = 0
            for answer in AppData.selectedWordsModel.answer ?? [] {
                let counter = fullText
                    .lowercased()
                    .ranges(of: answer.lowercased())
                    .count
                totalCounter += counter
            }
            DispatchQueue.main.async {
                self.counter = totalCounter
                self.checkLevel()
                AppData.lastCount = totalCounter
            }
        }
    }
    
    @MainActor
    func uploadResults() async {
        do {
            guard let user = Auth.auth().currentUser else { return }
            let id = UUID().uuidString
            try await reference.child(AppConstants.cUsers).child(user.uid).child(AppConstants.cWords).child(id).updateChildValues([
                "createdDate": Date().toString(),
                "countOfWords": counter,
                "id": id
            ])
        } catch let error {
            self.error = error.localizedDescription
        }
    }
    
    var isPlayState: (String, Image, CGFloat) {
        if isPlay {
            return ("Stop", Images.stop, 120)
        }
        return ("Start", Images.play, 256)
    }
}
