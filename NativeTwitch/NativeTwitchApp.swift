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
    var twitchVM: TwitchVM = .init()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(twitchVM)
                .frame(width: 320, height: 536)

        } label: {
            Image(.menuBarIcon)
        }
        .menuBarExtraStyle(.window)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button("About NativeTwitch") { appDelegate.showAboutPanel() }
            }
            if twitchVM.loggedIn {
                CommandGroup(after: .appInfo) {
                    Button("Log Out") {
                        twitchVM.logout()
                    }
                }
            }
        }

        Settings {
            SettingsView()
                .frame(width: 480, height: 320)
        }
    }
}
