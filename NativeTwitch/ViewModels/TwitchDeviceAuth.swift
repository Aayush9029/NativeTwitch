//
//  TwitchDeviceAuth.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-19.
//

import Foundation
import os

class TwitchDeviceAuth {
    let logger = Logger(category: "🔑")

    let clientID: String = Constants.clientID
    let scope: String = Constants.scopes

    func startDeviceAuthorization() async throws -> (deviceCode: String, userCode: String, verificationUri: String) {
        logger.log("Starting Device Authorization")
        let url = URL(string: "https://id.twitch.tv/oauth2/device")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyParameters = "client_id=\(clientID)&scopes=\(scope)"
        request.httpBody = bodyParameters.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        print("Start Device Authorization \(json)")
        guard let deviceCode = json["device_code"] as? String,
              let userCode = json["user_code"] as? String,
              let verificationUri = json["verification_uri"] as? String
        else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
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
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        print("pollForToken \(json)")
        if let accessToken = json["access_token"] as? String {
            // Store the access token securely
            return accessToken
        } else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authorization pending or other error"])
        }
    }
}
