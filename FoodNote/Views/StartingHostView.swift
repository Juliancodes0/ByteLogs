//
//  ContentView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct StartingHostView: View {
    @State var showStartSheet: Bool = true
    @State var showInfoSheet: Bool = false
    @State var goToHomePge: Bool = false
    let user = UserBasicsManager()
    var body: some View {
        ZStack {
            VStack {
                if showStartSheet {
                    StartingView(completion: {
                        withAnimation {
                            showInfoSheet = true
                            showStartSheet = false
                        }
                    })
                        .transition(.move(edge: .leading))
                } else if showInfoSheet {
                    InfoSheet()
                        .transition(.move(edge: .trailing))
                }
            }
        }.opacity(self.goToHomePge ? 0 : 1)
        .fullScreenCover(isPresented: $goToHomePge, content: {
            HomePgeView(user: self.user)
        })
        .onAppear(perform: {
            switch user.userDidLoadApp() {
            case true:
                self.showStartSheet = false
                self.showInfoSheet = false
                self.goToHomePge = true
            case false:
                self.showInfoSheet = false
            }
        })
        .preferredColorScheme(.light)
    }
}

#Preview {
    StartingHostView()
}
