//
//  NativeTwitchApp.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

import SwiftUI

@main
struct NativeTwitchApp: App {
    @StateObject var twitchData =  TwitchDataViewModel()
    @StateObject var updater =  AutoUpdater()


    @State var showingLogs = false
    @State var hightLightWarnings = false


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(twitchData)
                .frame(width: 320, height: 420)
                .task {
                    updater.checkForUpdates()
                }
                .onChange(of: updater.status, perform: { newValue in
                    if (updater.status == .yesUpdates){
                    UpdateInfoView(update: updater.updates)
                        .environmentObject(updater)
                        .background(VisualEffectView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
                        .openNewWindow(with: "New Update Available")
                    }
                    twitchData.addToLogs(response: updater.status.rawValue, hidestatus: true)
                })
                .alert(Text("Restart app to finish update"), isPresented: $updater.showingRestartAlert) {
                    HStack{
                        Button("ok"){
                            print("ok")
                        }
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)

        .commands {
            CommandMenu("Actions") {
                VStack{
                    Button("Refresh") {
                        withAnimation {
                            withAnimation {
                                twitchData.startFetch()
                                
                            }
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

