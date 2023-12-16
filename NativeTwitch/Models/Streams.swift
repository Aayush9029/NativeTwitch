//
//  Streams.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-13.
//

import Foundation

// MARK: - Streams

struct TwitchResponse: Codable {
    let data: [StreamModel]
}

// MARK: - StreamModel

struct StreamModel: Codable, Identifiable {
    let id, userID, userLogin, userName: String
    let gameID, gameName, title: String
    let viewerCount: Int
    let startedAt: String
    let language, thumbnailURL: String
    let tags: [String]
    let isMature: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case userLogin = "user_login"
        case userName = "user_name"
        case gameID = "game_id"
        case gameName = "game_name"
        case title
        case viewerCount = "viewer_count"
        case startedAt = "started_at"
        case language
        case thumbnailURL = "thumbnail_url"
        case tags
        case isMature = "is_mature"
    }

    // Computed Properties
    var viewers: String {
        return Double(viewerCount).shortStringRepresentation
    }

    var startedDate: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        if let date = formatter.date(from: startedAt) {
            return date
        } else {
            return Date.now
        }
    }

    var streamURL: URL {
        return "https://www.twitch.tv/\(userLogin)".toURL()!
    }

    var chatURL: URL {
        return "https://www.twitch.tv/popout/\(userLogin)/chat".toURL()!
    }

    var thumbnail: URL? {
        return URL(
            string: thumbnailURL
                .replacingOccurrences(of: "{width}", with: "720")
                .replacingOccurrences(of: "{height}", with: "360")
        )
    }
}

extension TwitchResponse {
    // Mock Data
    static let example: TwitchResponse = .init(data: [.xQc, .pokelawls])
}

extension StreamModel {
    // Mock Data
    static let xQc: StreamModel = .init(
        id: "49932260029",
        userID: "71092938",
        userLogin: "xqc",
        userName: "xQc",
        gameID: "32982",
        gameName: "Grand Theft Auto V",
        title: "🤖CLICK🤖NO-PIXEL 4.0🤖LAUNCH🤖MERCH🤖IS LIVE🤖BIG JUICER🤖RP🤖IS BACK🤖WOOHOO🤖DRAMA🤖IS BACK🤖YAY🤖",
        viewerCount: 71775,
        startedAt: "2023-12-15T18:33:00Z",
        language: "en",
        thumbnailURL: "https://static-cdn.jtvnw.net/previews-ttv/live_user_xqc-{width}x{height}.jpg",
        tags: ["English", "vtuber", "depression", "adhd", "psychosis", "xqc", "femboy", "anime", "reaction", "IRL"],
        isMature: false
    )
    static let pokelawls: StreamModel = .init(
        id: "43224626107",
        userID: "12943173",
        userLogin: "pokelawls",
        userName: "pokelawls",
        gameID: "33214",
        gameName: "Fortnite",
        title: "Cool",
        viewerCount: 3355,
        startedAt: "2023-12-13T23:14:42Z",
        language: "en",
        thumbnailURL: "https://static-cdn.jtvnw.net/previews-ttv/live_user_pokelawls-{width}x{height}.jpg",
        tags: ["frog",
               "gigi",
               "Depression",
               "Water",
               "English"],
        isMature: true
    )
}
