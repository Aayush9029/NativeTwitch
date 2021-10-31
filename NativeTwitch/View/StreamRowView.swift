//
//  StreamRowView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct StreamRowView: View {
    var stream: Stream
    var const: Constants
    
    //    For More Info Settings (Command + i) *Will migrate to Settings View Model Later?* *maybe idk*
    @EnvironmentObject var twitchData: TwitchDataViewModel
    
    @State private var hovered = false
    @State var stream_logo: URL?
    
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: stream_logo) { image in
                    image.resizable()
                } placeholder: {
                   Image("streamer-image-placeholder")
                        .resizable()
                } .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                            .shadow(color: Color.pink.opacity(0.75), radius: 5)
                    )
                    .padding(5)
                VStack{
                    HStack {
                        Text(stream.user_name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        Spacer()
                        if(stream.type == "live"){
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.red)
                                .foregroundStyle(.secondary)

                            Text("\(Double(stream.viewer_count).shortStringRepresentation)")
                                .foregroundStyle(.primary)
                        }
                    }
                    HStack {
                        Text(stream.title)
                            .font(.caption)
                            .lineLimit(twitchData.showingInfo ? 3: 1)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    if twitchData.showingInfo{
                        HStack{
                            Text(stream.game_name)
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(hovered ? Color("AccentColor").opacity(0.5) : Color.white.opacity(0.025))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(hovered ? .purple : .gray.opacity(0.25), lineWidth: 2)
                    .shadow(color: hovered ?.blue : .clear, radius: 10)
        )
        .onHover { isHovered in self.hovered = isHovered }
        .padding(.horizontal, 10)
        .animation(.default, value: hovered)
        .onAppear(perform: {
            //            A hacky way of loading logo once the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                getUserLogo()
            })
        })
    }
}



extension StreamRowView{
    func getUserLogo(){
        let url = "https://api.twitch.tv/helix/users"
        
        let headers: HTTPHeaders = [
            "Client-ID": const.twitchClientID,
            "Authorization": " Bearer \(const.oauthToken)"
        ]
        let parameters: Parameters = [
            "id": stream.user_id
        ]
        
        let task = AF.request(url, parameters: parameters, headers: headers)
        
        task.responseData { response in
            if let json = try? JSON(data: response.data!){
                stream_logo  = URL(string: json["data"][0]["profile_image_url"].string!)!
            }
        }
    }
    
    
}
