//
//  StreamRowView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct StreamRowView: View {
    @EnvironmentObject var twitchDataViewModel: TwitchDataViewModel
    @State private var hovered = false

    let stream: StreamModel

    var body: some View {
        Group {
            Group {
                HStack {
                    StreamerLogoView(url: stream.user_logo)
                    VStack {
                        Group {
                            HStack {
                                Text(stream.user_name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                Spacer()

                                LiveBadgeView(viewCount: "\(Double(stream.viewer_count).shortStringRepresentation)")
                            }
                            HStack {
                                Text(stream.game_name)
                                    .font(.body.bold())
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.bottom, 1)
                        }
                        if twitchDataViewModel.showingInfo {
                            HStack {
                                Text(stream.title)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(8)
            }
            .onHover { isHovered in
                withAnimation {
                    self.hovered = isHovered
                }
            }
            .padding(6)
            .background(
                Group {
                    AsyncImage(url: stream.getThumbnail())
                        .scaledToFill()
                        .blur(radius: hovered ? 0 : 4)
                        .scaleEffect(hovered ? 1 : 1.125)
                        .overlay(Color.purple.opacity(0.25).blendMode(.darken))
                }
            )
        }
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(hovered ? .purple : .secondary.opacity(0.5), lineWidth: 2)
            .shadow(color: hovered ?.blue : .clear, radius: 10)
        )
        .padding(2)
        .contextMenu {
            StreamActionMenu(stream: stream)
                .environmentObject(twitchDataViewModel)
        }
    }
}

struct StreamRowView_Previews: PreviewProvider {
    static var previews: some View {
        StreamRowView(stream: StreamModel.exampleStream)
            .environmentObject(TwitchDataViewModel())
            .padding()
    }
}
