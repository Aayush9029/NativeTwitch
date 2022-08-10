//
//  BottomBarView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var twitchDataViewModel: TwitchDataViewModel

    var body: some View {
        HStack {
            Group {
                Button {
                    if twitchDataViewModel.settingsShown { return }
                    twitchDataViewModel.settingsShown.toggle()
                    PreferencesView()
                        .onDisappear(perform: {
                            twitchDataViewModel.settingsShown.toggle()
                        })
                        .environmentObject(twitchDataViewModel)
                        .openNewWindow(with: "NativeTwitch Preferences")

                } label: {
                    BottomBarButton(title: "Prefrences", icon: "gear")
                }
                .buttonStyle(.borderless)
                .keyboardShortcut(",", modifiers: .command)
            }
            Group {
                Button {
                    withAnimation {
                        twitchDataViewModel.fetchStreams()
                    }
                } label: {
                    BottomBarButton(title: "Refresh", icon: "arrow.counterclockwise", color: .blue)
                }
                .buttonStyle(.borderless)
                .keyboardShortcut("r", modifiers: .command)

            }

            Group {
                Button {
                    NSApplication.shared.terminate(self)
                } label: {
                    BottomBarButton(title: "Quit", icon: "power", color: .red)
                }
                .buttonStyle(.borderless)
                .keyboardShortcut("q", modifiers: .command)

            }

        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
            .labelStyle(.iconOnly)
            .frame(width: 320, height: 400)
            .environmentObject(TwitchDataViewModel())
            .padding()
    }
}

struct BottomBarButton: View {
    let title: String
    let icon: String
    var color: Color = .secondary

    @State private var hovered: Bool = false
    var body: some View {
        HStack {
            Spacer()
            Label(title, systemImage: icon)
            Spacer()
        }
        .foregroundColor(hovered ? .white : color)
        .padding(4)
        .background(color.opacity(hovered ? 0.5 : 0.125))
        .cornerRadius(4)
        .shadow(color: color.opacity(0.5), radius: 6, x: 0, y: 0)
        .onHover { hovering in
            withAnimation {
                hovered = hovering
            }

        }
    }
}
