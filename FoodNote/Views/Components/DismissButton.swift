//
//  DismissButton.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct DismissButton : View {
    var action: ( () -> ())
    var padding: Edge.Set = .trailing
    var paddingAmount: CGFloat = 10
    var alignToRight: Bool = true
    var buttonOpacity: Double = 1
    var body: some View {
        if alignToRight {
            HStack {
                Spacer()
                Button(action: {
                    action()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.red)
                }).opacity(self.buttonOpacity)
            }.padding(padding, paddingAmount)
        }
        else {
            Button(action: {
                action()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.red)
            }).opacity(self.buttonOpacity)
        }
    }
}

