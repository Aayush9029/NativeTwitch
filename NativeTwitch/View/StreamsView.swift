//
//  StreamsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-12-26.
//

import SwiftUI

struct StreamsView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    @Environment(\.openURL) var openURL

    @AppStorage(AppStorageStrings.clientID.rawValue) var twitchClientID = ""
    @AppStorage(AppStorageStrings.oauthToken.rawValue) var oauthToken = ""
    @AppStorage(AppStorageStrings.streamlinkLocation.rawValue) var streamlinkLocation = ""
    @AppStorage(AppStorageStrings.streamlinkConfig.rawValue) var streamlinkConfig = ""

    var body: some View {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(twitchData.streams, id: \.self) { stream in
                        StreamRowView(stream: stream, const: Constants(twitchClientID: twitchClientID, oauthToken: oauthToken, streamlinkLocation: streamlinkLocation, streamlinkConfig: streamlinkConfig))
                            .environmentObject(twitchData)
                            .onTapGesture(count: 2, perform: {
                                twitchData.watchStream(stream.user_login)
                            })
                            .contextMenu(ContextMenu(menuItems: {
                                VStack {
                                    Button("Play \(twitchData.iinaEnabled ? "using iina" : "")") {
                                        twitchData.watchStream(stream.user_login)
                                    }
                                    if twitchData.experimental {
                                        Button("Play (low latency)") {
                                            twitchData.watchLowLatencyWithVLC(stream.user_login)
                                        }

                                        Divider()

                                        Button("Open chat in Native Chat") {
                                            openURL(URL(string: "nativechat://\(stream.user_login)")!) { accepted in
                                                DispatchQueue.main.sync {
                                                    twitchData.isShowingNativeChatAlert = !accepted
                                                }
                                            }
                                        }

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

                            }))
                    }.padding(.bottom)
                }
            }
            .alert(Text("Native Chat isn't installed"), isPresented: $twitchData.isShowingNativeChatAlert) {
                HStack {
                    Button("What's Native chat?") {
                        openURL(URL(string: "https://github.com/Aayush9029/NativeChat")!)
                    }
                    Button("Don't care, Didn't ask") {
                        print("OK")
                    }
                }
            }
    }
}

struct StreamsView_Previews: PreviewProvider {
    static var previews: some View {
        StreamsView()
    }
}
