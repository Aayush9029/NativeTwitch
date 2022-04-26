//
//  StreamerLogoView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI
import SDWebImageSwiftUI

struct StreamerLogoView: View {
    let url: URL?

    var body: some View {
        WebImage(url: url, options: [.progressiveLoad, .delayPlaceholder])
            .placeholder(Image("streamer-logo-placeholder").resizable())
            .resizable()
            .scaledToFill()
            .frame(width: 45, height: 45)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.red, lineWidth: 2)
                    .shadow(color: Color.pink.opacity(0.75), radius: 5)
            )
            .padding(5)
    }
}

struct StreamerLogo_Previews: PreviewProvider {
    static var previews: some View {
        StreamerLogoView(url: StreamModel.exampleStream.user_logo)
    }
}
