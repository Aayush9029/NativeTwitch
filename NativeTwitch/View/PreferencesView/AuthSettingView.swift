//
//  AuthSettingView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-23.
//

import SwiftUI

struct AuthSettingView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(twitchData.user.name)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .lineLimit(1)
                }
                Spacer()
            }.padding(.bottom)
            VStack(alignment: .leading, spacing: 10) {
                Text("Client ID")
                    .foregroundStyle(.secondary)
                TextField("Your Twitch Client ID", text: $twitchData.twitchClientID)
                    .font(.title3)

                Text("Access Token")
                    .foregroundStyle(.secondary)
                TextField("Your Twitch Access Token", text: $twitchData.oauthToken)
                    .font(.title3)

                Link(
                    destination: URL(string: "https://twitchtokengenerator.com/quick/NIaMdzGYBR")!,
                    label: {
                        Label("Generate Client ID and  Access Token", systemImage: "network")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                )
                Divider()
            }.padding([.bottom])
                .textFieldStyle(.roundedBorder)

            VStack {
                if twitchData.oauthToken.count == 30 {
                    HStack {
                        Spacer()
                        Text("Press Command + R to save")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            Spacer()
            Group {
                if twitchData.experimental {
                    Text("Version.json")
                        .foregroundStyle(.secondary)
                    TextField("Used for development purposes only", text: $twitchData.remoteUpdateJson)
                        .font(.title3)

                }
            }

        }.padding()
    }
}
