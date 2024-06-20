//
//  MainArticlesTabView.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import SwiftUI

struct MainArticlesTabView: View {
    
    @StateObject var mainArticlesVM = MainArticlesViewModel()
    
    var body: some View {
        
        NavigationView {
            ArticleListView(articles: articles)
                .task(id: mainArticlesVM.selectedCategory, loadTask)
                .overlay(overlayView)
                .navigationTitle(mainArticlesVM.selectedCategory.text)
        }
    }
    
    // get the earticles from success phase
    private var articles: [Article] {
        if case .success(let articles) = mainArticlesVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    // fetch the articles from the API
    @Sendable
    private func loadTask() async {
        await mainArticlesVM.loadArticles()
    }
    
    
    // return appropriate view depending on the phase
    @ViewBuilder // A custom parameter attribute that constructs views from closures
    private var overlayView: some View {
       
        switch mainArticlesVM.phase {
            
        case .empty:
            ProgressView()
            // show the PlaceholderView if we don't have any articles
        case .success(let articles) where articles.isEmpty: EmptyPlaceholderView(text: "No Article received", image: Image(systemName: "doc.questionmark"))
        case .failure(let error):
            // the screen for trying to repeat the API request
            RetryView(text: error.localizedDescription) {
                
            }
        default: EmptyView()
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainArticlesTabView(mainArticlesVM: MainArticlesViewModel(articles: Article.previewData))
    }
}
