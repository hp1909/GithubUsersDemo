//
//  UserRepository.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func searchUsers(_ query: String, page: Int) -> AnyPublisher<[User], Never>
}

enum APIError: LocalizedError {
    case statusCode
    case dataFormat
}

class UserRepository: UserRepositoryProtocol {
    func searchUsers(_ query: String, page: Int) -> AnyPublisher<[User], Never> {
        let urlString = "https://api.github.com/search/users?q=\(query)&page=\(page)&per_page=30"
        let url = URL(string: urlString)!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchUserResult.self, decoder: JSONDecoder())
            .map(\.items)
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
