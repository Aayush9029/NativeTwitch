//
//  Stream.swift
//  Stream
//
//  Created by Aayush Pokharel on 2021-09-04.
//
import Foundation

struct Stream: Hashable{
    var user_name: String
    var user_id: String
    var viewer_count: Int
    var type: String // type is "live" if streamer is live else ""
    var game_name: String
    var title: String
    var user_logo: String?
    
    func getStreamURL() -> URL {
        if let url = URL(string: "https://www.twitch.tv/\(user_name)"){
            return url
        }
        return URL(string: "https://www.twitch.tv")!
    }
    
    func getChatURL() -> URL {
        if let url = URL(string: "https://www.twitch.tv/popout/\(user_name)/chat"){
            return url
        }
        return getStreamURL()
    }
}

let exampleStream = Stream(user_name: "xQcOW", user_id: "71092938", viewer_count: 122577, type: "live", game_name: "Grand Theft Auto V", title: "[Nopixel] RIDEALONG PIERRE PP PAUL RIDS LOS SANTOS OF ALL THE CRIMINAL SCUM", user_logo: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")
