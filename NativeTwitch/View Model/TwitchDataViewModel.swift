//
//  TwitchData.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-05-08.
//

import SwiftUI
import Alamofire
import SwiftyJSON

class TwitchDataViewModel: ObservableObject {

    @Published var showingSettings: Bool = false

    @AppStorage(AppStorageStrings.showingInfo.rawValue) var showingInfo: Bool = false

    @AppStorage(AppStorageStrings.clientID.rawValue) var twitchClientID = ""
    @AppStorage(AppStorageStrings.oauthToken.rawValue) var oauthToken = ""

    @AppStorage(AppStorageStrings.streamlinkLocation.rawValue) var streamlinkLocation = ""
    @AppStorage(AppStorageStrings.streamlinkConfig.rawValue) var streamlinkConfig = ""

    @AppStorage(AppStorageStrings.defaultResolution.rawValue) var defaultResolution = ""

    @AppStorage(AppStorageStrings.iinaEnabled.rawValue) var iinaEnabled = false
    @AppStorage(AppStorageStrings.experimental.rawValue) var experimental = false
    @AppStorage(AppStorageStrings.remoteUpdateJson.rawValue) var remoteUpdateJson = "https://raw.githubusercontent.com/Aayush9029/NativeTwitch/main/version.json"

    @Published var status: StatusStates = .starting
    @Published var user: User
    @Published var streams: [Stream]
    @Published var isShowingNativeChatAlert: Bool = false
    @Published var logs = [String]()

    var temp_stream_user = ""

    init() {
        self.user = User.exampleUser
        self.streams = []
        self.status = .starting
        self.startFetch()
    }

    func startFetch() {
        self.logs = []
        self.user = User.exampleUser
        self.streams = []
        self.validateTokens()
        self.fetchUserData()
    }

    func validateTokens() {
        self.status = .userValidating

        let url = Constants.oauthValidate
        // 2
        let headers: HTTPHeaders = [
            "Client-ID": twitchClientID,
            "Authorization": " Bearer \(oauthToken)"
        ]

        let task = AF.request(url, headers: headers)

        task.responseData { response in

            if let json = try? JSON(data: response.data!) {
                if json["client_id"].string == self.twitchClientID {
                    if json["scopes"] != ["user:read:follows"] {
                        self.status = .badScopes
                        self.addToLogs(json.rawString())
                    } else {
                        self.status = .userValidated
                        self.addToLogs(json.rawString())
                    }
                    self.addToLogs(json.rawString())
                } else {
                    self.status = .badClient
                    self.addToLogs(json.rawString())
                }
            } else {
                self.status = .badScopes
                self.addToLogs(response.description)
            }
        }
    }

    func fetchUserData() {
        self.status = .userLoading

        let url = Constants.oauthValidate

        let headers: HTTPHeaders = [
            "Client-ID": self.twitchClientID,
            "Authorization": " Bearer \(self.oauthToken)"
        ]

        let task = AF.request(url, headers: headers)

        task.responseData { response in
            if let json = try? JSON(data: response.data!) {
                if let name = json["login"].string {
                    self.user = User(client_id: self.twitchClientID, oauthToken: self.oauthToken, name: name, user_id: json["user_id"].string!, isValid: true)
                } else {
                    self.status = .badOuath
                    self.addToLogs(json.rawString())
                }
                self.status = .userLoaded
                self.addFollowedStreams()
            }
        }
    }

    func addFollowedStreams() {
        self.status = .streamLoading
        self.addToLogs()
        let url = "https://api.twitch.tv/helix/streams/followed"

        let headers: HTTPHeaders = [
            "Client-ID": twitchClientID,
            "Authorization": " Bearer \(oauthToken)"
        ]
        let parameters: Parameters = [
            "user_id": user.user_id
        ]

        let task = AF.request(url, parameters: parameters, headers: headers)

        task.responseData { response in

            if let json = try? JSON(data: response.data!) {
                for (_, subJson):(String, JSON) in json["data"] {
                    let d = subJson

                    self.streams.append(Stream(user_name: d["user_name"].string!, user_id: d["user_id"].string!, viewer_count: d["viewer_count"].int!, type: d["type"].string!, game_name: d["game_name"].string!, title: d["title"].string!, user_login: d["user_login"].string ?? "Unknown", thumbnail_url: d["thumbnail_url"].string!))

                }
                self.status = .streamLoaded
                self.addToLogs(json.rawString())
            } else {
                self.status = .badScopes
                self.addToLogs()
            }
        }
    }

    func watchLowLatencyWithVLC(_ streamUsername: String) {

        self.temp_stream_user = streamUsername

        DispatchQueue.global(qos: .background).async {
            var command = "\(self.streamlinkLocation) twitch.tv/\(self.temp_stream_user) \(self.defaultResolution) --twitch-low-latency"

            if self.streamlinkConfig.count > 5 {
                command = "\(self.streamlinkLocation) twitch.tv/\(self.temp_stream_user) \(self.defaultResolution) --twitch-low-latency --config \(self.streamlinkConfig)"
            }
            self.addToLogs(command, hidestatus: false)

            let shell_out = shell(command)
            self.addToLogs("\(self.streamlinkLocation):🎉 Success 🎉")

            if shell_out.isEmpty {
                self.addToLogs("\(self.streamlinkLocation):🎉 Success 🎉")
                return
            } else {
                self.addToLogs(shell_out)
                self.addToLogs("BIG FAIL 😩 @ \(self.streamlinkLocation)")
            }
            self.addToLogs(shell("which streamlink"))
        }

    }

    func watchStream(_ streamerUsername: String) {

        self.temp_stream_user = streamerUsername

        DispatchQueue.global(qos: .background).async {
            if self.iinaEnabled {
                _ = shell("ttvQT () { open -a iina $(\(self.streamlinkLocation) twitch.tv/$@ \(self.defaultResolution) --stream-url) ;}; ttvQT \(self.temp_stream_user )")
                self.addToLogs("\(self.streamlinkLocation):🎉 Success 🎉")
                return
            } else {
                let shell_out = shell("ttvQT () { open -a \"quicktime player\" $(\(self.streamlinkLocation) twitch.tv/$@ \(self.defaultResolution) --stream-url) ;}; ttvQT \(self.temp_stream_user )")
                if shell_out.isEmpty {
                    self.addToLogs("\(self.streamlinkLocation):🎉 Success 🎉")
                    return
                } else {
                    self.addToLogs(shell_out)
                    self.addToLogs("BIG FAIL 😩 @ \(self.streamlinkLocation)")
                }
            }
            self.addToLogs(shell("which streamlink"))
        }
    }

    func addToLogs(_ response: String? = nil, hidestatus: Bool = false) {
        DispatchQueue.main.async {
            if hidestatus {
                self.logs.append("\(Date()) | \(response ?? "")")
            } else {
                self.logs.append("\(Date()) | \(self.status.rawValue)")
                if response != nil {
                    self.logs.append("response: \(response!)\n")
                }
            }
        }

    }

    func copyLogsToClipboard(redacted: Bool = true) {
        var logsText = ""
        for log in self.logs {
            logsText += log
            logsText += "\n"
        }
        if redacted {
            logsText = logsText.replacingOccurrences(of: user.client_id, with: "********CLIENTID*****")
            logsText = logsText.replacingOccurrences(of: user.oauthToken, with: "********OAUTHTOKEN*****")
            logsText = logsText.replacingOccurrences(of: user.name, with: "*******USERNAME********")
            logsText = logsText.replacingOccurrences(of: user.user_id, with: "*******USER_ID********")
        }

        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(logsText, forType: .string)
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
