//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-12.
//

import SwiftUI

struct ContentView: View {
    @Environment(TwitchVM.self) var twitchVM
    @State private var streams: [StreamModel] = []

    var body: some View {
        Group {
            if twitchVM.loading {
                ProgressView()
            } else if streams.isEmpty {
                NoStreamsView
            } else {
                StreamsView(streams)
            }
        }
        .onKeyboardShortcut(key: "r", modifiers: .command) {
            Task {
                streams = await twitchVM.fetchFollowedStreams()
            }
        }
        .task {
            streams = await twitchVM.fetchFollowedStreams()
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
                    streams = await twitchVM.fetchFollowedStreams()
                }
            }
        }
    }
}

#Preview("Streams View") {
    ContentView()
        .environment(TwitchVM.shared)
        .frame(width: 360, height: 480)
}
