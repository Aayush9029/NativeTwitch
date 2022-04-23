//
//  NeatButton.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-28.
//

import SwiftUI

struct NeatButton: View {
    let title: String
    let symbol: String
    var color: Color = .orange
    @State var isHoverd: Bool = false
    var body: some View {
        Group {
            Label(title, systemImage: symbol)
                .foregroundStyle(color)
            .buttonStyle(.borderless)
            .padding(8)
            .background(isHoverd ? .ultraThickMaterial : .ultraThinMaterial)
            .cornerRadius(8)
            .shadow(color: isHoverd ? color : .clear, radius: 2)
            .padding(0.25)

        }
        .onHover { val in
            isHoverd = val
        }
    }
}

struct NeatButton_Previews: PreviewProvider {
    static var previews: some View {
        NeatButton(title: "Open Reddit", symbol: "globe")
    }
}
