//
//  FiltersViewModel.swift
//  FuckCounter
//
//  Created by Alex on 08.12.2023.
//

import SwiftUI

class FiltersViewModel: ObservableObject {
    
    private var fullList: [FullWordsModel]
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
        self.fullList = []
        self.list = []
        self.isCustom = false
    }
    
    func loadWordList() {
        guard let url = Bundle.main.url(forResource: "Words", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([FullWordsModel].self, from: data)
            self.fullList = jsonData
        } catch let error {
            debugPrint(error)
        }
    }
    
    func updateBadWordsList() {
        list = fullList.first(where: {$0.localize == languageModel.languageCode})?.words ?? []
        if let model = list.first(where: {$0.id == wordsModel.id}) {
            wordsModel = model
        } else {
            wordsModel = list.first ?? AppData.selectedWordsModel
        }
    }
}
