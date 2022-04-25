//
//  Stream.swift
//  Stream
//
//  Created by Aayush Pokharel on 2021-09-04.
//
import Foundation

// MARK: - Stream Model
struct Stream: Hashable {
    var user_name: String
    var user_id: String
    var viewer_count: Int
    var type: String // type is "live" if streamer is live else ""
    var game_name: String
    var title: String
    var user_logo: String?
    var user_login: String // using this instead of username (fixes Chinise character issue)
    var thumbnail_url: String

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

    func getThumbnail(width: Int = 400, height: Int = 248) -> String {
        return thumbnail_url.replacingOccurrences(of: "{width}", with: "\(width)").replacingOccurrences(of: "{height}", with: "\(height)")
    }

    static let exampleStream = Stream(
        user_name: "xQcOW",
        user_id: "71092938",
        viewer_count: 122577,
        type: "live",
        game_name: "Grand Theft Auto V",
        title: "[Nopixel] RIDEALONG PIERRE PP PAUL RIDS LOS SANTOS OF ALL THE CRIMINAL SCUM",
        user_logo: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
        user_login: "xqcow",
        thumbnail_url: "https://static-cdn.jtvnw.net/previews-ttv/live_user_xqcow-400x248.jpg"
    )
}
