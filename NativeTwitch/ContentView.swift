//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

// https://twitchtokengenerator.com/quick/NIaMdzGYBR
import Foundation
import SwiftUI
import HotKey

struct ContentView: View {
    var const = Constants()
    @ObservedObject var twitchData =  TwitchData()
    @State var streams : [Stream] = []
    
    let topBarToggleHotKey = HotKey(key: .comma, modifiers: [.command])
    let refreshData = HotKey(key: .r, modifiers: [.command])

    @State var titleBarShown: Bool = false
    
    var body: some View{
        Group{
            if twitchData.status != .finished{
                Text("Loading Streams")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
                    .onAppear(perform: {
                        
                    })
            }else{
                VStack {
                    ScrollView(.vertical, showsIndicators: false){
                        if titleBarShown{
                            UserView(user: twitchData.user)
                            Divider()
                        }
                        ForEach(twitchData.getStreamData(), id: \.self) { stream in
                            StreamRowView(stream: stream, const: const, stream_logo:  URL(string: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")!)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action: {
                                        print(shell("ttvQT () { open -a \"quicktime player\" $(\(const.streamlinkLocation) twitch.tv/$@ best --stream-url) ;}; ttvQT \(stream.user_name)"))
                                    }, label: {
                                        Text("Play")
                                    })
                                }))
                        }
                        
                    }
                }
            }
        }
        .onAppear(perform: {
            topBarToggleHotKey.keyDownHandler = {
                withAnimation {
                    titleBarShown.toggle()
                }
            }
            refreshData.keyDownHandler = {
                withAnimation {
                    twitchData.startFetch()
                }
            }
        })
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
