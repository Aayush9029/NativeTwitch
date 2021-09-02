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
    @State var isHovered = false
    var body: some View {
        VStack{
            Image(systemName: "gear")
                .font(.title2.bold())
                .foregroundColor(color)
                .padding(5)
                .background(isHovered ? color.opacity(0.25) : nil)
                .cornerRadius(5)
        }
        .padding()
        .onHover { _ in
            withAnimation {
                isHovered.toggle()
            }
        }
    }
}

struct CleanButton_Previews: PreviewProvider {
    static var previews: some View {
        CleanButton(image: "gear", color: .blue)
    }
}
