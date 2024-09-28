//
//  StartingView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI
import UIKit

struct StartingView: View {
    @State var buttonTapped: Bool = false
    var completion: () -> ()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Welcome to ByteLogs")
                    .padding()
                    .glass(cornerRadius: 10)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Spacer()
                
                Text("A simple app to track your food intake.")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.4)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                nextButton
            }
            .environment(\.colorScheme, .light)
        }
    }
}


extension StartingView {
    var nextButton: some View {
        Button {
            completion()
            withAnimation(.spring(.smooth)) {
                buttonTapped = true
            }
        } label: {
            Text("NEXT")
                .padding(buttonTapped ? 15 : 20)
                .glass(cornerRadius: 10)
                .shadow(radius: 5)
                .foregroundStyle(Color.white)
                .bold()
        }
    }
}




#Preview {
    StartingView(completion: {})
}
