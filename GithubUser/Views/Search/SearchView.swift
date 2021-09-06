//
//  SearchView.swift
//  GithubUser
//
//  Created by Phuc Hoang on 9/5/21.
//

import SwiftUI
import Combine

struct SearchView: View {
    private enum Design {
        static let searchBarPadding = EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        static let loadingRowHeight: CGFloat = 300
        static let loadMoreRowHeight: CGFloat = 50
    }
    
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                CustomSearchBar(text: $viewModel.searchKeyword)
                    .padding(Design.searchBarPadding)
                List(viewModel.items) { item in
                    switch item {
                    case .empty, .placeholder:
                        SearchWelcomeRow()
                            .listRowSeparator(.hidden)
                    case .user(user: let user):
                        SearchResultRow(user: user)
                    case .loading:
                        LoadingRow(height: Design.loadingRowHeight)
                    case .error(error: let info):
                        SearchErrorRow(errorInfo: info)
                    case .loadMore:
                        LoadingRow(height: Design.loadMoreRowHeight)
                        .onAppear {
                            viewModel.loadMoreUsers()
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
                .refreshable {
                    viewModel.refreshUsers()
                }
            }
            .listStyle(InsetListStyle())
            .navigationTitle(
                "SEARCH_VIEW_NAVIGATION_TITLE".localized()
            )
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.searchKeyword = ""
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            viewModel: SearchViewModel(repository: UserRepository())
        )
    }
}
