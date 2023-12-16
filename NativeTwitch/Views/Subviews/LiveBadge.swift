//
//  LiveBadge.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct LiveBadge: View {
    let viewers: String
    @State var animate: Bool = false

    init(_ viewers: String) {
        self.viewers = viewers
        self.animate = animate
    }

    var body: some View {
        HStack {
            Group {
                Image(systemName: "circle.fill")
                    .foregroundStyle(.red.opacity(animate ? 1 : 0.5))
                    .shadow(
                        color: .red,
                        radius: animate ? 2 : 6,
                        x: 0, y: 0
                    )
                    .animation(
                        .easeIn(duration: 3)
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
            }

            Text(viewers)
                .bold()
        }
        .task { animate.toggle() }
        .font(.caption2)
        .padding(6)
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 6))
    }
}

#Preview("Live Badge") {
    LiveBadge("10k")
        .padding()
        .background(.gray.opacity(0.25))
}
