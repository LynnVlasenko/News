//
//  ArticlesSearchTabView.swift
//  News
//
//  Created by Alina Vlasenko on 24.06.2024.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticlesSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            
            ArticleListView(articles: searchVM.articles,
                            isFetchingNextPage: searchVM.isFetchingNextPage,
                            nextPageHandler: { await searchVM.loadNextPage() })
                .overlay(overlayView)
                .navigationTitle(Constant.searchScreenTitle)
        }
        .searchable(text: $searchVM.searchQuery)
        .onChange(of: searchVM.searchQuery, { _, newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        })
        // search works by button
        .onSubmit(of: .search, search)
    }
    
        @ViewBuilder
        private var overlayView: some View {
            switch searchVM.phase {
            case .empty:
                
                if !searchVM.searchQuery.isEmpty {
                    ProgressView()
                } else if !searchVM.history.isEmpty {
                    SearchHistoryListView(searchVM: searchVM) { newValue in
                        searchVM.searchQuery = newValue
                        search()
                        hideKeyboard()
                    }
                } else {
                    EmptyPlaceholderView(text: Constant.phSearchText, image: Image(systemName: Constant.phSearchIcon))
                }
                
            case .success(let articles) where articles.isEmpty:
                EmptyPlaceholderView(text: Constant.phErrorSearchText, image: Image(systemName: Constant.phSearchIcon))
                
            case .failure(let error):
                RetryView(text: error.localizedDescription, retryAction: search)
                
            default: EmptyView()
            }
        }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        
        Task.init {
            await searchVM.searchFirstPageArticles()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkVM = BookmarkedArticlesViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
