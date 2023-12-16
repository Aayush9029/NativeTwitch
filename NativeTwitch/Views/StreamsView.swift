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
            VStack(alignment: .leading) {
                ForEach(streams) { stream in
                    SingleStreamRow(stream)
                }
                .scrollTargetLayout()
            }
            .padding(12)
        }
    }
}

#Preview {
    StreamsView([.xQc, .pokelawls])
}
