//
//  TwitchVM.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-13.
//

import os
import SwiftUI

@MainActor
@Observable
final class TwitchVM {
    @ObservationIgnored private let logger: Logger = .init(category: "TwitchVM")
    @ObservationIgnored private let twitchAuth: TwitchDeviceAuth = .init()
    @ObservationIgnored private var loadingTimeoutTask: Task<Void, Never>?
    var deviceCodeInfo: (userCode: String, verificationUri: String)?

    var loggedIn: Bool = true
    var streams: [StreamModel] = []

    // Login
    var attempts = 0
    let maxAttempts = 25

    // UI
    var showOnlyMenu = false

    init() {
        logger.debug("Created TwitchVM")
        loggedIn = (KeychainSwift.getUserID() != nil)
    }

    deinit {
        loadingTimeoutTask?.cancel()
    }

    var loading = false {
        didSet {
            if loading {
                scheduleLoadingTimeout()
            } else {
                loadingTimeoutTask?.cancel()
            }
        }
    }

    func startDeviceAuthorization() async {
        do {
            attempts = 1
            let (deviceCode, userCode, verificationUri) = try await twitchAuth.startDeviceAuthorization()
            deviceCodeInfo = (userCode, verificationUri)
            await pollForToken(deviceCode: deviceCode)
        } catch {
            logger.error("Device Authorization Error: \(error.localizedDescription)")
        }
    }

    private func scheduleLoadingTimeout() {
        loadingTimeoutTask?.cancel()
        loadingTimeoutTask = Task { [weak self] in
            do {
                try await Task.sleep(for: .seconds(3))
            } catch {
                return
            }

            guard let self, loading else { return }
            logger.log("3.0 seconds timeout for loading ended, toggling it to false")
            loading = false
        }
    }

    private func pollForToken(deviceCode: String) async {
        let pollingIntervalNanoseconds: UInt64 = 5_000_000_000 // 5 seconds

        while attempts < maxAttempts {
            do {
                let accessToken = try await twitchAuth.pollForToken(deviceCode: deviceCode)
                let authModel = AuthModel(Constants.clientID, accessToken)
                let loginSuccess = KeychainSwift.login(authModel)
                loggedIn = loginSuccess
                if loginSuccess {
                    await fetchFollowedStreams()
                    return
                }
            } catch {
                logger.error("Error Polling for Token: \(error.localizedDescription)")
            }
            attempts += 1
            do {
                try await Task.sleep(nanoseconds: pollingIntervalNanoseconds)
            } catch {
                return
            }
        }

        logger.error("Max polling attempts reached or device code expired")
    }

    func login() async {
        guard let auth = KeychainSwift.getAuth() else {
            loggedIn = false
            return
        }

        logger.log("Logging in with stored auth credentials")
        loggedIn = true
        await fetchFollowedStreams()
    }

    func logout() {
        loggedIn = !KeychainSwift.logout()
        streams = []
        deviceCodeInfo = nil
    }

    func fetchFollowedStreams() async {
        loading = true
        defer { loading = false }
        logger.info("Fetching followed streams")

        guard let auth: AuthModel = KeychainSwift.getAuth() else {
            logger.error("AccessToken + ClientID not found")
            loggedIn = false
            return
        }

        guard let userID: String = KeychainSwift.getUserID() else {
            logger.warning("UserID not fetched yet, going to fetch it now.")
            guard let userID = await fetchUserID(with: auth.accessToken) else {
                return
            }

            if KeychainSwift.setUserID(userID) {
                await fetchFollowedStreams()
            }

            return
        }

        guard let url = Constants.followedAPIURL(with: userID) else {
            logger.error("Invalid endpoint for followed API")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(auth.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue(auth.clientID, forHTTPHeaderField: "Client-Id")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                logger.error("Error: Non-200 HTTP response from twitch: \(response)")
                return
            }

            streams = decode(TwitchResponse.self, from: data)?.data ?? []
        } catch {
            logger.error("Error fetching streams: \(String(describing: error))")
        }
    }
}

extension TwitchVM {
    // Helper Functions
    func fetchUserID(with accessToken: String) async -> String? {
        var request = URLRequest(url: Constants.oauthValidateURL)
        request.httpMethod = "GET"
        request.addValue("OAuth \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                loggedIn = false
                logger.error("Error: Non-200 HTTP response while validating oauth: \(response)")
                return nil
            }
            
            guard let userID = decode(OauthValidate.self, from: data)?.userID else {
                logger.error("Error decoding userID")
                
                return nil
            }
            return userID

        } catch {
            logger.error("Error fetching userID: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Generic Decoding Function with pretty messages
    func decode<T: Decodable>(_: T.Type, from data: Data) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch let DecodingError.dataCorrupted(context) {
            logger.error("Data corrupted: \(context.debugDescription)")
        } catch let DecodingError.keyNotFound(key, context) {
            logger.error("Key '\(key.stringValue)' not found: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(value, context) {
            logger.error("Value '\(String(describing: value))' not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            logger.error("Type '\(String(describing: type))' mismatch: \(context.debugDescription)")
        } catch {
            logger.error("Unknown decoding error: \(error.localizedDescription)")
        }
        return nil
    }
}
