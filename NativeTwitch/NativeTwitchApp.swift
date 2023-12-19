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
                    .keyboardShortcut(KeyEquivalent("i"), modifiers: .command)
            }
            CommandGroup(replacing: .systemServices) {
                Button("Hide Application, Maintain Menu Bar") {
                    twitchVM.showOnlyMenu.toggle()
                    NSApp.setActivationPolicy(.prohibited)
                }
                .keyboardShortcut(KeyEquivalent("q"), modifiers: .option)
            }
            CommandGroup(replacing: .appVisibility) {
                if twitchVM.loggedIn {
                    Button("Log Out") {
                        twitchVM.logout()
                    }
                    .keyboardShortcut(KeyEquivalent("q"), modifiers: .shift)
                }
            }
        }
    }
}
