//
//  UserView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI

struct UserView: View {
    var user: User
    var body: some View {
        VStack {
            HStack{
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Spacer()
                CleanButton(image: "gear", color: .blue)
            }.padding(.horizontal)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: exampleUser)
    }
}
