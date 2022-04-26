//
//  TwitchDataViewModel.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2022-04-25.
//

import SwiftUI
import Alamofire
import SwiftyJSON

class TwitchDataViewModel: ObservableObject {
    @AppStorage(StorageStrings.showingInfo) var showingInfo: Bool = true

    @AppStorage(StorageStrings.streamlinkLocation) var streamlinkLocation: String = ""
    @AppStorage(StorageStrings.streamlinkConfig) var streamlinkConfig: String = ""
    @AppStorage(StorageStrings.defaultResolution) var defaultResolution: String = "best"
    @AppStorage(StorageStrings.iinaEnabled) var iinaEnabled: Bool = false
    @AppStorage(StorageStrings.experimental) var experimental: Bool = false
    @AppStorage(StorageStrings.remoteUpdateJson) var remoteUpdateJson: String = Constants.remoteUpdateURL

    @AppStorage(StorageStrings.userID) var userID: String = ""
    @AppStorage(StorageStrings.userName) var userName: String = ""

    @Published var streams: [StreamModel] = []
    @Published var logs: [String] = []
    @Published var currentStatus: CurrentStatus = .starting

    @Published var showAddAuthView: Bool = false
    @Published var settingsShown: Bool = false

    @Published var clientID: String = ""
    @Published var accessToken: String = ""

    let keychain = KeychainSwift()

    init() {
        // if clientID and token doesn't exist show Add Auth View
        if !readAuthData() {
            self.showAddAuthView = true
            return
        } else {
            self.showAddAuthView = false
        }
    }

    func fetchStreams() {
        if !self.streams.isEmpty {
            self.streams.removeAll()
            self.logs.removeAll()
        }
        if clientID.isEmpty {
            self.showAddAuthView = true
            return
        }
        if userID.isEmpty {
            self.fetchUserData()
        } else {
            //            if userID already exists just fetch streams (which it should after calling fetchUserData
            changeStatus(.streamsLoading)
            let headers: HTTPHeaders = [

                "Client-ID": clientID,
                "Authorization": " Bearer \(accessToken)"
            ]
            let parameters: Parameters = [
                "user_id": userID
            ]

            let task = AF.request(Constants.followedApiURL, parameters: parameters, headers: headers)

            task.responseData { response in

                if let json = try? JSON(data: response.data!) {
                    for (_, subJson):(String, JSON) in json["data"] {
                        let d = subJson
                        let stream =
                            StreamModel(
                            id: UUID(),
                            user_name: d["user_name"].string!,
                            user_id: d["user_id"].string!,
                            viewer_count: d["viewer_count"].int!,
                            type: d["type"].string!,
                            game_name: d["game_name"].string!,
                            title: d["title"].string!,
                            user_logo: nil,
                            user_login: d["user_login"].string ?? "Unknown",
                            thumbnail_url: d["thumbnail_url"].string!
                        )
                        stream.loadUserLogo(clientID: self.clientID, oauthToken: self.accessToken, userID: d["user_id"].string!)
                        self.streams.append(stream)
                    }

                    if (json["message"].string ?? "").count != 0 {
                        self.changeStatus(.invalidCredentials)
                        self.showAddAuthView = true
                        self.addLog(json["message"].string!)
                    } else {
                        self.changeStatus(.streamsLoaded)
                    }

                    self.addLog(json.rawString() ?? "{ No Response from fetchStreams() }")
                } else {
                    self.changeStatus(.invalidCredentials)
                    self.userID = ""
                    self.addLog("Failed fetching streams, perhaps creds is wrong?\nClearing userID")
                }
            }

        }
    }

    func fetchUserData() {
        if clientID.isEmpty || accessToken.isEmpty {
            return
        }
        changeStatus(.userLoading)

        let headers: HTTPHeaders = [
            "Client-ID": self.clientID,
            "Authorization": " Bearer \(self.accessToken)"
        ]
        let task = AF.request(Constants.oauthValidateURL, headers: headers)

        task.responseData { response in
            if let json = try? JSON(data: response.data!) {
                if let name = json["login"].string {
                    self.userID = json["user_id"].string!
                    self.userName = name
                } else {
                    self.changeStatus(.invalidCredentials)
                    self.addLog(json.rawString() ?? "{ Invalid JSON }")
                }
                self.changeStatus(.userLoaded)
                self.fetchStreams()
            }
        }
    }

    func readAuthData() -> Bool {
        self.changeStatus(.userValidating)
        let clientID = keychain.get(StorageStrings.clientID)
        let accessToken = keychain.get(StorageStrings.accessToken)

        if clientID == nil || accessToken == nil {
            return false
        } else {
            self.clientID = clientID!
            self.accessToken = accessToken!
            self.changeStatus(.invalidCredentials)
            return true
        }
    }

    func saveAuthData() {
            keychain.set(clientID, forKey: StorageStrings.clientID)
            keychain.set(accessToken, forKey: StorageStrings.accessToken)
            self.changeStatus(.userLoading)
            self.showAddAuthView = !readAuthData()
            print(self.showAddAuthView)
            self.fetchStreams()
    }

    func watchLowLatency(_ streamerName: String) {

        DispatchQueue.global(qos: .background).async {
            var command = "\(self.streamlinkLocation) twitch.tv/\(streamerName) \(self.defaultResolution) --twitch-low-latency"

            if self.streamlinkConfig.count > 5 {
                command = "\(self.streamlinkLocation) twitch.tv/\(streamerName) \(self.defaultResolution) --twitch-low-latency --config \(self.streamlinkConfig)"
            }
            self.addLog(command)

            let shell_out = self.shell(command)
            self.addLog("\(self.streamlinkLocation):🎉 Success 🎉")

            if shell_out.isEmpty {
                self.addLog("\(self.streamlinkLocation):🎉 Success 🎉")
                return
            } else {
                self.addLog(shell_out)
                self.addLog("BIG FAIL 😩 @ \(self.streamlinkLocation)")
            }
            self.addLog(self.shell("which streamlink"))
        }

    }

    func watchStream(_ streamerName: String) {

        DispatchQueue.global(qos: .background).async {
            if self.iinaEnabled {
                _ = self.shell("ttvQT () { open -a iina $(\(self.streamlinkLocation) twitch.tv/$@ \(self.defaultResolution) --stream-url) ;}; ttvQT \(streamerName )")
                self.addLog("\(self.streamlinkLocation):🎉 Success 🎉")
                return
            } else {
                let shell_out = self.shell("ttvQT () { open -a \"quicktime player\" $(\(self.streamlinkLocation) twitch.tv/$@ \(self.defaultResolution) --stream-url) ;}; ttvQT \(streamerName )")
                if shell_out.isEmpty {
                    self.addLog("\(self.streamlinkLocation):🎉 Success 🎉")
                    return
                } else {
                    self.addLog(shell_out)
                    self.addLog("BIG FAIL 😩 @ \(self.streamlinkLocation)")
                }
            }
            self.addLog(self.shell("which streamlink"))
        }
    }

}

extension TwitchDataViewModel {
    func changeStatus(_ newStatus: CurrentStatus) {
        DispatchQueue.main.async {
            self.currentStatus = newStatus
        }
        self.addLog(newStatus.rawValue)
    }
    func addLog(_ text: String) {
        DispatchQueue.main.async {
            self.logs.append(" \(UUID().uuidString) : \(Date()) >> \(text)\n")
        }
    }
    // MARK: - Shell function
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }

    func copyLogsToClipboard(redacted: Bool = true) {
        var logsText = ""
        for log in self.logs {
            logsText += log
            logsText += "\n"
        }
        if redacted {
            logsText = logsText.replacingOccurrences(of: clientID, with: "********CLIENTID*****")
            logsText = logsText.replacingOccurrences(of: accessToken, with: "********ACCESS-TOKEN*****")
            logsText = logsText.replacingOccurrences(of: userName, with: "*******USERNAME********")
            logsText = logsText.replacingOccurrences(of: userID, with: "*******USER_ID********")
        }

        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(logsText, forType: .string)
    }
}
