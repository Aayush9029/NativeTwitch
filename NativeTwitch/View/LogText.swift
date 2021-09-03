//
//  BoldTextView.swift
//  BoldTextView
//
//  Created by Aayush Pokharel on 2021-09-03.
//

import SwiftUI

struct LogText: View {
    let text: String
    var color: Color = .gray
    
    var body: some View {
            Text(text)
                .font(.caption2)
                .foregroundColor(.gray)
    }
}

struct BoldTextView_Previews: PreviewProvider {
    static var previews: some View {
        LogText(text: "All streams are offline :(", color: .gray)
    }
}
