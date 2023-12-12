//
//  CleanTextFieldStyle.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct CleanTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .padding(6)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            .font(.title3)
    }
}

extension View {
    func cleanTextField() -> ModifiedContent<Self, CleanTextFieldStyle> {
        return modifier(
            CleanTextFieldStyle()
        )
    }
}
