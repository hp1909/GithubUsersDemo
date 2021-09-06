//
//  SearchItem.swift
//  SearchItem
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation

enum SearchItem: Identifiable, Equatable {
    case placeholder
    case user(user: User)
    case empty
    case loading
    case loadMore
    case error(error: String)
    
    var id: String {
        switch self {
        case .empty:
            return "empty"
        case .placeholder:
            return "placeholder"
        case .user(user: let user):
            return user.name ?? ""
        case .loading:
            return "loading"
        case .loadMore:
            return "loadMore"
        case .error(error: let error):
            return "error_\(error)"
        }
    }
    
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
