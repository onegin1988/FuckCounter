//
//  FiltersView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct FiltersView: View {
    
    struct FiltersConstants {
        static let listItemHeight: CGFloat = 64
        static let sectionRadius: CGFloat = 24
        static let buttonHeight: CGFloat = 52
        static let padding: CGFloat = 16
    }
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var speechService: SpeechService
    
    @StateObject var filtersViewModel = FiltersViewModel()
    
    private let navTitle: String?
    @State private var isShow = false
    
    init(navTitle: String? = nil) {
        self.navTitle = navTitle
    }
    
    var body: some View {
        VStack {
            ScrollView {
                listView()
            }
            
            ButtonView(title: "Allow filters", useBG: true, buttonBG: Colors._FFDD64, textColor: .black) {
                
                if filtersViewModel.isCustom {
                    AppData.selectedWordsModel = WordsModel(id: -1, name: filtersViewModel.customWord, nameCorrect: filtersViewModel.customWord, answer: [filtersViewModel.customWord])
                } else {
                    AppData.selectedWordsModel = filtersViewModel.wordsModel
                }
                
                AppData.selectedLanguageModel = filtersViewModel.languageModel
                AppData.customWord = filtersViewModel.customWord
                
                speechService.updateSpeechLocale()
                
                dismiss()
            }
            .frame(height: FiltersConstants.buttonHeight)
            .padding(
                EdgeInsets(
                    top: FiltersConstants.padding,
                    leading: FiltersConstants.padding,
                    bottom: 37,
                    trailing: FiltersConstants.padding)
            )
        }
        .onFirstAppear {
            filtersViewModel.isCustom = filtersViewModel.customWord == filtersViewModel.wordsModel.name
            filtersViewModel.loadWordList()
            filtersViewModel.updateBadWordsList()
        }
        .onReceive(filtersViewModel.$languageModel, perform: { _ in
            filtersViewModel.updateBadWordsList()
        })
        .onChange(of: filtersViewModel.isCustom, perform: { newValue in
            if newValue {
                if filtersViewModel.customWord.isEmpty {
                    filtersViewModel.isCustom = false
                    return
                }
                filtersViewModel.wordsModel = WordsModel(id: -1, name: filtersViewModel.customWord, nameCorrect: filtersViewModel.customWord, answer: [filtersViewModel.customWord])
            }
        })
        .padding(.top, safeAreaInsets.top + FiltersConstants.listItemHeight)
        .toolbarBackground(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(NavBarModifiers(title: navTitle, rightTitle: rightNavItem))
        .modifier(GradientModifiers(style: .red,
                                    useBlackOpacity: true))
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isShow) {
            switch filtersViewModel.filtersEvent {
            case .languages:
                LanguagesView(navTitle: filtersViewModel.filtersEvent?.title)
                    .environmentObject(filtersViewModel)
            case .customWord:
                CustomWordView(wordText: filtersViewModel.customWord, navTitle: filtersViewModel.filtersEvent?.title)
                    .environmentObject(filtersViewModel)
            case .subscription:
                SubscriptionView(subscriptionInfo: filtersViewModel.subscriptionInfo)
            default:
                EmptyView()
            }
        }
    }
    
    private var rightNavItem: (String, () -> Void)? {
        return (filtersViewModel.languageModel.languageSymbol, {
            if AppData.hasPremium {
                filtersViewModel.filtersEvent = .languages
            } else {
                filtersViewModel.subscriptionInfo = .thirdInfo
                filtersViewModel.filtersEvent = .subscription
            }
            isShow.toggle()
        })
    }
    
    private func listView() -> some View {
        LazyVStack(spacing: 0, content: {
            setupWordsSectionView()
            Spacer(minLength: 44)
            
            if filtersViewModel.languageModel.languageCode == LanguageCode.en.rawValue {
                setupCustomWordSectionView()
            }
        })
        .padding(.horizontal, 16)
    }
    
    private func setupWordsSectionView() -> some View {
        Section {
            VStack {
                ForEach(Array(filtersViewModel.list.enumerated()), id: \.offset) { index, element in
                    ListItemCheckView(title: element.nameCorrect,
                                      isChecked: element.id == filtersViewModel.wordsModel.id)
                    .frame(height: FiltersConstants.listItemHeight)
                    .itemTap {
                        filtersViewModel.wordsModel = element
                        filtersViewModel.isCustom = false
                    }
                    .padding(.top, index == 0 ? 10 : 0)
                }
            }
            .background(
                Color.black.opacity(0.2)
            )
            .cornerRadius(FiltersConstants.sectionRadius)
        } header: {
            setupHeaderView("Bad words")
        }
    }
    
    private func setupCustomWordSectionView() -> some View {
        Section {
            ListItemArrowView(title: filtersViewModel.customWord.isEmpty ? "Choose any you want" : filtersViewModel.customWord,
                              useLeftCheckmark: true,
                              selectCheckmark: filtersViewModel.isCustom) {
                if AppData.hasPremium {
                    filtersViewModel.filtersEvent = .customWord
                } else {
                    filtersViewModel.subscriptionInfo = .firstInfo
                    filtersViewModel.filtersEvent = .subscription
                }
                isShow.toggle()
            }
                              .frame(height: FiltersConstants.listItemHeight)
                              .padding(.top, 5)
                              .background(Color.black.opacity(0.2))
                              .onTapGesture {
                                  if AppData.hasPremium {
                                      filtersViewModel.isCustom = true
                                  } else {
                                      filtersViewModel.subscriptionInfo = .firstInfo
                                      filtersViewModel.filtersEvent = .subscription
                                      isShow.toggle()
                                  }
                              }
                              .cornerRadius(FiltersConstants.sectionRadius)
        } header: {
            setupHeaderView("Custom word")
        }
    }
    
    private func setupHeaderView(_ title: String) -> some View {
        SectionHeaderView(title: title)
            .frame(height: 18)
            .padding(.bottom, 8)
    }
}

#Preview {
    FiltersView(navTitle: "Test")
}
