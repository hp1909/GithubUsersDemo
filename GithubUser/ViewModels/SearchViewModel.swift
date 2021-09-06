//
//  SearchViewModel.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    // Inputs
    @Published var searchKeyword: String = ""
    
    // Outputs
    @Published var items: [SearchItem] = []
    
    // Internal publishers
    @Published private var isLoading: Bool = false
    @Published private var isLoadMore: Bool = false
    
    private var canFetch: Bool {
        return !isLoading && !isLoadMore && !searchKeyword.isEmpty
    }
    
    private var page: Int = 1
    private var totalItemsCount: Int = 0
    private var canLoadMore: Bool = false
    private let itemsPerPage: Int = 30
    private var users: [User] = []
    
    // Data access
    let repository: UserRepositoryProtocol
    
    var subscriptions = Set<AnyCancellable>()
    var loadSubject = PassthroughSubject<Bool, Never>()
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
        setupBindings()
    }
    
    func setupBindings() {
        $searchKeyword
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.page = 1
                self?.loadSubject.send(true)
            }
            .store(in: &subscriptions)
        
        $isLoading.removeDuplicates()
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading && !self.isLoadMore {
                    self.items = [.loading]
                }
            }
            .store(in: &subscriptions)
        
        loadSubject
            .sink { [weak self] isRefresh in
                self?.handleRequest(isRefresh: isRefresh)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: User interaction handlers
    func loadMoreUsers() {
        guard canFetch else { return }
        page += 1
        loadSubject.send(false)
    }
    
    func refreshUsers() {
        guard canFetch else { return }
        page = 1
        loadSubject.send(true)
    }
    
    // MARK: Fetch data handlers
    func handleRequest(isRefresh: Bool) {
        isLoadMore = !isRefresh
        isLoading = true
        self.searchUsers(query: self.searchKeyword, page: self.page, isRefresh: isRefresh)
            .prefix(untilOutputFrom: loadSubject)
            .sink { [weak self] completion in
                self?.isLoading = false
                self?.isLoadMore = false
                
                switch completion {
                case .failure(let error):
                    self?.handleError(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                self?.isLoading = false
                self?.isLoadMore = false
                
                self?.handleFetchedUsers(result)
            }
            .store(in: &subscriptions)

    }
    
    func searchUsers(query: String, page: Int, isRefresh: Bool = false) -> AnyPublisher<RefreshableResult, UserError> {
        if query.isEmpty {
            return Just(.default).setFailureType(to: UserError.self).eraseToAnyPublisher()
        }
        
        return repository.searchUsers(query, page: page)
            .map { searchResult in
                return RefreshableResult(result: searchResult, isRefresh: isRefresh)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleFetchedUsers(_ refreshableResult: RefreshableResult) {
        isLoading = false
        isLoadMore = false
        
        let isRefresh = refreshableResult.isRefresh
        let result = refreshableResult.result
        
        totalItemsCount = result.totalCount ?? 0
        
        if !isRefresh {
            users = appendAndRemoveDuplicates(users, newElements: result.items)
        } else {
            users = result.items
        }
        
        let newItems: [SearchItem] = users.map { .user(user: $0) }
        if newItems.isEmpty && isRefresh {
            self.items = [.placeholder]
            resetParams()
            return
        } else {
            self.items = newItems
        }
        
        if items.count < totalItemsCount {
            canLoadMore = true
            self.items.append(.loadMore)
        } else {
            canLoadMore = false
        }
    }
    
    func handleError(_ error: UserError) {
        switch error {
        case .serverError(error: let error):
            let errorInfo = (error as NSError).localizedDescription
            resetParams()
            self.items = [.error(error: errorInfo)]
        }
    }
    
    func resetParams() {
        page = 1
        totalItemsCount = 0
        canLoadMore = false
        users = []
    }
}

// MARK: Remove duplicated users - bugs from Github API
extension SearchViewModel {
    private func appendAndRemoveDuplicates(_ origin: [User], newElements: [User]) -> [User] {
        var result = origin
        newElements.forEach { user in
            if !result.contains(user) {
                result.append(user)
            }
        }
        
        return result
    }
}
