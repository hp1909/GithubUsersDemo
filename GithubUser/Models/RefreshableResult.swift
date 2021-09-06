//
//  RefreshableResult.swift
//  RefreshableResult
//
//  Created by Phuc Hoang on 9/6/21.
//

import Foundation

struct RefreshableResult {
    let result: SearchResult
    let isRefresh: Bool
    
    static let `default` = RefreshableResult(result: .default, isRefresh: true)
}
