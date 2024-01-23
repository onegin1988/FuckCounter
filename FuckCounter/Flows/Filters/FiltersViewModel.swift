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
    
    init() {
        self.wordsModel = AppData.selectedWordsModel
        self.languageModel = AppData.selectedLanguageModel
        self.customWord = ""
        self.list = [
            WordsModel(id: 1, name: "Fuck"),
            WordsModel(id: 2, name: "Bitch"),
            WordsModel(id: 3, name: "Freak"),
            WordsModel(id: 4, name: "Custom", isCustom: true)
        ]
    }
}
