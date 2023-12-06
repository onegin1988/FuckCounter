//
//  FuckCounterApp.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

@main
struct FuckCounterApp: App {
    
    @State private var isShowHome: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isShowHome {
                HomeView()
            } else {
                SplashView()
                    .onFirstAppear {
                        
                        UIFont.familyNames.forEach({ familyName in
                            let fontNames = UIFont.fontNames(forFamilyName: familyName)
                            print(familyName, fontNames)
                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isShowHome = true
                        }
                    }
            }
        }
    }
}
