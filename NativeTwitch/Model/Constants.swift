//
//  Constants.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import Foundation

struct Constants {
    let twitchClientID: String
    let oauthToken: String
    let streamlinkLocation: String
    static let downloadDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let installDir = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask).first!

}

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

enum AppStorageStrings: String{
    case clientID = "twitchClientID"
    case oauthToken = "oauthToken"
    case streamlinkLocation = "streamlinkLocation"
    case showingInfo = "showingInfo"
    case iinaLocation = "IINA location (optional)"
    case iinaEnabled = "Enable IINA"
    case tmpDirectory = "Temporary Updates Download Directory"
    case remoteUpdateJson = "URL Remote Version"
}
