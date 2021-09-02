//
//  UserView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI

struct UserView: View {
    @AppStorage("twitchClientID") var twitchClientID = "gp762nuuoqcoxypju8c569th9wz7q5"
    @AppStorage("oauthToken") var oauthToken = "3jaosugvb9bypjcrb0ks8d7stj1jdy"
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
                }
                Spacer()
//                CleanButton(image: "gear", color: .blue)
            }.padding(.horizontal)
            VStack(spacing: 10){
                TextField("Twitch Client ID", text: $twitchClientID)
                TextField("Twitch OauthToken", text: $oauthToken)
                TextField("Stream link Location", text: $streamlinkLocation)
            }.padding([.horizontal, .bottom])
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: exampleUser)
    }
}
