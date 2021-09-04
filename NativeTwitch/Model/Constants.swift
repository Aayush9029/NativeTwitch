//
//  Constants.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//


struct Constants {
    let twitchClientID: String
    let oauthToken: String
    let streamlinkLocation: String
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

