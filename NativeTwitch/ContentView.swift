//
//  ContentView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-07.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    var body: some View {
        Group {
            if twitchData.status != .streamLoaded {
                Text("Loading Streams")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
            }
            if twitchData.status == .streamLoaded && twitchData.streams.count == 0 {
                Text("All streams are offline :(")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
            } else {
                StreamsView()
                    .environmentObject(twitchData)
            }
        }
    }
}
