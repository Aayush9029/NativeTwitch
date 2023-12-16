//
//  SingleStreamRow.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

struct SingleStreamRow: View {
    @Environment(\.openURL) var openURL
    let stream: StreamModel
    @State private var hovered = false

    init(_ stream: StreamModel) {
        self.stream = stream
    }

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if !hovered {
                    LiveBadge(stream.viewers)
                        .blurReplace(edge: .trailing)
                        .hSpacing(.trailing)
                    Spacer()

                    Text(stream.title)
                        .fontWeight(.semibold)
                        .shadow(radius: 6)
                        .hSpacing(.leading)
                        .blurReplace(edge: .bottom)
                }
            }
        }
        .padding(8)
        .xSpacing(.center)
        .background(
            ZStack {
                Group {
                    ScalledToFillImage(stream.thumbnail)
                    if !hovered {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThickMaterial)
                            .mask(LinearGradient.bottomMasked)
                            .blurReplace(edge: .bottom)
                    }
                }
            }
        )
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            Group {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        hovered ? .twitch : .gray.opacity(0.25),
                        lineWidth: 2
                    )
            }
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
