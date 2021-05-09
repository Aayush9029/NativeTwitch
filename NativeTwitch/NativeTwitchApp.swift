//
//  NativeTwitchApp.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

import SwiftUI
import HotKey

@main
struct NativeTwitchApp: App {

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 300, height: 400)
                .fixedSize()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
