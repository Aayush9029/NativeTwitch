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
                    Text("\(twitchData.userName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .lineLimit(1)
                }
                Spacer()
            }.padding(.bottom)
            VStack(alignment: .leading, spacing: 10) {

                CustomTextField(title: "Client ID", text: $twitchData.clientID, fontSize: .title3)

                Divider()

                CustomTextField(title: "Access Token", text: $twitchData.accessToken, fontSize: .title3)
                Divider()

                Link(
                    destination: URL(string: "https://twitchtokengenerator.com/quick/NIaMdzGYBR")!,
                    label: {
                        Label("Generate Client ID and  Access Token", systemImage: "network")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                )
            }.padding([.bottom])
                .textFieldStyle(.roundedBorder)

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
            .onChange(of: twitchData.accessToken) { newValue in
                if newValue.count == 30 {
                    twitchData.saveAuthData()
                }
            }
    }
}
