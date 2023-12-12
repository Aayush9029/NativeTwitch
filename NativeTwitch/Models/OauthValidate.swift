//
//  OauthValidate.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-13.
//

import Foundation

// MARK: - OauthValidate

struct OauthValidate: Codable {
    let clientID, login: String
    let scopes: [String]
    let userID: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case login, scopes
        case userID = "user_id"
        case expiresIn = "expires_in"
    }
}
