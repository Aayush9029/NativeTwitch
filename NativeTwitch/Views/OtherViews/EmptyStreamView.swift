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
            Image(systemName: "person.2.fill")
            Text("Streamers Offline")
                .font(.title.bold())
                .foregroundStyle(.tertiary)
            Spacer()
        }
    }
}

struct EmptyStreamView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStreamView()
    }
}
