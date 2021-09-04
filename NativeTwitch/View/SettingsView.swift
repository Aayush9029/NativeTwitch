//
//  SettingsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppStorageStrings.clientID.rawValue) var twitchClientID = ""
    @AppStorage(AppStorageStrings.oauthToken.rawValue) var oauthToken = ""
    @AppStorage(AppStorageStrings.streamlinkLocation.rawValue) var streamlinkLocation = ""
    
    @EnvironmentObject var twitchData: TwitchDataViewModel

    @State var logs = [String]()
    @Binding var showingLogs: Bool
    
    var body: some View {
        VStack{
        VStack {
            HStack{
                VStack(alignment: .leading){
                    Text("\(twitchData.user.name)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .lineLimit(1)
                }
                Spacer()
            }.padding()
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
            Divider()
            VStack(alignment: .leading){
                HStack{
                    Text("Logs")
                        .font(.title3.bold())
                        .padding(.top, 5)
                    Spacer()
                    Image(systemName: showingLogs ? "chevron.up" : "chevron.down")
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                        .padding(5)
                        .background(Color.blue.opacity(0.25))
                        .cornerRadius(5)
                        .padding(.trailing)
                        .onTapGesture {
                            withAnimation {
                                showingLogs.toggle()
                            }
                        }
                }
                Spacer()
                Group{
                    if showingLogs{
                    ScrollView{
                        VStack(alignment: .leading){

                            ForEach(twitchData.logs, id: \.self){log in
                                LogText(text: log, color: .gray)
                            }
                        }
                    }
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showingLogs: .constant(true))
            .environmentObject(TwitchDataViewModel())
    }
}
