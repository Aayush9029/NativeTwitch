//
//  TwitchDeviceAuth.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-19.
//

import Foundation
import os

actor TwitchDeviceAuth {
    private let logger = Logger(category: "TwitchDeviceAuth")

    private let clientID: String = Constants.clientID
    private let scope: String = Constants.scopes

    func startDeviceAuthorization() async throws -> (deviceCode: String, userCode: String, verificationUri: String) {
        logger.log("Starting Device Authorization")
        let url = URL(string: "https://id.twitch.tv/oauth2/device")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyParameters = "client_id=\(clientID)&scopes=\(scope)"
        request.httpBody = bodyParameters.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw TwitchDeviceAuthError.invalidResponse
        }
        logger.debug("Received device authorization response")
        guard let deviceCode = json["device_code"] as? String,
              let userCode = json["user_code"] as? String,
              let verificationUri = json["verification_uri"] as? String
        else {
            throw TwitchDeviceAuthError.invalidResponse
        }

        return (deviceCode, userCode, verificationUri)
    }

    func pollForToken(deviceCode: String) async throws -> String {
        logger.log("Polling for Token")
        let url = URL(string: "https://id.twitch.tv/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyParameters = "client_id=\(clientID)&device_code=\(deviceCode)&grant_type=urn:ietf:params:oauth:grant-type:device_code"
        request.httpBody = bodyParameters.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw TwitchDeviceAuthError.invalidResponse
        }
        logger.debug("Received token polling response")
        if let accessToken = json["access_token"] as? String {
            return accessToken
        } else {
            throw TwitchDeviceAuthError.authorizationPending
        }
    }
}

enum TwitchDeviceAuthError: LocalizedError {
    case invalidResponse
    case authorizationPending

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid response data"
        case .authorizationPending:
            "Authorization pending or other error"
        }
    }
}
