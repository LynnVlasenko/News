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
    
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
    
    static let shared = BookmarkedArticlesViewModel()
    
    private init() {
        Task.init {
            await load()
        }
    }
    
    // MARK: - data store actions
    
    private func load() async {
        
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    private func bookmarkUpdated() {
        
        let bookmarks = self.bookmarks
        Task.init {
            await bookmarkStore.save(bookmarks)
        }
    }
    
    // MARK: - bookmark button actions
    
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
        bookmarkUpdated()
    }
    
    // delete from list of bookmarked articles
    func removeBookmark(for article: Article) {
        
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
}
