//
//  AppDelegate.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

// MARK: - Menu Bar and Icon Setup
class AppDelegate: NSObject, ObservableObject, NSApplicationDelegate {

    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()

    private let appearNotification = Constants.popupAppearNotification

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupPopOverMenu()
    }

    func setupPopOverMenu() {
        //        Setting Popover View
        popover.animates = true
        popover.behavior = .transient

        //        Linking SwiftUI View
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: ContentView())

        //        Making it the "Key" window
        popover.contentViewController?.view.window?.makeKey()

        //        Setting width of the icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        //        Setting an icon and attaching show/hide function
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(imageLiteralResourceName: "menu-bar-icon")
            menuButton.action = #selector(menuButtonAction(sender:))
        }
    }

    // MARK: - Show / Hide Function for Popover View
    @objc func menuButtonAction(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let menuButton = statusItem?.button {
                appearNotification.center.post(name: Constants.popupAppearNotification.name, object: nil)
                popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
}
