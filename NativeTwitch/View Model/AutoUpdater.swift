//
//  Updater.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import SwiftUI
import Zip

class AutoUpdater: ObservableObject {
    
    @Published var updates = exampleUpdateModel
    @Published var status: UpdateStatus = .none
    

    
    enum UpdateFetcherError: Error {
        case invalidURL
        case missingData
        
        case unzipError
    }
    
    enum UpdateStatus: String {
        case none = "Nothing has happened yet"
        case failed = "Update checking failed"
        case noUpdates = "Current version is the latest version"
        case yesUpdates = "Updates are available"
        
        case errorDownloading = "There was a error while downloading the zip file"
        case downloading = "Downloading updates"
        case downloaded = "Updates Downloaded"
        
        case installing = "Installing Updates"
        case done = "Done."
    }
    
    
    init(){
        
    }
    
    
    
    func checkForUpdates(){

        Task{
            do {
                let updates = try await fetchRemoteVersion()
                if let currentBuildNumber = getCurrentBuildNumber() {
                    if currentBuildNumber > Double(updates.build){
                        print("New version found updating...")
                        DispatchQueue.main.sync {
                            self.status = .yesUpdates
                        }
                        let url = URL(string: updates.downloadlink)
                        DispatchQueue.main.sync {
                            self.status = .downloading
                        }
                        AutoUpdater.loadFileAsync(url: url!) { (path, error) in
                            if let _ = error {
                                self.status = .errorDownloading
                            }
                            print("Zip File downloaded to : \(path!)")
                            DispatchQueue.main.sync {
                                self.status = .downloaded
                            }
                            
                            print("Unzipping folder")
                            DispatchQueue.main.sync {
                                self.status = .installing
                            }

                            do{
                                let unzipppedPath = try? self.unzipFolder(for: path!)
                                print(unzipppedPath?.absoluteURL)

                            }catch{
                                print("ERROR UNZIPPING / Installing App")
                                DispatchQueue.main.sync {
                                    self.status = .failed
                                }
                            }
                        }
                    }else{
                        print("Current version is the latest one")
                        self.status = .noUpdates
                    }
                }
            } catch {
                print("Request failed with error: \(error)")
                self.status = .failed
            }
            
        }
    }
    
    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        
        let destinationUrl = Constants.downloadDir.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
                                            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
    
    func unzipFolder(for path: String) throws  -> URL{
        if let url = URL(string: path){
            do {
                let filePath = url
                let unzipDirectory = Constants.installDir
                print("Unzipping file @ \(Constants.installDir)")
                try Zip.unzipFile(filePath, destination: unzipDirectory, overwrite: true, password: nil, progress: {
                    (progress: Double) -> () in
                    // print("Unzip progress: \(progress)\n")
//                    We don't need this file is only 4 mb maybe in future
                })
                print("Deleting the zip file @ \(filePath)")
                try? FileManager().removeItem(atPath: filePath.absoluteString)
                
                return unzipDirectory
            }
            catch {
                throw UpdateFetcherError.unzipError
            }
        }
        throw UpdateFetcherError.unzipError
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

