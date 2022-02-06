//
//  Updater.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import SwiftUI
import Zip

class AutoUpdater: ObservableObject {

    @Published var updates = UpdateModel.exampleUpdateModel
    @Published var status: UpdateStatus = .none
    @Published var showingRestartAlert: Bool = false
    @AppStorage(AppStorageStrings.remoteUpdateJson.rawValue) var remoteUpdateJson = "https://raw.githubusercontent.com/Aayush9029/NativeTwitch/main/version.json"

    enum UpdateFetcherError: Error {
        case invalidURL
        case missingData
        case unzipError
    }

    enum UpdateStatus: String {
        case none = "Nothing has happened yet "
        case failed = "Update checking failed ❌"
        case noUpdates = "Current version is the latest version ✅"
        case yesUpdates = "Updates are available ✅"

        case errorDownloading = "There was a error while downloading the zip file ❌"
        case downloading = "Downloading updates ✅"
        case downloaded = "Updates Downloaded ✅"

        case installing = "Installing Updates"
        case installFailed = "Failed to install the updates (unzip)❌"
        case done = "Done Installing Updates ✅."
    }

    init() {

    }

    func checkForUpdates() {
        Task {
            do {
                let updates = try await fetchRemoteVersion()
                if let currentBuildNumber = getCurrentBuildNumber() {
                    if Double(updates.build) > currentBuildNumber {
                        DispatchQueue.main.sync {
                            self.status = .yesUpdates
                            print("New updates is avaiable")
                        }
                    } else {
                        print("Current version is the latest one")
                        DispatchQueue.main.sync {
                            self.status = .noUpdates
                        }
                    }
                }
            } catch {
                print("Request failed with error: \(error.localizedDescription)")
                DispatchQueue.main.sync {
                    self.status = .noUpdates
                }
            }

        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void) {

        let destinationUrl = Constants.downloadDir.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                if error == nil {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            if let data = data {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                    completion(destinationUrl.path, error)
                                } else {
                                    completion(destinationUrl.path, error)
                                }
                            } else {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                } else {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }

    func downloadAndInstall() {
        print("New version found updating...")
        self.status = .yesUpdates

        let url = URL(string: updates.downloadlink)
        self.status = .downloading

        AutoUpdater.loadFileAsync(url: url!) { (path, error) in
            if let _ = error {
                self.status = .errorDownloading
            }
            print("Zip File downloaded to : \(path!)")
            DispatchQueue.main.sync {
            }

            print("Unzipping folder")
            DispatchQueue.main.sync {
                self.status = .installing
            }

            do {
//                throws unzip error no plans on using that yet.. global catch should suffice
                try self.installApp(for: path!)
            } catch {
                print("ERROR UNZIPPING / Installing App")
                DispatchQueue.main.sync {
                    self.status = .installFailed
                }
            }
        }
    }

    func installApp(for path: String) throws {
        if let url = URL(string: path) {
            do {
                let filePath = url
                let unzipDirectory = Constants.installDir
                let installedPath = unzipDirectory.appendingPathComponent("NativeTwitch.app").absoluteString.replacingOccurrences(of: "file:///", with: "/")
                print("Deleting the old App  @ \(installedPath)")
                try? FileManager().removeItem( atPath: installedPath)

                print("Unzipping file @ \(Constants.installDir)")
                try Zip.unzipFile(filePath, destination: unzipDirectory, overwrite: false, password: nil, progress: {
                    (_: Double) -> Void in
                    // print("Unzip progress: \(progress)\n")
                    //                    We don't need this file is only 4 mb maybe in future
                })
                print("Deleting the zip file @ \(filePath)")
                try? FileManager().removeItem(atPath: filePath.absoluteString)
                DispatchQueue.main.sync {
                    showingRestartAlert.toggle()
                }
            } catch {
                throw UpdateFetcherError.unzipError
            }
        }
        DispatchQueue.main.sync {
            self.status = .done
        }
    }

    func fetchRemoteVersion() async throws -> UpdateModel {

        guard let url = URL(string: remoteUpdateJson) else {
            throw UpdateFetcherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let result = try JSONDecoder().decode(UpdateModel.self, from: data)
        DispatchQueue.main.sync {
            self.updates = result
        }
        return result
    }

    func getCurrentBuildNumber() -> Double? {
        if let buildNumber =  Bundle.main.buildVersionNumber {
            return Double(buildNumber) ?? 0.0
        }
        return 0.0
    }
}
