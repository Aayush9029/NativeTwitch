//
//  LiveBadge.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct LiveBadge: View {
    let viewers: String

    init(_ viewers: String) {
        self.viewers = viewers
    }

    var body: some View {
        HStack {
            Group {
                Image(systemName: "circle.fill")
                    .foregroundStyle(.red)
                    .shadow(color: .red, radius: 4)
            }

            Text(viewers)
                .bold()
        }

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
