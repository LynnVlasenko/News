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
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    ContentView()
}
