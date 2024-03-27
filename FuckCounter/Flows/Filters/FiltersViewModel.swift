//
//  FiltersViewModel.swift
//  FuckCounter
//
//  Created by Alex on 08.12.2023.
//

import SwiftUI

class FiltersViewModel: ObservableObject {
    
    @Published var wordsModel: WordsModel
    @Published var languageModel: LanguageModel
    @Published var list: [WordsModel]
    @Published var customWord: String
    @Published var isCustom: Bool

    var subscriptionInfo: SubscriptionInfo = .firstInfo
    var filtersEvent: FiltersEvent?
    
    init() {
        self.wordsModel = AppData.selectedWordsModel
        self.languageModel = AppData.selectedLanguageModel
        self.customWord = AppData.customWord
        self.list = []
        self.isCustom = false
    }
    
    func updateBadWordsList() {
        list = [
            WordsModel(id: 1,
                       name: "fuck".localize(languageModel.languageCode),
                       nameCorrect: "fuck_title".localize(languageModel.languageCode)),
            WordsModel(id: 2,
                       name: "bitch".localize(languageModel.languageCode),
                       nameCorrect: "bitch_title".localize(languageModel.languageCode)),
            WordsModel(id: 3,
                       name: "freak".localize(languageModel.languageCode),
                       nameCorrect: "freak_title".localize(languageModel.languageCode))
        ]
    }
}
