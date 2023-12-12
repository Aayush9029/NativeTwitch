//
//  FluidView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import FluidGradient
import SwiftUI

struct FluidView: View {
    @State var colors: [Color] = []
    @State var highlights: [Color] = []

    @State var speed = 0.5

    let colorPool: [Color] = [.blue, .green, .yellow, .orange, .red, .pink, .purple, .teal, .indigo]

    var body: some View {
        VStack {
            gradient
                .onAppear(perform: setColors)
        }
    }

    func setColors() {
        colors = []
        highlights = []
        for _ in 0...Int.random(in: 5...5) {
            colors.append(colorPool.randomElement()!)
        }
        for _ in 0...Int.random(in: 5...5) {
            highlights.append(colorPool.randomElement()!)
        }
    }

    var gradient: some View {
        FluidGradient(blobs: colors,
                      highlights: highlights,
                      speed: speed)
    }
}

#Preview {
    ZStack {
        FluidView()
    }
}
