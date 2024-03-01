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
    func loadUsers() async {
        do {
            let snapshot = try await reference.child(AppConstants.cUsers).getData()
            let users = ((snapshot.value as? [String: [String: Any]])?.values)?
                .compactMap({UserModel($0)}) ?? []
            
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
            
            if let userModel = filtered.first {
                self.userModel = userModel
                totalCount = userModel.points
                isChamp = userModel.id == AppData.userLoginModel?.id
            } else {
                userModel = nil
            }
        } catch let error {
            self.error = error.localizedDescription
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
        return ("Play", Images.play, 256)
    }
}
