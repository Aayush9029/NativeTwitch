//
//  AuthModel.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-13.
//

import Foundation

// MARK: - Model Stored in Keychain

struct AuthModel {
    var clientID: String
    var accessToken: String

    init(_ clientID: String, _ accessToken: String) {
        self.clientID = clientID
        self.accessToken = accessToken
    }

    static var empty: AuthModel = .init("", "")
}
