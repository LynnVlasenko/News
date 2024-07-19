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
            
            ArticleListView(articles: mainArticlesVM.articles,
                            isFetchingNextPage: mainArticlesVM.isFetchingNextPage,
                            nextPageHandler: { await mainArticlesVM.loadNextPage() })
                // to show the different stages of the loading screen
                .overlay(overlayView)
            
                // load the data from API
                .task(id: mainArticlesVM.fetchTaskToken, loadTask)
                
                // pull to refresh functionality to update articles by swiping down
                .refreshable(action: refreshTask)
            
                .navigationTitle(mainArticlesVM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: menu)
        }
    }
    
    // MARK: - return appropriate view depending on the phase
    @ViewBuilder // A custom parameter attribute that constructs views from closures
    private var overlayView: some View {
       
        switch mainArticlesVM.phase {
            
        case .empty:
            ProgressView()
            
            // show the PlaceholderView if we don't have any articles
        case .success(let articles) where articles.isEmpty: EmptyPlaceholderView(text: Constant.phMainText, image: Image(systemName: Constant.phMainIcon))
        
        case .failure(let error):
            // the screen for trying to repeat the API request
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        
        default: EmptyView()
        }
    }
    
    // MARK: - menu for the categories
    private var menu: some View {
        
        Menu {
            //Such us Category model is CaseIterable - we use allCases method to get array of cases + use tag
            Picker("Category", selection: $mainArticlesVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: Constant.menuLine)
                .imageScale(.large)
                .tint(Color.cyan)
        }
    }
    
    // MARK: - Actions
    // fetch the articles from the API
    @Sendable
    private func loadTask() async {
        await mainArticlesVM.loadFirstPage()
    }
    
    // refresh action for refreshable
    @Sendable
    private func refreshTask() {
        DispatchQueue.main.async {
            mainArticlesVM.fetchTaskToken = FetchTaskToken(
                category: mainArticlesVM.fetchTaskToken.category,
                token: Date())
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkedArticlesVM = BookmarkedArticlesViewModel.shared
    
    static var previews: some View {
        MainArticlesTabView(mainArticlesVM: MainArticlesViewModel(articles: Article.previewData))
            .environmentObject(bookmarkedArticlesVM)
    }
}
