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
    @State private var hovered = false
    
    @State var stream_logo: URL
    
    var body: some View {
        VStack{
            HStack{
                CustomImageOnline(url: stream_logo)
                    .frame(width: 45, height: 45)
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
                        Spacer()
                        if(stream.type == "live"){
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.red)
                            Text("\(stream.viewer_count)")
                        }
                    }
                    HStack {
                        Text(stream.title)
                            .lineLimit(1)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(hovered ? Color.blue.opacity(0.5) : Color.white.opacity(0.025))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(hovered ? Color.blue : .gray.opacity(0.25), lineWidth: 2)
                    .shadow(color: hovered ?.blue : .blue.opacity(0), radius: 10)
                    
        )
        .onHover { isHovered in
            self.hovered = isHovered
        }
        .padding(.horizontal, 10)

        //        .
        .animation(.default, value: hovered)
      
        
        .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
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
