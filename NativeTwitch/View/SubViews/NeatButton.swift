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
    @State var isHoverd: Bool = false
    var body: some View {
        Group {
            Label(title, systemImage: symbol)
            .buttonStyle(.borderless)
            .padding(8)
            .background(isHoverd ? .ultraThickMaterial : .ultraThinMaterial)
            .cornerRadius(8)
            .shadow(color: isHoverd ? .purple.opacity(0.25) : .clear, radius: 2)

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
