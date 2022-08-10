//
//  PreferencesView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-23.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    var body: some View {
        TabView {
            GeneralPreferenceView()
                .environmentObject(twitchData)
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            AuthSettingView()
                .tabItem {
                    Label("Auth", systemImage: "key")
                }

            LogsView()
                .environmentObject(twitchData)
                .tabItem {
                    Label("Logs", systemImage: "text.redaction")
                }
        }
        .frame(width: 320, height: 512)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow).ignoresSafeArea())
        .fixedSize()
        .tint(.purple)
    }
}

struct PreferencesView_Preview: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(TwitchDataViewModel())
    }
}
