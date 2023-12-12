//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-12.
//

import SwiftUI

struct ContentView: View {
    @Environment(TwitchVM.self) var twitchVM

    var body: some View {
        Group {
            if let streams = twitchVM.streams {
                if streams.data.isEmpty {
                    NoStreamsView
                } else {
                    StreamsView(streams)
                }
            } else {
                LoginView()
            }
        }
        .environment(twitchVM)
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

#Preview {
    ContentView()
        .environment(TwitchVM.shared)
        .frame(width: 300, height: 360)
}
