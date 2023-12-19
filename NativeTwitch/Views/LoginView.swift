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
        VStack {
            HStack {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96)
                VStack(alignment: .leading) {
                    Text("NativeTwitch")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("Aayush9029/NativeTwitch")
                        .foregroundStyle(.tertiary)
                }
            }
            .hSpacing(.leading)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("👋 Hi Person")
                        .font(.title.bold())
                    Text("I'm genuinely grateful for the opportunity to create valuable tools for amazing individuals like you. Your support, whether through donations, sharing my work, or simply by using it, means everything to me. It enables me to continue doing what I love. Although I can't see all of you (since I don't collect any analytics data), I feel your support in my heart. You might be wondering, 'Why the heck is this guy writing an essay?' Well, I needed to fill this blank space with something, so I thought a thank you note would be fitting. Thank you for inspiring me, Mr. Internet Person.")
                        .foregroundStyle(.secondary)
                    VStack {
                        Button(action: { openURL(Constants.donateLink) }, label: {
                            Text("☕\nBuy me a coffee")
                                .foregroundStyle(.secondary)
                                .padding(4)
                                .hSpacing(.center)
                                .multilineTextAlignment(.center)
                                .background(.green.opacity(0.125))
                                .clipShape(.rect(cornerRadius: 6))
                        })
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .xSpacing(.center)
            .background(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.twitch, lineWidth: 2)
                    .shadow(color: .twitch, radius: 12)
            )
            .clipShape(.rect(cornerRadius: 6))

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
            .clipShape(.rect(cornerRadius: 6))
            Spacer()
            if let deviceCode = twitchVM.deviceCodeInfo {
                Text(deviceCode.userCode)
                    .font(.largeTitle.bold())
                    .hSpacing(.center)
                    .padding()
                    .background(.secondary.opacity(0.125))
                    .clipShape(.rect(cornerRadius: 6))

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
        .frame(width: 320, height: 536)
        .environment(TwitchVM())
}
