//
//  NativeTwitchApp.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-12.
//

import SwiftUI

@main
struct NativeTwitchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let twitchVM: TwitchVM = .shared

    var body: some Scene {
        MenuBarExtra {
            Group {
                if let streams = twitchVM.streams {
                    ContentView(streams: streams.data)
                } else {
                    LoginView()
                }
            }
            .environment(twitchVM)
            .frame(width: 360, height: 480)

        } label: {
            Image(.menuBarIcon)
        }
        .menuBarExtraStyle(.window)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button("About NativeTwitch") { appDelegate.showAboutPanel() }
            }
        }
    }
}
