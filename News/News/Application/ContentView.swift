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
                    Label(Constant.mainScreenLbl,
                          systemImage: Constant.mainScreenIcon)
                }
            
            SearchTabView()
                .tabItem {
                    Label(Constant.searchScreenLbl,
                          systemImage: Constant.searchScreenIcon)
                }
            
            BookmarkTabView()
                .tabItem {
                    Label(Constant.bookmarkScreenLbl,
                          systemImage: Constant.bookmarkIcon)
                }
        }
        .tint(Color.cyan)
    }
}

#Preview {
    ContentView()
}
