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
            HStack {
                Spacer()
            }
            if twitchData.status != .streamLoaded {
                VStack {
                    Spacer()
                    ProgressView()
                        .opacity(0.75)
                        .padding(.bottom)

                    Text("Loading Streams")
                        .font(.title)
                        .bold()
                        .foregroundColor(.gray.opacity(0.5))
                }

            }
            if twitchData.status == .streamLoaded && twitchData.streams.count == 0 {
                VStack {
                    Spacer()
                Text("All streams are offline :(")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray.opacity(0.5))
                    Spacer()
                }
            } else {
                StreamsView()
                    .environmentObject(twitchData)
            }
        }
        .padding(.top, 24)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)).ignoresSafeArea()
    }
}
