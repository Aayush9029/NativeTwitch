//
//  Constants.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-13.
//

import Foundation

enum Constants {
    static let baseAPI = "https://api.twitch.tv/helix"
    static let followedAPI = "\(baseAPI)/streams/followed"
    static let streamerInfoURL = "\(baseAPI)/users".toURL()!
    static let oauthValidateURL = "https://id.twitch.tv/oauth2/validate".toURL()!

    static func followedAPIURL(with userID: String) -> URL? {
        return "\(followedAPI)?user_id=\(userID)".toURL()
    }

//    static let tokenGeneratorURL = "https://twitchtokengenerator.com/quick/NIaMdzGYBR".toURL()!

    // Oauth flow
    static let clientID = "gp762nuuoqcoxypju8c569th9wz7q5"
    static let scopes = ["user:read:follows", "user:read:email", "user:edit:follows"].joined(separator: "+")
}
