//
//  BookmarkedArticlesTabView.swift
//  News
//
//  Created by Alina Vlasenko on 21.06.2024.
//

import SwiftUI

struct BookmarkTabView: View {
    
    @EnvironmentObject var bookmarkedArticlesVM: BookmarkedArticlesViewModel
    
    @State var searchText: String = ""
    
    private var articles: [Article] {
        
        if searchText.isEmpty {
            return bookmarkedArticlesVM.bookmarks
        }
        return bookmarkedArticlesVM.bookmarks
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    var body: some View {
        
        let articles = self.articles
        
        NavigationView {
           
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder // A custom parameter attribute that constructs views from closures.
    //You typically use ViewBuilder as a parameter attribute for child view-producing closure parameters, allowing those closures to provide multiple child views
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No saved articles", image: Image(systemName: "bookmark"))
        }
    }
}


struct BookmarkTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkedArticlesVM = BookmarkedArticlesViewModel.shared

    static var previews: some View {
        BookmarkTabView()
            .environmentObject(bookmarkedArticlesVM)
    }
}
