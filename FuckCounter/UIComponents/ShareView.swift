//
//  ShareView.swift
//  FuckCounter
//
//  Created by Alex on 13.12.2023.
//

import SwiftUI
import UIKit

// MARK: - ShareView
struct ShareView: UIViewControllerRepresentable {

    private let items: [Any]
    private let applicationActivities: [UIActivity]?
    private let excludedActivityTypes: [UIActivity.ActivityType]?
    private let onHandler: (() -> Void)?
    
    @Environment(\.presentationMode) var presentationMode

    init(items: [Any], 
         applicationActivities: [UIActivity]? = nil,
         excludedActivityTypes: [UIActivity.ActivityType]? = nil,
         onHandler: (() -> Void)? = nil) {
        self.items = items
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.onHandler = onHandler
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = { activityType, completed, items, error in
            self.presentationMode.wrappedValue.dismiss()
            self.onHandler?()
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - SheetShareView
struct SheetShareView: ViewModifier {
    
    @Binding var showSheet: Bool
    private let items: [Any]
    
    init(showSheet: Binding<Bool>, items: [Any]) {
        self._showSheet = showSheet
        self.items = items
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSheet, content: {
                ShareView(
                    items: items,
                    excludedActivityTypes: [
                        .assignToContact, .print, .copyToPasteboard, .addToReadingList, .markupAsPDF, .openInIBooks
                    ]) {
                        showSheet = false
                    }
            })
    }
}

extension View {
    func sheetShare(showSheet: Binding<Bool>, items: [Any]) -> some View {
        modifier(SheetShareView(showSheet: showSheet, items: items))
    }
}
