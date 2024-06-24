//
//  ContentView.swift
//  News
//
//  Created by Алина Власенко on 19.06.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainArticlesTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            SearchTabView()
                .tabItem {
                    Label("Search", systemImage: "doc.text.magnifyingglass")
                }
            
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
        .tint(Color.cyan)
    }
}

#Preview {
    ContentView()
}
