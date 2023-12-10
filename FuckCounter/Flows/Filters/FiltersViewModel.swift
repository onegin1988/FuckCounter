//
//  FiltersViewModel.swift
//  FuckCounter
//
//  Created by Alex on 08.12.2023.
//

import SwiftUI

class FiltersViewModel: ObservableObject {
    
    @Published var wordsModel: WordsModel
    @Published var list: [WordsModel]
    
    init() {
        self.wordsModel = WordsModel(id: 1, name: "Fuck")
        self.list = [
            WordsModel(id: 1, name: "Fuck"),
            WordsModel(id: 2, name: "Bitch"),
            WordsModel(id: 3, name: "Freak")
        ]
    }
}
