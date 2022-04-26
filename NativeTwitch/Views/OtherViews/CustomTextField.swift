//
//  CustomTextField.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var fontSize: Font = .title2
    var placeholder: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(.secondary)

            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    TextField(placeholder != nil ? placeholder! : title, text: $text)
                        .id(title)
                        .font(fontSize)
                        .textFieldStyle(.plain)
                        .onChange(of: text) { _ in
                            scrollView.scrollTo(title, anchor: .trailing)
                        }
                }
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Title for text", text: .constant("Hello 123"))
    }
}
