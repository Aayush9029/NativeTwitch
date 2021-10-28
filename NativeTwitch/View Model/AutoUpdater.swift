//
//  Updater.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import SwiftUI


class AutoUpdater: ObservableObject {
    
    @Published var updates = exampleUpdateModel
    @Published var status: UpdateStatus = .none
    
    enum UpdateFetcherError: Error {
        case invalidURL
        case missingData
    }
    enum UpdateStatus: String {
        case none = "Nothing has happened yet"
        case failed = "Update checking failed"
        case hmmUpdates = "Update not avaialble"
        case noUpdates = "Current version is the latest version"
        case yesUpdates = "Updates are available"
    }
    

    init(){
        print("checking for updates")
        checkForUpdates()
    }
    
    
    
    func checkForUpdates(){
        Task{
            do {
                let updates = try await fetchRemoteVersion()
                if let currentBuildNumber = getCurrentBuildNumber() {
                    if currentBuildNumber > Double(updates.build){
                        print("New version found updating...")
                        downloadUsingCurl(for: updates.downloadlink)
                    }else{
                        print("Current version is the latest one")
                    }
                }
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }
    }
    
    
    func downloadUsingCurl(for url: String){
//        Using good ol shell (lazy way but most stable and should work very well)
        Task{
        let command = "ls;pwd;curl -o /var/tmp/nativetwitch\(updates.build) \(url)"
        print(command)
        let shell_out = shell(command)
        print(shell_out)
        }
        
    }
    
    func fetchRemoteVersion() async throws -> UpdateModel {
        
        guard let url = URL(string: "https://raw.githubusercontent.com/Aayush9029/NativeTwitch/Autoupdate/version.json") else {
            throw UpdateFetcherError.invalidURL
        }
        
        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parse the JSON data
        let result = try JSONDecoder().decode(UpdateModel.self, from: data)
        return result
    }
    
    func getCurrentBuildNumber() -> Double?{
        if let buildNumber =  Bundle.main.buildVersionNumber{
            return Double(buildNumber) ?? 0.0
        }
        return 0.0
    }
}

