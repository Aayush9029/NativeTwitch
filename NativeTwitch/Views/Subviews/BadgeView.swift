//
//  BadgeView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-16.
//

import SwiftUI

struct BadgeView<Content: View>: View {
    var symbol: String
    var symbolColor: Color
    var content: () -> Content

    init(symbol: String, symbolColor: Color, @ViewBuilder content: @escaping () -> Content) {
        self.symbol = symbol
        self.symbolColor = symbolColor
        self.content = content
    }

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .foregroundStyle(symbolColor)
                .shadow(color: symbolColor.opacity(0.5), radius: 6)
                .symbolVariant(.fill)
            content()
                .bold()
        }
        .font(.caption)
        .padding(6)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview("Badge View") {
    VStack {
        BadgeView(symbol: "circle", symbolColor: .red) {
            Text("10k")
        }
        .padding()
        .background(Color.gray.opacity(0.25))

        BadgeView(symbol: "clock", symbolColor: .red) {
            Text(Date().addingTimeInterval(-2400), style: .relative)
        }
        .padding()
        .background(Color.gray.opacity(0.25))
    }
}
