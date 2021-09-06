//
//  UserRepository.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func searchUsers(_ query: String, page: Int) -> AnyPublisher<SearchResult, UserError>
}

enum UserError: Error {
    case serverError(error: Error)
}

class UserRepository: UserRepositoryProtocol {
    func searchUsers(_ query: String, page: Int) -> AnyPublisher<SearchResult, UserError> {
        print("Fedor: Loading page \(page)")
        let validQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://api.github.com/search/users?q=\(validQuery)&page=\(page)&per_page=30"
        let url = URL(string: urlString)!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .mapError { UserError.serverError(error: $0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
