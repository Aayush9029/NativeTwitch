//
//  UpdateModel.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2021-10-27.
//

import Foundation


// MARK: - UpdateModel
struct UpdateModel: Codable {
    let published, version: String
    let build: Int
    let title, mainfeature, downloadlink: String
    let image: [ImageModel]
    
    static let exampleUpdateModel = UpdateModel(
        published: "2021-10-27",
        version: "1.0",
        build: 4,
        title: "Play Using IINA",
        mainfeature: "You can now play streams using IINA instead of Quicktime.",
        downloadlink: "https://github.com/Aayush9029/NativeTwitch/releases/download/v4.0/NativeTwitch.app.zip",
        image: exampleImageModels
    )
    
}

// MARK: - ImageModel
struct ImageModel: Codable, Hashable {
    let image: String
    let title, imageDescription: String
    
    enum CodingKeys: String, CodingKey {
        case image, title
        case imageDescription = "description"
    }
}

// MARK: - Example Model for Updates.
let exampleImageModels = [
    ImageModel(image: "https://user-images.githubusercontent.com/43297314/139175873-1200ec82-2d8f-4380-8ee6-ee18c11c2061.png",
               title: "IINA",
               imageDescription: "You can now play using IINA and other blah blah random stuff."),
    
    ImageModel(image: "https://raw.githubusercontent.com/Aayush9029/NativeTwitch/main/assets/ryan.png",
               title: "Ryan",
               imageDescription:  "Ryan is here or something Lorem ipsum?")
]

