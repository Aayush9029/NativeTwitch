//
//  SettingsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-17.
//

import SwiftUI

enum SPage: String {
    case apperance
    case account
    case donate

    var getLabel: some View {
        switch self {
        case .apperance:
            return Label("Appearance", systemImage: "paintbrush.pointed.fill")
        case .account:
            return Label("Account", systemImage: "person.fill")
        case .donate:
            return Label("Donate", systemImage: "heart.fill")
        }
    }
}

struct SettingsView: View {
    @State private var selectedPage: SPage = .account
    var body: some View {
        TabView(selection: $selectedPage,
                content: {
                    AccountInfo
                        .tabItem { SPage.account.getLabel }
                        .tag(SPage.account)

                    Text("Apperance")
                        .tabItem { SPage.apperance.getLabel }
                        .tag(SPage.apperance)

                    Text("Donate")
                        .tabItem { SPage.donate.getLabel }
                        .tag(SPage.donate)
                        .badge(2)

                })
    }

    var AccountInfo: some View {
        VStack {
            Spacer()
            HStack {
                Image(.exampleUser)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text("NerdAware")
                        .font(.title2.bold())
                        .foregroundStyle(.twitch.gradient)
                    Text(Date.now, style: .date)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Label("Log Out", systemImage: "person.badge.minus")
                    .foregroundStyle(.red)
                    .labelStyle(.iconOnly)
                    .font(.title3.bold())
                    .padding(12)
                    .background(.red.opacity(0.125))

                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.red, lineWidth: 1)
                    )
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 32))
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .frame(width: 480, height: 320)
}
