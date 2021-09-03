//
//  Constants.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//


import SwiftUI

struct Constants {
    let twitchClientID: String
    let oauthToken: String
    let streamlinkLocation: String
}


struct User {
    var client_id: String
    var oauthToken: String
    var name: String
    var user_id: String
    var isValid = false
}

struct Stream: Hashable{
    var user_name: String
    var user_id: String
    var viewer_count: Int
    var type: String // type is "live" if streamer is live else ""
    var game_name: String
    var title: String
    var user_logo: String?
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


let exampleStream = Stream(user_name: "xQcOW", user_id: "71092938", viewer_count: 122577, type: "live", game_name: "Grand Theft Auto V", title: "[Nopixel] RIDEALONG PIERRE PP PAUL RIDS LOS SANTOS OF ALL THE CRIMINAL SCUM", user_logo: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")

let exampleUser = User(client_id: "gp762nuuoqcoxypju8c569th9wz7q5", oauthToken:  "3jaosugvb9bypjcrb0ks8d7stj1jdy", name:  "aahyoushh2" , user_id:  "511005830" , isValid: false)
