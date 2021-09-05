//
//  User.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation

struct User: Codable {
    var name: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case url = "url"
    }
}
