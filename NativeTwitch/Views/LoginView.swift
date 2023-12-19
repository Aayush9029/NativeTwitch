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
            if let deviceCodeInfo = twitchVM.deviceCodeInfo {
                Text("Enter Code: \(deviceCodeInfo.userCode)")
                    .font(.title)
                Text("Go to: \(deviceCodeInfo.verificationUri)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: deviceCodeInfo.verificationUri) {
                            openURL(url)
                        }
                    }
            } else {
                Button("Login with Twitch") {
                    Task {
                        await twitchVM.startDeviceAuthorization()
                    }
                }
            }
        }
        .padding()
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
