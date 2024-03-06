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
    
    var filtersEvent: FiltersEvent?
    
    init() {
        self.wordsModel = AppData.selectedWordsModel
        self.languageModel = AppData.selectedLanguageModel
        self.customWord = AppData.customWord
        self.list = []
        self.isCustom = false
    }
    
    func updateBadWordsList() {
        self.list = [
            WordsModel(id: 1, name: "Fuck"),
            WordsModel(id: 2, name: "Bitch"),
            WordsModel(id: 3, name: "Freak")
        ]
    }
}
