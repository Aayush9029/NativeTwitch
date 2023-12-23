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
            if !twitchVM.loggedIn {
                LoginView()
            } else if twitchVM.loading {
                ProgressView()
            } else if twitchVM.streams.isEmpty {
                NoStreamsView
            } else {
                StreamsView(twitchVM.streams)
            }
        }
        .task {
            await twitchVM.fetchFollowedStreams()
        }
        .onKeyboardShortcut(key: "r", modifiers: .command) {
            Task {
                await twitchVM.fetchFollowedStreams()
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

#Preview("Streams View") {
    ContentView()
        .environment(TwitchVM())
        .frame(width: 360, height: 480)
}
