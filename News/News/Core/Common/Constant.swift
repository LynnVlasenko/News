//
//  Constant.swift
//  News
//
//  Created by Alina Vlasenko on 28.06.2024.
//

import Foundation

enum Constant {
    
    // Icon Names
    static let mainScreenIcon: String = "newspaper"
    static let searchScreenIcon: String = "doc.text.magnifyingglass"
    static let bookmarkIcon: String = "bookmark"
    static let bookmarkFillIcon: String = "bookmark.fill"
    static let saveArticleIcon: String = "square.and.arrow.up"
    static let photoPlaceholderIcon: String = "photo.fill"
    static let deleteIcon: String = "trash"
    static let menuLine: String = "line.3.horizontal.decrease"
    
    // Tab Labels
    static let mainScreenLbl: String = "News"
    static let searchScreenLbl: String = "Search"
    static let bookmarkScreenLbl: String = "Saved"
    
    // Screen Titles
    static let mainScreenTitle: String = "Top News"
    static let searchScreenTitle: String = "Search"
    static let bookmarkScreenTitle: String = "Saved Articles"
    
    // Photo
    static let articlePhotoMinHeight: CGFloat = 200.0
    static let articlePhotoMaxHeight: CGFloat = 300.0
    static let photoBgOpacity: Double = 0.1
    static let photoTextOpacity: Double = 0.4
    
    // ArticleRow
    static let rowRadius: CGFloat = 25.0
    static let listRowInsetsTopBottom: CGFloat = 0.0
    static let listRowInsetsleadingTrailing: CGFloat = 16.0
    static let mainVStackSpacing: CGFloat = 16.0
    static let infoVStackSpacing: CGFloat = 8.0
    
    // LineLimit
    static let titleLineLimit: Int = 3
    static let descrLineLimit: Int = 2
    static let captionLineLimit: Int = 1
    
    // EmptyPlaceholderView
    static let phVStackSpacing: CGFloat = 8.0
    static let phFontSize: CGFloat = 52.0
    
    static let phBookmarksText: String = "No saved articles"
    
    static let phSearchText: String = "Type your query to search from NewsAPI"
    static let phSearchIcon: String = "magnifyingglass"
    static let phErrorSearchText: String = "No search results found"
    
    static let phMainText: String = "No Article received"
    static let phMainIcon: String = "doc.questionmark"
    
    // Error descriptions
    static let generalError: String = "An error occured"
    static let serverError: String = "A server error occured"
    static let responseError: String = "Bad Response"
    
    static let responseSuccess: String = "ok"
    
    // Retry view
    static let retryBtnText: String = "Try again"
    static let retryMainVStackSpacing: CGFloat = 8.0
    
    // HistoryView
    static let hstTitle: String = "Recently Searched"
    
    // DataStoreFilenames
    static let bookmarkStoreFilename: String = "bookmarks"
    static let historyStoreFilename: String = "histories"
    
    
    // General
    static let clearBtnText: String = "Clear"
    static let deleteLbl: String = "Delete"
    
    static let domainName: String = "NewsAPI"
}
