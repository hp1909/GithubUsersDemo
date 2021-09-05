//
//  SearchViewModel.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    
    private var page: Int = 1
    
    let repository: UserRepositoryProtocol
    
    let querySubject = PassthroughSubject<String, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func bindInputs() {
        querySubject
            .removeDuplicates()
            .sink { self.refreshUsers(query: $0) }
            .store(in: &subscriptions)
    }
    
    func refreshUsers(query: String) {
        page = 1
        searchUsers(query: query, page: page)
    }
    
    func loadMoreUsers(query: String) {
        page = page + 1
        searchUsers(query: query, page: page, isAppend: true)
    }
    
    func searchUsers(query: String, page: Int, isAppend: Bool = false) {
        repository.searchUsers(query, page: page)
            .sink { [weak self] fetchedUsers in
                guard let self = self else { return }
                if isAppend {
                    self.users.append(contentsOf: fetchedUsers)
                } else {
                    self.users = fetchedUsers
                }
            }
            .store(in: &subscriptions)
    }
}
