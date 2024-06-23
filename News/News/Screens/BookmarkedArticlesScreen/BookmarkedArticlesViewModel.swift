//
//  BookmarkedArticlesViewModel.swift
//  News
//
//  Created by Alina Vlasenko on 21.06.2024.
//

import SwiftUI

@MainActor
class BookmarkedArticlesViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = []
    
    // check if the article is bookmarked
    func isBookmarked(for article: Article) -> Bool {
        
        bookmarks.first { article.id == $0.id } != nil
    }
    
    // add to list of bookmarked articles
    func addBookmark(for article: Article) {
       
        guard !isBookmarked(for: article) else {
            return
        }
        bookmarks.insert(article, at: 0)
    }
    
    // delete from list of bookmarked articles
    func removeBookmark(for article: Article) {
        
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
    }
}
