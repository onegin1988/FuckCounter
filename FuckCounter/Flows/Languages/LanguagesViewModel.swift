//
//  LanguagesViewModel.swift
//  FuckCounter
//
//  Created by Alex on 20.01.2024.
//

import SwiftUI

class LanguagesViewModel: ObservableObject {
    
    @Published var languageModel: LanguageModel
    @Published var list: [LanguageModel]
    
    init() {
        self.languageModel = AppData.selectedLanguageModel
        self.list = [
            LanguageModel(id: 1, name: LanguageCode.en.title, languageCode: LanguageCode.en.rawValue, languageSymbol: LanguageCode.en.languageSymbol),
            LanguageModel(id: 2, name: LanguageCode.de.title, languageCode: LanguageCode.de.rawValue, languageSymbol: LanguageCode.de.languageSymbol),
            LanguageModel(id: 3, name: LanguageCode.fr.title, languageCode: LanguageCode.fr.rawValue, languageSymbol: LanguageCode.fr.languageSymbol),
            LanguageModel(id: 4, name: LanguageCode.uk.title, languageCode: LanguageCode.uk.rawValue, languageSymbol: LanguageCode.uk.languageSymbol),
            LanguageModel(id: 5, name: LanguageCode.ru.title, languageCode: LanguageCode.ru.rawValue, languageSymbol: LanguageCode.ru.languageSymbol)
        ]
    }
}
