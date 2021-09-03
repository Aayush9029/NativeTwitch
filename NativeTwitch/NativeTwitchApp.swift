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
    @State var showingLogs = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(twitchData)
                .frame(width: 300, height: 400)
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
            SettingsView(showingLogs: $showingLogs).background(VisualEffectView(material: NSVisualEffectView.Material.sidebar, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
                .environmentObject(twitchData)
                .frame(width: 300, height: showingLogs ? 500: 270)
            .fixedSize()
        }

    }
}



struct VisualEffectView: NSViewRepresentable
{
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}
