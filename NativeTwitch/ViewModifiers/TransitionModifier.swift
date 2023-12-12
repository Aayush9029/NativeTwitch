//
//  TransitionModifier.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct BlurReplaceTransition: ViewModifier {
    let edge: Edge
    func body(content: Content) -> some View {
        content
            .transition(.move(edge: edge).combined(with: .blurReplace))
    }
}

extension View {
    func blurReplace(edge: Edge = .bottom) -> ModifiedContent<Self, BlurReplaceTransition> {
        return modifier(BlurReplaceTransition(edge: edge))
    }
}
