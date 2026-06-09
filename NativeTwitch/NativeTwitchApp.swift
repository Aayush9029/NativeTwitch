//
//  NativeTwitchApp.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-12.
//

import SwiftUI

@main
struct NativeTwitchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var twitchVM = TwitchVM()

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
                Button("About NativeTwitch") { aboutNativeTwitchButtonTapped() }
                    .keyboardShortcut(KeyEquivalent("i"), modifiers: .command)
            }
            CommandGroup(replacing: .systemServices) {
                Button("Hide Application, Maintain Menu Bar") {
                    hideApplicationButtonTapped()
                }
                .keyboardShortcut(KeyEquivalent("q"), modifiers: .option)
            }
            CommandGroup(replacing: .appVisibility) {
                if twitchVM.loggedIn {
                    Button("Log Out") {
                        logOutButtonTapped()
                    }
                    .keyboardShortcut(KeyEquivalent("q"), modifiers: .shift)
                }
            }
        }
    }

    private func aboutNativeTwitchButtonTapped() {
        appDelegate.showAboutPanel()
    }

    private func hideApplicationButtonTapped() {
        twitchVM.showOnlyMenu.toggle()
        NSApp.setActivationPolicy(.prohibited)
    }

    private func logOutButtonTapped() {
        twitchVM.logout()
    }
}
