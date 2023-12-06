//
//  FontStyle.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

protocol FontType {
    func semibold(size: CGFloat) -> Font
    func bold(size: CGFloat) -> Font
    func regular(size: CGFloat) -> Font
    func medium(size: CGFloat) -> Font
}

enum FontStyle: FontType {
    case gilroy, sfPro
    
    func semibold(size: CGFloat) -> Font {
        switch self {
        case .gilroy: return .custom("Gilroy-SemiBold", size: size)
        case .sfPro: return .custom("SFProDisplay-Semibold", size: size)
        }
    }

    func bold(size: CGFloat) -> Font {
        switch self {
        case .gilroy: return .custom("Gilroy-Bold", size: size)
        case .sfPro: return .custom("SFProDisplay-Bold", size: size)
        }
    }
    
    func regular(size: CGFloat) -> Font {
        switch self {
        case .gilroy: return .custom("Gilroy-Regular", size: size)
        case .sfPro: return .custom("SFProDisplay-Regular", size: size)
        }
    }
        
    func medium(size: CGFloat) -> Font {
        switch self {
        case .gilroy: return .custom("Gilroy-Medium", size: size)
        case .sfPro: return .custom("SFProDisplay-Medium", size: size)
        }
    }
}
