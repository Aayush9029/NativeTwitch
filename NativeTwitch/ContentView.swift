//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

/*
 https://twitchtokengenerator.com/quick/NIaMdzGYBR
 Copy Generate Client ID  and Access Token
 Client ID = Client ID
 Access token = Oauth Key (learnt this the hard way)
 */

import Foundation
import SwiftUI

struct ContentView: View {
    
    @AppStorage(AppStorageStrings.clientID.rawValue) var twitchClientID = ""
    @AppStorage(AppStorageStrings.oauthToken.rawValue) var oauthToken = ""
    @AppStorage(AppStorageStrings.streamlinkLocation.rawValue) var streamlinkLocation = ""
    
    @EnvironmentObject var twitchData: TwitchDataViewModel
    
    @State var streams : [Stream] = []
    
    
    var body: some View{
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
                            StreamRowView(stream: stream, const: Constants(twitchClientID: twitchClientID, oauthToken: oauthToken, streamlinkLocation: streamlinkLocation), stream_logo:  URL(string: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")!)
                                .environmentObject(twitchData)
                                .onTapGesture(count: 2, perform: {
                                    let shell_out = shell("ttvQT () { open -a \"quicktime player\" $(\(streamlinkLocation) twitch.tv/$@ best --stream-url) ;}; ttvQT \(stream.user_name)")
                                    if shell_out.isEmpty{
                                        twitchData.addToLogs(response: "\(streamlinkLocation):🎉 Success 🎉")
                                    }else{
                                        twitchData.addToLogs(response: shell_out)
                                        twitchData.addToLogs(response: "BIG FAIL 😩 @ \(streamlinkLocation)")
                                        twitchData.addToLogs(response: shell("which streamlink"))
                                    }
                                })
                                .contextMenu(ContextMenu(menuItems: {
                                    VStack {
                                        Button("Play"){
                                            let shell_out = shell("ttvQT () { open -a \"quicktime player\" $(\(streamlinkLocation) twitch.tv/$@ best --stream-url) ;}; ttvQT \(stream.user_name)")
                                            if shell_out.isEmpty{
                                                twitchData.addToLogs(response: "\(streamlinkLocation):🎉 Success 🎉")
                                            }else{
                                                twitchData.addToLogs(response: shell_out)
                                                twitchData.addToLogs(response: "BIG FAIL 😩 @ \(streamlinkLocation)")
                                                twitchData.addToLogs(response: shell("which streamlink"))
                                            }
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


extension ContentView{
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
}

extension NSTextField{
    open override var focusRingType: NSFocusRingType{
        get{.none}
        set{}
    }
}
