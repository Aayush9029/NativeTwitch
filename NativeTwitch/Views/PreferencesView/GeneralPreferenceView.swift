//
//  GeneralPreferenceView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-23.
//

import SwiftUI

struct GeneralPreferenceView: View {
    @EnvironmentObject var twitchData: TwitchDataViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("General")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.green)
                .padding(.bottom)

            Group {
                CustomTextField(title: "Your Streamlink Location", text: $twitchData.streamlinkLocation, fontSize: .body, placeholder: "/opt/homebrew/bin/streamlink")

                Divider()

                CustomTextField(title: "Streamlink Config (optional)", text: $twitchData.streamlinkConfig, fontSize: .body, placeholder: "/Users/hellohi/configs/streamlink-conf")
            }

            Divider()

            Group {

                Toggle("Show Title", isOn: $twitchData.showingInfo)
                    .font(.title3.bold())
                    .toggleStyle(.switch)

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Use IINA", isOn: $twitchData.iinaEnabled)
                        .font(.title3.bold())
                        .toggleStyle(.switch)

                    Text("Quicktime is used by default but you can use IINA. Install it via brew for optimal results.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Experimental Features", isOn: $twitchData.experimental)
                        .font(.title3.bold())
                        .toggleStyle(.switch)

                    Text("Enables Low latency, Native Chat...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Divider()

            Group {
                Text("Default Resolution")
                    .font(.title3.bold())

                Menu {
                    ForEach(availableResolutions, id: \.self) { res in
                        Button {
                            twitchData.defaultResolution = res
                        } label: {
                            Text("\(res)")
                        }

                    }
                } label: {
                    Text(twitchData.defaultResolution)
                }

            }
            Spacer()
        }.padding()
            .tint(.accentColor)
    }
}

struct GeneralPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPreferenceView()
            .environmentObject(TwitchDataViewModel())
    }
}
