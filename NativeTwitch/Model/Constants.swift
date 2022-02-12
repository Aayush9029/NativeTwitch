//
//  Constants.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import Foundation

// MARK: - Constants
struct Constants {
    let twitchClientID: String
    let oauthToken: String

    let streamlinkLocation: String
    let streamlinkConfig: String

    static let downloadDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let installDir = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask).first!

    static let oauthValidate = "https://id.twitch.tv/oauth2/validate"
}

// MARK: - Status States Debugging.
enum StatusStates: String {
    case starting = "Starting.."
    case badOuath = "Incorrect Access Token"
    case badClient = "Incorrect Client ID"
    case badScopes = "BAD Scopes (Client ID / Access Token)"
    case userValidating = "Validating User"
    case userValidated = "User Validated"
    case userLoading = "Loading User Data"
    case userLoaded = "Got User Data"
    case streamLoading = "Loading Streams"
    case streamLoaded = "Stream Has Been Loaded"
}

// MARK: - Enums for Appstorage strings.
enum AppStorageStrings: String {
    case clientID = "twitchClientID"
    case oauthToken = "oauthToken"
    case streamlinkLocation = "streamlinkLocation"
    case streamlinkConfig = "streamLinkConfig"
    case showingInfo = "showingInfo"
    case iinaEnabled = "Enable IINA"
    case experimental = "Experimental Features"
    case tmpDirectory = "Temporary Updates Download Directory"
    case remoteUpdateJson = "URL Remote Version"
}
