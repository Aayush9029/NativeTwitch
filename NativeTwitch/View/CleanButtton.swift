//
//  CleanButtton.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI

struct CleanButton: View {
    var image: String
    var color: Color
    var body: some View {
        VStack{
            Image(systemName: "gear")
                .foregroundColor(.white)
                .padding(5)
                .background(color.opacity(0.25))
                .overlay(
                       RoundedRectangle(cornerRadius: 5)
                           .stroke(Color.blue, lineWidth: 2)
                   )
                .cornerRadius(5)
                .shadow(color: .blue, radius: 5, x: 0.0, y: 0.0)
        }
        .padding()
    }
}

struct CleanButton_Previews: PreviewProvider {
    static var previews: some View {
        CleanButton(image: "gear", color: .blue)
    }
}
