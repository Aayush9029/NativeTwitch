//
//  LinearGradient+Extensions.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-15.
//

import SwiftUI

extension LinearGradient {
    static let bottomMasked: LinearGradient = .init(colors: [.black.opacity(0), .white, .white], startPoint: .top, endPoint: .bottom)
}
