//
//  User.swift
//  User
//
//  Created by Aayush Pokharel on 2021-09-04.
//

struct User {
    var client_id: String
    var oauthToken: String
    var name: String
    var user_id: String
    var isValid = false
}

let exampleUser = User(client_id: "gp762nuuoqcoxypju8c569th9wz7q5", oauthToken:  "3jaosugvb9bypjcrb0ks8d7stj1jdy", name:  "aahyoushh2" , user_id:  "511005830" , isValid: false)
