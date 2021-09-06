//
//  User.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation

struct User: Codable, Equatable {
    var name: String?
    var url: String?
    var avatarUrlPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case url = "url"
        case avatarUrlPath = "avatar_url"
    }
    
    var avatarUrl: URL? {
        guard let avatarUrlPath = avatarUrlPath, let url = URL(string: avatarUrlPath) else {
            return nil
        }
        
        return url
    }
    
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.url == rhs.url
    }
}
