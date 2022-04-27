//
//  EmptyStreamView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct EmptyStreamView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person.2.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
            Text("Streamers Offline")
                .font(.title.bold())
            Spacer()
        }
        .foregroundStyle(.tertiary)
    }
}

struct EmptyStreamView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStreamView()
    }
}
