//
//  NativeTwitchApp.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

import SwiftUI

@main
struct NativeTwitchApp: App {
    @State var hightLightWarnings = false
    @StateObject var twitchData =  TwitchData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(twitchData)
                .frame(width: 300, height: 400)
                .fixedSize()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandMenu("Actions") {
                VStack{
                    Button("Refresh") {
                        withAnimation {
                            withAnimation {
                                twitchData.startFetch()                            }
                        }
                    }
                    .keyboardShortcut("r", modifiers: .command)
                    Divider()
                }
            }
        }
        Settings {
            SettingsView(user: twitchData.user)
            .frame(width: 300, height: 200)
            .fixedSize()
        }

    }
}
