//
//  LogsView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-23.
//

import SwiftUI

struct LogsView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Logs")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .lineLimit(1)

                Spacer()

                NeatButton(title: "Copy", symbol: "paperclip")
                    .onTapGesture {
                        twitchData.copyLogsToClipboard()
                    }
                    .contextMenu {
                        Button("Copy Raw") {
                            twitchData.copyLogsToClipboard(redacted: false)
                        }
                        Button("Copy Redacted") {
                            twitchData.copyLogsToClipboard(redacted: true)
                        }
                    }
            }
            Spacer()
            Group {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {

                        ForEach(twitchData.logs, id: \.self) {log in
                            LogText(text: log, color: .gray)
                        }.id(UUID())

                    }
                }
            }
        }
        .padding()
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
            .environmentObject(TwitchDataViewModel())
    }
}
