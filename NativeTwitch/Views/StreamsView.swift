//
//  StreamsView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct StreamsView: View {
    @EnvironmentObject var twitchDataViewModel: TwitchDataViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(twitchDataViewModel.streams) { stream in
                StreamRowView(stream: stream)
                    .environmentObject(twitchDataViewModel)
            }.padding()
        }
    }
}

struct StreamsView_Previews: PreviewProvider {
    static var previews: some View {
        StreamsView()
            .environmentObject(TwitchDataViewModel())
            .frame(width: 320, height: 360)
    }
}
