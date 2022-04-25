//
//  StreamRowView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI

struct StreamRowView: View {
    var stream: Stream

    @EnvironmentObject var twitchData: TwitchDataViewModel

    @State private var hovered = false
    @State var stream_logo: URL?

    var body: some View {

            VStack {
                HStack {
                    WebImage(url: stream_logo, options: [.progressiveLoad, .delayPlaceholder])
                        .placeholder(Image("streamer-image-placeholder"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.red, lineWidth: 2)
                                .shadow(color: Color.pink.opacity(0.75), radius: 5)
                        )
                        .padding(5)
                    VStack {
                        HStack {
                            Text(stream.user_name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            Spacer()
                            if stream.type == "live" {
                                LiveBadgeView(viewCount: "\(Double(stream.viewer_count).shortStringRepresentation)")
                            }
                        }
                        HStack {
                            Text(stream.game_name)
                                .lineLimit( twitchData.showingInfo ? 3 : 1)
                                .font(.callout.bold())
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        Group {
                            if twitchData.showingInfo {
                                HStack {
                                    Text(stream.title)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(
                WebImage(url: URL(string: stream.getThumbnail()))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 10)
                            .background(hovered ? Color("AccentColor").opacity(0.5) : Color.white.opacity(0.025))
                    }
                    .resizable()
                    .scaledToFill()
                    .blur(radius: hovered ? 0 : 4)
                    .scaleEffect(hovered ? 1 : 1.125)
                    .brightness(-0.0125)
            )
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(hovered ? .purple : .secondary.opacity(0.5), lineWidth: 2)
                        .shadow(color: hovered ?.blue : .clear, radius: 10)
            )
            .onHover { isHovered in self.hovered = isHovered }
            .padding(.horizontal, 10)
            .animation(.default, value: hovered)
            .task {
                getUserLogo()
        }
        }
            .preferredColorScheme(.dark)
    }
}

extension StreamRowView {
    func getUserLogo() {
        print("getting")
        let url = "https://api.twitch.tv/helix/users"

        let headers: HTTPHeaders = [
            "Client-ID": twitchData.twitchClientID,
            "Authorization": " Bearer \(twitchData.oauthToken)"
        ]
        let parameters: Parameters = [
            "id": stream.user_id
        ]

        let task = AF.request(url, parameters: parameters, headers: headers)

        task.responseData { response in
            if let json = try? JSON(data: response.data!) {
                stream_logo  = URL(string: json["data"][0]["profile_image_url"].string!)!
            }
        }
    }

}

struct StreamRowView_Previews: PreviewProvider {
    static var previews: some View {
        StreamRowView(stream: .exampleStream)
            .environmentObject(TwitchDataViewModel())

    }
}
