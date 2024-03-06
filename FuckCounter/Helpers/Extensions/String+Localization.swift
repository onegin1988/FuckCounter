//
//  String+Localization.swift
//  FuckCounter
//
//  Created by Alex on 06.03.2024.
//

import Foundation

extension String {
    
    func localize(_ languageCode: String) -> String {
        guard 
            let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
            let bundle = Bundle(path: path) 
        else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
