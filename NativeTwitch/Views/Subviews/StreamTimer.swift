//
//  StreamTimer.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-16.
//

import SwiftUI

struct StreamTimer: View {
    let date: Date

    init(_ date: Date) {
        self.date = date
    }

    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundStyle(.green)
                .shadow(color: .green, radius: 4)
            Text(date, style: .relative)
        }
        .font(.caption2)
        .padding(6)
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 6))
    }
}

#Preview {
    StreamTimer(.now.addingTimeInterval(-2400))
        .padding()
        .background(.gray.opacity(0.25))
}
