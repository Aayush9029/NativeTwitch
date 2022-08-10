//
//  View+Extension.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-28.
//

import SwiftUI

extension View {
    private func newWindowInternal(with title: String) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 320),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent  = true
        window.makeKeyAndOrderFront(nil)
        window.level = .floating
        return window
    }

    func openNewWindow(with title: String = "New Window") {
        self.newWindowInternal(with: title).contentView = NSHostingView(rootView: self)
    }
}
