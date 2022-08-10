//
//  Bundle+Extension.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
