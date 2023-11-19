//
//  GradientStyle.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct GradientStyle {
    
    enum Style {
        case red, orange, green
    }
    
    let style: GradientStyle.Style
    
    init(style: GradientStyle.Style) {
        self.style = style
    }
    
    var gradient: LinearGradient {
        switch style {
        case .red: 
            return LinearGradient(stops: stops,
                                  startPoint: UnitPoint(x: 0.5, y: 0),
                                  endPoint: UnitPoint(x: 0.5, y: 1))
        case .orange:
            return LinearGradient(stops: stops,
                                  startPoint: UnitPoint(x: 0.5, y: 0),
                                  endPoint: UnitPoint(x: 0.53, y: 1))
        case .green:
            return LinearGradient(stops: stops,
                                  startPoint: UnitPoint(x: 0.5, y: 1),
                                  endPoint: UnitPoint(x: 0.53, y: -0.02))
        }
    }
    
    private var stops: [Gradient.Stop] {
        switch style {
        case .red: 
            return [
                Gradient.Stop(color: Colors._F54479, location: 0.00),
                Gradient.Stop(color: Colors._9C1D1D, location: 1.00)
            ]
        case .orange:
            return [
                Gradient.Stop(color: Colors._F7BC2C, location: 0.00),
                Gradient.Stop(color: Colors._F48231, location: 1.00)
            ]
        case .green:
            return [
                Gradient.Stop(color: Colors._0BA360, location: 0.00),
                Gradient.Stop(color: Colors._8ABA3C, location: 1.00)
            ]
        }
    }
}
