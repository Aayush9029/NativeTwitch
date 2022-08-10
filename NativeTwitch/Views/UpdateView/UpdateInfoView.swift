//
//  UpdateInfoView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import SwiftUI

struct UpdateInfoView: View {
    @EnvironmentObject var autoUpdater: AutoUpdater
    let update: UpdateModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                Text("What's new in NativeTwitch \(update.version) build \(update.build)?")
                    .italic()
                Spacer()

                NeatButton(title: autoUpdater.status != .yesUpdates ? "Installing updates": "Install Update", symbol: autoUpdater.status != .yesUpdates ? "bolt.fill" : "arrow.down", color: .blue)
                    .onTapGesture {
                        if autoUpdater.status == .yesUpdates {
                            autoUpdater.downloadAndInstall()
                        }
                    }

                NeatButton(title: "Open Releases", symbol: "globe", color: .green)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/Aayush9029/NativeTwitch/releases")!)
                    }
            }
            .padding()
            ScrollView {
                VStack(alignment: .leading) {

                    VStack {
                        HStack {
                            Text(update.title)
                                .font(.title.bold())
                            Spacer()
                        }

                        Divider()

                        ForEach(update.image, id: \.self) {imageDetail in
                            HStack {
                                Text(imageDetail.title)
                                    .bold()
                                Spacer()
                            }
                            AsyncImage(url: URL(string: imageDetail.image)) { image in
                                image.resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image("streamer-logo-placeholder")
                                    .resizable()
                                    .scaledToFill()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.purple, lineWidth: 2)
                                    .shadow(color: Color.pink.opacity(0.75), radius: 5)
                            )
                            .padding(5)
                            Text(imageDetail.imageDescription)
                                .foregroundColor(.secondary)
                            Divider()
                        }
                    }
                    Text("You can watch streams while the app is updating :)")
                        .italic()

                    Spacer()

                }
                .padding()
            }
        }

    }
}

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInfoView(update: UpdateModel.exampleUpdateModel)
            .frame(width: 500, height: 500)
                    .environmentObject(AutoUpdater())
    }
}
