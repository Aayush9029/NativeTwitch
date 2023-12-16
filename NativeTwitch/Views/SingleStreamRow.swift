//
//  SingleStreamRow.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct SingleStreamRow: View {
    @Environment(\.openURL) var openURL
    @State private var hovered = false

    let stream: StreamModel

    init(_ stream: StreamModel) {
        self.stream = stream
    }

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if !hovered {
                    HStack {
                        BadgeView(
                            symbol: "clock",
                            symbolColor: .green
                        ) {
                            Text(stream.startedDate, style: .relative)
                        }

                        Spacer()

                        BadgeView(
                            symbol: "person.2",
                            symbolColor: .red
                        ) {
                            Text(stream.viewers)
                        }
                    }
                    .padding(6)
                    .blurReplace(edge: .top)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(stream.userName)
                            .font(.headline)
                        Text(stream.title)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .fontWeight(.medium)
                            .hSpacing(.leading)
                    }
                    .shadow(radius: 6)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.thickMaterial)
                            .mask(LinearGradient.bottomMasked)
                    )
                    .blurReplace(edge: .bottom)
                }
            }
        }
        .xSpacing(.center)
        .background(
            ScalledToFillImage(stream.thumbnail)
        )
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    hovered ? .twitch : .gray.opacity(0.25),
                    lineWidth: 2
                )
        )
        .frame(height: 164)
        .onHover { hovering in
            withAnimation(.easeInOut) {
                hovered = hovering
            }
        }
        .contextMenu(menuItems: {
            Button("Open Stream") {
                openURL(stream.streamURL)
            }
            Button("Popout Chat") {
                openURL(stream.chatURL)
            }

        })
    }

    @ViewBuilder
    func ScalledToFillImage(_ url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }
        .scaledToFill()
    }
}

#Preview {
    SingleStreamRow(.xQc)
        .frame(width: 320, height: 480)
        .padding()
}
