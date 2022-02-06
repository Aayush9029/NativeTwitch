//
//  SettingsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppStorageStrings.clientID.rawValue) var twitchClientID = ""
    @AppStorage(AppStorageStrings.oauthToken.rawValue) var oauthToken = ""
    @AppStorage(AppStorageStrings.streamlinkLocation.rawValue) var streamlinkLocation = ""

    @EnvironmentObject var twitchData: TwitchDataViewModel

    @State var logs = [String]()
    @Binding var showingLogs: Bool

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
            }.padding(.vertical)
            VStack(spacing: 10) {
                TextField("Your Twitch Client ID", text: $twitchClientID)

                TextField("Your Twitch Access Token", text: $oauthToken)

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

                TextField("Stream link Location", text: $streamlinkLocation)

                Divider()
                TextField("Custom Update URL", text: $twitchData.remoteUpdateJson)

            }.padding([.bottom])
                .textFieldStyle(.roundedBorder)

            VStack {
                if oauthToken.count < 10 {
                    Text("Press Command + R to save")
                        .foregroundColor(.gray)
                }
            }

            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Use IINA", isOn: $twitchData.iinaEnabled)
                    .font(.title3.bold())
                    .toggleStyle(.switch)
                    .accentColor(.purple)
                Text("Quicktime is used by default but you can use IINA. Install it via brew for optimal results.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Toggle("Experimental Features", isOn: $twitchData.experimental)
                    .font(.title3.bold())
                    .toggleStyle(.switch)
                    .accentColor(.purple)
                Text("Enables Low latency, Native Chat...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Divider()
            VStack(alignment: .leading) {
                HStack {
                    Text("Logs")
                        .font(.title3.bold())
                        .padding(.top, 5)
                    Spacer()

                    NeatButton(title: "Copy", symbol: "paperclip")
                        .onTapGesture {
                            twitchData.copyLogsToClipboard()
                        }
                        .contextMenu {
                            Button("Copy Raw") {
                                twitchData.copyLogsToClipboard(redacted: false)
                            }
                            Button("Copy Redacted") {
                                twitchData.copyLogsToClipboard(redacted: true)
                            }
                        }
                    NeatButton(title: showingLogs ? "Hide" : "Show", symbol: showingLogs ? "chevron.up" : "chevron.down")
                        .onTapGesture {
                            showingLogs.toggle()
                        }
                }
                Spacer()
                Group {
                    if showingLogs {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {

                                ForEach(twitchData.logs, id: \.self) {log in
                                    LogText(text: log, color: .gray)
                                }                                        .id(UUID())

                            }
                        }
                    }
                }

            }
        }
        .padding()
    }
}
