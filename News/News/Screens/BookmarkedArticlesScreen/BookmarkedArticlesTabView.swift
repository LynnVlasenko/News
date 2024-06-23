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
    
    var body: some View {
        
        NavigationView {
           
            ArticleListView(articles: bookmarkedArticlesVM.bookmarks)
                .overlay(overlayView(isEmpty: bookmarkedArticlesVM.bookmarks.isEmpty))
                .navigationTitle("Saved Articles")
        }
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
    
    @StateObject static var bookmarkedArticlesVM = BookmarkedArticlesViewModel()

    static var previews: some View {
        BookmarkTabView()
            .environmentObject(bookmarkedArticlesVM)
    }
}
