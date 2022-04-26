//
//  StreamActionMenu.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct StreamActionMenu: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var twitchData: TwitchDataViewModel

    let stream: StreamModel

    var body: some View {
        VStack {
            Button("Play \(stream.user_login) \(twitchData.iinaEnabled ? "using iina" : "")") {
                twitchData.watchStream(stream.user_login)
            }
            if twitchData.experimental {
                Button("Play (low latency)") {
                    twitchData.watchLowLatency(stream.user_login)
                }

                Divider()

                Button("Open chat in Safari") {
                    NSWorkspace.shared.open(stream.getChatURL())
                }

            } else {
                Button("Open chat in Safari") {
                    NSWorkspace.shared.open(stream.getChatURL())
                }

                Divider()

                Button("Open twitch.tv/\(stream.user_login)") {
                    NSWorkspace.shared.open(stream.getStreamURL())
                }
            }
        }
    }
}

struct StreamActionMenu_Previews: PreviewProvider {
    static var previews: some View {
        StreamActionMenu(stream: StreamModel.exampleStream)
            .environmentObject(TwitchDataViewModel())
    }
}
