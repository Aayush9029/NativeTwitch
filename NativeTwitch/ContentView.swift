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
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Group{
            switch twitchData.status{
            default:
                Text("")
            }
            if twitchData.status != .streamLoaded{
                Text("Loading Streams")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
            }
            if (twitchData.status == .streamLoaded && twitchData.streams.count == 0) {
                Text("All streams are offline :(")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
            }
            else{
                VStack {
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(twitchData.streams, id: \.self) { stream in
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
                                        Button("Open chat in Native Chat"){
                                            
                                            openURL(URL(string: "nativechat://\(stream.user_name)")!) { accepted in
                                                DispatchQueue.main.sync {
                                                    twitchData.isShowingNativeChatAlert = !accepted
                                                }
                                            }
                                        }

                                        Divider()
                                        
                                        Button("Open twitch.tv/\(stream.user_name)"){
                                            NSWorkspace.shared.open(stream.getStreamURL())
                                        }
                                        
                                        Button("Open chat in Safari"){
                                            NSWorkspace.shared.open(stream.getChatURL())
                                        }

                                    }
                                    
                                }))
                        }.padding(.bottom)
                    }
                }
                
                .alert(Text("Native Chat isn't installed"), isPresented: $twitchData.isShowingNativeChatAlert) {
                    HStack{
                        Button("What's Native chat?"){
                            openURL(URL(string: "https://github.com/Aayush9029/NativeChat")!)
                        }
                        Button("Don't care, Didn't ask"){
                            print("OK")
                        }
                    }
                }
            }
        }
    }
}


