//
//  StreamModel.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Stream Model
class StreamModel: Identifiable {
    var id: UUID
    var user_name: String
    var user_id: String
    var viewer_count: Int
    var type: String
    var game_name: String
    var title: String
    var user_logo: URL?
    var user_login: String
    var thumbnail_url: String

    init(id: UUID, user_name: String, user_id: String, viewer_count: Int, type: String, game_name: String, title: String, user_logo: URL?, user_login: String, thumbnail_url: String) {
        self.id = id
        self.user_name = user_name
        self.user_id = user_id
        self.viewer_count = viewer_count
        self.type = type
        self.game_name = game_name
        self.title = title
        self.user_logo = user_logo
        self.user_login = user_login
        self.thumbnail_url = thumbnail_url
    }

    func getStreamURL() -> URL {
        if let url = URL(string: "https://www.twitch.tv/\(user_login)") {
            return url
        }
        return URL(string: "https://www.twitch.tv")!
    }

    func getChatURL() -> URL {
        if let url = URL(string: "https://www.twitch.tv/popout/\(user_login)/chat") {
            return url
        }
        return getStreamURL()
    }

    func getThumbnail(width: Int = 720, height: Int = 360) -> URL? {
        return URL(string: thumbnail_url.replacingOccurrences(of: "{width}", with: "\(width)").replacingOccurrences(of: "{height}", with: "\(height)"))
    }

    func loadUserLogo(clientID: String, oauthToken: String, userID: String) {
        print("getting")
        let url = Constants.streamerDataURL

        let headers: HTTPHeaders = [
            "Client-ID": clientID,
            "Authorization": " Bearer \(oauthToken)"
        ]
        let parameters: Parameters = [
            "id": userID
        ]

        let task = AF.request(url, parameters: parameters, headers: headers)

        task.responseData { response in
            if let json = try? JSON(data: response.data!) {
                self.user_logo  = URL(string: json["data"][0]["profile_image_url"].string!)!
            }
        }
    }

    static let exampleStream = StreamModel(
        id: UUID(),
        user_name: "xQcOW",
        user_id: "71092938",
        viewer_count: 122577,
        type: "live",
        game_name: "Grand Theft Auto V",
        title: "[Nopixel] RIDEALONG PIERRE PP PAUL RIDS LOS SANTOS OF ALL THE CRIMINAL SCUM",
        user_logo: nil,
        user_login: "xqcow",
        thumbnail_url: "https://static-cdn.jtvnw.net/previews-ttv/live_user_xqcow-400x248.jpg"
    )
}
