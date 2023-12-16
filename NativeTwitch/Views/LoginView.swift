//
//  LoginView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct LoginView: View {
    @Environment(TwitchVM.self) var twitchVM
    @State private var auth: AuthModel = .empty

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64)
                    .offset(x: -10)
                Image(systemName: "questionmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .hSpacing(.trailing)
            }

            Text("Authenticate with twitch")
                .font(.headline)

            Divider()
                .opacity(0.125)

            Group {
                CustomTextField(text: "Client ID", value: $auth.clientID)

                CustomTextField(text: "Access Token", value: $auth.accessToken)
            }

            Spacer()

            Group {
                Button {} label: {
                    Label("Generate", systemImage: "globe")
                        .longButton(foreground: .white, background: .blue)
                }

                Button {
                    Task {
                        let set = KeychainSwift.login(auth)
                        print("AUTH: \(set)")
                        if let userID = await twitchVM.fetchUserID(with: auth.accessToken) {
                            let set = KeychainSwift.setUserID(userID)
                            print("USERID: \(set)")
                        }
                        await twitchVM.fetchFollowedStreams()
                    }

                } label: {
                    Label("Save", systemImage: "key.fill")
                        .longButton(foreground: .white, background: .gray.opacity(0.5))
                }
                .disabled(auth.clientID.isEmpty || auth.accessToken.isEmpty)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            GenerativePreview(shader: .sineBow)
                .blur(radius: 64)
        )
        .task {
            if let auth = KeychainSwift.getAuth() {
                self.auth = auth
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
                    .cleanTextField()
//                    .focusable()

                Group {
                    if let pasteboard = NSPasteboard.general.string(forType: .string),
                       value.isEmpty
                    {
                        Button(
                            action: { value = pasteboard },
                            label: {
                                Label("Paste", systemImage: "list.clipboard.fill")
                                    .font(.headline)
                                    .labelStyle(.iconOnly)
                                    .padding(3)
                                    .background(.thickMaterial)
                                    .clipShape(.rect(cornerRadius: 4))
                            }
                        )
                        .buttonStyle(.plain)
                        .padding(.trailing, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .frame(width: 320, height: 360)
        .background(.gray.opacity(0.25))
        .environment(TwitchVM.shared)
}
