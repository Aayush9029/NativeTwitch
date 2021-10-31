//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @AppStorage(AppStorageStrings.clientID.rawValue) var twitchClientID = ""
    @AppStorage(AppStorageStrings.oauthToken.rawValue) var oauthToken = ""
    @AppStorage(AppStorageStrings.streamlinkLocation.rawValue) var streamlinkLocation = ""
    
    @EnvironmentObject var twitchData: TwitchDataViewModel
    
    @State var streams : [Stream] = []
    
    
    var body: some View {
        Group{
            if twitchData.status != .streamLoaded{
                Text("Loading Streams")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
            }
            if (twitchData.status == .streamLoaded && twitchData.getStreamData().count == 0) {
                Text("All streams are offline :(")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
            }
            else{
                VStack {
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(twitchData.getStreamData(), id: \.self) { stream in
                            StreamRowView(stream: stream, const: Constants(twitchClientID: twitchClientID, oauthToken: oauthToken, streamlinkLocation: streamlinkLocation))
                                .environmentObject(twitchData)
                                .onTapGesture(count: 2, perform: {
                                    twitchData.watchStream(streamLinkLocation: streamlinkLocation, streamerUsername: stream.user_name)
                                })
                                .contextMenu(ContextMenu(menuItems: {
                                    VStack {
                                        Button("Play \(twitchData.iinaEnabled ? "using iina" : "")"){
                                            twitchData.watchStream(streamLinkLocation: streamlinkLocation, streamerUsername: stream.user_name)
                                        }
                                        Divider()
                                        Button("Open chat"){
                                            NSWorkspace.shared.open(stream.getChatURL())
                                        }

                                        Divider()
                                        Button("Open twitch.tv/\(stream.user_name)"){
                                            NSWorkspace.shared.open(stream.getStreamURL())
                                        }
                                    }
                                    
                                }))
                        }
                    }
                }
            }
        }
    }
}


