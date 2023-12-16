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
class TwitchVM {
    private let logger: Logger = .init(category: "TwitchVM")
    static let shared: TwitchVM = .init()
    
    var loggedIn = true

    var loading = true {
        didSet {
            if loading {
                // Start the 3.0 sec timeout in case it never stops loading.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                    // == true is necessary because loading can be nil.
                    if self?.loading == true {
                        self?.logger.log("3.0 seconds timeout for loading ended, toggling it to false")
                        self?.loading = false
                    }
                }
            }
        }
    }
    
    init() {}
    
    func fetchFollowedStreams() async -> [StreamModel] {
        loading = true
        logger.info("Fetching followed streams")
        
        guard let auth: AuthModel = KeychainSwift.getAuth() else {
            logger.error("AccessToken + ClientID not found")
            return []
        }
        
        guard let userID: String = KeychainSwift.getUserID() else {
            logger.warning("UserID not fetched yet, going to fetch it now.")
            guard let userID = await fetchUserID(with: auth.accessToken) else {
                loggedIn = false
                return []
            }
            
            if KeychainSwift.setUserID(userID) { return await fetchFollowedStreams() }
            
            return []
        }
        
        guard let url = Constants.followedAPIURL(with: userID) else {
            logger.error("Invalid endpoint for followed API")
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(auth.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue(auth.clientID, forHTTPHeaderField: "Client-Id")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                logger.error("Error: Non-200 HTTP response from twitch: \(response)")
                return []
            }
            loading = false
            return decode(TwitchResponse.self, from: data)?.data ?? []
            
        } catch {
            logger.error("Error fetching streams: \(String(describing: error))")
        }
        return []
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
            print("Data corrupted: \(context.debugDescription)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: \(context.debugDescription)")
        } catch {
            print("Unknown error: \(error)")
        }
        return nil
    }
}
