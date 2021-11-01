//
//  User.swift
//  User
//
//  Created by Aayush Pokharel on 2021-09-04.
//

// MARK: - User Model
struct User {
    var client_id: String
    var oauthToken: String
    var name: String
    var user_id: String
    var isValid = false
    static let exampleUser = User(
        client_id: "",
        oauthToken:  "",
        name:  "Example User" , user_id:  "" ,
        isValid: false
    )
}

