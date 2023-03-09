//
//  StreamerLogoView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct StreamerLogoView: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
            // Change this according to the taste
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                EmptyView()
            }
        }

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
