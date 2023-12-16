//
//  StreamsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct StreamsView: View {
    let streams: [StreamModel]

    init(_ streams: [StreamModel]) {
        self.streams = streams
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(streams) { stream in
                    SingleStreamRow(stream)
                }
            }
            .scrollTargetLayout()
            .padding(8)
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    StreamsView([.xQc, .pokelawls])
        .frame(width: 360, height: 480)
}
