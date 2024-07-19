//
//  NewsApp.swift
//  News
//
//  Created by Алина Власенко on 19.06.2024.
//

import SwiftUI

@main
struct NewsApp: App {
    
    // create initialisation of articleBookmarkVM to get it to the environmentObject
    @StateObject var bookmarkedArticlesVM = BookmarkedArticlesViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkedArticlesVM)
        }
    }
}

var ENV: APIKeyable {
    #if DEBUG
    return DebugENV()
    #else
    return ProdENV()
    #endif
}
