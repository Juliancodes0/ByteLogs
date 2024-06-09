//
//  HideListIndicatorsViewModifier.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct HideListIndicatorsViewModifier: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollIndicators(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func hideScrollBar () -> some View {
      return self
            .modifier(HideListIndicatorsViewModifier())
    }
}
