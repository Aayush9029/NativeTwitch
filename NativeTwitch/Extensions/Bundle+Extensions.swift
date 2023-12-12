//
//  Bundle+Extensions.swift
//  Neo
//
//  Created by Aayush Pokharel on 2023-11-28.
//

import Foundation

extension Bundle {
    var appName: String { getInfo("CFBundleName") }
    var displayName: String { getInfo("CFBundleDisplayName") }
    var bundleID: String { getInfo("CFBundleIdentifier") }
    var copyright: String { getInfo("NSHumanReadableCopyright") }

    var appBuild: String { getInfo("CFBundleVersion") }
    var appVersion: String { getInfo("CFBundleShortVersionString") }

    func getInfo(_ str: String) -> String {
        infoDictionary?[str] as? String ?? "No Information."
    }
}
