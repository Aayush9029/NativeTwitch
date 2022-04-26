//
//  Constants.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import Foundation

// MARK: - URL Constants
struct Constants {
    static let downloadDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let installDir = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask).first!

    static let oauthValidateURL = URL(string: "https://id.twitch.tv/oauth2/validate")!
    static let followedApiURL = URL(string: "https://api.twitch.tv/helix/streams/followed")!
    static let streamerDataURL = URL(string: "https://api.twitch.tv/helix/users")!

    static let remoteUpdateURL = "https://raw.githubusercontent.com/Aayush9029/NativeTwitch/v2/version.json"
    static let popupAppearNotification = NotificationCenter.default
        .publisher(for: NSNotification.Name("com.aayush.NativeTwitch.popupAppear"))
}

// MARK: - Status States Debugging.
enum CurrentStatus: String {
    case starting = "App Launched"
    case userValidating = "User Validating"
    case userValidated = "User Validated"
    case userLoading = "Loading User Data"
    case userLoaded = "User Data Loaded"
    case invalidCredentials = "Invalid Credentials"
    case streamsLoading = "Loading Streams"
    case streamsLoaded = "Streams Loaded"
}

// MARK: - Enums for Appstorage strings.
struct StorageStrings {
    static let clientID = "com.aayush.NativeTwitch.clientID"
    static let accessToken = "com.aayush.NativeTwitch.accessToken"
    static let userName = "com.aayush.NativeTwitch.userName"
    static let userID = "com.aayush.NativeTwitch.userID"
    static let streamlinkLocation = "com.aayush.NativeTwitch.streamlinkLocation"
    static let streamlinkConfig = "com.aayush.NativeTwitch.streamlinkConfig"
    static let showingInfo = "com.aayush.NativeTwitch.showingInfo"
    static let iinaEnabled = "com.aayush.NativeTwitch.iinaEnabled"
    static let experimental = "com.aayush.NativeTwitch.experimental"
    static let remoteUpdateJson = "com.aayush.NativeTwitch.remoteUpdateJson"
    static let defaultResolution = "com.aayush.NativeTwitch.defaultResolution"
}

// MARK: - Avail Resolutions
let availableResolutions = [
    "audio_only",
    "worst",
    "360p",
    "480p",
    "720p60",
    "best"
]
