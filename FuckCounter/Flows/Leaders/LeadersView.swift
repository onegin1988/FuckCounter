//
//  LeadersView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct LeadersView: View {
    
    @StateObject var leadersViewModel = LeadersViewModel()
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var googleService: GoogleService
    @EnvironmentObject var appleService: AppleService
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    private let navTitle: String?
    
    var isPushToView: Binding<Bool> {
        Binding(get: { leadersViewModel.leadersEvent != nil },
                set: { _ in leadersViewModel.leadersEvent = nil } )
    }
    
    init(navTitle: String? = nil) {
        self.navTitle = navTitle
    }
    
    var body: some View {
//        NavigationStack {
            ZStack {
                if isAuth {
                    if leadersViewModel.users.isEmpty {
                        makeAddFriendsPlaceholderView()
                            .frame(width: 220)
                    } else {
                        if !leadersViewModel.users.isEmpty {
                            makeLeadersListView()
                        }
                    }
                } else {
                    makeLoginPlaceholderView()
                        .frame(width: 220)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .red,
                                        useBlackOpacity: true))
            .modifier(NavBarModifiers(title: navTitle))
            .ignoresSafeArea()
//        }
        .onFirstAppear {
            Task {
                await leadersViewModel.subscribeObserveUsers()
            }
        }
        .errorSocialServices($leadersViewModel.error)
        .sheetShare(showSheet: $leadersViewModel.showAddUserSheet, items: ["Now your language level. Connect to Fuck Counter"])
        .onReceive(leadersViewModel.$leadersTimeType, perform: { _ in
            Task {
                await leadersViewModel.loadUsers()
            }
        })
        .navigationDestination(isPresented: isPushToView, destination: {
            switch leadersViewModel.leadersEvent {
            case .login:
                LoginView()
            case .none:
                EmptyView()
            }
        })
    }
    
    private var isAuth: Bool {
        return facebookService.isAuth || googleService.isAuth || appleService.isAuth
    }
    
    @ViewBuilder
    private func makeLeadersListView() -> some View {
        VStack {
            segmentView()
            SectionView()
            listView()
        }
        .padding(.top, safeAreaInsets.top + 64)
    }
    
    @ViewBuilder
    private func makeLoginPlaceholderView() -> some View {
        LeadersPlaceholderView(title: "Here you can see your friend’s\nstatistic. Add friends to see it",
                               actionTitle: "Login") {
            leadersViewModel.leadersEvent = .login
        }
    }
    
    @ViewBuilder
    private func makeAddFriendsPlaceholderView() -> some View {
        LeadersPlaceholderView(title: "Here you can see your friend’s\nstatistic. Add friends to see it",
                               actionTitle: "Add friends") {
            leadersViewModel.showAddUserSheet = true
        }
    }
    
    private func segmentView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            SegmentItem(title: LeadersTimeType.daily.title, 
                        isSelected: leadersViewModel.leadersTimeType == .daily)
                .onTapGesture {
                    leadersViewModel.leadersTimeType = .daily
                }
            SegmentItem(title: LeadersTimeType.weekly.title, 
                        isSelected: leadersViewModel.leadersTimeType == .weekly)
                .onTapGesture {
                    leadersViewModel.leadersTimeType = .weekly
                }
            SegmentItem(title: LeadersTimeType.yearly.title, 
                        isSelected: leadersViewModel.leadersTimeType == .yearly)
                .onTapGesture {
                    leadersViewModel.leadersTimeType = .yearly
                }
        }
    }
    
    private func listView() -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array($leadersViewModel
                    .users.enumerated()), id: \.offset) { index, element in
                        ZStack {
                            Rectangle()
                                .fill(myPositionColor(element.wrappedValue))
                                .frame(height: 48)
                            
                            LeadersRow(index: index + 1, userModel: element.wrappedValue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .frame(height: 56)
                    }
            }
        }
    }
    
    private func myPositionColor(_ user: UserModel) -> Color {
        return user.id == AppData.userLoginModel?.id ? Colors._D9D9D9.opacity(0.2) : .clear
    }
}

private extension LeadersView {
    
    // MARK: - SegmentItem
    struct SegmentItem: View {
        
        private let title: String
        private let isSelected: Bool
        
        init(title: String, isSelected: Bool) {
            self.title = title
            self.isSelected = isSelected
        }
        
        var body: some View {
            ZStack {
                BoldTextView(style: .lato, title: title, size: 13, color: isSelected ? .white : .white.opacity(0.5))
                    .frame(height: 20)
                    .padding(.bottom, 4)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(isSelected ? Colors._FFDD64 : .clear)
                            .frame(height: 2)
                            .cornerRadius(2)
                    }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
        }
    }
    
    // MARK: - SectionView
    struct SectionView: View {
        var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: 6, content: {
                    Spacer()
                    Images.crown
                        .frame(width: 24, height: 24)
                    
                    Color.clear
                        .frame(width: 40, height: 24)
                    
                    Images.redState
                        .resizable(resizingMode: .stretch)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 11)
                })
                .padding(.vertical, 2)
            }
        }
    }
    
    // MARK: - LeadersRow
    struct LeadersRow: View {
        
        private let index: Int
        private let userModel: UserModel
        
        init(index: Int, userModel: UserModel) {
            self.index = index
            self.userModel = userModel
        }
        
        var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: 6, content: {
                    BoldTextView(style: .lato, title: "\(index)", size: 13)
                                        
                    ImageView(url: userModel.image ?? "")
                        .frame(width: 40, height: 40)
                        .padding(.leading, 8)
                    
                    RegularTextView(style: .lato, title: userModel.name ?? "", size: 17)
                        .padding(.leading, 2)
                    
                    Spacer()
                    
                    BoldTextView(style: .lato, title: "\(userModel.wins)", size: 15)
                    
                    BoldTextView(style: .lato, title: userModel.points.withCommas(), size: 15)
                        .frame(width: 70, alignment: .trailing)
                })
            }
        }
    }
}

#Preview {
    LeadersView(navTitle: "Leaders")
}
