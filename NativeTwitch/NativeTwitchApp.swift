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
    @StateObject var twitchData =  TwitchDataViewModel()
    @State var showingLogs = false
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(twitchData)
                .frame(width: 320, height: 420)
        }
        .windowStyle(.hiddenTitleBar)
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
                    Button("Show Info") {
                        withAnimation {
                            withAnimation {
                                twitchData.showingInfo.toggle()
                            }
                        }
                    }
                    .keyboardShortcut("i", modifiers: .command)
                }
            }
        }
        Settings {
            SettingsView(showingLogs: $showingLogs)
                .environmentObject(twitchData)
                .background(VisualEffectView(material: NSVisualEffectView.Material.sidebar, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
                .frame(width: 320, height: showingLogs ? 650: 400)
            .fixedSize()
        }

    }
}

