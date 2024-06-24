//
//  ArticlesSearchTabView.swift
//  News
//
//  Created by Alina Vlasenko on 24.06.2024.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticlesSearchViewModel()
    
    private var articles: [Article] {
        
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    var body: some View {
        NavigationView {
            
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
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
                } else {
                    EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
                }
                
            case .success(let articles) where articles.isEmpty:
                EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
                
            case .failure(let error):
                RetryView(text: error.localizedDescription, retryAction: search)
                
            default: EmptyView()
            }
        }
    
    private func search() {
        Task.init {
            await searchVM.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkVM = BookmarkedArticlesViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
