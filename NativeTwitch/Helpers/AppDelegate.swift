//
//  AppDelegate.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-11-15.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var aboutBoxWindowController: NSWindowController?

    func showAboutPanel() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .titled, .fullSizeContentView]
            let window = NSWindow()
            window.styleMask = styleMask
            window.isMovableByWindowBackground = true
            window.backgroundColor = .clear
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.contentView = NSHostingView(rootView: AboutView())
            window.center()
            aboutBoxWindowController = NSWindowController(window: window)
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.prohibited)
    }
}
