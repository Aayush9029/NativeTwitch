//
//  ContentView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var twitchDataViewModel = TwitchDataViewModel()
    @StateObject var updater = AutoUpdater()

    private let appearNotification = Constants.popupAppearNotification

    var body: some View {
        Group {
            if twitchDataViewModel.showAddAuthView {
                AddAuthView()
                    .environmentObject(twitchDataViewModel)
            } else {
                Group {
                    if twitchDataViewModel.currentStatus == .streamsLoading {
                        LoadingStreamView()
                    } else if twitchDataViewModel.streams.isEmpty {
                        EmptyStreamView()
                    } else {
                        StreamsView()
                            .environmentObject(twitchDataViewModel)
                    }
                }
            }
            BottomBarView()
                .environmentObject(twitchDataViewModel)
            .padding()
        }
        .labelStyle(.iconOnly)
        .frame(width: 360, height: 400)
        .onAppear(perform: {
            print("Appear")
            updater.checkForUpdates()

            twitchDataViewModel.fetchStreams()
        })
        .onReceive(appearNotification) { _ in
            print("Got Notification")
            twitchDataViewModel.fetchStreams()
        }
        .onChange(of: updater.status, perform: { _ in
            if updater.status == .yesUpdates {
                UpdateInfoView(update: updater.updates)
                    .environmentObject(updater)
                    .frame(minHeight: 640)
                    .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow).ignoresSafeArea())
                    .openNewWindow(with: "New Update Available")
            }
            twitchDataViewModel.addLog(updater.status.rawValue)
        })
        .alert(Text("Restart app to finish update"), isPresented: $updater.showingRestartAlert) {
            HStack {
                Button("ok") {
                    print("ok")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
