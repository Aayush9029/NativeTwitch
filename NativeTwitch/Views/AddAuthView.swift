//
//  AddAuthView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct AddAuthView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Login")
                    .font(.largeTitle.bold())
                    .foregroundColor(.purple)
                    .padding(.top)

                Divider()

                CustomTextField(title: "Your Client ID", text: $twitchData.clientID)
                CustomTextField(title: "Your Access Token", text: $twitchData.accessToken)
                Spacer()
                Link(
                    destination: URL(string: "https://twitchtokengenerator.com/quick/NIaMdzGYBR")!,
                    label: {
                        HStack {
                            Spacer()
                            Label("Generate Tokens", systemImage: "network")
                                .font(.body.bold())
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .buttonStyle(.borderless)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(.purple.opacity(0.25))
                        .cornerRadius(32)
                    }
                )

            }
                .textFieldStyle(.roundedBorder)

            VStack {
                    Button {
                        twitchData.saveAuthData()
                    } label: {
                        HStack {
                        Spacer()
                        Label("Save Authentication Data", systemImage: "lock.fill")
                            .font(.body.bold())
                            .foregroundColor(.white)
                        Spacer()
                        }
                    }
                    .buttonStyle(.borderless)
                    .disabled(twitchData.accessToken.count != 30)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.purple.opacity(twitchData.accessToken.count == 30 ? 0.75 : 0.125))
                    .cornerRadius(32)
            }

        }.padding()
    }
}

struct AddAuthView_Previews: PreviewProvider {
    static var previews: some View {
        AddAuthView()
            .environmentObject(TwitchDataViewModel())
    }
}
