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
    @State private var showNote = false
    var startedAttempt: Bool {
        return twitchVM.attempts < 2
    }

    var body: some View {
        VStack {
            VStack {
                if startedAttempt {
                    ThankYouNote
                        .blurReplace(edge: .top)
                }
            }.animation(.easeInOut, value: startedAttempt)

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
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(twitchVM.attempts)/\(twitchVM.maxAttempts) polling twitch.tv ")
                        Spacer()

                        Image(systemName: "wifi")
                            .symbolEffect(.variableColor.iterative, isActive: twitchVM.deviceCodeInfo?.userCode != nil)

                    }.foregroundStyle(.secondary)
                    ProgressView(value: Double(twitchVM.attempts / twitchVM.maxAttempts), total: 1.0)
                        .progressViewStyle(.linear)
                        .foregroundStyle(.secondary)
                        .tint(.twitch)
                }

                Text(deviceCode.userCode)
                    .font(.largeTitle.bold())
                    .hSpacing(.center)
                    .padding()

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
                RefreshDeviceAuthorization
            }
        }
        .xSpacing(.center)
        .padding()
        .background(
            GenerativePreview(shader: .lightGrid)
                .blur(radius: 128)
        )
    }

    var RefreshDeviceAuthorization: some View {
        Button {
            Task {
                await twitchVM.startDeviceAuthorization()
            }

        } label: {
            Label("Get Device Code", systemImage: "hands.sparkles")
                .longButton(foreground: .twitch, background: .white, radius: 6)
        }
        .buttonStyle(.plain)
    }

    var ThankYouNote: some View {
        VStack {
            if showNote {
                Group {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Text("👋 Hi Person!")
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
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                Button {
                    showNote.toggle()

                } label: {
                    Label("Read Thank You Note.", systemImage: "heart.fill")
                        .fontWeight(.medium)
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .hSpacing(.center)
                        .padding()
                        .background(
                            GenerativePreview(shader: .animatedGradient)
                                .blur(radius: 32)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .animation(.bouncy, value: showNote)

        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(showNote ? .twitch : .gray.opacity(0.25), lineWidth: 2)
                .shadow(color: showNote ? .twitch : .red.opacity(0.1), radius: 32)
        )
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
