//
//  Constants.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import Foundation
class Constants{
    var twitchClientID = "gp762nuuoqcoxypju8c569th9wz7q5"
    var oauthToken = "3jaosugvb9bypjcrb0ks8d7stj1jdy"
    var userID = ""
    var streamlinkLocation = "/opt/homebrew/bin/streamlink"
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

enum StatusStates {
    case badOuath, badClient, badScopes, userValidating, userValidated, userLoading, userLoaded, streamLoading, streamLoaded, finished
}



let exampleStream = Stream(user_name: "xQcOW", user_id: "71092938", viewer_count: 122577, type: "live", game_name: "Grand Theft Auto V", title: "[Nopixel] RIDEALONG PIERRE PP PAUL RIDS LOS SANTOS OF ALL THE CRIMINAL SCUM", user_logo: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")

let exampleUser = User(client_id: "gp762nuuoqcoxypju8c569th9wz7q5", oauthToken:  "3jaosugvb9bypjcrb0ks8d7stj1jdy", name:  "aahyoushh" , user_id:  "511005830" , isValid: false)
