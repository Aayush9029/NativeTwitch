//
//  AboutView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-11-14.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                logoSection
                
                infoSection
            }
            
            Group {
                moreInfoButton
                
                privacyTOS
            }
            
            Spacer()
        }
        .frame(width: 280, height: 500 - 42)
        .background(
            ZStack {
                Image(.appIcon)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 128)
                    .opacity(0.25)
                
                VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow, state: .active)
            }
            .ignoresSafeArea())
    }
    
    private var logoSection: some View {
        VStack {
            Image(.appIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 128)
                .padding()
            
            Text("NativeTwitch")
                .font(.title.bold())
            
            Text("Version \(Bundle.main.appVersion), \(Bundle.main.appBuild)")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom)
        }
    }
    
    private var infoSection: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                InfoRow(label: "Build", value: Bundle.main.appBuild)
                InfoRow(label: "Github", value: "Aayush9029", link: "https://github.com/Aayush9029")
                InfoRow(label: "Designed By", value: "Aayush", link: "https://aayush.art")
                InfoRow(label: "Made in", value: "Toronto, CA")
            }
            .font(.subheadline)
            Spacer()
        }
    }
    
    private var moreInfoButton: some View {
        Link(destination: URL(string: "https://github.com/aayush9029")!) {
            Text("More Info...")
        }
        .buttonStyle(.bordered)
        .padding()
    }
    
//    MARK: - TODO CREATE WEBSITES LOL

    private var privacyTOS: some View {
        VStack {
            Link(destination: URL(string: "https://apps.aayush.art/privacy")!) {
                Text("Privacy Policy")
            }
            Link(destination: URL(string: "https://love.aayush.art")!) {
                Text("Support Developer")
            }
            Link(destination: URL(string: "https://apps.aayush.art")!) {
                Text("Other Apps by Developer")
            }
        }
        .underline()
        .buttonStyle(.plain)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
}

struct InfoRow: View {
    @Environment(\.openURL) var openURL
    let label: String
    let value: String
    var link: String? = nil
    @State private var hovered: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
            HStack {
                Text(value)
                Spacer()
            }
            .foregroundStyle(hovered ? .primary : .secondary)
            .frame(width: 80)
        }
        .onTapGesture {
            if let link,
               let url = URL(string: link)
            {
                openURL(url)
            }
        }
        .onHover(perform: { hovering in
            if link != nil {
                withAnimation(.spring) {
                    hovered = hovering
                }
            }
        })
    }
}

#Preview {
    AboutView()
}
