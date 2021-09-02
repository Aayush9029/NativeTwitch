//
//  TwitchData.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI
import Alamofire
import SwiftyJSON


class TwitchData: ObservableObject{
    
    //    VIEW MODEL CODE: App is too small to make a seperate viewmodel file
    @Published var showingSettings: Bool = false
    
    
    @AppStorage("twitchClientID") var twitchClientID = ""
    @AppStorage("oauthToken") var oauthToken = ""
    @AppStorage("streamlinkLocation") var streamlinkLocation = "/opt/homebrew/bin/streamlink"
    
    @Published var status: StatusStates
    
    var user: User
    var streams: [Stream]
    
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
            "Client-ID": twitchClientID,
            "Authorization": " Bearer \(oauthToken)"
        ]
        
        let task = AF.request(url, headers: headers)
        
        task.responseData { response in
            
            if let json = try? JSON(data: response.data!){
                if json["client_id"].string == self.twitchClientID{
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
            "Client-ID": self.twitchClientID,
            "Authorization": " Bearer \(self.oauthToken)"
        ]
        
        let task = AF.request(url, headers: headers)
        
        task.responseData { response in
            if let json = try? JSON(data: response.data!){
                if let name = json["login"].string {
                    self.user = User(client_id: self.twitchClientID, oauthToken: self.oauthToken, name: name, user_id: json["user_id"].string!, isValid: true)
                }else{
                    self.status = .badOuath
                }
                
                self.status = .userLoaded
                self.addFollowedStreams()
                
            }
        }
    }
    
    
    func addFollowedStreams(){
        self.status = .streamLoading
        
        let url = "https://api.twitch.tv/helix/streams/followed"
        
        let headers: HTTPHeaders = [
            "Client-ID": twitchClientID,
            "Authorization": " Bearer \(oauthToken)"
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
            }else{
                self.status = .badScopes
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
