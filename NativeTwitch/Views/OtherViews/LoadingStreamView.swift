//
//  LoadingStreamView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct LoadingStreamView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .padding()
            Text("Loading Streams")
                .font(.title.bold())
                .foregroundStyle(.tertiary)
            Spacer()
        }
    }
}

struct LoadingStreamView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingStreamView()
    }
}
