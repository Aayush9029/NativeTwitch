//
//  LongButtonModifier.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

// MARK: - LongButtonModifier

struct LongButtonModifier: ViewModifier {
    let foreground: Color
    let background: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .hSpacing(.center)
            .padding(8)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(.rect(cornerRadius: radius))
            .fontWeight(.semibold)
    }
}

extension View {
    func longButton(
        foreground: Color = .primary,
        background: Color = .secondary,
        radius: CGFloat = 8.0
    ) -> ModifiedContent<Self, LongButtonModifier> {
        return modifier(
            LongButtonModifier(
                foreground: foreground,
                background: background,
                radius: radius
            )
        )
    }
}
