//
//  SearchUserResult.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation

struct SearchUserResult: Codable {
    var totalCount: Int?
    var items: [User] = []
}
