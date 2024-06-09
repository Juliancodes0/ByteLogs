//
//  StartingView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI
import UIKit

struct StartingView: View {
    var completion: () -> ()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Welcome to ByteLogs")
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
                
                Button(action: {
                    completion()
                }) {
                    Text("NEXT")
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 30)
                
            }
            .padding()
        }
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    StartingView(completion: {})
}

