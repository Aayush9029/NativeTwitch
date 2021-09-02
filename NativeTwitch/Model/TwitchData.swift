//
//  TwitchData.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import Foundation
import Alamofire
import SwiftyJSON


class TwitchData: ObservableObject{
    
    @Published var status: StatusStates
    var user: User
    var streams: [Stream]
    var constants = Constants()
    
    init() {
        self.user = User(client_id: "", oauthToken: "", name: "", user_id: "", isValid: false)
        self.streams = []
        self.status = .userValidating
        self.startFetch()
    }
    
    func startFetch(){
        self.user = User(client_id: "", oauthToken: "", name: "", user_id: "", isValid: false)
        self.streams = []
        self.status = .userValidating
        
        self.validateTokens() // Changes StatusStates that's all
        self.fetchUserData() // Fetches user data and excecutes get followed internally
    }
    
    func validateTokens(){
        self.status = .userValidating
        
        let url = "https://id.twitch.tv/oauth2/validate"
        // 2
        let headers: HTTPHeaders = [
            "Client-ID": Constants().twitchClientID,
            "Authorization": " Bearer \(Constants().oauthToken)"
        ]
        
        let task = AF.request(url, headers: headers)
        
        task.responseData { response in
            
            if let json = try? JSON(data: response.data!){
                if json["client_id"].string == Constants().twitchClientID{
                    if json["scopes"] != ["user:read:follows"]{
                        self.status = .badScopes
                    }else{
                        self.status = .userValidated
                    }
                    
                }else{
                    self.status = .badClient
                }
                
            }
        }
    }
    
    
    func fetchUserData(){
        self.status = .userLoading
        
        let url = "https://id.twitch.tv/oauth2/validate"
        // 2
        let headers: HTTPHeaders = [
            "Client-ID": constants.twitchClientID,
            "Authorization": " Bearer \(constants.oauthToken)"
        ]
        
        let task = AF.request(url, headers: headers)
        
        task.responseData { response in
            if let json = try? JSON(data: response.data!){
                self.user = User(client_id: self.constants.twitchClientID, oauthToken: self.constants.oauthToken, name: json["login"].string!, user_id: json["user_id"].string!, isValid: true)
                
                self.status = .userLoaded
                self.addFollowedStreams()
                
            }
        }
    }
    
    
    func addFollowedStreams(){
        self.status = .streamLoading
        
        let url = "https://api.twitch.tv/helix/streams/followed"
        
        let headers: HTTPHeaders = [
            "Client-ID": constants.twitchClientID,
            "Authorization": " Bearer \(constants.oauthToken)"
        ]
        let parameters: Parameters = [
            "user_id": user.user_id
        ]
        
        let task = AF.request(url, parameters: parameters, headers: headers)
        
        task.responseData { response in
            
            if let json = try? JSON(data: response.data!){
                for (_, subJson):(String, JSON) in json["data"] {
                    let d = subJson
                    
                    self.streams.append(Stream(user_name: d["user_name"].string!, user_id: d["user_id"].string!, viewer_count: d["viewer_count"].int!, type: d["type"].string!, game_name: d["game_name"].string!, title: d["title"].string!))
                
                }
                self.status = .streamLoaded
                self.status = .finished
            }
        }
    }
    

    
    
    func getUserData() -> User{
        return self.user
    }
    
    func getStreamData() -> [Stream]{
        return self.streams
    }
    
}
