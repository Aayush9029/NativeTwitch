//
//  LoginView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.openURL) var openURL
    @Environment(TwitchVM.self) var twitchVM

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96)
                VStack(alignment: .leading) {
                    Text("NativeTwitch")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("By /Aayush9029")
                        .foregroundStyle(.secondary)
                }
            }
            .hSpacing(.leading)

            Group {
                Text("1. Get Device Code")
                    .hSpacing(.leading)
                Text("2. Go to: https://www.twitch.tv/activate")
                    .hSpacing(.leading)
                Text("3. Login and enter the Code")
                    .hSpacing(.leading)
            }
            .padding(6)
            .padding(.horizontal, 8)
            .background(.ultraThinMaterial)
            .font(.headline)
            .clipShape(.rect(cornerRadius: 12))
            Spacer()

            if let deviceCode = twitchVM.deviceCodeInfo {
                Text(deviceCode.userCode)
                    .font(.title.bold())
                    .hSpacing(.center)
                    .padding(12)
                    .background(.secondary.opacity(0.25))
                    .clipShape(.rect(cornerRadius: 6))
                Spacer()
                Button {
                    if let url = URL(string: deviceCode.verificationUri) {
                        openURL(url)
                    }
                } label: {
                    Label("Continue on twitch.tv", systemImage: "safari")
                        .longButton(foreground: .white, background: .twitch, radius: 6)
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    Task {
                        await twitchVM.startDeviceAuthorization()
                    }

                } label: {
                    Label("Start Authorization with Twitch.tv", systemImage: "hands.sparkles")
                        .longButton(foreground: .twitch, background: .white, radius: 6)
                }
                .buttonStyle(.plain)
            }
        }
        .xSpacing(.center)
        .padding()
        .background(
            GenerativePreview(shader: .lightGrid)
                .blur(radius: 128)
        )

        .onAppear {
            Task {
                await twitchVM.login()
            }
        }
    }
}

struct CustomTextField: View {
    let text: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .foregroundStyle(.secondary)
                .font(.caption2)

            ZStack(alignment: .trailing) {
                SecureField(text, text: $value)
                    .lineLimit(1)
                    .cleanTextField()
            }
        }
    }
}

#Preview {
    LoginView()
        .frame(width: 320, height: 360)
        .background(.gray.opacity(0.25))
        .environment(TwitchVM())
}
