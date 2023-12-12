//
//  View+Extension.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-28.
//

import SwiftUI

/// Custom View Extensions
extension View {
    /// Custom Spacers
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func xSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}
