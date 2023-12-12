//
//  String+Extensions.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-12-13.
//

import Foundation

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}
