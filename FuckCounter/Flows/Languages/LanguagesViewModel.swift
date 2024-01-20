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
            LanguageModel(id: 1, name: "English", languageCode: "en"),
            LanguageModel(id: 2, name: "Deutch", languageCode: "de"),
            LanguageModel(id: 3, name: "France", languageCode: "fr"),
            LanguageModel(id: 4, name: "Ukrainian", languageCode: "uk"),
            LanguageModel(id: 5, name: "Russian", languageCode: "ru")
        ]
    }
}
