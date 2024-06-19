//
//  MainArticlesTabView.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                // check we get the data from API
            }.task(id: articleNewsVM.selectedCategory, loadTask)
        }
    }
    
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
}
