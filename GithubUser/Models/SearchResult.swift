//
//  SearchUserResult.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation

struct SearchResult: Codable {
    var totalCount: Int?
    var items: [User] = []
    
    static let `default` = SearchResult(totalCount: 0, items: [])
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items = "items"
    }
}
