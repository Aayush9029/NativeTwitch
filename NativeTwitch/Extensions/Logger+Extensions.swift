//
//  Logger+Extensions.swift
//  Neo
//
//  Created by NOX on 2023-11-10.
//

import Foundation
import os

extension Logger {
    init(category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}
