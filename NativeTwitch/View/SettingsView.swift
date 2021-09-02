//
//  SettingsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("twitchClientID") var twitchClientID = ""
    @AppStorage("oauthToken") var oauthToken = ""
    @AppStorage("streamlinkLocation") var streamlinkLocation = "/opt/homebrew/bin/streamlink"
    
    var user: User
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text("\(user.name)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .lineLimit(1)
                }
                Spacer()
            }.padding(.horizontal)
            VStack(spacing: 10){
                TextField("Your Twitch Client ID", text: $twitchClientID)
                
                Divider()
                
                TextField("Your Twitch Access Token", text: $oauthToken)
                
                Link(
                    destination: URL(string: "https://twitchtokengenerator.com/quick/NIaMdzGYBR")!,
                    label: {
                        Label("Generate Client ID and  Access Token", systemImage: "network")
                    }
                )
                Divider()
                
                TextField("Stream link Location", text: $streamlinkLocation)
                
            }.padding([.horizontal, .bottom])
                .textFieldStyle(.roundedBorder)
            
            VStack{
                if oauthToken.count < 10{
                    Text("Press Command + R to save")
                        .foregroundColor(.gray)
                }
            }.padding(.horizontal)
            
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: exampleUser)
    }
}
