//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-12.
//

import SwiftUI

struct ContentView: View {
    @Environment(TwitchVM.self) var twitchVM
    let streams: [StreamModel]

    var body: some View {
        Group {
            if streams.isEmpty {
                NoStreamsView
            } else {
                StreamsView(streams)
            }
        }
    }

    var NoStreamsView: some View {
        ContentUnavailableView {
            Label("Streamers Offline", systemImage: "person.3.fill")
        } description: {
            Text("Seems like streamers you follow are offline time to follow new ones or touch some grass.")
        } actions: {
            Button("Refresh", systemImage: "arrow.counterclockwise") {
                Task {
                    await twitchVM.fetchFollowedStreams()
                }
            }
        }
    }
}

#Preview("Example Streams View") {
    ContentView(streams: [.xQc, .pokelawls])
        .environment(TwitchVM.shared)
        .frame(width: 360, height: 480)
}

#Preview("Empty Streams View") {
    ContentView(streams: [])
        .environment(TwitchVM.shared)
        .frame(width: 360, height: 480)
}
