//
//  LiveBadgeView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct LiveBadgeView: View {
    var viewCount: String = ""
    @State var dotAnimate: Bool = false

    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 2)
            .repeatForever()
    }

    var body: some View {
        HStack {
            Circle()
                .foregroundColor(.red.opacity(dotAnimate ? 0.25 : 1.0))
                .frame(width: 5, height: 5)
                .shadow(color: .red.opacity(dotAnimate ? 0.25 : 0.5), radius: 2, x: 0, y: 0)
                .onAppear {
                    withAnimation(self.repeatingAnimation) { self.dotAnimate.toggle()
                    }
                }

            Text(viewCount)
                .font(.caption.bold())
        }
        .padding(6)
        .background(.thinMaterial)
        .cornerRadius(6)
    }
}

struct LiveBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        LiveBadgeView()
    }
}
